#!/bin/sh
# run.sh - Erlang web: start the web server
#
# WHAT: runs hello_httpd:main/0, a web server on http://localhost:$PORT
#       (default 8080) that answers GET / with: <p>Hello, World!</p>
# WHY:  the server is httpd, the web server of the inets application, which
#       ships with Erlang/OTP. The program is the compiled module in ebin/
#       (see build.sh); main/0 starts httpd and then waits.
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

# Run from this script's folder so "ebin" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts a downloaded Erlang/OTP (Windows) on PATH; see erlang-env.sh.
# shellcheck source=erlang-env.sh
. ./erlang-env.sh

require_cmd erl "Erlang/OTP provides erl, which runs this program."
[ -f ebin/hello_httpd.beam ] || fail "ebin/hello_httpd.beam is missing. Run ./build.sh first."

# hello_httpd.erl reads PORT too, so the export makes the server and this
# script agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: erl runs hello_httpd:main(), which starts inets and its httpd server on"
explain "     127.0.0.1 (this computer only) and waits."
# erl options:
#   +Bd        Ctrl+C ends the program instead of opening the emulator's break menu
#   -noshell   no interactive Erlang shell
#   -pa ebin   add ebin/ to the code path, so erl finds hello_httpd.beam
#   -s hello_httpd main   call hello_httpd:main(), which never returns
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    erl +Bd -noshell -pa ebin -s hello_httpd main &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # Starting the virtual machine and inets takes about a second; 15 s is ample.
    wait_for_http "http://localhost:$PORT/" 15
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with erl, so Ctrl+C stops it directly.
    exec erl +Bd -noshell -pa ebin -s hello_httpd main
fi
