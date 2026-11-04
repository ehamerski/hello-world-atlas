#!/bin/sh
# install.sh - PHP web: check (and optionally install) the toolchain
#
# WHAT: checks that the PHP command-line interpreter (php) is installed. If
#       it is missing, shows the official install command for your operating
#       system and runs it only if you answer "y". Nothing is installed
#       silently and sudo is never hidden.
# WHY:  the web server used here is built into PHP itself ("php -S"), so
#       the php program is the only thing this app needs: no Apache or
#       nginx, no framework, no Composer packages.
# HOW:  ./install.sh       (run once; safe to run again)
#       PHP=/path/to/php ./install.sh   check another interpreter
#
# Platforms: macOS Intel (verified on the test machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://www.php.net/manual/en/install.macosx.packages.php
#   https://www.php.net/manual/en/install.unix.debian.php
#   https://www.php.net/manual/en/install.windows.manual.php

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The interpreter command. Homebrew, apt and the Windows ZIP all call it "php".
TOOL=${PHP:-php}
TOOL_NAME="PHP 8"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: 'php -S' (PHP's built-in web server) runs public/index.php."
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" -v 2>&1 | head -n 1)"
    # curl is only used by "./run.sh --verify" and to test by hand.
    has_cmd curl || warn "curl is missing: ./run.sh works, but ./run.sh --verify needs curl."
    exit 0
fi
warn "$TOOL_NAME is not installed (no '$TOOL' on PATH)."

step "2/2 Install $TOOL_NAME"
explain "WHY: each OS has an official or standard way to install PHP;"
explain "     a package manager also keeps it up to date."
case "$TF_OS" in
    macos-intel|macos-arm)
        # The PHP manual's macOS page recommends Homebrew (https://brew.sh).
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install php ;;
    linux)
        # Debian/Ubuntu shown. php-cli contains the php command and with it
        # the built-in web server; no Apache module is needed.
        install_pkg "$TOOL_NAME" sudo apt-get install -y php-cli ;;
    windows)
        # php.net publishes ZIP builds for Windows. The manual recommends the
        # Non-Thread-Safe (NTS) build for command-line use, and "php -S" is
        # part of the command-line program.
        explain "On Windows download the 'VS17 x64 Non Thread Safe' ZIP from"
        explain "    https://windows.php.net/download/"
        explain "unzip it (e.g. to C:\\php), add that folder to PATH, then reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://www.php.net/downloads.php" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
