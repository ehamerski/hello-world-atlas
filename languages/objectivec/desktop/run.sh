#!/bin/sh
# run.sh - Objective-C desktop: run the Hello World program
#
# WHAT: runs the compiled `hello` executable, which opens the window. With
#       --verify, sets TF_VERIFY=1: the program also prints "Hello, World!"
#       to stdout and closes after about 2 seconds.
# WHY:  the self-check runs the same window code a person sees, and ends on
#       its own, so scripts/verify-all.sh needs no one to close the window.
# HOW:  ./run.sh            open the window (Cmd+Q or Ctrl+C to quit)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#
# The AppKit window shows "Hello, World!" in bold 48pt text, centered in a
# 600x400 window.
#
# Platforms: macOS Intel (verified on the dev machine); Linux (GNUstep) and
# Windows are documented but NOT verified.

set -eu

cd -- "$(dirname -- "$0")"
. ../../../scripts/common.sh

[ -x ./hello ] || {
    explain "Compiling first (hello is missing)."
    sh build.sh
}

step "Open the Hello World window"
explain "WHY: AppKit, loaded by hello, opens the window and draws the text."
if is_verify "$@"; then
    explain "Self-check: the app prints the label text and closes after ~2 seconds."
    TF_VERIFY=1 ./hello
else
    explain "Quit the app (Cmd+Q) or press Ctrl+C here to end the program."
    # `exec` replaces this script with the app, so Ctrl+C stops it directly.
    exec ./hello
fi
