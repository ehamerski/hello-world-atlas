#!/bin/sh
# run.sh - Rust desktop: open the Hello World window
#
# WHAT: starts target/release/hello-desktop, which opens a window titled
#       "Hello, World!" that shows the text Hello, World!
# WHY:  the executable made by ./build.sh contains eframe and egui, so the
#       operating system runs it directly. It draws the window with wgpu,
#       which uses Metal on macOS.
# HOW:  ./run.sh            open the window (close it to end the program)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once it is running and
#                           closes itself after about 2 seconds
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so target/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

BIN=target/release/hello-desktop
[ -x "$BIN" ] || fail "$BIN is missing. Run ./build.sh first."

step "Open the Hello World window"
explain "WHY: eframe, linked into $BIN, opens the window; egui draws it with the GPU."
if is_verify "$@"; then
    explain "Self-check: the app prints the label text and closes after ~2 seconds."
    TF_VERIFY=1 "./$BIN"
else
    explain "Close the window to end the program."
    "./$BIN"
fi
