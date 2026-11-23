#!/bin/sh
# install.sh - Zig cli: check (and optionally install) Zig 0.17.0
#
# WHAT: checks that the Zig compiler (zig) is in $ZIG_PREFIX (see zig-env.sh). If it is
#       missing, offers to download the official tarball from the Zig project, check its
#       SHA-256 digest, and unpack it into $ZIG_PREFIX. Nothing is installed without your
#       "y", and sudo is never used.
# WHY:  hello.zig needs the Zig compiler. The tarball holds the compiler and its standard
#       library and needs no installer, so it goes into a folder in your home directory.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented and NOT verified: the pinned tarball
# is for macOS Intel only.
# Source: https://ziglang.org/download/ and https://ziglang.org/download/index.json (URL and
# digest in zig-env.sh). The Zig project lists a minisign signature for each tarball. This
# script checks the SHA-256 digest only.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# ZIG_VERSION, ZIG_URL, ZIG_SHA256, ZIG_PREFIX, ZIG.
# shellcheck source=zig-env.sh
. ./zig-env.sh

# install_zig_tarball - download the tarball, check its digest, unpack it into
# $ZIG_PREFIX (no sudo).
install_zig_tarball() {
    zig_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-zig
    zig_txz=zig-x86_64-macos-$ZIG_VERSION.tar.xz
    explain "Download $zig_txz (about 60 MB) from ziglang.org into $zig_cache,"
    explain "check its SHA-256 digest, and unpack it into $ZIG_PREFIX."
    confirm "Install Zig $ZIG_VERSION now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd curl || fail "curl is missing. Install curl, then run ./install.sh again."
    has_cmd shasum || fail "shasum is missing. It checks the download."
    mkdir -p "$zig_cache"
    [ -f "$zig_cache/$zig_txz" ] || curl -fL -o "$zig_cache/$zig_txz" "$ZIG_URL"
    # The digest proves the file is exactly the archive that the Zig project published.
    echo "$ZIG_SHA256  $zig_cache/$zig_txz" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $zig_cache/$zig_txz and retry."

    # Unpack beside the final folder first, so an interrupted run leaves no half-installed Zig.
    zig_tmp=$ZIG_PREFIX.tmp.$$
    mkdir -p "$zig_tmp"
    # --strip-components=1 drops the top folder of the tarball (zig-x86_64-macos-0.17.0/).
    tar -xJf "$zig_cache/$zig_txz" -C "$zig_tmp" --strip-components=1 \
        || { rm -rf "$zig_tmp"; fail "Unpacking failed. See the messages above."; }
    rm -rf "$ZIG_PREFIX"
    mv "$zig_tmp" "$ZIG_PREFIX"
}

step "1/2 Check whether Zig is installed"
explain "WHY: zig compiles hello.zig; without it the program cannot be built."
if [ -x "$ZIG" ]; then
    ok "Zig found: $("$ZIG" version 2>&1 | head -n 1) ($ZIG)"
    exit 0
fi
warn "Zig is not installed at $ZIG."

step "2/2 Install Zig $ZIG_VERSION"
explain "WHY: the official tarball is a complete Zig that needs no installer and no sudo."
case "$TF_OS" in
    macos-intel)
        install_zig_tarball ;;
    macos-arm|linux)
        explain "zig-env.sh pins the macOS Intel tarball only, so this script cannot install it here."
        explain "Take the URL and digest for your system from https://ziglang.org/download/index.json,"
        explain "put them in zig-env.sh, and run ./install.sh again."
        fail "This platform is not verified for this implementation." ;;
    *)
        fail "Windows is not verified for this implementation. Use WSL, or see https://ziglang.org/download/." ;;
esac

[ -x "$ZIG" ] || fail "'$ZIG' was not installed. See the messages above."
ok "Zig $ZIG_VERSION is ready in $ZIG_PREFIX. Next: ./build.sh"
