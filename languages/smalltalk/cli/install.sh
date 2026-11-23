#!/bin/sh
# install.sh - Smalltalk cli: check (and optionally install) GNU Smalltalk
#
# WHAT: checks that GNU Smalltalk (gst) is installed. If it is missing,
#       shows the official install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  GNU Smalltalk (gst) is the interpreter that runs hello.st. It is
#       the free implementation of the Smalltalk language, maintained by
#       the GNU Project.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash) are documented but NOT verified.
# Sources for the install commands:
#   https://www.gnu.org/software/smalltalk/
#   https://formulae.brew.sh/formula/gnu-smalltalk

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

TOOL="gst"
TOOL_NAME="GNU Smalltalk"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: hello.st is run by the GNU Smalltalk interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" --version 2>&1 | head -n 1)"
    exit 0
fi
warn "$TOOL_NAME is not installed."

step "2/2 Install $TOOL_NAME"
explain "WHY: GNU Smalltalk is the free Smalltalk implementation from the GNU Project."
case "$TF_OS" in
    macos-intel|macos-arm)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install gnu-smalltalk ;;
    linux)
        # Debian/Ubuntu package: gnu-smalltalk
        install_pkg "$TOOL_NAME" sudo apt-get install -y gnu-smalltalk ;;
    windows)
        explain "On Windows, use WSL or install from source:"
        explain "    https://www.gnu.org/software/smalltalk/"
        exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://www.gnu.org/software/smalltalk/" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
