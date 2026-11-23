#!/bin/sh
# install.sh - Go desktop: check (and optionally install) Go and a C compiler
#
# WHAT: 1. checks that Go 1.25 or newer is installed;
#       2. checks that a C compiler (and, on Linux, the graphics headers)
#          is available for cgo.
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  the "go" command compiles main.go. Fyne itself is NOT installed
#       here: "go build" downloads it (and its dependencies, listed in
#       go.sum) during ./build.sh, like Maven downloads JavaFX in
#       ../../java/desktop. But Fyne talks to the operating system's
#       graphics (OpenGL) and window system through C code, so Go must call
#       a C compiler while building. That bridge between Go and C is "cgo".
#       This program needs Go 1.25 or newer: go.mod requires it so that
#       the patched golang.org/x/image (v0.43.0) can be used.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://go.dev/doc/install
#   https://formulae.brew.sh/formula/go
#   https://docs.fyne.io/started/quick/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The oldest Go version this code is written for (the "go" line in go.mod).
GO_MIN_MINOR=25

# go_ok succeeds if "go" is on PATH and is Go 1.25 or newer.
# "go env GOVERSION" prints e.g. go1.27.3; sed keeps the minor number (27).
go_ok() {
    has_cmd go || return 1
    go_minor=$(go env GOVERSION 2>/dev/null | sed -n 's/^go1\.\([0-9][0-9]*\).*/\1/p')
    [ -n "$go_minor" ] && [ "$go_minor" -ge "$GO_MIN_MINOR" ]
}

step "1/2 Check whether Go 1.$GO_MIN_MINOR (or newer) is installed"
explain "WHY: the 'go' command compiles main.go and downloads Fyne during ./build.sh."
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
            # The Fyne docs' apt line below also installs Go ("golang"), but
            # the distribution's Go may be older than 1.25; see the README.
            explain "Install Go from https://go.dev/dl/ as described on https://go.dev/doc/install:"
            explain "    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.X.Y.linux-amd64.tar.gz"
            explain "    export PATH=\$PATH:/usr/local/go/bin     (add this line to ~/.profile)"
            exit 1 ;;
        windows)
            explain "On Windows Fyne's docs recommend MSYS2; see step 2/2 below and the README."
            explain "Or install Go alone in PowerShell: winget install --id GoLang.Go -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install Go by hand: https://go.dev/doc/install" ;;
    esac
    go_ok || fail "Go is still not on PATH. Open a new terminal and retry."
fi

step "2/2 Check the C compiler that cgo needs"
explain "WHY: Fyne opens windows and draws with OpenGL through C code, so 'go build'"
explain "     compiles that C code too. Plain Go programs (../cli, ../web) need no C compiler."
case "$TF_OS" in
    macos-intel|macos-arm)
        # On macOS the compiler (clang) and the system frameworks (Cocoa,
        # OpenGL) come with Apple's Command Line Tools.
        fix_developer_dir
        if xcrun --find clang >/dev/null 2>&1; then
            ok "C compiler found: $(xcrun clang --version 2>&1 | head -n 1)"
        else
            # xcode-select --install opens Apple's own installer window.
            install_pkg "Apple's Command Line Tools (clang)" xcode-select --install || exit 1
            fail "Finish Apple's installer window, then run ./install.sh again."
        fi ;;
    linux)
        # Fyne's documented package list for Debian/Ubuntu: gcc plus the
        # headers of OpenGL, X11 and Wayland.
        if has_cmd gcc && [ -f /usr/include/GL/gl.h ] && [ -f /usr/include/X11/Xlib.h ]; then
            ok "gcc and the OpenGL/X11 headers were found."
        else
            install_pkg "gcc and the graphics headers" sudo apt-get install -y \
                gcc libgl1-mesa-dev xorg-dev libwayland-dev libxkbcommon-dev || exit 1
        fi ;;
    windows)
        if has_cmd gcc; then
            ok "C compiler found: $(gcc --version | head -n 1)"
        else
            explain "Fyne's docs recommend MSYS2 (https://www.msys2.org/). In the 'MSYS2 MinGW 64-bit' shell:"
            explain "    pacman -Syu"
            explain "    pacman -S git mingw-w64-x86_64-toolchain mingw-w64-x86_64-go"
            explain "Then add C:\\msys64\\mingw64\\bin to PATH and reopen Git Bash."
            exit 1
        fi ;;
    *)
        fail "Unknown OS. See Fyne's prerequisites: https://docs.fyne.io/started/quick/" ;;
esac

[ "$(go env CGO_ENABLED)" = 1 ] \
    || fail "cgo is turned off (go env CGO_ENABLED is not 1). Run: go env -u CGO_ENABLED"
ok "Ready. Next: ./build.sh (the first build compiles Fyne's C code and takes about a minute)"
