#!/bin/sh
# run.sh - Node.js desktop: open the Hello World window
#
# WHAT: starts Electron with this folder as the app. Electron reads
#       package.json, runs the file named in "main" (main.js), and main.js
#       opens a window that shows index.html: Hello, World!
# WHY:  there is no build step: Electron runs main.js directly, as Node.js
#       does in ../cli. (Shipping the app to other people would need a
#       packaging tool such as Electron Forge; a Hello World does not.)
# HOW:  ./run.sh            open the window; close it (Cmd+Q on macOS) to end
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once the page is shown
#                           and quits by itself after about 2 seconds
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# A desktop app needs a graphical session: it cannot open a window over a
# plain SSH connection or in a CI job without a display.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "." below means this app.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd node "Node.js starts the electron command."
# Without the downloaded program, the electron command would start a
# ~125 MB download on its own. install.sh asks before doing that.
[ -f node_modules/electron/path.txt ] \
    || fail "Electron is not installed in node_modules/. Run ./install.sh first."

# npm puts the "electron" command of the package in node_modules/.bin/.
ELECTRON=node_modules/.bin/electron

step "Open the Hello World window"
explain "WHY: 'electron .' runs main.js in Electron's main process; main.js opens"
explain "     a window whose content (index.html) is drawn by Chromium."
if is_verify "$@"; then
    # TF_VERIFY=1 switches on the self-check in main.js.
    TF_VERIFY=1 "$ELECTRON" .
else
    explain "Close the window (Cmd+Q on macOS, or Ctrl+C here) to end the program."
    "$ELECTRON" .
fi
