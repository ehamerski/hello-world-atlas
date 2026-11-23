#!/bin/sh
# install.sh - Swift iOS: check the toolchain (Xcode and the iOS Simulator).
#
# WHAT: checks that macOS has full Xcode (not only the Command Line Tools),
#   the iphonesimulator SDK, the `simctl` tool and the Swift compiler. It
#   prints what is missing and how to get it. It never installs anything.
# WHY:  an iOS app is built against the iOS SDK, and the Simulator that runs
#   it ships only inside Xcode. The Command Line Tools alone compile macOS
#   code, which is why ../desktop works on a Mac without Xcode but this
#   folder does not. Xcode is large (several gigabytes) and comes from the
#   Mac App Store or developer.apple.com, so the student installs it.
#
# Platforms: verified on macOS Intel (macOS 26, Xcode 26.5, iOS 26.5
# Simulator runtime) and on a macOS Apple Silicon CI runner
# (.github/workflows/ios.yml). Linux and Windows cannot build iOS apps.
#
# References:
#   Xcode:            https://developer.apple.com/xcode/
#   Xcode downloads:  https://developer.apple.com/download/all/
#   Simulator:        https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device
#   Runner images:    https://github.com/actions/runner-images (the CI Xcode versions)

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# --- Check macOS (iOS apps are built only on macOS) -----------------------------

step "Check the operating system"
explain "WHY: the iOS SDK and the Simulator exist only on macOS."
if [ "$(uname -s)" != "Darwin" ]; then
    fail "This program needs macOS. Linux and Windows cannot build iOS apps."
fi
ok "macOS $(sw_vers -productVersion 2>/dev/null || echo unknown) ($(uname -m))"

# --- Check full Xcode (not only the Command Line Tools) -------------------------

step "Check Xcode"
explain "WHY: xcodebuild and the iOS Simulator are installed only with the full Xcode app."
if ! xcodebuild -version >/dev/null 2>&1; then
    fail "Full Xcode was not found. Install Xcode from the Mac App Store or
       https://developer.apple.com/xcode/, open it once to accept the license,
       then run: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
fi
ok "$(xcodebuild -version | head -1)"

# --- Check the iOS Simulator SDK and simctl -------------------------------------

step "Check the iOS Simulator SDK"
explain "WHY: swiftc needs the iphonesimulator SDK to compile for the Simulator."
if ! sdk=$(xcrun --sdk iphonesimulator --show-sdk-path 2>/dev/null); then
    fail "The iphonesimulator SDK is missing. Open Xcode > Settings > Platforms and install the iOS Simulator."
fi
ok "SDK: $sdk"

step "Check simctl and the Swift compiler"
explain "WHY: simctl boots the Simulator and installs and starts the app. swiftc builds the code."
if ! xcrun --find simctl >/dev/null 2>&1; then
    fail "simctl was not found. It comes with Xcode."
fi
ok "simctl: $(xcrun --find simctl)"
ok "swiftc: $(xcrun --find swiftc)"

echo "install.sh: OK"
