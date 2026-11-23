#!/bin/sh
# install.sh - Lua cli: check (and optionally install) the toolchain
#
# WHAT: checks that the Lua interpreter ("lua") is installed. If it is
#       missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  Lua is interpreted: hello.lua is run by the "lua" program, so that
#       program must be on your PATH. The cli version needs nothing else,
#       only the language itself.
# HOW:  ./install.sh       (run once; safe to run again)
#       LUA=lua5.4 ./install.sh   check another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/lua
#   https://www.lua.org/download.html
#   https://packages.debian.org/stable/lua5.4
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-lua

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 folder with lua.exe on PATH.
# shellcheck source=../use-msys2-lua.sh
. ../use-msys2-lua.sh

# The interpreter command. Homebrew's "lua" formula installs "lua". Debian
# and Ubuntu name the package by version and install "lua5.4" instead.
case "$TF_OS" in
    linux) TOOL=${LUA:-lua5.4} ;;
    *)     TOOL=${LUA:-lua} ;;
esac
TOOL_NAME="Lua"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: hello.lua is run by the Lua interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" -v 2>&1 | head -n 1)"
    exit 0
fi
warn "$TOOL_NAME is not installed (no '$TOOL' on PATH)."

step "2/2 Install $TOOL_NAME"
explain "WHY: each OS has a standard way to install Lua; a package manager"
explain "     also keeps it up to date."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) installs command-line tools on macOS.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install lua ;;
    linux)
        # Debian/Ubuntu shown; the package name carries the Lua version.
        install_pkg "$TOOL_NAME" sudo apt-get install -y lua5.4 ;;
    windows)
        # Lua.org publishes source only; binaries come from third parties.
        # MSYS2 comes with the GitHub windows-latest image and packages Lua
        # 5.5 (lua.exe) for its "ucrt64" environment. pacman -Sy refreshes the
        # package lists first; -S --needed skips what is installed. The login
        # shell (-l) sets MSYS2 up for pacman. use-msys2-lua.sh then puts
        # C:\msys64\ucrt64\bin on PATH. Without MSYS2, get a build from
        # https://www.lua.org/download.html and run: LUA=lua ./install.sh
        [ -x /c/msys64/usr/bin/bash.exe ] \
            || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ first."
        install_pkg "Lua (MSYS2 package)" /c/msys64/usr/bin/bash.exe -lc \
            "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-lua" || exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://www.lua.org/download.html" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
