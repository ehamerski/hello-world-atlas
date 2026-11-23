#!/bin/sh
# run.sh - ALGOL 68 cli: run the Hello World program
#
# WHAT: runs hello.a68 with a68g, which prints exactly: Hello, World!
# WHY:  a68g is an interpreter: it reads hello.a68, checks it, and runs it
#       in one step, so this folder has no build.sh. The program exits when
#       its last statement is done.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts $A68G_DIR/bin on PATH when install.sh installed a68g there.
# shellcheck source=algol68-env.sh
. ./algol68-env.sh

step "Run the program"
explain "WHY: a68g reads hello.a68 and runs it directly (no build step)."
require_cmd a68g "The Algol 68 Genie interpreter is needed."
a68g hello.a68
