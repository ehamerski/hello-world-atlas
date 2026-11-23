#!/bin/sh
# build.sh — Objective-C web: compile the HTTP server
#
# WHAT: runs clang to compile server.m into a binary called server.
# WHY:  Objective-C is compiled to native machine code. On macOS, the
#       -framework Foundation flag links Foundation (NSString, NSLog).
#       On Linux, GNUstep provides compatible Foundation headers and runtime.
# HOW:  ./build.sh
#
# References:
#   Clang user manual: https://clang.llvm.org/docs/UsersManual.html
#   Foundation:        https://developer.apple.com/documentation/foundation
#   GNUstep:           https://www.gnustep.org/

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd clang "Clang compiles Objective-C. On macOS: xcode-select --install"

step "Compile server.m"
explain "WHY: clang compiles Objective-C source to a native executable."

case "$(uname -s)" in
    Darwin)
        # macOS: Foundation is an Apple system framework; link with -framework.
        clang -fobjc-arc server.m -o server -framework Foundation
        ;;
    Linux)
        # Linux with GNUstep: gnustep-config provides the include paths and
        # libraries for Foundation. The output of gnustep-config is word-split
        # intentionally (each flag is a separate argument to clang).
        require_cmd gnustep-config \
            "GNUstep is needed on Linux. Install: sudo apt-get install -y gnustep-devel"
        # shellcheck disable=SC2046
        clang -fobjc-arc \
            $(gnustep-config --objc-flags) \
            server.m -o server \
            $(gnustep-config --base-libs) -lobjc
        ;;
    *)
        fail "Unsupported OS. Build manually — see README.md § Prerequisites."
        ;;
esac

ok "Built → server"
