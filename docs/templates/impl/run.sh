#!/bin/sh
# run.sh - <Language> <category>: run the Hello World program
#
# TEMPLATE: copy to languages/<language>/<category>/run.sh, keep ONLY the block for
# your category (cli, web or desktop), replace every "TODO(template)" and
# <placeholder>, and delete this paragraph.
#
# WHAT: runs the program.
#   cli     prints exactly: Hello, World!
#   web     starts a server on http://localhost:$PORT that answers Hello, World!
#   desktop opens a window that shows Hello, World!
# WHY:  <what actually executes the code: the binary built by build.sh, the
#       interpreter, the JVM, ...>.            TODO(template)
# HOW:  ./run.sh            run it for yourself (web: stop with Ctrl+C)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh; it
#                           never waits for you and always exits
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd "<command>" "<Tool> runs this program."   # TODO(template)

# ============================== cli ==========================================
step "Run the program"
explain "WHY: <how the program is started>."          # TODO(template)
echo "<run command>"                                   # TODO(template), e.g. python3 src/hello.py

# ============================== web ==========================================
# The port can be changed: PORT=9000 ./run.sh
PORT=${PORT:-8080}                                     # TODO(template): documented port
step "Start the web server on http://localhost:$PORT"
explain "WHY: <what the server framework does>."      # TODO(template)
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    echo "<server command>" &                          # TODO(template)
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    wait_for_http "http://localhost:$PORT/"
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec echo "<server command>"                       # TODO(template)
fi

# ============================== desktop ======================================
step "Open the Hello World window"
explain "WHY: <what GUI toolkit draws the window>."   # TODO(template)
if is_verify "$@"; then
    # Self-check: with TF_VERIFY=1 the app prints "Hello, World!" to the
    # terminal once its window is shown, and closes itself after ~2 seconds.
    TF_VERIFY=1 echo "<app command>"                   # TODO(template)
else
    echo "<app command>"                               # TODO(template)
fi
