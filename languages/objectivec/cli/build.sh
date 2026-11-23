#!/bin/sh
# build.sh - Objective-C cli: compile the program
#
# WHAT: runs `clang hello.m -o hello -framework Foundation` to produce a
#       native executable.
# WHY:  Objective-C is compiled to native machine code. Clang handles both
#       the C and Objective-C parts of the source. The `-framework Foundation`
#       flag links against Apple's Foundation framework, which provides
#       NSString, NSArray, NSDictionary and other core classes.
#
# On macOS, the executable links dynamically against:
#   - /System/Library/Frameworks/Foundation.framework
#   - /usr/lib/libSystem.B.dylib
#
# References:
#   Clang Objective-C: https://clang.llvm.org/docs/UsersManual.html
#   Foundation: https://developer.apple.com/documentation/foundation

set -eu

cd -- "$(dirname -- "$0")"
. ../../../scripts/common.sh

step "Compile hello.m"
explain "WHY: clang compiles Objective-C source to a native Mach-O executable."
clang hello.m -o hello -framework Foundation

ok "Built → hello"
