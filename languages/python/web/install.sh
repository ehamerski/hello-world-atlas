#!/bin/sh
# install.sh - Python web: check Python 3, then install Flask into .venv
#
# WHAT: 1. checks that a Python 3 interpreter is installed (and shows how to
#          install it if not);
#       2. creates a virtual environment in .venv/ (a private folder of
#          packages for this app only);
#       3. installs the pinned Flask version from requirements.txt into it.
#       Steps 2 and 3 download packages from PyPI, so they ask first.
# WHY:  Flask is a third-party package, not part of Python. Installing it in
#       a virtual environment keeps it out of your system Python, so this
#       app cannot break (or be broken by) other projects. The Flask docs
#       recommend exactly this.
# HOW:  ./install.sh       (run once; safe to run again)
#       PYTHON=python ./install.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://flask.palletsprojects.com/en/stable/installation/
#   https://docs.python.org/3/library/venv.html
#   https://formulae.brew.sh/formula/python@3.14
#   https://docs.python.org/3/using/windows.html

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so .venv is created here, not elsewhere.
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

step "1/3 Check whether $TOOL_NAME is installed"
explain "WHY: Flask is a Python package, so it needs the Python interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" --version 2>&1 | head -n 1)"
else
    warn "$TOOL_NAME is not installed (no '$TOOL' on PATH)."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "$TOOL_NAME" brew install python@3.14 || exit 1 ;;
        linux)
            # python3-venv provides the venv module on Debian/Ubuntu.
            install_pkg "$TOOL_NAME" sudo apt-get install -y python3 python3-venv || exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install 9NQ7512CXL7T -e --accept-package-agreements --disable-interactivity"
            explain "    py install 3.14"
            explain "Then run the scripts with: PYTHON=python ./install.sh"
            exit 1 ;;
        *)
            fail "Unknown OS. Install $TOOL_NAME by hand: https://www.python.org/downloads/" ;;
    esac
    has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
fi

# A virtual environment keeps its programs in .venv/bin on macOS/Linux and
# in .venv/Scripts on Windows (see the venv docs).
venv_python() {
    if [ -x .venv/bin/python ]; then echo .venv/bin/python
    elif [ -x .venv/Scripts/python.exe ]; then echo .venv/Scripts/python.exe
    else return 1
    fi
}

step "2/3 Create the virtual environment .venv/"
explain "WHY: packages installed here are used only by this app."
if VENV_PY=$(venv_python); then
    ok "Virtual environment found: $VENV_PY"
else
    install_pkg "a virtual environment in .venv/" "$TOOL" -m venv .venv || exit 1
    VENV_PY=$(venv_python) || fail "The virtual environment was not created in .venv/."
fi

step "3/3 Install Flask into .venv/"
explain "WHY: requirements.txt pins the Flask version, so everyone runs the same code."
if "$VENV_PY" -c "import flask" 2>/dev/null; then
    # importlib.metadata reads the installed version (part of the standard library).
    ok "Flask found: $("$VENV_PY" -c "import importlib.metadata as m; print(m.version('flask'))")"
else
    install_pkg "Flask (from PyPI)" "$VENV_PY" -m pip install --disable-pip-version-check -r requirements.txt || exit 1
fi

ok "Ready. Next: ./run.sh"
