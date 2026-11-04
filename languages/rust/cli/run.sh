#!/bin/sh
# run.sh - Rust cli: run the Hello World program
#
# WHAT: runs target/release/hello-cli, which prints exactly: Hello, World!
# WHY:  target/release/hello-cli is a native executable made by ./build.sh.
#       The operating system runs it directly: no interpreter, no virtual
#       machine and no Rust installation are needed at this point.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so target/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

BIN=target/release/hello-cli
[ -x "$BIN" ] || fail "$BIN is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: $BIN is machine code; the operating system runs it directly."
"./$BIN"
