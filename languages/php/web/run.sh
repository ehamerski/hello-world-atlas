#!/bin/sh
# run.sh - PHP web: start PHP's built-in web server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers a request for "/" with: <p>Hello, World!</p>
# WHY:  "php -S" starts the web server that is built into the php program.
#       "-t public" makes public/ the document root, so the server runs
#       public/index.php for "/" and can never send these scripts or the
#       README. That server is meant for development only, never for
#       production or a public network (PHP manual).
#       There is no build.sh: PHP is interpreted, like the cli version.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified on the test machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so public/ is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

PHP=${PHP:-php}
require_cmd "$PHP" "PHP runs this web server."

# 8080 is this repository's convention for every web implementation.
PORT=${PORT:-8080}

step "Start the web server on http://localhost:$PORT"
explain "WHY: '$PHP -S 127.0.0.1:$PORT -t public' serves the public/ folder on this computer only."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    "$PHP" -S "127.0.0.1:$PORT" -t public &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/"
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec "$PHP" -S "127.0.0.1:$PORT" -t public
fi
