#!/bin/sh
# install.sh - Python desktop: check (and optionally install) Python and Tk
#
# WHAT: 1. checks that a Python 3 interpreter is installed;
#       2. checks that this Python can load tkinter (its link to Tcl/Tk).
#       If either is missing, shows the install command for your operating
#       system and runs it only if you answer "y". Nothing is installed
#       silently and sudo is never hidden.
# WHY:  tkinter is an optional part of Python: the Python docs advise
#       asking the distributor of your Python if it is missing. The
#       python.org installers include it, but Homebrew and Linux
#       distributions ship it as a separate package.
# HOW:  ./install.sh       (run once; safe to run again)
#       PYTHON=python ./install.sh   check another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://docs.python.org/3/library/tkinter.html
#   https://formulae.brew.sh/formula/python-tk@3.14
#   https://packages.debian.org/stable/python3-tk
#   https://docs.python.org/3/using/mac.html
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

step "1/2 Check whether Python 3 is installed"
explain "WHY: hello.py is run by the Python interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "Python 3 found: $("$TOOL" --version 2>&1 | head -n 1)"
else
    warn "Python 3 is not installed (no '$TOOL' on PATH)."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Python 3" brew install python@3.14 || exit 1 ;;
        linux)
            install_pkg "Python 3" sudo apt-get install -y python3 || exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install 9NQ7512CXL7T -e --accept-package-agreements --disable-interactivity"
            explain "    py install 3.14"
            explain "Then run the scripts with: PYTHON=python ./install.sh"
            exit 1 ;;
        *)
            fail "Unknown OS. Install Python by hand: https://www.python.org/downloads/" ;;
    esac
    has_cmd "$TOOL" || fail "Python 3 is still not on PATH. Open a new terminal and retry."
fi

# tk_version prints the Tcl/Tk version this Python uses, or fails if
# tkinter cannot be loaded.
tk_version() {
    "$TOOL" -c "import tkinter; print(tkinter.Tcl().eval('info patchlevel'))" 2>/dev/null
}

step "2/2 Check that this Python can use tkinter (Tcl/Tk)"
explain "WHY: tkinter needs the compiled module _tkinter and the Tcl/Tk libraries."
if TK=$(tk_version); then
    ok "tkinter works with Tcl/Tk $TK"
    explain "Optional: '$TOOL -m tkinter' opens Python's own tkinter demo window."
    exit 0
fi
warn "This Python cannot load tkinter."
case "$TF_OS" in
    macos-intel|macos-arm)
        # The formula must match the Python minor version (3.14 -> python-tk@3.14).
        PYVER=$("$TOOL" -c 'import sys; print("%d.%d" % sys.version_info[:2])')
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        explain "Homebrew ships tkinter as a separate formula. (The python.org installer"
        explain "includes Tk instead: https://www.python.org/downloads/macos/)"
        install_pkg "tkinter for Python $PYVER" brew install "python-tk@$PYVER" || exit 1 ;;
    linux)
        # Debian/Ubuntu package for the system python3.
        install_pkg "tkinter" sudo apt-get install -y python3-tk || exit 1 ;;
    windows)
        explain "On Windows, check with: py -m tkinter"
        explain "If it fails, see https://docs.python.org/3/using/windows.html"
        exit 1 ;;
    *)
        fail "Unknown OS. See https://docs.python.org/3/library/tkinter.html" ;;
esac

TK=$(tk_version) || fail "tkinter still does not load. See the Platform notes in README.md."
ok "tkinter works with Tcl/Tk $TK. Next: ./run.sh"
