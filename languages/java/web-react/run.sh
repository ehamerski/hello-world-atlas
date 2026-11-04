#!/bin/sh
# run.sh - Java web-react: start the Spring Boot API and the React front end
#
# WHAT: starts two servers, one per part:
#       - the backend: Spring Boot on http://localhost:$PORT (default 8080),
#         which answers GET /api/hello with {"message":"Hello, World!"};
#       - the front end: Vite on http://localhost:$FE_PORT (default 4173),
#         which serves the built React app (frontend/dist) and forwards
#         every /api request to the backend.
#       Open the front end in a browser: React calls /api/hello and shows
#       Hello, World!
# WHY:  the front end and the backend are separate programs, so both
#       must run at the same time. "java -jar" runs the API jar built by
#       ./build.sh; "vite preview" serves the front end that ./build.sh
#       built. vite preview is meant for trying a build locally, not for
#       production.
# HOW:  ./run.sh                       serve until you press Ctrl+C
#       PORT=9000 FE_PORT=5000 ./run.sh   use other ports
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           both, call the API through the front end with
#                           curl (and, if Chrome is installed, check the page
#                           React draws), then stop both
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

require_cmd java "The JVM runs the backend."
require_cmd node "Node.js runs the front-end server."
[ -f backend/target/hello-api.jar ] && [ -f frontend/dist/index.html ] \
    || fail "The build output is missing. Run ./build.sh first."

# The backend's application.properties and the front end's vite.config.js
# both read PORT, so the export makes all three agree on the API's port.
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

step "1/2 Start the backend (Spring Boot API) on http://localhost:$PORT"
explain "WHY: the API must be up before the front end can ask it for the message."
java -jar backend/target/hello-api.jar &
API_PID=$!
FE_PID=''
# `trap` stops both servers when this script ends, also after Ctrl+C.
trap 'kill "$API_PID" $FE_PID 2>/dev/null || true' EXIT INT TERM
# The JVM and Spring need a few seconds to start, so wait up to 60 s. The
# answer printed below is the raw JSON the API sends.
wait_for_http "http://localhost:$PORT/api/hello" 60

step "2/2 Start the front end (Vite serving the React build) on http://localhost:$FE_PORT"
explain "WHY: Vite serves frontend/dist and forwards /api/* to the backend (see vite.config.js)."
if is_verify "$@"; then
    # `exec` inside the ( ) makes FE_PID the Vite process itself, so the
    # trap can stop it.
    (cd frontend && exec ./node_modules/.bin/vite preview --port "$FE_PORT" --strictPort) &
    FE_PID=$!
    explain "Check 1: GET /api/hello on the FRONT END's port, which Vite forwards to Spring Boot:"
    wait_for_http "http://localhost:$FE_PORT/api/hello" 30
    if CHROME=$(find_chrome); then
        explain "Check 2: load the page in headless Chrome and show what React drew:"
        PROFILE=$(mktemp -d)
        # --dump-dom prints the page's HTML after the JavaScript ran;
        # --virtual-time-budget gives fetch() time to finish first.
        "$CHROME" --headless=new --disable-gpu --user-data-dir="$PROFILE" \
            --virtual-time-budget=10000 --dump-dom "http://localhost:$FE_PORT/" 2>/dev/null \
            | grep -o '<div id="root">.*</div>' || { rm -rf "$PROFILE"; fail "React did not draw the page."; }
        rm -rf "$PROFILE"
    else
        explain "Check 2 skipped: no Chrome/Chromium found to load the page."
    fi
else
    explain "Open http://localhost:$FE_PORT/ in your browser. Stop both servers with Ctrl+C."
    (cd frontend && exec ./node_modules/.bin/vite preview --port "$FE_PORT" --strictPort)
fi
