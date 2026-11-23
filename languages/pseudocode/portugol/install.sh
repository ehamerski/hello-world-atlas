#!/bin/sh
# install.sh - Pseudocode (Portugol / VisuAlg): check Node.js, then install
#              the Delégua interpreter
#
# WHAT: 1. checks that Node.js and npm are installed (and shows how to
#          install them if not);
#       2. installs Delégua into node_modules/ with "npm ci", which uses
#          the exact versions recorded in package-lock.json. This step
#          downloads packages from the npm registry, so it asks first.
# WHY:  pseudocode is normally read, not run. The original VisuAlg editor
#       runs VisuAlg programs, but it is a Windows program. Delégua is a
#       free (MIT) interpreter written in TypeScript for Node.js that also
#       understands the VisuAlg dialect ("--dialeto visualg"), so the same
#       ola-mundo.alg runs on macOS, Linux and Windows from a terminal.
#       npm puts it in this folder's node_modules/, used by this folder only.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://nodejs.org/en/download
#   https://formulae.brew.sh/formula/node
#   https://www.npmjs.com/package/@designliquido/delegua-node
#   https://docs.npmjs.com/cli/commands/npm-ci

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so node_modules/ is created here.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check whether Node.js and npm are installed"
explain "WHY: Delégua is a Node.js program; npm downloads it."
if has_cmd node && has_cmd npm; then
    ok "Node.js found: $(node --version), npm $(npm --version)"
else
    warn "Node.js with npm was not found."
    case "$TF_OS" in
        macos-intel|macos-arm)
            # Homebrew (https://brew.sh). nodejs.org also offers an official
            # installer: https://nodejs.org/en/download
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Node.js" brew install node || exit 1 ;;
        linux)
            explain "Install a current LTS version as shown on https://nodejs.org/en/download"
            exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id OpenJS.NodeJS.LTS -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install Node.js by hand: https://nodejs.org/en/download" ;;
    esac
    has_cmd node && has_cmd npm || fail "Node.js is still missing. Open a new terminal and retry."
fi

step "2/2 Install the Delégua interpreter into node_modules/"
explain "WHY: 'npm ci' installs exactly the versions in package-lock.json,"
explain "     so every student runs the same interpreter."
if [ -x node_modules/.bin/delegua ]; then
    ok "Delégua found: $(node -p 'require("@designliquido/delegua-node/package.json").version')"
else
    install_pkg "Delégua (from the npm registry)" npm ci --no-fund --no-audit || exit 1
fi

ok "Ready. Next: ./run.sh"
