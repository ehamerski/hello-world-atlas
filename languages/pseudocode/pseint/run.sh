#!/bin/sh
# run.sh - Pseudocode (PSeInt): run hola.psc with the PSeInt interpreter
#
# WHAT: runs
#         pseint hola.psc --nouser
#       which prints exactly: Hello, World!
# WHY:  PSeInt pseudocode is interpreted: there is no build step, the
#       interpreter reads the algorithm and executes it, like Python runs a
#       .py file. The PSeInt editor does the same when you press "Ejecutar"
#       (run), but it shows the output in its own window and waits for a
#       key at the end. --nouser turns that off: "no mostrar mensajes de
#       estado ni esperar un tecla al final" ("do not show status messages
#       or wait for a key at the end", from `pseint` without arguments).
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hola.psc is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# PSEINT: the path of the interpreter, or empty.
# shellcheck source=pseint-env.sh
. ./pseint-env.sh

[ -n "$PSEINT" ] && [ -x "$PSEINT" ] || fail "PSeInt was not found. Run ./install.sh first."

step "Run hola.psc with the PSeInt interpreter"
explain "WHY: PSeInt reads the pseudocode and executes it; --nouser prints only"
explain "     the program's output and does not wait for a key at the end."
"$PSEINT" hola.psc --nouser
