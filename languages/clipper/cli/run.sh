#!/bin/sh
# run.sh - Clipper cli: run the Hello World program
#
# WHAT: runs bin/hello-cli, which prints exactly: Hello, World!
# WHY:  bin/hello-cli is a native executable made by ./build.sh. The
#       operating system runs it directly; Harbour's virtual machine and
#       runtime library are linked into it, so Harbour itself
#       is not needed now.
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

# hbmk2 adds ".exe" on Windows, so the program is bin/hello-cli.exe there.
BIN=bin/hello-cli
[ "$TF_OS" = windows ] && BIN=bin/hello-cli.exe
[ -x "$BIN" ] || fail "$BIN is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: bin/hello-cli is machine code; the operating system runs it directly."
"./$BIN"
