#!/bin/sh
# run.sh - Node.js web: start the Express server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers GET / with: <p>Hello, World!</p>
# WHY:  "node app.js" runs the program. The HTTP server is Node's own http
#       module, which Express uses underneath; unlike ../../java/web there
#       is no separate server (Tomcat) and, as in ../cli, no build step.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so app.js and node_modules/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd node "Node.js runs this program."
[ -f node_modules/express/package.json ] \
    || fail "Express is not installed in node_modules/. Run ./install.sh first."

# app.js reads PORT too, so the export makes the server and this script
# agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: 'node app.js' listens on 127.0.0.1 (this computer only) and answers GET /."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    node app.js &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/" 10
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec node app.js
fi
