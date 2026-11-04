#!/bin/sh
# install.sh - Python cli: check (and optionally install) the toolchain
#
# WHAT: checks that a Python 3 interpreter is installed. If it is missing,
#       shows the official install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  Python is interpreted: hello.py is run by the python3 program, so
#       that program must be on your PATH. The cli version needs nothing
#       else, only the language itself.
# HOW:  ./install.sh       (run once; safe to run again)
#       PYTHON=python ./install.sh   check another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/python@3.14
#   https://docs.python.org/3/using/unix.html
#   https://docs.python.org/3/using/windows.html

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The interpreter command. On macOS it is "python3.14": Homebrew's
# python@3.14 puts only this versioned name on PATH, and a plain "python3"
# there is often Apple's older /usr/bin/python3. On Windows it is usually
# "python" or "py".
case "$TF_OS" in
    macos-*) TOOL=${PYTHON:-python3.14} ;;
    *)       TOOL=${PYTHON:-python3} ;;
esac
TOOL_NAME="Python 3"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: hello.py is run by the Python interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" --version 2>&1 | head -n 1)"
    exit 0
fi
warn "$TOOL_NAME is not installed (no '$TOOL' on PATH)."

step "2/2 Install $TOOL_NAME"
explain "WHY: each OS has an official or standard way to install Python;"
explain "     a package manager also keeps it up to date."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) installs command-line tools on macOS.
        # The python.org installer is the other official option:
        # https://www.python.org/downloads/macos/
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install python@3.14 ;;
    linux)
        # Debian/Ubuntu shown; most distributions already ship python3.
        install_pkg "$TOOL_NAME" sudo apt-get install -y python3 ;;
    windows)
        # The Python install manager is the CPython team's recommended way
        # on Windows (https://docs.python.org/3/using/windows.html).
        explain "On Windows run this in PowerShell, then reopen Git Bash:"
        explain "    winget install 9NQ7512CXL7T -e --accept-package-agreements --disable-interactivity"
        explain "    py install 3.14"
        explain "Then run the scripts with: PYTHON=python ./install.sh"
        exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://www.python.org/downloads/" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
