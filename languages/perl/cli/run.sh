#!/bin/sh
# run.sh - Perl cli: run the Hello World program
#
# WHAT: runs hello.pl, which prints exactly: Hello, World!
# WHY:  Perl is an interpreted language. There is no build.sh: the perl
#       interpreter reads hello.pl and runs it directly. (It does compile
#       the code to an internal form in memory first, but that happens
#       automatically each time, so you never run a separate compile step.)
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does the same thing)
#       PERL=perl5 ./run.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.pl" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

PERL=${PERL:-perl}
require_cmd "$PERL" "Perl runs this program."

step "Run the program"
explain "WHY: '$PERL hello.pl' starts the interpreter, which runs the file top to bottom."
"$PERL" hello.pl
