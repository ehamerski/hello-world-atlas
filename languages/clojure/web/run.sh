#!/bin/sh
# run.sh - Clojure web: start the Ring + Jetty server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers every request for "/" with: <p>Hello, World!</p>
# WHY:  "clojure -M -m hello.core" starts the Java Virtual Machine (JVM) and
#       calls the -main function of hello.core, which starts Jetty, the web
#       server library, through the Ring adapter. The server listens on
#       127.0.0.1 (this computer only). There is no ./build.sh: Clojure
#       compiles the source to bytecode in memory when it loads it.
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

# Run from this script's folder so deps.edn is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh
# Puts the Clojure CLI that install.sh installed on PATH.
# shellcheck source=clojure-env.sh
. ./clojure-env.sh

require_cmd clojure "The Clojure CLI starts the program."

# hello.core reads PORT too, so the export makes the server and this script
# agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: Ring starts the embedded Jetty server on 127.0.0.1 (this computer only)."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    clojure -M -m hello.core &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # The JVM and Clojure need a few seconds to start, so wait up to 60 s.
    wait_for_http "http://localhost:$PORT/" 60
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec clojure -M -m hello.core
fi
