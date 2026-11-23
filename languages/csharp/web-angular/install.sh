#!/bin/sh
# install.sh - C# web-angular: check (and optionally install) the toolchains
#
# WHAT: 1. checks that the .NET SDK 10 (or newer) is installed;
#       2. checks that Node.js (22.22.3+, 24.15+ or 26+) and npm are installed;
#       3. installs the front end's packages into frontend/node_modules.
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  this app has two separate parts, each with its own toolchain:
#       - backend/ is C#: the .NET SDK compiles and runs it. ASP.NET Core
#         comes with the SDK, so nothing is downloaded for it;
#       - frontend/ is TypeScript: Node.js runs the Angular CLI (the build
#         tool and development server), and npm downloads Angular from the
#         npm registry. Angular 22 supports Node.js ^22.22.3, ^24.15.0
#         and ^26.0.0.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.
# Sources for the install commands:
#   https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script
#   https://learn.microsoft.com/dotnet/core/install/windows
#   https://angular.dev/reference/versions
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

# dotnet-install.sh puts .NET in ~/.dotnet but does not change PATH. If
# "dotnet" is not on PATH yet, use that copy for this script.
if ! has_cmd dotnet && [ -x "$HOME/.dotnet/dotnet" ]; then
    PATH="$HOME/.dotnet:$PATH"; export PATH
fi
# The dotnet CLI sends usage telemetry to Microsoft unless this is set, and
# prints a welcome banner on first use unless DOTNET_NOLOGO is set.
# NG_CLI_ANALYTICS=false turns off the Angular CLI's usage analytics. They
# are opt-in, but this also makes sure the CLI never stops to ask (see
# node_modules/@angular/cli/src/utilities/environment-options.js).
DOTNET_CLI_TELEMETRY_OPTOUT=1; DOTNET_NOLOGO=1; NG_CLI_ANALYTICS=false
export DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO NG_CLI_ANALYTICS

# The oldest SDK major version that can build net10.0 projects.
SDK_MIN=10

# DOTNET_INSTALL_SHA256 is the SHA-256 digest of https://dot.net/v1/dotnet-install.sh
# as it was downloaded on 2026-11-10 and again on 2026-11-19 (Microsoft's installer
# script). If Microsoft changes the script, install.sh stops with a checksum
# mismatch; check the new script, then update this value.
DOTNET_INSTALL_SHA256=082f7685e156738a1b2e2ed8381a621870d4ce8e8c59278034556f05c186eb2e

# sdk_ok succeeds if "dotnet --list-sdks" shows an SDK of version 10 or
# newer. Each line looks like: 10.0.404 [/Users/you/.dotnet/sdk]
sdk_ok() {
    has_cmd dotnet || return 1
    dotnet --list-sdks 2>/dev/null | awk -F. -v min="$SDK_MIN" '$1 >= min { f = 1 } END { exit !f }'
}

# install_dotnet downloads Microsoft's install script to a temporary file,
# checks its SHA-256 digest and runs it (see ../cli/install.sh for the details).
install_dotnet() {
    id_script=$(mktemp)
    curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$id_script"
    echo "$DOTNET_INSTALL_SHA256  $id_script" | shasum -a 256 -c - \
        || fail "Checksum mismatch for dotnet-install.sh: see DOTNET_INSTALL_SHA256 in install.sh."
    bash "$id_script" --channel 10.0 --install-dir "$HOME/.dotnet"
    rm -f "$id_script"
    PATH="$HOME/.dotnet:$PATH"; export PATH
}

# node_ok succeeds if the installed Node.js is one Angular 22 supports:
# 22.22.3+ in the 22.x line, 24.15+ in the 24.x line, or 26.x.
node_ok() {
    node -e 'const [a, b, c] = process.versions.node.split(".").map(Number);
             process.exit((a === 22 && (b > 22 || (b === 22 && c >= 3))) ||
                          (a === 24 && b >= 15) || a === 26 ? 0 : 1)' \
        2>/dev/null
}

step "1/3 Check whether the .NET SDK $SDK_MIN (or newer) is installed"
explain "WHY: the backend is C#: the SDK compiles it and includes ASP.NET Core."
if sdk_ok; then
    ok ".NET SDK found: $(dotnet --version) ($(command -v dotnet))"
else
    warn "No .NET SDK $SDK_MIN or newer was found ('dotnet' missing or too old)."
    case "$TF_OS" in
        macos-intel|macos-arm|linux)
            explain "Microsoft's dotnet-install.sh (https://dot.net/v1/dotnet-install.sh)"
            explain "installs the SDK into ~/.dotnet, no sudo needed. Its SHA-256 digest is"
            explain "checked first (DOTNET_INSTALL_SHA256 above). It runs:"
            explain "    bash dotnet-install.sh --channel 10.0 --install-dir \$HOME/.dotnet"
            install_pkg "the .NET $SDK_MIN SDK" install_dotnet || exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id Microsoft.DotNet.SDK.10 -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install the .NET SDK by hand: https://dotnet.microsoft.com/download" ;;
    esac
    sdk_ok || fail "The .NET SDK is still not found. Open a new terminal and retry."
fi

step "2/3 Check whether Node.js (22.22.3+, 24.15+ or 26) and npm are installed"
explain "WHY: the front end is TypeScript; Node.js runs the Angular CLI, npm installs the packages."
if has_cmd node && has_cmd npm && node_ok; then
    ok "Node.js found: $(node --version), npm $(npm --version)"
else
    warn "A Node.js version supported by Angular 22, with npm, was not found."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Node.js" brew install node || exit 1 ;;
        linux)
            explain "Debian/Ubuntu's own nodejs package may be older than Angular needs."
            explain "Install a current LTS version as shown on https://nodejs.org/en/download"
            exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id OpenJS.NodeJS.LTS -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install Node.js by hand: https://nodejs.org/en/download" ;;
    esac
    node_ok || fail "Node.js is still missing or not supported. Open a new terminal and retry."
fi

step "3/3 Install the front end's packages into frontend/node_modules"
explain "WHY: 'npm ci' installs exactly the versions recorded in package-lock.json,"
explain "     so every student builds the front end with the same Angular."
if [ -x frontend/node_modules/.bin/ng ]; then
    ok "Packages found: $(cd frontend && node -p '"@angular/core " + require("@angular/core/package.json").version + ", @angular/cli " + require("@angular/cli/package.json").version')"
else
    install_pkg "the front end's packages (Angular)" \
        sh -c 'cd frontend && npm ci --no-fund --no-audit' || exit 1
fi

ok "Ready. Next: ./build.sh"
