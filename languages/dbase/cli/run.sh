#!/bin/sh
# run.sh - dBASE III Plus cli: run the Hello World program
#
# WHAT: runs build/hello, which prints exactly: Hello, World!
# WHY:  build/hello is the native program that build.sh made from hello.prg with Harbour.
#       It runs like any other command and exits by itself.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# COMPROMISE: Harbour runs the dBASE III-compatible code; dBASE III Plus (DOS) is not
# run here. See README.md.
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows
# are NOT verified for this implementation.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "Run the program"
explain "WHY: build/hello is the native program that build.sh made from hello.prg."
[ -x build/hello ] || fail "build/hello was not found. Run ./build.sh first."
./build/hello
