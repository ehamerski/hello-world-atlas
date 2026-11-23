#!/bin/sh
# run.sh - Swift cli: run the Hello World program
#
# WHAT: runs the compiled `hello` executable (or compiles first if missing).
# WHY:  `hello` is a native executable made by `./build.sh`. The operating
#       system runs it directly: no interpreter is needed at runtime beyond
#       the Swift standard library (preinstalled on macOS with Xcode).
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine). macOS Apple Silicon,
# Linux and Windows are documented but not verified.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x ./hello ] || {
    explain "Compiling first (hello is missing)."
    sh build.sh
}

step "Run the program"
explain "WHY: hello is machine code; the operating system runs it directly."
./hello
