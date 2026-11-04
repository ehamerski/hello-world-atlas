#!/bin/sh
# run.sh - Common Lisp cli: run the Hello World program
#
# WHAT: runs bin/hello-cli, which prints exactly: Hello, World!
# WHY:  bin/hello-cli is the Lisp image saved by ./build.sh, with the SBCL
#       runtime inside. The operating system starts it, the image is loaded
#       back into memory, and SBCL calls MAIN. SBCL itself is not needed at
#       this point.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x bin/hello-cli ] || fail "bin/hello-cli is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: bin/hello-cli is a saved Lisp image plus the SBCL runtime; the"
explain "     operating system runs it, and the image calls MAIN."
./bin/hello-cli
