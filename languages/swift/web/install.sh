#!/bin/sh
# install.sh - Swift web: check the Vapor toolchain
#
# WHAT: checks that Swift and Swift Package Manager are available.
# WHY:  Vapor is a Swift package managed by SPM (Swift Package Manager).
#       SPM ships with the Swift toolchain, so no separate installation
#       is needed beyond Swift itself.
#
# Platforms: macOS Intel (verified on the dev machine). macOS Apple Silicon,
# Linux and Windows are documented but not verified.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check the Swift toolchain"
explain "WHY: 'swift' compiles Vapor and the app."
require_cmd swift "Swift 6 compiles Vapor and runs the server. Install it from https://www.swift.org/install/."
ok "$(swift --version 2>&1 | head -n 1)"

step "2/2 Check Swift Package Manager"
explain "WHY: SPM ships with Swift; it reads Package.swift and downloads Vapor."
swift package describe > /dev/null 2>&1 ||
    fail "Swift Package Manager failed to describe the package. Install Swift from https://www.swift.org/install/"

ok "Swift and SPM are available. Next: ./build.sh"
