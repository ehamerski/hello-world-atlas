#!/bin/sh
# run.sh - Prolog web: start the web server
#
# WHAT: runs "swipl server.pl", a web server on http://localhost:$PORT
#       (default 8080) that answers GET / with: <p>Hello, World!</p>
# WHY:  as in ../cli there is no build step: swipl loads server.pl and its
#       HTTP libraries, which come with SWI-Prolog, and proves the goal
#       "main", which starts the server and waits.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so server.pl is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=../use-msys2-swipl.sh
. ../use-msys2-swipl.sh

SWIPL=${SWIPL:-swipl}
require_cmd "$SWIPL" "SWI-Prolog runs server.pl."

# server.pl reads PORT too, so the export makes the server and this script
# agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: swipl loads server.pl and proves 'main', which starts SWI-Prolog's"
explain "     HTTP server on 127.0.0.1 (this computer only) and waits."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    "$SWIPL" server.pl &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # Loading the HTTP libraries takes about a second; a 15 s limit is ample.
    wait_for_http "http://localhost:$PORT/" 15
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with swipl, so Ctrl+C stops it directly.
    exec "$SWIPL" server.pl
fi
