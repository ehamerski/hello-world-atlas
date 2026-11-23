#!/bin/sh
# run.sh - Go desktop: open the Hello World window
#
# WHAT: starts bin/hello-desktop, which opens a window titled
#       "Hello, World!" that shows the text Hello, World!
# WHY:  bin/hello-desktop is a native executable made by ./build.sh, with
#       Fyne linked inside, so the operating system runs it directly.
# HOW:  ./run.sh            open the window (close it to end the program)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once it is running and
#                           closes itself after about 2 seconds
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x bin/hello-desktop ] || fail "bin/hello-desktop is missing. Run ./build.sh first."

step "Open the Hello World window"
explain "WHY: Fyne, linked into bin/hello-desktop, opens the window and draws it with OpenGL."
if is_verify "$@"; then
    explain "Self-check: the app prints the label text and closes after ~2 seconds."
    TF_VERIFY=1 ./bin/hello-desktop
else
    explain "Close the window to end the program."
    ./bin/hello-desktop
fi
