#!/bin/sh
# run.sh - TypeScript web: start the node:http server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers GET / with: Hello, World!
# WHY:  "node build/server.js" runs the JavaScript that ./build.sh wrote from
#       src/server.ts. The server is Node.js's built-in http module: there is
#       no framework and no separate server program (compare ../../java/web).
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=typescript-env.sh
. ./typescript-env.sh

require_cmd node "Node.js runs this program."
[ -f build/server.js ] || fail "build/server.js is missing. Run ./build.sh first."

# server.ts reads PORT too, so the export makes the server and this script
# agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: 'node build/server.js' listens on 127.0.0.1 (this computer only) and answers GET /."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    node build/server.js &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/" 10
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec node build/server.js
fi
