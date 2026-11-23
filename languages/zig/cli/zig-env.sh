# shellcheck shell=sh
# zig-env.sh - Zig cli: where Zig is, shared by install.sh, build.sh and run.sh
#              (sourced, not run: it only sets variables and PATH)
#
# WHAT: sets ZIG_VERSION, ZIG_URL, ZIG_SHA256, ZIG_PREFIX, ZIG (the compiler), and puts
#       $ZIG_PREFIX first on PATH.
# WHY:  Zig is installed from the official tarball of the Zig project into a folder in
#       your home directory, so no package manager and no sudo is needed, and the scripts
#       find the same compiler every time, whatever your shell PATH is. The tarball holds
#       the zig program and its standard library (the lib/ folder) side by side.
#
# ZIG_SHA256 is the SHA-256 digest of the macOS Intel (x86_64) tarball at ZIG_URL. The Zig
# project publishes it in https://ziglang.org/download/index.json (field "shasum" of
# "0.17.0" / "x86_64-macos"), and it was checked against a downloaded copy on 2026-11-11 and against the index on 2026-11-12.
# The download page also lists a minisign signature for each file; install.sh checks the
# SHA-256 digest only.
# To use another platform, take its URL and digest from the same index and change the
# two lines below.

# shellcheck disable=SC2034  # ZIG_VERSION and ZIG_SHA256 are used by install.sh
ZIG_VERSION=0.17.0
ZIG_URL=https://ziglang.org/download/$ZIG_VERSION/zig-x86_64-macos-$ZIG_VERSION.tar.xz
ZIG_SHA256=4f9a1c5269aa17ebda5e6d3c2b89d6cbf36f7d2b22a0306e9ab98f25f95529c6
# Override with: ZIG_PREFIX=/some/dir ./install.sh (and the same for build.sh and run.sh)
ZIG_PREFIX=${ZIG_PREFIX:-$HOME/.local/zig-x86_64-macos-$ZIG_VERSION}
ZIG=$ZIG_PREFIX/zig
PATH=$ZIG_PREFIX:$PATH
export PATH
