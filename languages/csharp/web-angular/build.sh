#!/bin/sh
# build.sh - C# web-angular: compile the backend and build the front end
#
# WHAT: 1. backend/:  "dotnet build" compiles the ASP.NET Core API into
#          backend/bin/Release/net10.0/hello-api.dll;
#       2. frontend/: "ng build" (the Angular CLI) compiles the TypeScript
#          in src/ and writes plain HTML and JavaScript into
#          frontend/dist/frontend/browser.
# WHY:  each part has its own build. C# compiles to IL in a .dll, as in
#       ../cli. Browsers do not run TypeScript, and Angular's templates must
#       be compiled too, so the Angular CLI compiles and bundles the front
#       end into one .js file. frontend/dist/frontend/browser is what you
#       would copy to a web server in production. ./run.sh uses "ng serve",
#       which compiles the same code again in memory (see the README).
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so backend/ and frontend/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# Same setup as install.sh: find ~/.dotnet, no telemetry or analytics.
if ! has_cmd dotnet && [ -x "$HOME/.dotnet/dotnet" ]; then
    PATH="$HOME/.dotnet:$PATH"; export PATH
fi
DOTNET_CLI_TELEMETRY_OPTOUT=1; DOTNET_NOLOGO=1; NG_CLI_ANALYTICS=false
export DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO NG_CLI_ANALYTICS

step "1/3 Check the build tools"
explain "WHY: the backend needs the .NET SDK, the front end needs Node.js and its"
explain "     packages; ./install.sh installs all of them."
require_cmd dotnet "The .NET SDK compiles the backend."
require_cmd node "Node.js runs the Angular CLI."
[ -x frontend/node_modules/.bin/ng ] \
    || fail "frontend/node_modules is missing. Run ./install.sh first."

step "2/3 Backend: compile the ASP.NET Core API with 'dotnet build'"
explain "WHY: compiles backend/Program.cs to IL in backend/bin/Release/net10.0/hello-api.dll."
(cd backend && set -x && dotnet build -c Release --disable-build-servers)

step "3/3 Front end: build the Angular app with 'ng build'"
explain "WHY: compiles app.ts and its template to JavaScript and writes index.html plus"
explain "     one bundled .js file into frontend/dist/frontend/browser."
(cd frontend && set -x && ./node_modules/.bin/ng build)

ok "Both parts are built. Next: ./run.sh"
