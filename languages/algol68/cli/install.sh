#!/bin/sh
# install.sh - ALGOL 68 cli: check (and optionally install) Algol 68 Genie
#
# WHAT: checks that a68g, the Algol 68 Genie interpreter, is installed. If it
#       is missing, offers to build version 3.13.4 from the project's source
#       archive into ~/.local/algol68g-3.13.4 (see algol68-env.sh) and does it
#       only if you answer "y". Nothing is installed silently and sudo is
#       never used.
# WHY:  hello.a68 needs an ALGOL 68 implementation. Algol 68 Genie is a
#       maintained interpreter that implements the Revised Report, so it runs
#       the source directly and there is no build step. The project
#       publishes source archives, so this script downloads the pinned one,
#       checks its SHA-256 digest, and builds it with the GNU build system
#       (configure, make, make install). That needs a C compiler and make.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://algol68genie.nl/en/algol-68-genie/  (downloads)
#   https://algol68genie.nl/learning-algol-68-genie.pdf  (section 10.5)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# A68G_VERSION, A68G_URL, A68G_SHA256, A68G_DIR; puts $A68G_DIR/bin on PATH.
# shellcheck source=algol68-env.sh
. ./algol68-env.sh

# sha256_check DIGEST FILE - succeed if FILE has the SHA-256 digest DIGEST.
sha256_check() {
    if has_cmd shasum; then
        echo "$1  $2" | shasum -a 256 -c - >/dev/null
    else
        echo "$1  $2" | sha256sum -c - >/dev/null
    fi
}

step "1/2 Check whether Algol 68 Genie (a68g) is installed"
explain "WHY: a68g is the interpreter that runs hello.a68."
if has_cmd a68g; then
    # --version prints the name and version on the first line.
    have=$(a68g --version | sed -n 1p)
    case "$have" in
        *"$A68G_VERSION"*) ok "$have found: $(command -v a68g)" ;;
        *) warn "$have found, but this folder pins $A68G_VERSION. The program should still run." ;;
    esac
    exit 0
fi
warn "Algol 68 Genie is not installed (no 'a68g' on PATH, nor in $A68G_DIR/bin)."

step "2/2 Build and install Algol 68 Genie $A68G_VERSION"
explain "WHY: the project publishes source archives, so the script downloads"
explain "     $A68G_URL"
explain "     checks its SHA-256 ($A68G_SHA256),"
explain "     builds it with configure and make, and installs it into"
explain "     $A68G_DIR (--prefix, so no sudo)."
case "$TF_OS" in
    macos-intel|macos-arm|linux) ;;
    *) fail "Build from source needs a Unix shell. See https://algol68genie.nl/en/algol-68-genie/ (this system is not verified for this implementation)." ;;
esac
confirm "Build Algol 68 Genie $A68G_VERSION from source now?" \
    || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

# The compiler and make: on macOS, make clang work first.
fix_developer_dir
has_cmd make || fail "'make' is missing. macOS: xcode-select --install; Linux: install build-essential."
has_cmd cc || fail "No C compiler ('cc'). macOS: xcode-select --install; Linux: install build-essential."
has_cmd curl || fail "'curl' is missing. It downloads the source archive."

# Work in a new, empty temporary folder: the archive is untrusted until its
# checksum matches, and nothing is left behind afterwards.
a68_tmp=$(mktemp -d)
trap 'rm -rf "$a68_tmp"' EXIT HUP INT TERM
a68_tar=$a68_tmp/algol68g-$A68G_VERSION.tar.gz
curl -fL -o "$a68_tar" "$A68G_URL"
# The checksum proves the file is the one this folder pins.
sha256_check "$A68G_SHA256" "$a68_tar" \
    || fail "Checksum mismatch for $A68G_URL. Nothing was built. Do not use this file."
ok "SHA-256 matches"
mkdir "$a68_tmp/src"
tar -xzf "$a68_tar" -C "$a68_tmp/src"
# configure writes a Makefile for this machine; --prefix chooses the folder
# that "make install" fills (bin/a68g, include/, share/). make builds the
# interpreter. Optional libraries (GSL, plotutils, curl, PostgreSQL) are used
# only when configure finds them; Hello World needs none of them.
# --disable-readline turns off the optional GNU readline library (it gives
# line editing for terminal input, which Hello World does not use). On the
# development machine (macOS Intel) configure accepted the system readline
# and the build then failed with "use of undeclared identifier
# 'RL_VERSION_MAJOR'"; with readline off it builds.
(
    cd "$a68_tmp/src/algol68g-$A68G_VERSION"
    ./configure --prefix="$A68G_DIR" --disable-readline
    make
    make install
) || fail "Building Algol 68 Genie failed. See the messages above."
# Read algol68-env.sh again: it now puts $A68G_DIR/bin on PATH.
. ./algol68-env.sh

has_cmd a68g || fail "'a68g' is still not on PATH. Open a new terminal and retry."
ok "$(a68g --version | sed -n 1p) is ready in $A68G_DIR. Next: ./run.sh"
