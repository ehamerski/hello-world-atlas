#!/bin/sh
# run.sh - Python cli: run the Hello World program
#
# WHAT: runs hello.py, which prints exactly: Hello, World!
# WHY:  Python is an interpreted language. There is no build.sh: the
#       python3 interpreter reads hello.py and runs it directly. (It does
#       compile the code to bytecode in memory first, but that happens
#       automatically each time, so you never run a separate compile step.)
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does the same thing)
#       PYTHON=python ./run.sh   use another interpreter command (Windows)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.py" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The interpreter command: "python3.14" on macOS (see install.sh for why),
# "python3" elsewhere. On Windows it is usually "python" or "py".
case "$TF_OS" in
    macos-*) PYTHON=${PYTHON:-python3.14} ;;
    *)       PYTHON=${PYTHON:-python3} ;;
esac
require_cmd "$PYTHON" "Python 3 runs this program."

step "Run the program"
explain "WHY: '$PYTHON hello.py' starts the interpreter, which runs the file top to bottom."
"$PYTHON" hello.py
