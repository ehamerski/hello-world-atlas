#!/bin/sh
# install.sh - Go web: check (and optionally install) the Go toolchain
#
# WHAT: checks that Go 1.22 or newer is installed. If it is missing, shows
#       the install command for your operating system and runs it only if
#       you answer "y". Nothing is installed silently and sudo is never hidden.
# WHY:  Go is compiled. The "go" command is the whole toolchain in one
#       program: it compiles (go build), runs (go run), formats (go fmt) and
#       downloads dependencies. The web server itself (net/http) and the
#       HTML templates (html/template) are part of Go's standard library,
#       so there is nothing else to install. Go 1.22 is the minimum written
#       in go.mod: it added HTTP methods to net/http's URL patterns.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://go.dev/doc/install
#   https://formulae.brew.sh/formula/go

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The oldest Go version this code is written for (the "go" line in go.mod).
GO_MIN_MINOR=22

# go_ok succeeds if "go" is on PATH and is Go 1.22 or newer.
# "go env GOVERSION" prints e.g. go1.27.3; sed keeps the minor number (27).
go_ok() {
    has_cmd go || return 1
    go_minor=$(go env GOVERSION 2>/dev/null | sed -n 's/^go1\.\([0-9][0-9]*\).*/\1/p')
    [ -n "$go_minor" ] && [ "$go_minor" -ge "$GO_MIN_MINOR" ]
}

step "1/2 Check whether Go 1.$GO_MIN_MINOR (or newer) is installed"
explain "WHY: the 'go' command compiles main.go, web server included, into one program."
if go_ok; then
    ok "Go found: $(go version)"
    exit 0
fi
warn "Go 1.$GO_MIN_MINOR or newer was not found ('go' missing or too old)."

step "2/2 Install Go"
explain "WHY: go.dev publishes the official installers; on macOS Homebrew packages"
explain "     the same release and keeps it up to date."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) installs command-line tools on macOS.
        # The official .pkg installer is the other option: https://go.dev/dl/
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "Go" brew install go || exit 1 ;;
    linux)
        # Distribution packages are often older than the current Go release,
        # so the official archive is shown instead. It needs sudo because it
        # writes to /usr/local/go; that is why it is only printed.
        explain "Download the Linux archive from https://go.dev/dl/ and follow https://go.dev/doc/install:"
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
ok "Go is ready. Next: ./build.sh"
