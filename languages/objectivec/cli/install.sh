#!/bin/sh
# install.sh - Objective-C cli: check the toolchain
#
# WHAT: checks that clang is available and can compile Objective-C.
# WHY:  Objective-C requires the Clang compiler and the Foundation framework.
#       On macOS, both come with Xcode Command Line Tools. On Linux, GNUstep
#       provides the Foundation framework, but it is NOT verified on this
#       machine.
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

ok "clang with Objective-C support is available."
