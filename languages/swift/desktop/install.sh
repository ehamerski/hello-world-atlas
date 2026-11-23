#!/bin/sh
# install.sh - Swift desktop: check (and optionally install) the Swift compiler
#
# WHAT: checks that this is macOS and that `swiftc`, the Swift compiler, is
#       installed and is Swift 5 or later. If swiftc is missing, shows the
#       install command and runs it only if you answer "y". Nothing is
#       installed silently. With TF_NONINTERACTIVE=1 it only reports.
# WHY:  SwiftUI, the UI framework used here, is part of the Apple platform
#       SDKs (macOS 10.15 Catalina and later). The Command Line Tools contain
#       swiftc and the macOS SDK with AppKit and SwiftUI, so the full Xcode
#       app is not needed. SwiftUI does not exist on Linux or Windows.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon
# is not verified. Linux and Windows cannot run it: SwiftUI exists only on
# Apple platforms.
# Sources:
#   https://developer.apple.com/xcode/swiftui/
#   https://developer.apple.com/swift/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/3 Check the operating system"
explain "WHY: SwiftUI and AppKit are part of the macOS SDK; other systems do not have them."
case "$TF_OS" in
    macos-intel|macos-arm) ok "macOS $(sw_vers -productVersion 2>/dev/null || echo unknown) ($(uname -m))" ;;
    *) fail "This program needs macOS. SwiftUI is not available on Linux or Windows." ;;
esac

step "2/3 Check whether the Swift compiler is installed"
explain "WHY: 'swiftc' compiles hello.swift and links it with SwiftUI and AppKit."
# Make sure swiftc comes from a working developer directory.
fix_developer_dir
if ! has_cmd swiftc; then
    warn "The Swift compiler ('swiftc') was not found."
    # Apple's Command Line Tools contain swiftc and the macOS SDK.
    # xcode-select --install opens Apple's installer.
    install_pkg "Apple's Command Line Tools (swiftc)" xcode-select --install || exit 1
    fail "Finish Apple's installer window, then run ./install.sh again."
fi

step "3/3 Check the Swift version"
explain "WHY: the commands in this folder are written for Swift 5 or later."
# `swiftc --version` prints, for example, "Apple Swift version 6.3.2 (...)".
swift_major=$(swiftc --version 2>&1 | sed -n 's/.*Swift version \([0-9][0-9]*\).*/\1/p' | head -n 1)
[ "${swift_major:-0}" -ge 5 ] || fail "Swift ${swift_major:-unknown} found; Swift 5 or later is needed."
ok "Swift compiler found: $(swiftc --version 2>&1 | head -n 1). Next: ./build.sh"
