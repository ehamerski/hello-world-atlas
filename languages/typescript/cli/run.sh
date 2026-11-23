#!/bin/sh
# run.sh - TypeScript cli: run the Hello World program
#
# WHAT: prints exactly: Hello, World!
# WHY:  "node build/hello.js" runs the JavaScript that ./build.sh wrote from
#       src/hello.ts. Node.js never sees the TypeScript source.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   same output; used by scripts/verify-all.sh (this
#                           program always exits by itself)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=typescript-env.sh
. ./typescript-env.sh

require_cmd node "Node.js runs this program."
[ -f build/hello.js ] || fail "build/hello.js is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: 'node build/hello.js' runs the compiled JavaScript."
node build/hello.js
