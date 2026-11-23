#!/bin/sh
# install.sh - Lua web: check Lua and LuaRocks, then install Pegasus into rocks/
#
# WHAT: 1. checks that the Lua interpreter is installed (and shows how to
#          install it if not);
#       2. checks that LuaRocks, the Lua package manager, is installed;
#       3. installs Pegasus (a small web server written in Lua) and the
#          modules it needs, at pinned versions, into rocks/ (a private
#          folder for this app only).
#       Steps 1-3 may download or build software, so they ask first.
# WHY:  Pegasus is a third-party module, not part of Lua. Installing it with
#       "luarocks --tree ./rocks" keeps it out of your system Lua, so this
#       app cannot break (or be broken by) other projects. Pegasus needs
#       LuaSocket and other modules with C code, so a C compiler must be
#       installed (on macOS: the Xcode Command Line Tools).
# HOW:  ./install.sh       (run once; safe to run again)
#       LUA=lua5.4 ./install.sh   check another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/lua
#   https://formulae.brew.sh/formula/luarocks
#   https://luarocks.org/modules/evandrolg/pegasus
#   https://github.com/luarocks/luarocks/wiki/Using-LuaRocks
#   https://github.com/luarocks/luarocks/wiki/Download   ("--lua-version")
#   https://packages.ubuntu.com/resolute/liblua5.4-dev
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-lua-luarocks
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-gcc

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so rocks/ is created here, not elsewhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Fix the compiler setup on macOS (some machines have a broken Xcode path).
fix_developer_dir
# On Windows, puts the MSYS2 folder with lua.exe, luarocks and gcc on PATH.
# shellcheck source=../use-msys2-lua.sh
. ../use-msys2-lua.sh

# The interpreter command: "lua" on macOS, "lua5.4" on Debian/Ubuntu.
case "$TF_OS" in
    linux) TOOL=${LUA:-lua5.4} ;;
    *)     TOOL=${LUA:-lua} ;;
esac

# The versions that were tested together. LuaRocks would pick the newest
# version that Pegasus accepts for the four modules after the first one;
# naming them here makes every install the same. Format: name version.
# lr ARGS: run luarocks. On Debian/Ubuntu the "luarocks" package is set up for
# Lua 5.1, but this app runs with lua5.4, so luarocks is told the version of
# the interpreter ($TOOL); otherwise it would build the C modules (such as
# LuaSocket) against the Lua 5.1 headers and they would fail to load with
# "undefined symbol: lua_pcall". Elsewhere luarocks already matches the
# interpreter (Homebrew's and MSYS2's both use the current Lua).
# On Windows, MSYS2's LuaRocks looks for C libraries (such as zlib) in the
# folder named by MINGW_PREFIX, which MSYS2's own shells set and Git Bash
# does not; without it, it looks in c:\windows\system32 only, finds no
# zlib.h, and links with the system's msvcrt.dll instead of MSYS2's UCRT C
# library ("undefined reference to __acrt_iob_func"). So lr sets
# MINGW_PREFIX, and LDFLAGS (which LuaRocks puts before its own -L folders)
# makes the linker search MSYS2's library folder first.
# https://github.com/luarocks/luarocks/wiki/Download
# https://github.com/luarocks/luarocks/blob/main/src/luarocks/core/cfg.lua   (MINGW_PREFIX, LDFLAGS)
lr() {
    case "$TF_OS" in
        linux) luarocks --lua-version "$("$TOOL" -e 'print(_VERSION:match("%d+%.%d+"))')" "$@" ;;
        windows) MINGW_PREFIX=C:/msys64/ucrt64 LDFLAGS="-LC:/msys64/ucrt64/lib${LDFLAGS:+ $LDFLAGS}" luarocks "$@" ;;
        *)     luarocks "$@" ;;
    esac
}

ROCKS="luasocket 3.1.0-1
luafilesystem 1.9.0-1
lzlib 0.4.1.53-4
mimetypes 1.1.0-2
pegasus 1.1.0-0"

step "1/3 Check whether Lua is installed"
explain "WHY: app.lua is run by the Lua interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "Lua found: $("$TOOL" -v 2>&1 | head -n 1)"
else
    warn "Lua is not installed (no '$TOOL' on PATH)."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Lua" brew install lua || exit 1 ;;
        linux)
            install_pkg "Lua" sudo apt-get install -y lua5.4 || exit 1 ;;
        windows)
            # MSYS2 comes with the GitHub windows-latest image; see
            # ../use-msys2-lua.sh. pacman -Sy refreshes the package lists;
            # -S --needed skips what is installed; -l makes a login shell.
            [ -x /c/msys64/usr/bin/bash.exe ] \
                || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ first."
            install_pkg "Lua (MSYS2 package)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-lua" || exit 1 ;;
        *)
            fail "Unknown OS. Install Lua by hand: https://www.lua.org/download.html" ;;
    esac
    has_cmd "$TOOL" || fail "Lua is still not on PATH. Open a new terminal and retry."
fi

step "2/3 Check whether LuaRocks is installed"
explain "WHY: LuaRocks downloads, builds, and installs Lua modules (\"rocks\")."
if has_cmd luarocks; then
    ok "LuaRocks found: $(luarocks --version 2>&1 | head -n 1)"
else
    warn "LuaRocks is not installed (no 'luarocks' on PATH)."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "LuaRocks" brew install luarocks || exit 1 ;;
        linux)
            # build-essential and unzip are what LuaRocks needs to build modules;
            # liblua5.4-dev has the Lua 5.4 headers they are built against;
            # zlib1g-dev has the zlib headers that lzlib needs.
            install_pkg "LuaRocks" sudo apt-get install -y luarocks build-essential unzip liblua5.4-dev zlib1g-dev || exit 1 ;;
        windows)
            # LuaRocks for Lua 5.5, the GCC compiler that builds the C modules
            # (LuaSocket, ...) and zlib's headers (lzlib), from MSYS2.
            install_pkg "LuaRocks (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-lua-luarocks mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-zlib" || exit 1
            # The luarocks function of use-msys2-lua.sh exists only now.
            # shellcheck source=../use-msys2-lua.sh
            . ../use-msys2-lua.sh ;;
        *)
            fail "Install LuaRocks by hand: https://luarocks.org/" ;;
    esac
    has_cmd luarocks || fail "LuaRocks is still not on PATH. Open a new terminal and retry."
fi

step "3/3 Install Pegasus into rocks/"
explain "WHY: --tree ./rocks puts the modules in this folder only (git ignores it)."
has_cmd cc || has_cmd gcc || fail "No C compiler found. On macOS run: xcode-select --install"
# If Lua can already load Pegasus from rocks/, there is nothing to do.
# "luarocks path" prints the shell commands that set LUA_PATH and LUA_CPATH
# so that Lua looks inside rocks/ (run.sh does the same).
# (On Windows, rocks_env of ../use-msys2-lua.sh sets them instead.)
if (if [ "$TF_OS" = windows ]; then rocks_env ./rocks; else eval "$(lr --tree ./rocks path)"; fi
    "$TOOL" -e 'require("pegasus")') 2>/dev/null; then
    ok "Pegasus found in rocks/: $(lr --tree ./rocks list --porcelain pegasus | cut -f2)"
else
    explain "The modules are built from source, which takes about half a minute."
    # A here-document (not a pipe) keeps the loop in this shell, so a "no"
    # answer or a failed install stops the whole script.
    while read -r name version; do
        install_pkg "$name $version (from LuaRocks)" \
            lr --tree ./rocks install "$name" "$version" || exit 1
    done <<EOF_ROCKS
$ROCKS
EOF_ROCKS
fi

ok "Ready. Next: ./run.sh"
