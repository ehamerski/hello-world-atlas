#!/bin/sh
# install.sh - Simula cli: check (and optionally install) GNU Cim 5.1
#
# WHAT: checks that the Simula compiler cim is installed at $CIM_PREFIX
#       (see cim-env.sh). If it is missing, offers to download the official
#       GNU Cim 5.1 source tarball, check its SHA-256 digest, and build it
#       into your home folder. Nothing is installed without your "y", and
#       sudo is never used.
# WHY:  GNU Cim compiles Simula 67 to C, so its output runs as a normal
#       native program. It is the free Simula 67 compiler from the GNU
#       project (GPL-2.0), and it needs no Java or other runtime.
#       The source must be compiled on your computer. The configure
#       flags below are the ones that built on macOS 26 on the
#       development machine (2026-11-02). They only silence C warnings
#       about old C code that Cim generates. One symbolic link is made
#       so that the library's include path resolves. No source file is patched.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). Linux
# (Ubuntu, Debian) and Windows (Git Bash) are documented but NOT verified
# for this implementation. macOS Apple Silicon and WSL are not verified.
# Sources for the install steps: https://ftp.gnu.org/gnu/cim/ (the
# tarball, its GPG signature and the GNU Cim manual, cim.info), and
# https://www.gnu.org/software/cim/ (the project page).

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# CIM_VERSION, CIM_SHA256, CIM_URL, CIM_PREFIX, CIM.
# shellcheck source=cim-env.sh
. ./cim-env.sh

# build_cim - download, check and build GNU Cim into $CIM_PREFIX.
build_cim() {
    cim_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-simula
    cim_tar=cim-$CIM_VERSION.tar.gz
    explain "Download $cim_tar from the GNU server into $cim_cache,"
    explain "check its SHA-256 digest, unpack it there and build it with make."
    explain "The compiler is installed into $CIM_PREFIX (no sudo)."
    confirm "Build GNU Cim $CIM_VERSION now (a few minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd make || fail "make is missing. Run: xcode-select --install (macOS) or sudo apt-get install build-essential (Linux)."
    has_cmd cc || has_cmd gcc || fail "A C compiler is missing. Run: xcode-select --install (macOS) or install gcc."

    mkdir -p "$cim_cache"
    [ -f "$cim_cache/$cim_tar" ] || curl -fL -o "$cim_cache/$cim_tar" "$CIM_URL"
    # The checksum proves the file is exactly the GNU Cim 5.1 release.
    # shasum -a 256 is on macOS; sha256sum is on Linux and Git Bash.
    if has_cmd shasum; then cim_sum="shasum -a 256"; else cim_sum="sha256sum"; fi
    echo "$CIM_SHA256  $cim_cache/$cim_tar" | $cim_sum -c - \
        || fail "Checksum mismatch: delete $cim_cache/$cim_tar and retry."

    rm -rf "$cim_cache/cim-$CIM_VERSION"
    tar -xzf "$cim_cache/$cim_tar" -C "$cim_cache"
    # The library source simset.c includes "../../lib/cim.h". From lib/ that
    # path only exists if the folder above the source tree has a lib/ too.
    # A symbolic link does that without changing any source file (the same
    # link was used in the development machine's build, 2026-11-02).
    rm -f "$cim_cache/lib"
    ln -s "cim-$CIM_VERSION/lib" "$cim_cache/lib"
    # The flags are passed to the C compiler that Cim calls: they switch
    # off the warnings that old C code (which Cim generates) causes with
    # current gcc and clang. --prefix puts the result in $CIM_PREFIX.
    (
        cd "$cim_cache/cim-$CIM_VERSION"
        ./configure --prefix="$CIM_PREFIX" \
            CFLAGS="-O2 -std=gnu89 -Wno-implicit-function-declaration -Wno-implicit-int -Wno-int-conversion -Wno-return-mismatch -Wno-incompatible-pointer-types"
        make
        make install
    ) || fail "Building GNU Cim failed. See the messages above."
}

step "1/2 Check whether the GNU Cim compiler is installed"
explain "WHY: cim turns hello.sim into a native program (via C)."
# The C compiler that Cim calls is clang on macOS; make sure it works.
fix_developer_dir
if [ -x "$CIM" ]; then
    ok "GNU Cim found: $CIM"
    exit 0
fi
warn "GNU Cim is not installed at $CIM."

step "2/2 Install GNU Cim $CIM_VERSION"
explain "WHY: this script uses the official GNU source release, which is built on"
explain "     your computer (see cim-env.sh for the version and its SHA-256 digest)."
case "$TF_OS" in
    macos-intel|macos-arm|linux|windows)
        build_cim ;;
    *)
        fail "Unknown OS. See https://www.gnu.org/software/cim/ for the source tarball." ;;
esac

[ -x "$CIM" ] || fail "'$CIM' was not built. See the messages above."
ok "GNU Cim $CIM_VERSION is ready in $CIM_PREFIX. Next: ./build.sh"
