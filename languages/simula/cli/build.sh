#!/bin/sh
# build.sh - Simula cli: compile hello.sim into a native program
#
# WHAT: runs GNU Cim on hello.sim and writes the program to build/hello.
# WHY:  Simula source cannot run by itself. cim translates it to C, and the
#       C compiler makes the executable. Compiled output goes into build/,
#       which is ignored by git, so the source folder stays clean.
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.sim)
#
# Platforms: macOS Intel (verified on the development machine). Linux and
# Windows (Git Bash) are documented but NOT verified for this implementation.
# Source for the -o option: `cim --help` of GNU Cim 5.1 lists "-o FILE,
# --output=FILE"; the release is at https://ftp.gnu.org/gnu/cim/ .

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# CIM, CIM_PREFIX.
# shellcheck source=cim-env.sh
. ./cim-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs GNU Cim; ./install.sh installs it."
[ -x "$CIM" ] || fail "cim was not found at $CIM. Run ./install.sh first."

step "2/2 Compile hello.sim"
explain "WHY: cim writes hello.c, the C compiler makes hello.o, and the program is linked."
explain "     cim writes these files next to its input, so it works in build/ (a copy of"
explain "     hello.sim) and keeps this folder clean. Warnings about the generated C code are harmless."
mkdir -p build
cp hello.sim build/
(
    cd build
    "$CIM" -o hello hello.sim
)

ok "Build finished: build/hello. Next: ./run.sh"
