#!/bin/sh
# build.sh - compile the Swift iOS program into an app bundle for the Simulator.
#
# WHAT: compiles hello.swift against the iphonesimulator SDK into
#   HelloWorld.app/HelloWorld, copies Info.plist next to it and signs the
#   bundle. The result is the folder that iOS calls an app bundle.
# WHY:  an iOS app is not a plain executable. The system installs and starts
#   only a bundle with an Info.plist. Xcode normally creates that bundle from
#   an .xcodeproj; this script makes the same bundle with two commands, so the
#   build is easy to read and needs no project file.
#
# Why each step:
#   xcrun --sdk iphonesimulator  picks the Simulator SDK (not the device SDK)
#   -target ...-simulator        tells the compiler to build for the Simulator
#   -parse-as-library            reads the file as a library file, without
#                                top-level code, so @main can mark the entry point
#   codesign --sign -            an ad-hoc signature, which needs no developer
#                                account (the codesign(1) man page on macOS)
#
# The target architecture follows the Mac: arm64 on Apple Silicon (and on the
# arm64 CI runners), x86_64 on Intel. MinimumOSVersion in Info.plist must match.
#
# Platforms: verified on macOS Intel (macOS 26, Xcode 26.5, iOS 26.5
# Simulator runtime) and on a macOS Apple Silicon CI runner
# (.github/workflows/ios.yml). Linux and Windows cannot build iOS apps.
#
# References:
#   Compiling for the Simulator: https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device
#   Bundle structure:            https://developer.apple.com/documentation/bundleresources/placing-content-in-a-bundle
#   codesign:                    `man codesign` on macOS (not on the web)
#   swiftc:                      https://github.com/swiftlang/swift/blob/main/docs/Driver.md

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.swift and Info.plist are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/4 Check the tools"
explain "WHY: building needs xcrun (from Xcode) and codesign; ./install.sh checks Xcode."
require_cmd xcrun "xcrun finds the Swift compiler for the iOS Simulator SDK."
require_cmd codesign "codesign signs the app bundle."

# Must match MinimumOSVersion in Info.plist.
IOS_VERSION=17.0
case "$(uname -m)" in
    arm64) arch=arm64 ;;
    *)     arch=x86_64 ;;
esac
target="$arch-apple-ios$IOS_VERSION-simulator"

step "2/4 Compile hello.swift for $target"
explain "WHY: -target ...-simulator builds for the Simulator; -parse-as-library lets @main mark the entry point."
# Start from an empty bundle, so no file from an older build is left behind.
rm -rf HelloWorld.app
mkdir HelloWorld.app
# set -x prints the exact command, so you can copy it.
set -x
xcrun --sdk iphonesimulator swiftc -target "$target" -parse-as-library \
    hello.swift -o HelloWorld.app/HelloWorld
{ set +x; } 2>/dev/null

step "3/4 Copy Info.plist into the bundle"
explain "WHY: the bundle must contain Info.plist, or the Simulator will not install it."
cp Info.plist HelloWorld.app/Info.plist

step "4/4 Sign the bundle"
explain "WHY: the Simulator installs only signed apps. '-' means an ad-hoc signature (no developer account needed)."
codesign --force --sign - HelloWorld.app

ok "Built HelloWorld.app. Next: ./run.sh"
