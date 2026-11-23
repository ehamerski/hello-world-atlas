#!/bin/sh
# run.sh - Swift desktop: open the Hello World window
#
# WHAT: runs the compiled `hello` executable, which opens a 300x200 window
#       with "Hello, World!" in large title text.
# WHY:  `hello` is a native macOS program; SwiftUI and AppKit draw the window.
# HOW:  ./run.sh            open the window; quit the app (Cmd+Q) to end
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" and closes after ~2 seconds
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon
# is not verified. Linux and Windows cannot run it: SwiftUI exists only on
# Apple platforms.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x ./hello ] || {
    explain "Compiling first (hello is missing)."
    sh build.sh
}

step "Open the Hello World window"
explain "WHY: SwiftUI, loaded by hello, opens the window and draws the text."
if is_verify "$@"; then
    explain "Self-check: the app prints the label text and closes after ~2 seconds."
    TF_VERIFY=1 ./hello
else
    explain "Quit the app (Cmd+Q) or press Ctrl+C here to end the program."
    # `exec` replaces this script with the app, so Ctrl+C stops it directly.
    exec ./hello
fi
