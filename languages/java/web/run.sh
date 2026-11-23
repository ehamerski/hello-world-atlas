#!/bin/sh
# run.sh - Java web: start the Spring Boot server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers every request for "/" with: <p>Hello, World!</p>
# WHY:  "java -jar target/hello-web.jar" starts the JVM with the executable
#       jar built by ./build.sh. Spring Boot then starts its embedded Tomcat
#       web server; there is no separate server program to install.
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

# Run from this script's folder so target/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh

require_cmd java "The JVM runs this program."
[ -f target/hello-web.jar ] || fail "target/hello-web.jar is missing. Run ./build.sh first."

# application.properties reads PORT too (server.port=${PORT:8080}), so the
# export makes the server and this script agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: Spring Boot starts the embedded Tomcat server on 127.0.0.1 (this computer only)."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    java -jar target/hello-web.jar &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # The JVM and Spring need a few seconds to start, so wait up to 60 s.
    wait_for_http "http://localhost:$PORT/" 60
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec java -jar target/hello-web.jar
fi
