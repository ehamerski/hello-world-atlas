#!/bin/sh
# build.sh - Delphi-dialect cli: compile hello.pas with Free Pascal
#
# WHAT: runs fpc in Delphi mode on hello.pas and writes the program to build/hello.
# WHY:  Free Pascal turns Pascal source into a native program. -Mdelphi selects the
#       Delphi dialect, the same as {$mode delphi} in hello.pas. The output goes
#       into build/, which git ignores, so the source folder stays clean.
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.pas)
#
# COMPROMISE: this is the Delphi dialect compiled by Free Pascal, not Delphi
# (Embarcadero, commercial, Windows). Delphi itself is NOT verified.
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows
# (Git Bash) are documented and NOT verified for this implementation.
# Source for -M, -FE, -FU and -o: Free Pascal User's Guide, "Command line options",
# https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# FPC, FPC_VERSION, PATH.
# shellcheck source=delphi-env.sh
. ./delphi-env.sh

# On macOS, make sure the Apple linker and assembler tools are usable (see common.sh).
fix_developer_dir

step "1/2 Check the compiler"
explain "WHY: building needs Free Pascal; ./install.sh installs it."
require_cmd "$FPC" "Free Pascal is needed to compile."

step "2/2 Compile hello.pas in Delphi mode"
explain "WHY: -Mdelphi selects the Delphi dialect; -FE and -FU keep the files in build/;"
explain "     -o names the program. The Free Pascal version is printed next."
mkdir -p build
OUT=build/hello
[ "$TF_OS" = windows ] && OUT=build/hello.exe
# set -x prints the exact command, so you can copy it.
set -x
"$FPC" -Mdelphi -FEbuild -FUbuild "-o$OUT" hello.pas
{ set +x; } 2>/dev/null

ok "Built $OUT with Free Pascal $("$FPC" -iV). Next: ./run.sh"
