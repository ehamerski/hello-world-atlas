#!/bin/sh
# run.sh — Objective-C web: start the HTTP server
#
# WHAT: starts ./server on http://localhost:$PORT (default 8080) that
#       answers every GET request with: <p>Hello, World!</p>
# WHY:  ./server is the binary compiled by build.sh. It uses BSD sockets for
#       TCP networking and Foundation for string handling. No external server
#       (nginx, Apache) is needed.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check: start the server, curl once, stop
#
# Platforms: macOS Intel (verified on the dev machine); Linux with GNUstep
# verified in CI; Windows is NOT verified.
# Source: https://developer.apple.com/documentation/foundation

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x ./server ] || {
    explain "server binary missing; compiling first."
    sh build.sh
}

PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: ./server listens on 127.0.0.1 and answers every GET request."
if is_verify "$@"; then
    # Start in the background, curl once to verify, then stop.
    # trap ensures the server is stopped even if the curl check fails.
    ./server &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/" 10
else
    explain "Open http://localhost:$PORT/ in your browser. Press Ctrl+C to stop."
    exec ./server
fi
