#!/bin/sh
# build.sh - COBOL cli: compile hello.cob into bin/hello-cli with GnuCOBOL
#
# WHAT: runs
#         cobc -x -std=cobol85 -Wall -o bin/hello-cli hello.cob
#       cobc translates hello.cob into C, calls the C compiler on that C
#       code and links the result with libcob (GnuCOBOL's runtime library)
#       into bin/hello-cli. The temporary C files are deleted afterwards.
# WHY:  COBOL is compiled ahead of time, like C and Go. The flags:
#         -x             build an executable program (without it, cobc
#                        builds a module that another program CALLs)
#         -std=cobol85   check the source against the COBOL-85 standard,
#                        the ANSI standard of COBOL's mainframe era
#         -Wall          enable most warnings
#         -o bin/hello-cli  the name of the output file
#       Fixed source format (columns 7, 8-11, 12-72) is cobc's default.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#       ./build.sh -save-temps keep the generated C files to look at them
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.cob is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check the compiler"
explain "WHY: building needs GnuCOBOL's 'cobc' and the C compiler it calls;"
explain "     ./install.sh checks for them."
fix_developer_dir
require_cmd cobc "GnuCOBOL's compiler turns hello.cob into an executable."

step "2/2 Compile hello.cob (COBOL-85, fixed format)"
explain "WHY: -x makes an executable, -std=cobol85 checks the program against the"
explain "     1985 standard, -Wall adds warnings and -o names the executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it. "$@" passes any
# extra options given to build.sh (e.g. -save-temps) on to cobc.
set -x
cobc -x -std=cobol85 -Wall "$@" -o bin/hello-cli hello.cob
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $(cobc --version 2>&1 | head -n 1). Next: ./run.sh"
