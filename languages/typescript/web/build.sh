#!/bin/sh
# build.sh - TypeScript web: compile server.ts to JavaScript
#
# WHAT: runs the TypeScript compiler (tsc) with the settings in tsconfig.json.
#       It checks the types in src/server.ts and writes build/server.js.
# WHY:  Node.js runs JavaScript. tsc checks the types first (strict mode), then
#       erases them and writes plain JavaScript. If the types are wrong, tsc
#       prints the errors and writes nothing ("noEmitOnError" in tsconfig.json).
#       Node.js can also run a .ts file directly by "type stripping", but that
#       removes the types without checking them and ignores tsconfig.json
#       (see the README).
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=typescript-env.sh
. ./typescript-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs tsc, which ./install.sh puts in node_modules/."
[ -x node_modules/.bin/tsc ] || fail "tsc is not in node_modules/. Run ./install.sh first."
require_cmd node "Node.js runs the TypeScript compiler's launcher."

step "2/2 Compile"
explain "WHY: 'tsc -p .' reads tsconfig.json: strict type checking, source in src/,"
explain "     JavaScript output in build/."
echo "npx tsc -p ."
npx tsc -p .

ok "Build finished: build/server.js. Next: ./run.sh"
