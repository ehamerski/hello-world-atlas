#!/bin/sh
# run.sh - Dart web: start the HTTP server
#
# WHAT: starts a web server on http://localhost:$PORT (default 8080) that
#       answers every request for "/" with: <p>Hello, World!</p>
# WHY:  the `dart` command compiles server.dart to an intermediate format
#       and runs it on the Dart VM. The server uses dart:io HttpServer,
#       which is part of the standard library.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash) are documented but NOT verified.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd dart "The Dart SDK runs this program."

PORT=${PORT:-8080}

step "Start the web server on http://localhost:$PORT"
explain "WHY: 'dart server.dart' compiles and runs the file; the server"
explain "     listens on localhost:$PORT using dart:io HttpServer."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    PORT="$PORT" dart server.dart &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/"
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    # exec takes no VAR=value prefix in sh, so PORT is exported first.
    export PORT
    exec dart server.dart
fi
