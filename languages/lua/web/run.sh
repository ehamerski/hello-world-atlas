#!/bin/sh
# run.sh - Lua web: start the Pegasus server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers every request with: <p>Hello, World!</p>
# WHY:  the "lua" interpreter runs app.lua, which loads Pegasus from the
#       local rocks/ folder and serves requests in a loop. Pegasus is a
#       small, simple server: use it to learn, not for production.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#       LUA=lua5.4 ./run.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so app.lua and rocks/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 folder with lua.exe and luarocks on PATH.
# shellcheck source=../use-msys2-lua.sh
. ../use-msys2-lua.sh

# The interpreter command: "lua" on macOS, "lua5.4" on Debian/Ubuntu.
case "$TF_OS" in
    linux) LUA=${LUA:-lua5.4} ;;
    *)     LUA=${LUA:-lua} ;;
esac
require_cmd "$LUA" "Lua runs this program."
require_cmd luarocks "LuaRocks tells Lua where the modules in rocks/ are."
[ -d rocks ] || fail "Pegasus is not installed in rocks/. Run ./install.sh first."

PORT=${PORT:-8080}
# app.lua reads PORT with os.getenv, so it has to be in the environment.
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: 'luarocks --tree ./rocks path' prints the settings (LUA_PATH, LUA_CPATH)"
explain "     that let Lua find the modules in rocks/; 'eval' applies them to this script."
# On Debian/Ubuntu luarocks is told which Lua the rocks were built for (see
# install.sh); the rocks sit in rocks/lib/lua/<that version>.
if [ "$TF_OS" = linux ]; then
    eval "$(luarocks --lua-version "$("$LUA" -e 'print(_VERSION:match("%d+%.%d+"))')" --tree ./rocks path)"
elif [ "$TF_OS" = windows ]; then
    # See ../use-msys2-lua.sh: on Windows the same settings come from rocks_env.
    rocks_env ./rocks
else
    eval "$(luarocks --tree ./rocks path)"
fi
explain "Then '$LUA app.lua' serves on 127.0.0.1 (this computer only)."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    "$LUA" app.lua &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/"
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec "$LUA" app.lua
fi
