#!/bin/sh
# run.sh - Visual Basic (VB.NET) web: serve "Hello, World!" on localhost
#
# WHAT: starts the web server on http://localhost:$PORT/ (PORT defaults to 8080).
#       The page at / answers with the text Hello, World!
# WHY:  the server is the built program; without --verify it keeps running until you
#       press Ctrl+C.
# HOW:  ./run.sh            serve until Ctrl+C
#       ./run.sh --verify   start the server, read its answer with curl, and stop it
#                           (used by scripts/verify-all.sh)
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows are
# documented and NOT verified for this implementation.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# The dotnet command and the telemetry settings.
# shellcheck source=dotnet-env.sh
. ./dotnet-env.sh

require_cmd dotnet "The .NET SDK runs the web server. (run ./install.sh first)"
[ -f bin/Debug/net10.0/vbweb.dll ] || fail "vbweb.dll was not found. Run ./build.sh first."
PORT=${PORT:-8080}
export PORT

if is_verify "$@"; then
    step "Start the server, read the page, stop the server"
    explain "WHY: the server answers only while it runs, so it is started in the background."
    # Another program on the same port would answer instead of this server, and the
    # check would pass for the wrong reason. So refuse to start on a busy port.
    if curl -s -o /dev/null "http://localhost:$PORT/" 2>/dev/null; then
        fail "Port $PORT already answers, so this check could read another program. Stop it, or run PORT=<free port> ./run.sh --verify."
    fi
    dotnet bin/Debug/net10.0/vbweb.dll &
    tf_pid=$!
    # Always stop the server, even when the check fails.
    trap 'kill "$tf_pid" 2>/dev/null || true' EXIT
    wait_for_http "http://localhost:$PORT/"
    # The answer must come from the server this script started.
    kill -0 "$tf_pid" 2>/dev/null || fail "The server stopped before it answered."
    exit 0
fi

step "Serve Hello, World! on http://localhost:$PORT/ (Ctrl+C to stop)"
explain "WHY: dotnet runs the built server; --no-build reuses what build.sh made."
dotnet run --configuration Debug --no-build --project vbweb.vbproj
