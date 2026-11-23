#!/bin/sh
# run.sh - Delphi-dialect desktop: open the Hello World window
#
# WHAT: runs build/hello, which opens a window titled and labelled Hello, World!
# WHY:  the LCL draws the window with the native toolkit (Cocoa on macOS).
#       The program is machine code, so run.sh only starts it.
# HOW:  ./run.sh            open the window; close it to end the program
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the program
#                           prints Hello, World!, and closes its window after about 2 seconds
#
# COMPROMISE: Delphi (commercial, Windows) is NOT verified; this is the Delphi dialect
# on Free Pascal and Lazarus.
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows
# are documented and NOT verified for this implementation.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "Open the Hello World window"
explain "WHY: the LCL draws the window with the native toolkit (Cocoa on macOS)."
[ -x build/hello ] || fail "build/hello was not found. Run ./build.sh first."
if is_verify "$@"; then
    # TF_VERIFY=1 makes hello.lpr print the line and close the window after 2 seconds.
    TF_VERIFY=1 ./build/hello
else
    ./build/hello
fi
