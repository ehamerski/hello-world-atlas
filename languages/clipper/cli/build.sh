#!/bin/sh
# build.sh - Clipper cli: compile hello.prg into bin/hello-cli with Harbour
#
# WHAT: runs
#         hbmk2 -q0 -w3 -es2 -gtcgi hello.prg -obin/hello-cli
#       hbmk2, Harbour's build tool, runs the Harbour compiler, which
#       translates hello.prg into C (Harbour's virtual machine "pcode" in a
#       C file); then it calls the C compiler and links the result with
#       Harbour's runtime libraries into bin/hello-cli. The temporary C and
#       object files are deleted afterwards.
# WHY:  Clipper is compiled ahead of time; that was its point. It began as
#       a compiler for the dBASE language, at a time when dBASE's maker had
#       none (see ../README.md, History). The flags:
#         -q0      quiet: do not print the Harbour banner
#         -w3      the highest Harbour warning level (default 1)
#         -es2     treat warnings as errors (exit severity 2)
#         -gtcgi   use the "CGI" terminal driver (GT), which writes plain
#                  text to standard output. Harbour's default driver on
#                  macOS and Linux, GTTRM, controls the whole terminal
#                  screen like a Clipper program on MS-DOS and adds escape
#                  codes to the output, even when it goes to a pipe.
#         -obin/hello-cli  the name of the output file (no space after -o)
# HOW:  ./build.sh          (after ./install.sh; run again after editing)
#       ./build.sh -trace   also print every compiler and linker command
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.prg is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# HB_DIR; puts $HB_DIR/bin on PATH.
# shellcheck source=harbour-env.sh
. ./harbour-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs Harbour's hbmk2 and the C compiler it calls;"
explain "     ./install.sh checks for them."
fix_developer_dir
require_cmd hbmk2 "Harbour's build tool turns hello.prg into an executable."

step "2/2 Compile hello.prg"
explain "WHY: -q0 hides the banner, -w3 -es2 turn on every warning and make it an"
explain "     error, -gtcgi writes plain text and -o names the executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it. "$@" passes any
# extra options given to build.sh (e.g. -trace) on to hbmk2.
set -x
hbmk2 -q0 -w3 -es2 -gtcgi "$@" hello.prg -obin/hello-cli
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $(hbmk2 -build 2>&1 | grep -m 1 'Harbour'). Next: ./run.sh"
