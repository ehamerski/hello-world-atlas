#!/bin/sh
# run.sh - Python desktop: open the Hello World window
#
# WHAT: runs hello.py, which opens a window that shows: Hello, World!
# WHY:  like the cli version, Python runs hello.py directly (no build step).
#       The window itself is drawn by the Tk toolkit, which Python reaches
#       through the tkinter module.
# HOW:  ./run.sh            open the window; close it to end the program
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once its window is shown
#                           and closes itself after about 2 seconds
#       PYTHON=python ./run.sh   use another interpreter command (Windows)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# A desktop app needs a graphical session: it cannot open a window over a
# plain SSH connection or in a CI job without a display.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.py" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The interpreter command: "python3.14" on macOS (see install.sh for why),
# "python3" elsewhere. On Windows it is usually "python" or "py".
case "$TF_OS" in
    macos-*) PYTHON=${PYTHON:-python3.14} ;;
    *)       PYTHON=${PYTHON:-python3} ;;
esac
require_cmd "$PYTHON" "Python 3 runs this program."
"$PYTHON" -c "import tkinter" 2>/dev/null \
    || fail "This Python cannot load tkinter. Run ./install.sh first."

step "Open the Hello World window"
explain "WHY: tkinter asks Tk to create a native window; mainloop() keeps it open."
if is_verify "$@"; then
    # TF_VERIFY=1 switches on the self-check at the end of hello.py.
    TF_VERIFY=1 "$PYTHON" hello.py
else
    explain "Close the window (or press Ctrl+C here) to end the program."
    "$PYTHON" hello.py
fi
