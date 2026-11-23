#!/bin/sh
# run.sh - Elixir web: start the web server
#
# WHAT: runs "mix run --no-halt", a web server on http://localhost:$PORT
#       (default 8080) that answers GET / with: <p>Hello, World!</p>
# WHY:  "mix run" compiles the project if needed and starts its application
#       (HelloWeb.Application), which starts Bandit under a supervisor.
#       "--no-halt" keeps the Erlang VM running after that command ends;
#       without it, mix run would exit as soon as the application started,
#       and the server would stop with it.
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

# Run from this script's folder so mix.exs is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts a downloaded Elixir on PATH (Linux and Windows); see elixir-env.sh.
# shellcheck source=elixir-env.sh
. ./elixir-env.sh

require_cmd mix "Mix runs the project."

# application.ex reads PORT too, so the export makes the server and this
# script agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: mix run starts HelloWeb.Application, which starts Bandit on 127.0.0.1"
explain "     (this computer only) and keeps the Erlang VM alive with --no-halt."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    mix run --no-halt &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # Compiling after a change can take a few seconds; a 30 s limit is ample.
    wait_for_http "http://localhost:$PORT/" 30
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with mix, so Ctrl+C stops it directly.
    exec mix run --no-halt
fi
