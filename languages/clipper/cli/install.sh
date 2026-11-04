#!/bin/sh
# install.sh - Clipper cli: check (and optionally install) Harbour
#
# WHAT: checks that hbmk2, Harbour's build tool, is installed. If it is
#       missing, offers to build Harbour 3.2.0 from its official source
#       release into ~/.local/harbour-3.2.0 (see harbour-env.sh) and does
#       it only if you answer "y". Nothing is installed silently and sudo
#       is never used.
# WHY:  CA-Clipper itself is proprietary and was discontinued, so this
#       project uses Harbour, its open-source, Clipper-compatible
#       successor (see README.md, "Why this toolchain"). Harbour compiles
#       the .prg source into C, and then a C compiler makes the executable,
#       so a C compiler and "make" are needed too.
#       No package manager ships a current Harbour: Homebrew's formula is
#       3.0.0 from 2011 and deprecated, and Debian lists only a very old package (see README.md).
#       The Harbour project publishes 3.2.0 as source code, so this script
#       builds it. On the development machine the build took about 3 minutes
#       (2026-11-01).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://github.com/harbour/core/releases/tag/v3.2.0  (official release)
#   https://github.com/harbour/core#how-to-build-and-install-harbour-from-source

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# HB_VERSION, HB_SRC_SHA256, HB_DIR; puts $HB_DIR/bin on PATH.
# shellcheck source=harbour-env.sh
. ./harbour-env.sh

# build_harbour_from_source - macOS and Linux: download the Harbour source
# release, check it, build it with make and install it into $HB_DIR.
build_harbour_from_source() {
    hb_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-clipper
    hb_tar=harbour-$HB_VERSION.src.tar.gz
    hb_url="https://github.com/harbour/core/releases/download/v$HB_VERSION/$hb_tar"
    explain "Download $hb_tar (about 15 MB) from the Harbour project's GitHub"
    explain "releases into $hb_cache; check its SHA-256 checksum, build it"
    explain "with make and install it into $HB_DIR (no sudo)."
    confirm "Build Harbour $HB_VERSION from source now (several minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd make || fail "'make' is missing. macOS: xcode-select --install; Linux: install build-essential."
    has_cmd cc || fail "No C compiler ('cc'). macOS: xcode-select --install; Linux: install build-essential."

    mkdir -p "$hb_cache"
    [ -f "$hb_cache/$hb_tar" ] || curl -fL -o "$hb_cache/$hb_tar" "$hb_url"
    # The checksum proves the file is exactly the Harbour release.
    echo "$HB_SRC_SHA256  $hb_cache/$hb_tar" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $hb_cache/$hb_tar and retry."

    # The archive has no top folder, so unpack it into an empty temporary one.
    hb_src=$(mktemp -d)
    tar -xzf "$hb_cache/$hb_tar" -C "$hb_src"
    # Harbour's own Makefile builds the compiler (harbour), the build tool
    # (hbmk2) and the core libraries, then "install" copies them into
    # HB_INSTALL_PREFIX. The options:
    #   HB_INSTALL_PREFIX=$HB_DIR  install into your home folder, not /usr/local
    #   HB_BUILD_CONTRIBS=no       skip the optional contrib libraries (GUI,
    #                              SSL, databases...); Hello World needs none,
    #                              and they would need extra system packages
    # On a home-folder prefix Harbour builds static executables by default
    # (HB_BUILD_SHARED=no), so the result does not depend on the source folder.
    (
        cd "$hb_src"
        make install HB_INSTALL_PREFIX="$HB_DIR" HB_BUILD_CONTRIBS=no
    ) || fail "Building Harbour failed. See the messages above."
    rm -rf "$hb_src"
    # Read harbour-env.sh again: it now puts $HB_DIR/bin on PATH.
    . ./harbour-env.sh
}

step "1/2 Check whether Harbour (hbmk2) is installed"
explain "WHY: hbmk2 is Harbour's build tool. It runs the Harbour compiler on"
explain "     hello.prg and then the C compiler and linker."
# Harbour calls the C compiler; on macOS make sure that one works too.
fix_developer_dir
if has_cmd hbmk2; then
    # -build prints the Harbour version and build information.
    ok "Harbour found: $(hbmk2 -build 2>&1 | grep -m 1 'Harbour') ($(command -v hbmk2))"
    exit 0
fi
warn "Harbour is not installed (no 'hbmk2' on PATH, nor in $HB_DIR/bin)."

step "2/2 Install Harbour $HB_VERSION"
explain "WHY: no package manager ships a current Harbour, so it is built from"
explain "     the official source release (see harbour-env.sh)."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        build_harbour_from_source ;;
    windows)
        explain "Download harbour-$HB_VERSION-win-mingw64.7z from"
        explain "    https://github.com/harbour/core/releases/tag/v$HB_VERSION"
        explain "unpack it (for example into C:\\harbour) and add its bin folder to PATH."
        explain "It also needs a MinGW-w64 C compiler (for example from https://www.msys2.org/)."
        explain "Reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. See https://github.com/harbour/core#how-to-build-and-install-harbour-from-source" ;;
esac

has_cmd hbmk2 || fail "'hbmk2' is still not on PATH. Open a new terminal and retry."
ok "Harbour $HB_VERSION is ready in $HB_DIR. Next: ./build.sh"
