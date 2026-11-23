#!/bin/sh
# run.sh - Swift web: run the Vapor Hello World server
#
# WHAT: starts the Vapor web server on http://localhost:$PORT/ (default 8080).
#       With --verify, starts it in the background, fetches the page once
#       with curl, then stops it.
# WHY:  Vapor runs an embedded HTTP server; there is no separate web server
#       to install (compare Python/Flask or Node/Express). Vapor reads the
#       port from the --port option of its `serve` command, not from an
#       environment variable, so this script passes PORT to it.
# HOW:  ./run.sh                serve until Ctrl+C
#       PORT=9000 ./run.sh      serve on another port
#       ./run.sh --verify       self-check used by scripts/verify-all.sh
#
# Platforms: macOS Intel (verified on the dev machine). macOS Apple Silicon,
# Linux and Windows are documented but not verified.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

PORT=${PORT:-8080}

# Build if not already built. Test for the binary, not for .build/debug: an
# interrupted cold build leaves that folder behind without the App inside.
[ -x .build/debug/App ] || sh build.sh

step "Start the web server on http://localhost:$PORT"
explain "WHY: .build/debug/App is the server; 'serve --port' sets the port it listens on."
# Start the built binary directly, not `swift run`: killing `swift run`
# leaves its App child alive on the port, which breaks the next run.
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    .build/debug/App serve --port "$PORT" &
    server_pid=$!
    trap 'kill "$server_pid" 2>/dev/null || true' EXIT INT TERM
    # The binary is already built, so it starts in a few seconds; 60 s is
    # plenty even on a slow machine.
    wait_for_http "http://localhost:$PORT/" 60
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec .build/debug/App serve --port "$PORT"
fi
