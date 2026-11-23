#!/bin/sh
# build.sh - Go web-vue: compile the backend and build the front end
#
# WHAT: 1. backend/:  "go build" compiles the Go API into the executable
#          backend/bin/hello-api;
#       2. frontend/: "npm run build" (Vite) turns index.html and the Vue
#          code in src/ into plain HTML and JavaScript in frontend/dist.
# WHY:  each part has its own build. Go compiles ahead of time to machine
#       code, as in ../cli. Browsers do not understand .vue files (a
#       template, a script and a style in one file), and load one bundled
#       file faster than many small ones, so Vite compiles and bundles the
#       front end.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so backend/ and frontend/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/3 Check the build tools"
explain "WHY: the backend needs Go, the front end needs Node.js and its packages;"
explain "     ./install.sh installs all of them."
require_cmd go "The go command compiles the backend."
require_cmd npm "npm runs the front end's build."
[ -x frontend/node_modules/.bin/vite ] \
    || fail "frontend/node_modules is missing. Run ./install.sh first."

step "2/3 Backend: compile the Go API with 'go build'"
explain "WHY: 'go build' compiles backend/main.go and the standard library packages it"
explain "     uses (net/http, encoding/json) into one executable, backend/bin/hello-api."
(cd backend && go build -o bin/hello-api .)
ok "Built backend/bin/hello-api"

step "3/3 Front end: build the Vue app with Vite"
explain "WHY: 'npm run build' runs 'vite build', which compiles App.vue into JavaScript"
explain "     and writes index.html plus one bundled .js file into frontend/dist."
(cd frontend && npm run build)

ok "Both parts are built. Next: ./run.sh"
