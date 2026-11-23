#!/bin/sh
# run.sh - Racket cli: run the Hello World program
#
# WHAT: runs hello.rkt, which prints exactly: Hello, World!
# WHY:  Racket has no separate build step here. "racket hello.rkt" loads the module,
#       compiles it in memory, and runs it. (raco make hello.rkt compiles ahead of time
#       into a compiled/ folder; the README explains it. It is optional.)
#       The racket program comes from the folder set in racket-env.sh.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does the same thing and exits by itself)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.rkt" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts the Racket bin folder on PATH for this script.
# shellcheck source=racket-env.sh
. ./racket-env.sh

require_cmd racket "Racket runs this program. (run ./install.sh first)"

step "Run the program"
explain "WHY: 'racket hello.rkt' starts Racket, which compiles the module in memory and runs it."
racket hello.rkt
