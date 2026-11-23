#!/bin/sh
# install.sh - TypeScript cli: check Node.js and npm, then install the TypeScript compiler
#
# WHAT: 1. checks that Node.js 24 or newer and npm are installed (and shows
#          how to get them if not);
#       2. installs the TypeScript compiler (tsc) and the Node.js type
#          declarations into node_modules/ with "npm ci", which uses the exact
#          versions and SHA-512 integrity values in package-lock.json. This step downloads
#          packages from the npm registry, so it asks first.
# WHY:  tsc is a package, not part of Node.js. npm puts it in this folder's
#       node_modules/, so this example uses its own copy and version, the same
#       idea as Python's .venv in ../../python/web. The compiler checks the
#       types and writes the JavaScript that Node.js runs.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://nodejs.org/en/download
#   https://formulae.brew.sh/formula/node
#   https://docs.npmjs.com/cli/commands/npm-ci
#   https://www.typescriptlang.org/download/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so node_modules/ is created here.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# TS_NODE_MIN_MAJOR, and PATH so that node and npm are found (see typescript-env.sh).
# shellcheck source=typescript-env.sh
. ./typescript-env.sh

# node_ok succeeds if "node" is on PATH and its major version is high enough.
# process.versions.node is for example "26.8.2"; parseInt keeps the 26.
node_ok() {
    has_cmd node || return 1
    node -e "process.exit(parseInt(process.versions.node) >= $TS_NODE_MIN_MAJOR ? 0 : 1)"
}

step "1/2 Check whether Node.js $TS_NODE_MIN_MAJOR+ and npm are installed"
explain "WHY: Node.js runs the compiled program; npm downloads the TypeScript compiler."
if node_ok && has_cmd npm; then
    ok "Node.js found: $(node --version), npm $(npm --version)"
else
    warn "Node.js $TS_NODE_MIN_MAJOR or newer with npm was not found."
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
    # Homebrew's folder may be new to PATH: read the env file again.
    # shellcheck source=typescript-env.sh
    . ./typescript-env.sh
    node_ok && has_cmd npm || fail "Node.js is still missing or too old. Open a new terminal and retry."
fi

step "2/2 Install the TypeScript compiler into node_modules/"
explain "WHY: 'npm ci' installs exactly the versions in package-lock.json, which"
explain "     also records a SHA-512 integrity value for each package,"
explain "     so every student runs the same compiler."
if [ -x node_modules/.bin/tsc ]; then
    ok "TypeScript found: $(node_modules/.bin/tsc --version)"
else
    install_pkg "TypeScript and @types/node (from the npm registry)" npm ci --no-fund --no-audit || exit 1
fi

ok "Ready. Next: ./build.sh"
