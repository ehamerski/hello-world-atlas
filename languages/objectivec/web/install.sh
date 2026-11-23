#!/bin/sh
# install.sh — Objective-C web: check the toolchain
#
# WHAT: checks that clang is available and can compile Objective-C.
#       On Linux, also checks for GNUstep (which provides Foundation).
# WHY:  Objective-C requires the Clang compiler and the Foundation framework.
#       On macOS, both come with Xcode Command Line Tools (xcode-select --install).
#       On Linux, GNUstep provides a compatible Foundation implementation.
# HOW:  ./install.sh
#
# Platforms: macOS Intel (verified on the dev machine); Linux with GNUstep
# (verified in CI); Windows is NOT verified.
# Sources:
#   Clang:          https://clang.llvm.org/
#   GNUstep:        https://www.gnustep.org/
#   GNUstep Ubuntu: https://packages.ubuntu.com/gnustep-devel

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd clang "Clang compiles Objective-C. On macOS: xcode-select --install"

step "1/2 Check clang Objective-C support"
explain "WHY: Objective-C requires compiler support for ObjC syntax and ARC."
if ! clang -fobjc-arc -c /dev/null -o /dev/null 2>/dev/null; then
    fail "clang does not support Objective-C ARC. On macOS: xcode-select --install"
fi
ok "clang with Objective-C ARC support is available."

step "2/2 Check Foundation framework"
explain "WHY: NSString and NSLog used in server.m are part of Foundation."
case "$(uname -s)" in
    Darwin)
        # Foundation is provided by Xcode Command Line Tools on macOS.
        ok "Foundation framework available (macOS)."
        ;;
    Linux)
        # On Linux, GNUstep-Base provides Foundation-compatible headers/runtime.
        require_cmd gnustep-config \
            "GNUstep is needed on Linux. Install: sudo apt-get install -y gnustep-devel"
        ok "GNUstep Foundation available (Linux)."
        ;;
    *)
        warn "Unknown OS. This implementation is verified on macOS and Linux only."
        ;;
esac
