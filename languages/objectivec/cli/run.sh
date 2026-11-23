#!/bin/sh
# run.sh - Objective-C cli: run the Hello World program
#
# WHAT: runs the compiled `hello` executable (or compiles first if missing).
# WHY:  `hello` is a native executable made by `./build.sh`. The operating
#       system runs it directly: no interpreter is needed at runtime beyond
#       the Foundation framework (preinstalled on macOS).
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#
# Platforms: macOS Intel (verified on the dev machine); Linux (GNUstep) and
# Windows are documented but NOT verified.

set -eu

cd -- "$(dirname -- "$0")"
. ../../../scripts/common.sh

[ -x ./hello ] || {
    explain "Compiling first (hello is missing)."
    sh build.sh
}

step "Run the program"
explain "WHY: hello is machine code; the operating system runs it directly."
./hello
