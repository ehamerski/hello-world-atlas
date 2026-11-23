#!/bin/sh
# run.sh - Bash cli: run the Hello World program
#
# WHAT: runs hello.sh, which prints exactly: Hello, World!
# WHY:  Bash is an interpreter: the bash program reads hello.sh and runs it line by
#       line. There is no build.sh because there is no compile step. This script is
#       POSIX sh; hello.sh is a Bash script that run.sh starts with "bash".
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does the same thing and exits by itself)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.sh" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd bash "Bash runs this program."

step "Run the program"
explain "WHY: 'bash hello.sh' starts the interpreter, which runs the file from top to bottom."
bash hello.sh
