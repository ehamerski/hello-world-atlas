#!/bin/sh
# build.sh - Ada cli: compile src/hello.adb into bin/hello with Alire
#
# WHAT: runs "alr -n build". Alire reads alire.toml, writes the generated
#       settings in config/ and calls gprbuild on hello.gpr, which
#         - compiles src/hello.adb with GNAT (Ada 2022 mode, -gnat2022),
#         - binds it (gnatbind checks that every unit the program uses is
#           compiled and consistent, and writes the start-up code),
#         - links it into bin/hello.
# WHY:  Ada is compiled ahead of time, like C, COBOL and Fortran. Alire is
#       the standard way to get the compiler and build a project, like
#       Cargo for Rust; "-n" (non-interactive) takes default answers so
#       the script never stops to ask.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder: alr looks for alire.toml here.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check Alire"
explain "WHY: building needs alr and its GNAT toolchain; ./install.sh sets them up."
# GNAT links with Apple's linker on macOS; make sure it comes from a
# working developer directory.
fix_developer_dir
require_cmd alr "Alire installs GNAT and builds the program."

step "2/2 Build the crate (compile, bind, link)"
explain "WHY: GNAT compiles hello.adb (Ada 2022), gnatbind checks the program's units"
explain "     and the linker writes bin/hello. alr shows each phase."
# set -x prints the exact command, so you can copy it.
set -x
alr -n build
{ set +x; } 2>/dev/null

ok "Built bin/hello. Next: ./run.sh"
