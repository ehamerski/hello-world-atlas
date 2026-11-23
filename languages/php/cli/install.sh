#!/bin/sh
# install.sh - PHP cli: check (and optionally install) the toolchain
#
# WHAT: checks that the PHP command-line interpreter (php) is installed. If
#       it is missing, shows the official install command for your operating
#       system and runs it only if you answer "y". Nothing is installed
#       silently and sudo is never hidden.
# WHY:  PHP is interpreted: hello.php is run by the php program, so that
#       program must be on your PATH. The cli version needs nothing else,
#       only the language itself (no Composer, no extensions).
# HOW:  ./install.sh       (run once; safe to run again)
#       PHP=/path/to/php ./install.sh   check another interpreter
#
# Platforms: macOS Intel (verified on the test machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
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
explain "WHY: hello.php is run by the PHP command-line interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    # "php -v" also says "(cli)": the command-line build of PHP (CLI SAPI).
    ok "$TOOL_NAME found: $("$TOOL" -v 2>&1 | head -n 1)"
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
        # Debian/Ubuntu shown. php-cli is the command-line package only,
        # without a web server module.
        install_pkg "$TOOL_NAME" sudo apt-get install -y php-cli ;;
    windows)
        # php.net publishes ZIP builds for Windows. The manual recommends the
        # Non-Thread-Safe (NTS) build for command-line scripts.
        explain "On Windows download the 'VS17 x64 Non Thread Safe' ZIP from"
        explain "    https://windows.php.net/download/"
        explain "unzip it (e.g. to C:\\php), add that folder to PATH, then reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://www.php.net/downloads.php" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
