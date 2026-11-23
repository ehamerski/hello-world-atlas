#!/bin/sh
# build.sh - C cli: compile hello.c into bin/hello-cli as strict ANSI C (C89)
#
# WHAT: runs
#         cc -std=c89 -pedantic-errors -Wall -Wextra -o bin/hello-cli hello.c
#       The compiler preprocesses hello.c (pastes <stdio.h>), compiles it to
#       machine code and links it with the C library into bin/hello-cli.
# WHY:  C is compiled ahead of time, like Go and unlike Python. The flags
#       are the point of this folder ("ANSI C"):
#         -std=c89          accept only the 1989 ANSI C language (C90 in ISO)
#         -pedantic-errors  turn every use of a later or non-standard feature
#                           into an error (try a // comment: it fails)
#         -Wall -Wextra     extra warnings about suspicious code
#         -o bin/hello-cli  the name of the output file (default: a.out)
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#       CC=gcc ./build.sh      use another compiler
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.c is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# CC is the usual name for "the C compiler" in build tools such as make;
# default to cc, the system's C compiler.
CC=${CC:-cc}

step "1/2 Check the compiler"
explain "WHY: building needs a C compiler; ./install.sh checks for one."
fix_developer_dir
require_cmd "$CC" "The C compiler turns hello.c into an executable."

step "2/2 Compile hello.c as ANSI C (C89)"
explain "WHY: -std=c89 -pedantic-errors makes the compiler reject anything that is not"
explain "     ANSI C; -Wall -Wextra add warnings; -o names the executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it.
set -x
"$CC" -std=c89 -pedantic-errors -Wall -Wextra -o bin/hello-cli hello.c
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $("$CC" --version 2>&1 | head -n 1). Next: ./run.sh"
