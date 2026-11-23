#!/bin/sh
# run.sh - C# web: start the web server
#
# WHAT: runs  dotnet bin/Release/net10.0/hello-web.dll, a web server on
#       http://localhost:$PORT (default 8080) that answers GET / with:
#       <p>Hello, World!</p>
# WHY:  the .dll made by ./build.sh holds IL; "dotnet <file>.dll" starts the
#       .NET runtime, which JIT-compiles and runs it (see ../cli/run.sh).
#       The program starts Kestrel, ASP.NET Core's built-in web server, so
#       there is no separate server program to install or configure.
# HOW:  ./run.sh            serve until you press Ctrl+C
#       PORT=9000 ./run.sh  use another port
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: start
#                           the server, fetch the page once with curl, stop
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd, is_verify,
# wait_for_http.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# Same setup as install.sh: find ~/.dotnet, no telemetry, no banner.
if ! has_cmd dotnet && [ -x "$HOME/.dotnet/dotnet" ]; then
    PATH="$HOME/.dotnet:$PATH"; export PATH
fi
DOTNET_CLI_TELEMETRY_OPTOUT=1; DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO

require_cmd dotnet "The .NET runtime runs the compiled server."
DLL=bin/Release/net10.0/hello-web.dll
[ -f "$DLL" ] || fail "$DLL is missing. Run ./build.sh first."

# Program.cs reads PORT too, so the export makes the server and this script
# agree on the port.
PORT=${PORT:-8080}
export PORT

step "Start the web server on http://localhost:$PORT"
explain "WHY: Kestrel, ASP.NET Core's web server, listens on 127.0.0.1 (this computer only)."
if is_verify "$@"; then
    # Start in the background, call it once with curl, then stop it.
    # `trap` makes sure the server is stopped even if the check fails.
    dotnet "$DLL" &
    SERVER_PID=$!
    trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM
    # The runtime needs about a second to start and JIT-compile; 30 s is plenty.
    wait_for_http "http://localhost:$PORT/" 30
else
    explain "Open http://localhost:$PORT/ in your browser. Stop with Ctrl+C."
    # `exec` replaces this script with the server, so Ctrl+C stops it directly.
    exec dotnet "$DLL"
fi
