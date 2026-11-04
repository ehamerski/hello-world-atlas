#!/bin/sh
# install.sh - <Language> <category>: check (and optionally install) the toolchain
#
# TEMPLATE: copy to languages/<language>/<category>/install.sh, then replace every
# "TODO(template)" and every <placeholder>. Delete this TEMPLATE paragraph.
#
# WHAT: checks that <tool> is installed. If it is missing, shows the official
#       install command for your operating system and runs it only if you
#       answer "y". Nothing is installed silently and sudo is never hidden.
# WHY:  <one sentence: why this program needs <tool> (compiler, interpreter,
#       runtime, framework...)>.            TODO(template)
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Source for the install commands: <official install page, HTTPS>  TODO(template)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

TOOL="<command>"      # TODO(template): command that must be on PATH, e.g. python3
TOOL_NAME="<Tool>"    # TODO(template): human-readable name, e.g. "Python 3"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: <short reason this tool is needed>."   # TODO(template)
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" --version 2>&1 | head -n 1)"
    exit 0
fi
warn "$TOOL_NAME is not installed."

step "2/2 Install $TOOL_NAME"
explain "WHY: <why this package manager / installer is the recommended one>."  # TODO(template)
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) installs command-line tools on macOS.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install "<formula>" ;;           # TODO(template)
    linux)
        # Debian/Ubuntu shown; other distributions: see the README.
        install_pkg "$TOOL_NAME" sudo apt-get install -y "<package>" ;; # TODO(template)
    windows)
        explain "On Windows run this in PowerShell, then reopen Git Bash:"
        explain "    winget install --id <Id> -e"                       # TODO(template)
        exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: <official URL>" ;;  # TODO(template)
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./build.sh (if present) or ./run.sh"
