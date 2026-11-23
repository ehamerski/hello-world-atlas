#!/bin/sh
# build.sh - Swift web: build the Vapor server
#
# WHAT: runs `swift build` to compile the Vapor application.
# WHY:  Vapor is a compiled framework; `swift build` downloads dependencies
#       and compiles everything into a native executable.
#
# Platforms: macOS Intel (verified on the dev machine). macOS Apple Silicon,
# Linux and Windows are documented but not verified.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "Build the Vapor server"
explain "WHY: 'swift build' resolves dependencies, compiles Vapor and the app."
swift build

ok "Built → .build/debug/App"
