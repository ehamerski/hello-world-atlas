#!/bin/sh
# build.sh - BASIC cli: compile hello.bas into bin/hello-cli with QB64-PE
#
# WHAT: runs
#         qb64pe -x -q -w hello.bas -o bin/hello-cli
#       QB64-PE translates hello.bas into C++, then calls the C++ compiler
#       (clang++ on macOS) and links the result with its runtime library
#       into bin/hello-cli.
# WHY:  QBasic, the MS-DOS original, ran programs from inside its editor.
#       QB64-PE is a compiler instead: the program is built ahead of time
#       into a native executable, like C or COBOL. The flags:
#         -x    compile only (do not open the QB64-PE editor) and show the
#               compiler's messages in this terminal
#         -q    quiet: print only warnings and errors
#         -w    show warnings too
#         -o    the name of the output file
#       QB64-PE also writes bin/hello-cli_start.command, a double-click
#       launcher for macOS Finder; this project does not need it.
# HOW:  ./build.sh                         (after ./install.sh; run again after editing)
#       QB64PE=/path/to/qb64pe ./build.sh  use another QB64-PE
#
# Platforms: macOS Intel (verified on the development machine); Linux and
# Windows (Git Bash) verified in CI; macOS Apple Silicon and WSL are
# documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.bas is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# QB64PE_DIR and QB64PE (the qb64pe command to use).
# shellcheck source=qb64pe-env.sh
. ./qb64pe-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs qb64pe and the C++ compiler it calls;"
explain "     ./install.sh checks for them."
fix_developer_dir
has_cmd "$QB64PE" || fail "'qb64pe' was not found. QB64-PE turns hello.bas into an executable. Run ./install.sh first."

step "2/2 Compile hello.bas"
explain "WHY: -x compiles without opening the editor, -q keeps the output short,"
explain "     -w shows warnings and -o names the executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it.
set -x
"$QB64PE" -x -q -w hello.bas -o bin/hello-cli
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $("$QB64PE" -v 2>&1 | head -n 1). Next: ./run.sh"
