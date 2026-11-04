#!/bin/sh
# run.sh - PHP cli: run the Hello World program
#
# WHAT: runs hello.php, which prints exactly: Hello, World!
# WHY:  PHP is an interpreted language. There is no build.sh: the php
#       interpreter reads hello.php and runs it directly. (It does compile
#       the code to bytecode in memory first, but that happens
#       automatically each time, so you never run a separate compile step.)
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#       PHP=/path/to/php ./run.sh   use another interpreter
#
# Platforms: macOS Intel (verified on the test machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.php" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

PHP=${PHP:-php}
require_cmd "$PHP" "PHP runs this program."

step "Run the program"
explain "WHY: '$PHP hello.php' starts the interpreter, which runs the file top to bottom."
"$PHP" hello.php
