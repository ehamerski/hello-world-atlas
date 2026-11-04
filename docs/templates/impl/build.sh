#!/bin/sh
# build.sh - <Language> <category>: compile the program
#
# TEMPLATE: copy to languages/<language>/<category>/build.sh ONLY if the language is
# compiled (C, C++, Java, C#, Go, Rust, Pascal, COBOL, Fortran, Ada, ...).
# Interpreted implementations (Python, Node, PHP, ...) have no build.sh.
# Replace every "TODO(template)" and <placeholder>; delete this paragraph.
#
# WHAT: turns the source code into <an executable / a .jar / ...> in
#       <output folder>.                     TODO(template)
# WHY:  the computer cannot run <Language> source directly; the compiler
#       <tool> translates it into <machine code / bytecode> first.  TODO(template)
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# On macOS, make sure the Apple compiler tools are usable (see common.sh).
# Keep this line for toolchains that call clang/ld; delete it otherwise.
fix_developer_dir

step "1/2 Check the compiler"
explain "WHY: building needs <tool>; ./install.sh installs it."  # TODO(template)
require_cmd "<command>" "<Tool> is needed to compile."           # TODO(template)

step "2/2 Compile"
explain "WHY: <what each important flag means, e.g. -Wall turns on warnings>."  # TODO(template)
# TODO(template): the real compile command, e.g.
#   cc -std=c99 -pedantic -Wall -o build/hello src/hello.c
mkdir -p build
echo "<compile command>"

ok "Build finished. Next: ./run.sh"
