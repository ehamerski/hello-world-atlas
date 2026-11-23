#!/bin/sh
# build.sh - Fortran cli: compile hello.f90 into bin/hello-cli
#
# WHAT: runs
#         gfortran -std=f2008 -Wall -Wextra -o bin/hello-cli hello.f90
#       gfortran compiles hello.f90 to machine code and links it with the
#       Fortran runtime library (libgfortran) into bin/hello-cli.
# WHY:  Fortran is compiled ahead of time, like C and COBOL. The flags:
#         -std=f2008        accept only standard Fortran 2008 (no GNU
#                           extensions), like -std=c89 in ../../c/cli
#         -Wall -Wextra     extra warnings about suspicious code
#         -o bin/hello-cli  the name of the output file (default: a.out)
#       The ".f90" extension selects free-form source.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#       FC=gfortran-16 ./build.sh   use another gfortran command
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.f90 is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# FC is the usual name for "the Fortran compiler" in build tools.
FC=${FC:-gfortran}

step "1/2 Check the compiler"
explain "WHY: building needs gfortran; ./install.sh checks for it."
# gfortran uses Apple's linker on macOS; make sure it comes from a working
# developer directory.
fix_developer_dir
require_cmd "$FC" "gfortran turns hello.f90 into an executable."

step "2/2 Compile hello.f90 as Fortran 2008"
explain "WHY: -std=f2008 rejects anything that is not standard Fortran 2008;"
explain "     -Wall -Wextra add warnings; -o names the executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it.
set -x
"$FC" -std=f2008 -Wall -Wextra -o bin/hello-cli hello.f90
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $("$FC" --version 2>&1 | head -n 1). Next: ./run.sh"
