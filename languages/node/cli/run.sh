#!/bin/sh
# run.sh - Node.js cli: run the Hello World program
#
# WHAT: runs hello.js, which prints exactly: Hello, World!
# WHY:  there is no build.sh. Node.js reads hello.js and runs it directly.
#       Its V8 engine turns the source into bytecode in memory and compiles
#       the parts that run often to machine code while the program runs
#       ("just-in-time"), so, as with Python, there is no separate compile
#       step for you to run.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.js" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd node "Node.js runs this program."

step "Run the program"
explain "WHY: 'node hello.js' starts the Node.js runtime, which runs the file top to bottom."
node hello.js
