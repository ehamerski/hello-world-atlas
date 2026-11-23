#!/bin/sh
# run.sh - Kotlin web: start the Ktor server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers every request for "/" with: <p>Hello, World!</p>
# WHY:  "java -jar build/libs/hello-web-all.jar" starts the JVM with the
#       executable jar built by ./build.sh. Ktor then starts its Netty
#       engine inside the program; there is no separate server to install.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh

JAR=build/libs/hello-web-all.jar
require_cmd java "The JVM runs this program."
[ -f "$JAR" ] || fail "$JAR is missing. Run ./build.sh first."

# Main.kt reads PORT too, so the export makes the server and this script
# agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: Ktor starts the Netty engine on 127.0.0.1 (this computer only)."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    java -jar "$JAR" &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # The JVM needs a few seconds to start, so wait up to 60 s.
    wait_for_http "http://localhost:$PORT/" 60
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec java -jar "$JAR"
fi
