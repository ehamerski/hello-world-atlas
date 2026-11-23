#!/bin/sh
# run.sh - Ada cli: run the Hello World program
#
# WHAT: runs bin/hello, which prints exactly: Hello, World!
# WHY:  bin/hello is a native executable made by ./build.sh. The operating
#       system runs it directly: no interpreter and no compiler are needed
#       now. ("alr run" would also work, but it first checks the build
#       again; running the file shows that it stands on its own.)
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the development machine); Linux and
# Windows (Git Bash) verified in CI; macOS Apple Silicon and WSL are
# documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# gprbuild adds ".exe" on Windows, so the program is bin/hello.exe there.
BIN=bin/hello
[ "$TF_OS" = windows ] && BIN=bin/hello.exe
[ -x "$BIN" ] || fail "$BIN is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: bin/hello is machine code; the operating system runs it directly."
"./$BIN"
