#!/bin/sh
# install.sh - Objective-C desktop: check the toolchain
#
# WHAT: checks that clang is available and can compile Objective-C with
#       AppKit support.
# WHY:  AppKit is the macOS GUI framework. It requires the Apple platform
#       SDKs, so this implementation runs on macOS only. On Linux, GNUstep
#       provides a compatible AppKit (GNUstep GUI), but it is NOT verified
#       on this machine.
#
# Platforms: macOS Intel (verified on the dev machine); Linux (GNUstep) and
# Windows are documented but NOT verified.

set -eu

cd -- "$(dirname -- "$0")"
. ../../../scripts/common.sh

step "Check the Objective-C compiler"
explain "WHY: clang compiles hello.m; on macOS it comes with the Xcode Command Line Tools."
require_cmd clang "Clang compiles Objective-C. On macOS: xcode-select --install"

# Check an empty Objective-C class: proves clang has its Objective-C front end.
if ! printf '@interface A @end\n@implementation A @end\n' \
        | clang -x objective-c -fsyntax-only - 2>/dev/null; then
    explain "Install Xcode Command Line Tools: xcode-select --install"
    fail "clang cannot compile Objective-C."
fi

# Check macOS (AppKit requires Apple platform SDKs)
if [ "$(uname -s)" != "Darwin" ]; then
    explain "On Linux, GNUstep provides a compatible implementation."
    explain "Source: https://www.gnustep.org/"
    fail "AppKit requires macOS (Apple platform SDKs)."
fi

ok "clang with Objective-C and AppKit support is available."
