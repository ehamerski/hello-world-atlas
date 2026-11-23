#!/bin/sh
# install.sh - Node.js cli: check (and optionally install) the toolchain
#
# WHAT: checks that Node.js is installed. If it is missing, shows the
#       install command for your operating system and runs it only if you
#       answer "y". Nothing is installed silently and sudo is never hidden.
# WHY:  hello.js is JavaScript. JavaScript has no compiler that makes an
#       executable: the "node" program (the Node.js runtime) reads hello.js
#       and runs it, so "node" must be on your PATH. The cli version needs
#       nothing else: no npm packages, no package.json.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.
# Sources for the install commands:
#   https://nodejs.org/en/download
#   https://formulae.brew.sh/formula/node

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check whether Node.js is installed"
explain "WHY: hello.js is run by the Node.js runtime (the 'node' command)."
if has_cmd node; then
    ok "Node.js found: $(node --version)"
    exit 0
fi
warn "Node.js is not installed (no 'node' on PATH)."

step "2/2 Install Node.js"
explain "WHY: a package manager installs Node.js (and npm with it) and keeps it up to date."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh). nodejs.org also offers nvm and an
        # official installer: https://nodejs.org/en/download
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "Node.js" brew install node || exit 1 ;;
    linux)
        explain "Debian/Ubuntu's own nodejs package is often an old version."
        explain "Install a current LTS version as shown on https://nodejs.org/en/download"
        exit 1 ;;
    windows)
        explain "On Windows run this in PowerShell, then reopen Git Bash:"
        explain "    winget install --id OpenJS.NodeJS.LTS -e"
        exit 1 ;;
    *)
        fail "Unknown OS. Install Node.js by hand: https://nodejs.org/en/download" ;;
esac

has_cmd node || fail "Node.js is still not on PATH. Open a new terminal and retry."
ok "Node.js is ready. Next: ./run.sh"
