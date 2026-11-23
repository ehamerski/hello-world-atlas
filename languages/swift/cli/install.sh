#!/bin/sh
# install.sh - Swift cli: check (and optionally install) the Swift compiler
#
# WHAT: checks that `swiftc`, the Swift compiler, is installed and is Swift 5
#       or later. If it is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently. With TF_NONINTERACTIVE=1 it only reports.
# WHY:  Swift is compiled ahead of time to machine code. The compiler is the
#       only tool this program needs: `print` is part of the Swift standard
#       library, which comes with every Swift toolchain.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine). macOS Apple Silicon,
# Linux and Windows are documented but not verified.
# Sources for the install commands:
#   https://developer.apple.com/swift/          (Swift on macOS, with Xcode)
#   https://www.swift.org/install/linux/
#   https://www.swift.org/install/windows/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check whether the Swift compiler is installed"
explain "WHY: 'swiftc' compiles hello.swift into a program for your computer."
# On macOS, make sure swiftc comes from a working developer directory.
fix_developer_dir
if ! has_cmd swiftc; then
    warn "The Swift compiler ('swiftc') was not found."
    case "$TF_OS" in
        macos-intel|macos-arm)
            # Apple's Command Line Tools contain swiftc and the Swift
            # standard library. xcode-select --install opens Apple's installer.
            install_pkg "Apple's Command Line Tools (swiftc)" xcode-select --install || exit 1
            fail "Finish Apple's installer window, then run ./install.sh again." ;;
        linux)
            explain "Install Swift with the steps for your distribution on"
            explain "    https://www.swift.org/install/linux/"
            exit 1 ;;
        windows)
            explain "Install Swift with the steps on https://www.swift.org/install/windows/"
            explain "and reopen Git Bash."
            exit 1 ;;
        *)
            fail "Unknown OS. Install Swift from https://www.swift.org/install/" ;;
    esac
fi

step "2/2 Check the Swift version"
explain "WHY: the commands in this folder are written for Swift 5 or later."
# `swiftc --version` prints, for example, "Apple Swift version 6.3.2 (...)".
swift_major=$(swiftc --version 2>&1 | sed -n 's/.*Swift version \([0-9][0-9]*\).*/\1/p' | head -n 1)
[ "${swift_major:-0}" -ge 5 ] || fail "Swift ${swift_major:-unknown} found; Swift 5 or later is needed."
ok "Swift compiler found: $(swiftc --version 2>&1 | head -n 1). Next: ./build.sh"
