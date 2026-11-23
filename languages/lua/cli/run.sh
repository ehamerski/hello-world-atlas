#!/bin/sh
# run.sh - Lua cli: run the Hello World program
#
# WHAT: runs hello.lua, which prints exactly: Hello, World!
# WHY:  Lua is an interpreted language. There is no build.sh: the "lua"
#       program reads hello.lua and runs it directly. (It does compile the
#       code to bytecode in memory first, but that happens automatically
#       each time, so you never run a separate compile step.)
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does the same thing)
#       LUA=lua5.4 ./run.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.lua" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 folder with lua.exe on PATH.
# shellcheck source=../use-msys2-lua.sh
. ../use-msys2-lua.sh

# The interpreter command: "lua" on macOS, "lua5.4" on Debian/Ubuntu
# (see install.sh).
case "$TF_OS" in
    linux) LUA=${LUA:-lua5.4} ;;
    *)     LUA=${LUA:-lua} ;;
esac
require_cmd "$LUA" "Lua runs this program."

step "Run the program"
explain "WHY: '$LUA hello.lua' starts the interpreter, which runs the file top to bottom."
"$LUA" hello.lua
