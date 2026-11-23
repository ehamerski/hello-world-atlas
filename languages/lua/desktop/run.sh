#!/bin/sh
# run.sh - Lua desktop: open the Hello World window
#
# WHAT: runs LÖVE on this folder: it loads conf.lua and main.lua, and opens
#       a window titled "Hello, World!" that shows: Hello, World!
# WHY:  a LÖVE game is a folder with a main.lua. The "love" program takes the
#       folder as its argument and runs the code inside.
# HOW:  ./run.sh            open the window; close it to end the program
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once its window is shown
#                           and closes itself after about 2 seconds
#       LOVE=/path/to/love ./run.sh   use another LÖVE program
#
# Platforms: macOS Intel (verified on the dev machine); Linux verified in CI;
# macOS Apple Silicon, Windows (Git Bash) and WSL are documented but NOT
# verified.
# A desktop app needs a graphical session: it cannot open a window over a
# plain SSH connection or in a CI job without a display.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "." is the folder with main.lua.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# LOVE_BIN: where the love program is (see love-env.sh).
# shellcheck source=love-env.sh
. ./love-env.sh

[ -x "$LOVE_BIN" ] || has_cmd "$LOVE_BIN" \
    || fail "LÖVE was not found ('$LOVE_BIN'). Run ./install.sh first."

step "Open the Hello World window"
explain "WHY: 'love .' starts LÖVE, which runs conf.lua and main.lua from this folder."
if is_verify "$@"; then
    # TF_VERIFY=1 switches on the self-check in main.lua: it prints
    # "Hello, World!" and quits after about 2 seconds.
    TF_VERIFY=1 "$LOVE_BIN" .
else
    explain "Close the window (or press Ctrl+C here) to end the program."
    "$LOVE_BIN" .
fi
