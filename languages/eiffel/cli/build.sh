#!/bin/sh
# build.sh - Eiffel cli: compile hello.e into a native program
#
# WHAT: runs gec on hello.e and writes the program to build/hello.
# WHY:  Eiffel source cannot run by itself. gec checks the types (including the
#       contract expressions) and translates the program to C; the C compiler
#       makes the program.
#       gec names the program after the root class (HELLO becomes hello), and
#       it writes its files into the folder you run it from. So we work in
#       build/, which git ignores, and the source folder stays clean.
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.e)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified
# for this implementation.
# Source for gec's behaviour: the Gobo Eiffel 26.03 documentation installed by
# the Homebrew formula (https://www.gobosoft.com/).

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# On macOS, make sure the Apple compiler tools are usable (see common.sh).
fix_developer_dir

step "1/2 Check the compiler"
explain "WHY: building needs gec; ./install.sh installs it."
require_cmd gec "The Gobo Eiffel compiler is needed."

step "2/2 Compile hello.e"
explain "WHY: gec checks the types (including the contract expressions), makes C code, and calls the C compiler."
explain "     The output is named after the root class, so build/hello is the program."
explain "     The ld warnings about REFERENCED_DYNAMICALLY come from the Apple linker, not from our code."
mkdir -p build
(
    cd build
    gec ../hello.e
)

[ -x build/hello ] || fail "gec did not produce build/hello. See the messages above."
ok "Build finished: build/hello. Next: ./run.sh"
