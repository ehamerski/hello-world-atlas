# shellcheck shell=sh
# julia-env.sh - Julia cli: where Julia is, shared by install.sh and run.sh
#                (sourced, not run: it only sets variables and PATH)
#
# WHAT: sets JULIA_VERSION, JULIA_URL, JULIA_SHA256, JULIA_PREFIX, JULIA (the
#       interpreter), and puts $JULIA_PREFIX/bin first on PATH.
# WHY:  Julia is installed from the official tarball of the Julia project into a
#       folder in your home directory, so no package manager and no sudo is needed,
#       and the scripts find the same Julia every time, whatever your shell PATH is.
#
# JULIA_SHA256 is the SHA-256 digest of the macOS Intel (x86_64) tarball at JULIA_URL.
# The Julia project publishes it in
# https://julialang-s3.julialang.org/bin/checksums/julia-1.13.4.sha256, and it was
# read on 2026-11-20. The project also publishes a GPG
# signature (the same URL plus ".asc"), made with the Julia Release Signing Key
# (fingerprint 64B779A570972FFF7BFC2B54EAD471E1A1F2C10A, in use since v1.13.0-rc2, as
# https://julialang.org/downloads/manual-downloads/ states). install.sh checks the SHA-256
# digest only; README.md shows how to check the signature by hand.
# To use another platform, take its tarball and digest from
# https://julialang.org/downloads/manual-downloads/ and change the two lines below.

# shellcheck disable=SC2034  # JULIA_VERSION and JULIA_SHA256 are used by install.sh
JULIA_VERSION=1.13.4
JULIA_URL=https://julialang-s3.julialang.org/bin/mac/x64/1.13/julia-$JULIA_VERSION-mac64.tar.gz
JULIA_SHA256=c84de0fcb4268841f296fd56c47c27383d81358033428389b0d1882b110b9bcd
# Override with: JULIA_PREFIX=/some/dir ./install.sh (and the same for run.sh)
JULIA_PREFIX=${JULIA_PREFIX:-$HOME/.local/julia-$JULIA_VERSION}
JULIA=$JULIA_PREFIX/bin/julia
PATH=$JULIA_PREFIX/bin:$PATH
export PATH
