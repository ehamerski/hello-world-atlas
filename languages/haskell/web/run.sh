#!/bin/sh
# run.sh - Haskell web: start the web server
#
# WHAT: runs the hello-web executable that ./build.sh made, a web server on
#       http://localhost:$PORT (default 8080) that answers GET / with:
#       <p>Hello, World!</p>
# WHY:  the executable contains Scotty, Warp and the Haskell runtime
#       system, so the operating system runs it directly. Like ../../go/web
#       and ../../rust/web, there is no separate server program to install.
#       "cabal list-bin hello-web" prints where Cabal put it, inside
#       dist-newstyle/ (the exact path contains the GHC version).
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello-web.cabal is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts ~/.ghcup/bin on PATH.
# shellcheck source=ghcup-env.sh
. ./ghcup-env.sh

CABAL=${CABAL:-cabal}
require_cmd "$CABAL" "Cabal knows where the built executable is."
BIN=$("$CABAL" list-bin hello-web)
[ -x "$BIN" ] || fail "hello-web is not built yet. Run ./build.sh first."

# app/Main.hs reads PORT too, so the export makes the server and this
# script agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: hello-web runs Scotty on Warp, listening on 127.0.0.1 (this"
explain "     computer only), and answers GET /."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    "$BIN" &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # A compiled Haskell server starts in milliseconds; a 10 s limit is enough.
    wait_for_http "http://localhost:$PORT/" 10
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec "$BIN"
fi
