#!/bin/sh
# build.sh - Objective-C desktop: compile the AppKit program
#
# WHAT: runs `clang hello.m -o hello -framework Cocoa` to produce a macOS
#       executable. The Cocoa framework is a convenience umbrella that
#       includes both Foundation and AppKit.
# WHY:  Objective-C is compiled to native machine code. The `-framework Cocoa`
#       flag links against both Foundation (NSString, NSArray, etc.) and
#       AppKit (NSWindow, NSTextField, etc.).
#
# On macOS, the executable links dynamically against:
#   - /System/Library/Frameworks/Cocoa.framework
#     (which includes Foundation and AppKit)
#   - /usr/lib/libSystem.B.dylib
#
# References:
#   Clang: https://clang.llvm.org/docs/UsersManual.html
#   AppKit: https://developer.apple.com/documentation/appkit

set -eu

cd -- "$(dirname -- "$0")"
. ../../../scripts/common.sh

step "Compile hello.m"
explain "WHY: clang compiles Objective-C source to a native Mach-O executable."
clang hello.m -o hello -framework Cocoa

ok "Built → hello"
