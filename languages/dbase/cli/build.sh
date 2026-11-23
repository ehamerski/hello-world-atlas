#!/bin/sh
# build.sh - dBASE III Plus cli: compile hello.prg with Harbour into build/hello
#
# WHAT: runs hbmk2 on hello.prg and writes the program to build/hello.
# WHY:  Harbour turns the .prg file into C, and the C compiler makes the program.
#       -obuild/hello sets the output (the attached form: a space after -o would make
#       hbmk2 read build/hello as a second source file). -gtstd links the standard
#       console terminal driver, so ? and ?? write to the terminal (not a window).
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.prg)
#
# COMPROMISE: this is Harbour (open-source xBase) running dBASE III-compatible code,
# not dBASE III Plus (proprietary DOS software). See README.md.
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows are
# NOT verified for this implementation.
# Source for the hbmk2 options: the Harbour build-tool help (hbmk2 --help), and
# https://github.com/harbour/core

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# HB_DIR, PATH.
# shellcheck source=harbour-env.sh
. ./harbour-env.sh

# On macOS, make sure the Apple compiler tools are usable (see common.sh).
fix_developer_dir

step "1/2 Check the build tool"
explain "WHY: building needs hbmk2 (Harbour's build tool); ./install.sh installs it."
require_cmd hbmk2 "The Harbour build tool is needed to compile."

step "2/2 Compile hello.prg"
explain "WHY: hbmk2 runs the Harbour compiler, then the C compiler, and links build/hello."
mkdir -p build
# set -x prints the exact command, so you can copy it.
set -x
hbmk2 -obuild/hello -gtstd hello.prg
{ set +x; } 2>/dev/null

ok "Built build/hello. Next: ./run.sh"
