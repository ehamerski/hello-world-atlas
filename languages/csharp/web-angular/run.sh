#!/bin/sh
# run.sh - C# web-angular: start the ASP.NET Core API and the Angular front end
#
# WHAT: starts two servers, one per part:
#       - the backend: the ASP.NET Core API on http://localhost:$PORT
#         (default 8080), which answers GET /api/hello with
#         {"message":"Hello, World!"};
#       - the front end: "ng serve" on http://localhost:$FE_PORT (default
#         4200), which compiles and serves the Angular app and forwards
#         every /api request to the backend (frontend/proxy.conf.js).
#       Open the front end in a browser: Angular calls /api/hello and shows
#       Hello, World!
# WHY:  the front end and the backend are separate programs, so both
#       must run at the same time. The backend is the .dll built by
#       ./build.sh. Angular has no command that serves the output of
#       "ng build" (Vite has "vite preview" for that, see ../../go/web-vue),
#       so the front end is served by the Angular CLI's development server,
#       "ng serve", which is the server the Angular docs use for proxying to
#       a backend. It is for development, not for production.
# HOW:  ./run.sh                          serve until you press Ctrl+C
#       PORT=9000 FE_PORT=5000 ./run.sh   use other ports
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           both, call the API through the front end with
#                           curl (and, if Chrome is installed, check the page
#                           Angular draws), then stop both
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so backend/ and frontend/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd, is_verify,
# wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# Same setup as install.sh: find ~/.dotnet, no telemetry or analytics.
if ! has_cmd dotnet && [ -x "$HOME/.dotnet/dotnet" ]; then
    PATH="$HOME/.dotnet:$PATH"; export PATH
fi
DOTNET_CLI_TELEMETRY_OPTOUT=1; DOTNET_NOLOGO=1; NG_CLI_ANALYTICS=false
export DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO NG_CLI_ANALYTICS

require_cmd dotnet "The .NET runtime runs the backend."
require_cmd node "Node.js runs the Angular CLI."
DLL=backend/bin/Release/net10.0/hello-api.dll
[ -f "$DLL" ] && [ -x frontend/node_modules/.bin/ng ] \
    || fail "The build output is missing. Run ./install.sh and ./build.sh first."

# PORT is the API's port: backend/Program.cs reads it. ng serve would ALSO
# read PORT as its own port, so the front end gets the API's port as
# API_PORT (read by frontend/proxy.conf.js) and runs without PORT.
PORT=${PORT:-8080}
FE_PORT=${FE_PORT:-4200}
export PORT

# find_chrome prints the command of an installed Chrome/Chromium, if any.
find_chrome() {
    for fc_cmd in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
                  google-chrome google-chrome-stable chromium chromium-browser; do
        if [ -x "$fc_cmd" ] || has_cmd "$fc_cmd"; then echo "$fc_cmd"; return 0; fi
    done
    return 1
}

# start_backend / start_frontend run one server each, from its own folder:
# ASP.NET Core reads appsettings.json from the current folder, and ng serve
# reads angular.json. Both end with `exec`, so when they are started with
# `&` the background process IS the server, and its PID ($!) can be stopped
# by the trap below.
start_backend() {
    cd backend
    exec dotnet bin/Release/net10.0/hello-api.dll
}
# ng serve must not see PORT (see above), so it is removed here; this runs
# in a background process or a ( ) subshell, so the script keeps its PORT.
start_frontend() {
    cd frontend
    unset PORT
    API_PORT=$1; export API_PORT
    exec ./node_modules/.bin/ng serve --port "$FE_PORT"
}

step "1/2 Start the backend (ASP.NET Core API) on http://localhost:$PORT"
explain "WHY: the API must be up before the front end can ask it for the message."
start_backend &
API_PID=$!
FE_PID=''
# `trap` stops both servers when this script ends, also after Ctrl+C.
trap 'kill "$API_PID" $FE_PID 2>/dev/null || true' EXIT INT TERM
# The .NET runtime starts in about a second; 30 s is plenty. The answer
# printed below is the raw JSON the API sends.
wait_for_http "http://localhost:$PORT/api/hello" 30

step "2/2 Start the front end (ng serve) on http://localhost:$FE_PORT"
explain "WHY: ng serve compiles the Angular app, serves it and forwards /api/* to the"
explain "     backend (see frontend/proxy.conf.js)."
if is_verify "$@"; then
    start_frontend "$PORT" &
    FE_PID=$!
    explain "Check 1: GET /api/hello on the FRONT END's port, which ng serve forwards to the API:"
    # ng serve compiles first (a few seconds), so allow up to 60 s.
    wait_for_http "http://localhost:$FE_PORT/api/hello" 60
    if CHROME=$(find_chrome); then
        explain "Check 2: load the page in headless Chrome and show what Angular drew:"
        PROFILE=$(mktemp -d)
        # --dump-dom prints the page's HTML after the JavaScript ran;
        # --virtual-time-budget gives the HTTP request time to finish first.
        "$CHROME" --headless=new --disable-gpu --user-data-dir="$PROFILE" \
            --virtual-time-budget=10000 --dump-dom "http://localhost:$FE_PORT/" 2>/dev/null \
            | grep -o '<app-root[^>]*>.*</app-root>' || { rm -rf "$PROFILE"; fail "Angular did not draw the page."; }
        rm -rf "$PROFILE"
    else
        explain "Check 2 skipped: no Chrome/Chromium found to load the page."
    fi
else
    explain "Open http://localhost:$FE_PORT/ in your browser. Stop both servers with Ctrl+C."
    # In a ( ) subshell, not with exec: this script must keep running so its
    # trap can stop the backend when ng serve ends.
    (start_frontend "$PORT")
fi
