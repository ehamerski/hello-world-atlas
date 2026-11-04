#!/bin/sh
# run.sh - C web: start the web server
#
# WHAT: starts bin/hello-web, a web server on http://localhost:$PORT
#       (default 8080) that answers GET / with: <p>Hello, World!</p>
# WHY:  bin/hello-web is a native executable made by ./build.sh. The HTTP
#       server is libmicrohttpd, a library that the program loads when it
#       starts; there is no separate server program to launch (compare
#       ../../java/web, where Spring Boot starts Tomcat).
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

[ -x bin/hello-web ] || fail "bin/hello-web is missing. Run ./build.sh first."

# hello.c reads PORT too, so the export makes the server and this script
# agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: bin/hello-web listens on 127.0.0.1 (this computer only) and answers GET /."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    ./bin/hello-web &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # A C server starts in milliseconds; 10 s is plenty.
    wait_for_http "http://localhost:$PORT/" 10
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec ./bin/hello-web
fi
