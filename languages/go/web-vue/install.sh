#!/bin/sh
# install.sh - Go web-vue: check (and optionally install) the toolchains
#
# WHAT: 1. checks that Go 1.22 or newer is installed;
#       2. checks that Node.js (20.19+ or 22.12+) and npm are installed;
#       3. installs the front end's packages into frontend/node_modules.
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  this app has two separate parts, each with its own toolchain:
#       - backend/ is Go: the "go" command compiles it. It only uses Go's
#         standard library (net/http, encoding/json), so nothing is downloaded;
#       - frontend/ is JavaScript: Node.js runs Vite (the build tool and
#         front-end server), and npm downloads Vue and Vite from the npm
#         registry. Vite requires Node.js 20.19+ or 22.12+.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://go.dev/doc/install
#   https://formulae.brew.sh/formula/go
#   https://formulae.brew.sh/formula/node
#   https://nodejs.org/en/download
#   https://docs.npmjs.com/cli/commands/npm-ci

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The oldest Go version the backend is written for (the "go" line in
# backend/go.mod). Go 1.22 added HTTP methods to net/http's URL patterns.
GO_MIN_MINOR=22

# go_ok succeeds if "go" is on PATH and is Go 1.22 or newer.
# "go env GOVERSION" prints e.g. go1.27.3; sed keeps the minor number (27).
go_ok() {
    has_cmd go || return 1
    go_minor=$(go env GOVERSION 2>/dev/null | sed -n 's/^go1\.\([0-9][0-9]*\).*/\1/p')
    [ -n "$go_minor" ] && [ "$go_minor" -ge "$GO_MIN_MINOR" ]
}

# node_ok succeeds if the installed Node.js is one Vite supports:
# 20.19 or newer in the 20.x line, or 22.12 and newer.
node_ok() {
    node -e 'const [a, b] = process.versions.node.split(".").map(Number);
             process.exit((a === 20 && b >= 19) || (a === 22 && b >= 12) || a > 22 ? 0 : 1)' \
        2>/dev/null
}

step "1/3 Check whether Go 1.$GO_MIN_MINOR (or newer) is installed"
explain "WHY: the backend is Go: the 'go' command compiles it into one executable."
if go_ok; then
    ok "Go found: $(go version)"
else
    warn "Go 1.$GO_MIN_MINOR or newer was not found ('go' missing or too old)."
    case "$TF_OS" in
        macos-intel|macos-arm)
            # Homebrew (https://brew.sh); the official .pkg is at https://go.dev/dl/
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Go" brew install go || exit 1 ;;
        linux)
            explain "Install Go from https://go.dev/dl/ as described on https://go.dev/doc/install:"
            explain "    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.X.Y.linux-amd64.tar.gz"
            explain "    export PATH=\$PATH:/usr/local/go/bin     (add this line to ~/.profile)"
            exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id GoLang.Go -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install Go by hand: https://go.dev/doc/install" ;;
    esac
    go_ok || fail "Go is still not on PATH. Open a new terminal and retry."
fi

step "2/3 Check whether Node.js (20.19+ or 22.12+) and npm are installed"
explain "WHY: the front end is JavaScript; Node.js runs Vite, npm installs the packages."
if has_cmd node && has_cmd npm && node_ok; then
    ok "Node.js found: $(node --version), npm $(npm --version)"
else
    warn "Node.js 20.19+ / 22.12+ with npm was not found."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Node.js" brew install node || exit 1 ;;
        linux)
            explain "Debian/Ubuntu's own nodejs package may be older than Vite needs."
            explain "Install a current LTS version as shown on https://nodejs.org/en/download"
            exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id OpenJS.NodeJS.LTS -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install Node.js by hand: https://nodejs.org/en/download" ;;
    esac
    node_ok || fail "Node.js is still missing or too old. Open a new terminal and retry."
fi

step "3/3 Install the front end's packages into frontend/node_modules"
explain "WHY: 'npm ci' installs exactly the versions recorded in package-lock.json,"
explain "     so every student builds the front end with the same Vue and Vite."
if [ -x frontend/node_modules/.bin/vite ]; then
    ok "Packages found: $(cd frontend && node -p '"vue " + require("vue/package.json").version + ", vite " + require("vite/package.json").version')"
else
    install_pkg "the front end's packages (Vue, Vite)" \
        sh -c 'cd frontend && npm ci --no-fund --no-audit' || exit 1
fi

ok "Ready. Next: ./build.sh"
