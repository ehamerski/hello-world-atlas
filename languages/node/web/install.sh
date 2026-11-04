#!/bin/sh
# install.sh - Node.js web: check Node.js and npm, then install Express
#
# WHAT: 1. checks that Node.js 18 or newer and npm are installed (and shows
#          how to install them if not);
#       2. installs Express into node_modules/ with "npm ci", which uses
#          the exact versions recorded in package-lock.json. This step
#          downloads packages from the npm registry, so it asks first.
# WHY:  Express is a third-party package, not part of Node.js. npm (the
#       package manager installed with Node.js) puts it in this folder's
#       node_modules/, so it is used by this app only, the same idea as
#       Python's .venv in ../../python/web. Express 5 requires Node.js 18+.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://nodejs.org/en/download
#   https://formulae.brew.sh/formula/node
#   https://expressjs.com/en/starter/installing.html
#   https://docs.npmjs.com/cli/commands/npm-ci

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so node_modules/ is created here.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The oldest Node.js major version Express 5 supports ("engines" in its
# package.json says ">= 18").
NODE_MIN_MAJOR=18

# node_ok succeeds if "node" is on PATH and its major version is high enough.
# process.versions.node is e.g. "26.8.2"; parseInt keeps the 26.
node_ok() {
    has_cmd node || return 1
    node -e "process.exit(parseInt(process.versions.node) >= $NODE_MIN_MAJOR ? 0 : 1)"
}

step "1/2 Check whether Node.js $NODE_MIN_MAJOR+ and npm are installed"
explain "WHY: Node.js runs app.js; npm downloads Express."
if node_ok && has_cmd npm; then
    ok "Node.js found: $(node --version), npm $(npm --version)"
else
    warn "Node.js $NODE_MIN_MAJOR or newer with npm was not found."
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
    node_ok && has_cmd npm || fail "Node.js is still missing or too old. Open a new terminal and retry."
fi

step "2/2 Install Express into node_modules/"
explain "WHY: 'npm ci' installs exactly the versions in package-lock.json,"
explain "     so every student runs the same Express code."
if [ -f node_modules/express/package.json ]; then
    ok "Express found: $(node -p 'require("express/package.json").version')"
else
    install_pkg "Express (from the npm registry)" npm ci --no-fund --no-audit || exit 1
fi

ok "Ready. Next: ./run.sh"
