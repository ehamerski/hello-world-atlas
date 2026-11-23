#!/bin/sh
# run.sh - Assembly (x86-64) cli: run the Hello World program
#
# WHAT: runs bin/hello-cli, which prints exactly: Hello, World!
# WHY:  bin/hello-cli is a native executable made by ./build.sh. The CPU
#       runs its instructions directly: no interpreter, no virtual machine.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon
# (via Rosetta) is documented but NOT verified. Linux and Windows (Git Bash)
# build a different source and are verified in CI (see README.md,
# "Platform notes").

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x bin/hello-cli ] || fail "bin/hello-cli is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: bin/hello-cli is machine code; the operating system loads it and the CPU runs it."
./bin/hello-cli
