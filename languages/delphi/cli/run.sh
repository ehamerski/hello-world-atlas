#!/bin/sh
# run.sh - Delphi-dialect cli: run the Hello World program
#
# WHAT: runs build/hello, which prints exactly: Hello, World!
# WHY:  build/hello is the native program made by build.sh from hello.pas.
#       It runs like any other command and exits by itself.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# COMPROMISE: this is the Delphi dialect compiled by Free Pascal. Delphi (commercial,
# Windows) is NOT verified.
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows
# (Git Bash) are documented and NOT verified for this implementation.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail, TF_OS.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "Run the program"
explain "WHY: build/hello is the native program that build.sh made from hello.pas."
OUT=build/hello
[ "$TF_OS" = windows ] && OUT=build/hello.exe
[ -x "$OUT" ] || fail "$OUT was not found. Run ./build.sh first."
"./$OUT"
