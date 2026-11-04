#!/bin/sh
# run.sh - Go web-vue: start the Go API and the Vue front end
#
# WHAT: starts two servers, one per part:
#       - the backend: the Go API on http://localhost:$PORT (default 8080),
#         which answers GET /api/hello with {"message":"Hello, World!"};
#       - the front end: Vite on http://localhost:$FE_PORT (default 4173),
#         which serves the built Vue app (frontend/dist) and forwards
#         every /api request to the backend.
#       Open the front end in a browser: Vue calls /api/hello and shows
#       Hello, World!
# WHY:  the front end and the backend are separate programs, so both
#       must run at the same time. backend/bin/hello-api is the executable
#       built by ./build.sh; "vite preview" serves the front end that
#       ./build.sh built. vite preview is meant for trying a build locally,
#       not for production.
# HOW:  ./run.sh                       serve until you press Ctrl+C
#       PORT=9000 FE_PORT=5000 ./run.sh   use other ports
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           both, call the API through the front end with
#                           curl (and, if Chrome is installed, check the page
#                           Vue draws), then stop both
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so backend/ and frontend/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify, wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd node "Node.js runs the front-end server."
[ -x backend/bin/hello-api ] && [ -f frontend/dist/index.html ] \
    || fail "The build output is missing. Run ./build.sh first."

# The backend's main.go and the front end's vite.config.js both read PORT,
# so the export makes all three agree on the API's port.
PORT=${PORT:-8080}
FE_PORT=${FE_PORT:-4173}
export PORT

# find_chrome prints the command of an installed Chrome/Chromium, if any.
find_chrome() {
    for fc_cmd in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
                  google-chrome google-chrome-stable chromium chromium-browser; do
        if [ -x "$fc_cmd" ] || has_cmd "$fc_cmd"; then echo "$fc_cmd"; return 0; fi
    done
    return 1
}

step "1/2 Start the backend (Go API) on http://localhost:$PORT"
explain "WHY: the API must be up before the front end can ask it for the message."
./backend/bin/hello-api &
API_PID=$!
FE_PID=''
# `trap` stops both servers when this script ends, also after Ctrl+C.
trap 'kill "$API_PID" $FE_PID 2>/dev/null || true' EXIT INT TERM
# A Go server starts in milliseconds; 10 s is plenty. The answer printed
# below is the raw JSON the API sends.
wait_for_http "http://localhost:$PORT/api/hello" 10

step "2/2 Start the front end (Vite serving the Vue build) on http://localhost:$FE_PORT"
explain "WHY: Vite serves frontend/dist and forwards /api/* to the backend (see vite.config.js)."
if is_verify "$@"; then
    # `exec` inside the ( ) makes FE_PID the Vite process itself, so the
    # trap can stop it.
    (cd frontend && exec ./node_modules/.bin/vite preview --port "$FE_PORT" --strictPort) &
    FE_PID=$!
    explain "Check 1: GET /api/hello on the FRONT END's port, which Vite forwards to the Go API:"
    wait_for_http "http://localhost:$FE_PORT/api/hello" 30
    if CHROME=$(find_chrome); then
        explain "Check 2: load the page in headless Chrome and show what Vue drew:"
        PROFILE=$(mktemp -d)
        # --dump-dom prints the page's HTML after the JavaScript ran;
        # --virtual-time-budget gives fetch() time to finish first.
        "$CHROME" --headless=new --disable-gpu --user-data-dir="$PROFILE" \
            --virtual-time-budget=10000 --dump-dom "http://localhost:$FE_PORT/" 2>/dev/null \
            | grep -o '<div id="app"[^>]*>.*</div>' || { rm -rf "$PROFILE"; fail "Vue did not draw the page."; }
        rm -rf "$PROFILE"
    else
        explain "Check 2 skipped: no Chrome/Chromium found to load the page."
    fi
else
    explain "Open http://localhost:$FE_PORT/ in your browser. Stop both servers with Ctrl+C."
    (cd frontend && exec ./node_modules/.bin/vite preview --port "$FE_PORT" --strictPort)
fi
