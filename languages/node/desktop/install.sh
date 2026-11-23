#!/bin/sh
# install.sh - Node.js desktop: check Node.js and npm, then install Electron
#
# WHAT: 1. checks that Node.js 22.12 or newer and npm are installed (and
#          shows how to install them if not);
#       2. installs the "electron" npm package into node_modules/ with
#          "npm ci", which uses the exact versions in package-lock.json;
#       3. downloads the Electron program itself (about 125 MB zipped,
#          about 270 MB unpacked) with "npx install-electron --no".
#       Steps 2 and 3 download from the internet, so they ask first.
# WHY:  Electron is not part of Node.js. It is a separate program that
#       contains its own copy of Chromium (the browser engine that draws the
#       window's content) and of Node.js. The npm package is small; since
#       Electron 42 it no longer downloads the big program during
#       "npm install" (that used a "postinstall" script, a known
#       supply-chain risk). Electron would download it on the first run
#       instead; doing it here keeps ./run.sh offline and fast. The download
#       is checked against the checksums that ship inside the npm package.
#       The electron package needs Node.js 22.12+ ("engines" in its
#       package.json).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.
# Electron 45 needs macOS 13 (Ventura) or newer, or Windows 10 or newer.
# Sources for the install commands:
#   https://nodejs.org/en/download
#   https://formulae.brew.sh/formula/node
#   https://www.electronjs.org/docs/latest/tutorial/installation
#   https://www.electronjs.org/docs/latest/breaking-changes (42.0)
#   https://docs.npmjs.com/cli/commands/npm-ci

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so node_modules/ is created here.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# node_ok succeeds if "node" is on PATH and is version 22.12 or newer.
# process.versions.node is e.g. "26.8.2"; split(".") gives its numbers.
node_ok() {
    has_cmd node || return 1
    node -e 'const [major, minor] = process.versions.node.split(".").map(Number);
             process.exit(major > 22 || (major === 22 && minor >= 12) ? 0 : 1)'
}

# electron_ok succeeds if the Electron program has been downloaded:
# the package writes the program's path into node_modules/electron/path.txt.
electron_ok() {
    [ -f node_modules/electron/path.txt ] &&
        [ -f "node_modules/electron/dist/$(cat node_modules/electron/path.txt)" ]
}

step "1/3 Check whether Node.js 22.12+ and npm are installed"
explain "WHY: npm installs Electron; the electron package needs Node.js 22.12 or newer."
if node_ok && has_cmd npm; then
    ok "Node.js found: $(node --version), npm $(npm --version)"
else
    warn "Node.js 22.12 or newer with npm was not found."
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

step "2/3 Install the electron package into node_modules/"
explain "WHY: 'npm ci' installs exactly the versions in package-lock.json,"
explain "     so every student runs the same Electron."
if [ -f node_modules/electron/package.json ]; then
    ok "electron package found: $(node -p 'require("electron/package.json").version')"
else
    install_pkg "the electron package (from the npm registry)" npm ci --no-fund --no-audit || exit 1
fi

step "3/3 Download the Electron program"
explain "WHY: the npm package only holds a small launcher; the program with Chromium"
explain "     and Node.js inside is a separate download (cached in your user folder)."
if electron_ok; then
    ok "Electron program found: node_modules/electron/dist/$(cat node_modules/electron/path.txt)"
else
    # "--no" tells npx never to fetch a package from the registry: it must
    # use the install-electron command of the package installed in step 2.
    install_pkg "the Electron program (from GitHub releases)" npx --no install-electron || exit 1
    electron_ok || fail "The Electron program was not downloaded. Try the command above by hand."
fi

ok "Ready. Next: ./run.sh"
