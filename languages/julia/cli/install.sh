#!/bin/sh
# install.sh - Julia cli: check (and optionally install) Julia 1.13.4
#
# WHAT: checks that the Julia interpreter (julia) is in $JULIA_PREFIX (see julia-env.sh).
#       If it is missing, offers to download the official tarball from the Julia project,
#       check its SHA-256 digest, and unpack it into $JULIA_PREFIX. Nothing is installed
#       without your "y", and sudo is never used.
# WHY:  hello.jl needs the Julia interpreter. The tarball holds a complete Julia and
#       needs no installer, so it goes into a folder in your home directory.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented and NOT verified: the pinned tarball
# is for macOS Intel only.
# Source: https://julialang.org/downloads/manual-downloads/ (URL and digest in julia-env.sh).
# The Julia project publishes a SHA-256 digest and a GPG signature for each tarball. This
# script checks the digest; README.md shows the signature check.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# JULIA_VERSION, JULIA_URL, JULIA_SHA256, JULIA_PREFIX, JULIA.
# shellcheck source=julia-env.sh
. ./julia-env.sh

# install_julia_tarball - download the tarball, check its digest, unpack it into
# $JULIA_PREFIX (no sudo).
install_julia_tarball() {
    julia_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-julia
    julia_tgz=julia-$JULIA_VERSION-mac64.tar.gz
    explain "Download $julia_tgz (about 275 MB) from julialang-s3.julialang.org into"
    explain "$julia_cache, check its SHA-256 digest, and unpack it into $JULIA_PREFIX."
    confirm "Install Julia $JULIA_VERSION now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd curl || fail "curl is missing. Install curl, then run ./install.sh again."
    has_cmd shasum || fail "shasum is missing. It checks the download."
    mkdir -p "$julia_cache"
    [ -f "$julia_cache/$julia_tgz" ] || curl -fL -o "$julia_cache/$julia_tgz" "$JULIA_URL"
    # The digest proves the file is exactly the archive that the Julia project published.
    echo "$JULIA_SHA256  $julia_cache/$julia_tgz" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $julia_cache/$julia_tgz and retry."

    # Unpack beside the final folder first, so an interrupted run leaves no half-installed Julia.
    julia_tmp=$JULIA_PREFIX.tmp.$$
    mkdir -p "$julia_tmp"
    # --strip-components=1 drops the top folder of the tarball (julia-1.13.4/).
    tar -xzf "$julia_cache/$julia_tgz" -C "$julia_tmp" --strip-components=1 \
        || { rm -rf "$julia_tmp"; fail "Unpacking failed. See the messages above."; }
    rm -rf "$JULIA_PREFIX"
    mv "$julia_tmp" "$JULIA_PREFIX"
}

step "1/2 Check whether Julia is installed"
explain "WHY: julia reads and runs hello.jl; without it the program cannot run."
if [ -x "$JULIA" ]; then
    ok "Julia found: $("$JULIA" --version 2>&1 | head -n 1) ($JULIA)"
    exit 0
fi
warn "Julia is not installed at $JULIA."

step "2/2 Install Julia $JULIA_VERSION"
explain "WHY: the official tarball is a complete Julia that needs no installer and no sudo."
case "$TF_OS" in
    macos-intel)
        install_julia_tarball ;;
    macos-arm|linux)
        explain "julia-env.sh pins the macOS Intel tarball only, so this script cannot install it here."
        explain "Download the tarball for your system from https://julialang.org/downloads/manual-downloads/,"
        explain "put its URL and SHA-256 digest in julia-env.sh, and run ./install.sh again."
        fail "This platform is not verified for this implementation." ;;
    *)
        fail "Windows is not verified for this implementation. Use WSL, or see https://julialang.org/downloads/." ;;
esac

[ -x "$JULIA" ] || fail "'$JULIA' was not installed. See the messages above."
ok "Julia $JULIA_VERSION is ready in $JULIA_PREFIX. Next: ./run.sh"
