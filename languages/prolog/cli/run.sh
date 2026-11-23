#!/bin/sh
# run.sh - Prolog cli: run the Hello World program
#
# WHAT: runs "swipl hello.pl", which prints exactly: Hello, World!
# WHY:  there is no build.sh. swipl, the SWI-Prolog system, reads
#       hello.pl, compiles its clauses in memory into code for its own
#       virtual machine (as Python does with bytecode), then proves the
#       goal "main" because of the initialization(main, main) directive,
#       and exits. Nothing is written to disk.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#       SWIPL=/path/to/swipl ./run.sh   use another swipl command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.pl is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=../use-msys2-swipl.sh
. ../use-msys2-swipl.sh

SWIPL=${SWIPL:-swipl}
require_cmd "$SWIPL" "SWI-Prolog runs hello.pl."

step "Run the program"
explain "WHY: swipl loads hello.pl and proves the goal 'main', which prints the"
explain "     greeting as a side effect; then the program stops."
"$SWIPL" hello.pl
