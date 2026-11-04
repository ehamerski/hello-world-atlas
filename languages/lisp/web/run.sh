#!/bin/sh
# run.sh - Common Lisp web: start the web server
#
# WHAT: starts bin/hello-web, a web server on http://localhost:$PORT
#       (default 8080) that answers GET / with: <p>Hello, World!</p>
# WHY:  bin/hello-web is the Lisp image saved by ./build.sh: SBCL,
#       Hunchentoot and server.lisp in one file. The operating system runs
#       it, and the image calls HELLO-WEB:MAIN, which starts Hunchentoot and
#       waits. Like ../../go/web and ../../rust/web, there is no separate
#       server program to install.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

BIN=bin/hello-web
[ -x "$BIN" ] || fail "$BIN is missing. Run ./build.sh first."

# server.lisp reads PORT too, so the export makes the server and this
# script agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: $BIN starts Hunchentoot on 127.0.0.1 (this computer only); it"
explain "     answers GET / and logs each request to the terminal."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    "./$BIN" &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # The saved image starts in well under a second; a 10 s limit is ample.
    wait_for_http "http://localhost:$PORT/" 10
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec "./$BIN"
fi
