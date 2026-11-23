#!/bin/sh
# run.sh - Ruby web: start the Sinatra server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers every request for "/" with: <p>Hello, World!</p>
# WHY:  "ruby app.rb" runs the app. Sinatra then starts the Puma web server,
#       which waits for requests. "bundle exec" makes Ruby use exactly the
#       gems that Gemfile.lock lists, from vendor/bundle.
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

# Run from this script's folder so app.rb and vendor/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Ruby (and its gcc, make) first on PATH.
# shellcheck source=../use-msys2-ruby.sh
. ../use-msys2-ruby.sh

RUBY=${RUBY:-ruby}
require_cmd "$RUBY" "Ruby runs this program."
require_cmd bundle "Bundler starts Ruby with the project's gems."
bundle check >/dev/null 2>&1 || fail "The gems are not installed. Run ./install.sh first."

# app.rb reads PORT itself; exporting it makes it visible to the program.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: 'ruby app.rb' loads Sinatra, which serves the app with Puma on 127.0.0.1 (this computer only)."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    bundle exec "$RUBY" app.rb &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/"
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec bundle exec "$RUBY" app.rb
fi
