#!/bin/sh
# run.sh - Zig cli: run the Hello World program
#
# WHAT: runs build/hello, the native program that build.sh made. It prints exactly:
#       Hello, World!
# WHY:  Zig is compiled ahead of time, so the program is a normal executable and needs
#       no interpreter or runtime to run.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented and NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x build/hello ] || fail "build/hello was not found. Run ./build.sh first."

step "Run the program"
explain "WHY: build/hello is the native program that build.sh made from hello.zig."
./build/hello
