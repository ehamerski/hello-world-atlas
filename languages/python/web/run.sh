#!/bin/sh
# run.sh - Python web: start the Flask server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers every request for "/" with: <p>Hello, World!</p>
# WHY:  the "flask run" command (installed with Flask in .venv/) imports
#       app.py and serves it with Flask's development server. That server
#       is meant for local development only, never for production.
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

# Run from this script's folder so app.py and .venv/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The flask command lives in .venv/bin (macOS/Linux) or .venv/Scripts (Windows).
if [ -x .venv/bin/flask ]; then FLASK=.venv/bin/flask
elif [ -x .venv/Scripts/flask.exe ]; then FLASK=.venv/Scripts/flask.exe
else fail "Flask is not installed in .venv/. Run ./install.sh first."
fi

# 8080 instead of Flask's usual 5000: on macOS 12 and later, port 5000 is
# often taken by the AirPlay Receiver service (see the Flask server docs).
PORT=${PORT:-8080}

step "Start the web server on http://localhost:$PORT"
explain "WHY: 'flask --app app run' imports app.py and serves it on 127.0.0.1 (this computer only)."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    "$FLASK" --app app run --port "$PORT" &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/"
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec "$FLASK" --app app run --port "$PORT"
fi
