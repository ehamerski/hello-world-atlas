#!/bin/sh
# run.sh — Smalltalk web: start the HTTP server
#
# WHAT: starts ZnServer on http://localhost:$PORT (default 8080) that
#       answers every request for "/" with: <p>Hello, World!</p>
# WHY:  Pharo evaluates server.st inside its image in headless mode.
#       Zinc HTTP Components (ZnServer) is part of the standard Pharo 14 image.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check: start the server, curl once, stop
#
# Platforms: macOS Intel (verified on the dev machine); Linux verified in CI;
# Windows (Git Bash) with Pharo installed should work but is NOT verified.
# Source: https://github.com/svenvc/zinc
#         https://pharo.org/documentation

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# PHARO_CACHE, PHARO_HEADLESS, PHARO_IMAGE
# shellcheck source=pharo-env.sh
. ./pharo-env.sh

[ -f "$PHARO_IMAGE" ] \
    || fail "Pharo.image not found in $PHARO_CACHE. Run ./install.sh first."
[ -x "$PHARO_HEADLESS" ] \
    || fail "pharo launcher not found in $PHARO_CACHE. Run ./install.sh first."

PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: Pharo evaluates server.st inside its image in headless mode."
explain "     ZnServer (Zinc HTTP Components) is part of the standard Pharo 14 image."
if is_verify "$@"; then
    # Start Pharo in background; ZnServer starts synchronously in server.st.
    # trap ensures Pharo is stopped even if the curl check fails.
    "$PHARO_HEADLESS" "$PHARO_IMAGE" st server.st &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/" 30
else
    explain "Open http://localhost:$PORT/ in your browser. Press Ctrl+C to stop."
    exec "$PHARO_HEADLESS" "$PHARO_IMAGE" st server.st
fi
