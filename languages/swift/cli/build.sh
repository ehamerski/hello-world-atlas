#!/bin/sh
# build.sh - Swift cli: compile hello.swift into the executable hello
#
# WHAT: runs
#         swiftc hello.swift -o hello
#       swiftc type-checks hello.swift, compiles it to machine code and links
#       it with the Swift standard library into the executable `hello`.
# WHY:  Swift is compiled ahead of time, like C and unlike Python. `print` is
#       part of the Swift standard library (the module named Swift), which
#       every Swift file imports automatically, so the file needs no import
#       line. On macOS the executable is linked dynamically against
#       /usr/lib/swift/libswiftCore.dylib, which ships with macOS since
#       Swift 5 (check with: otool -L hello).
#         -o hello   the name of the output file
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine). macOS Apple Silicon,
# Linux and Windows are documented but not verified.
# Sources:
#   swiftc options: `swiftc -help`
#   Swift 5 ABI stability: https://www.swift.org/blog/swift-5-released/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.swift is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check the compiler"
explain "WHY: building needs the Swift compiler; ./install.sh checks for it."
fix_developer_dir
require_cmd swiftc "The Swift compiler turns hello.swift into an executable."

step "2/2 Compile hello.swift"
explain "WHY: swiftc compiles the source to machine code; -o names the executable."
# set -x prints the exact command, so you can copy it.
set -x
swiftc hello.swift -o hello
{ set +x; } 2>/dev/null

ok "Built hello with $(swiftc --version 2>&1 | head -n 1). Next: ./run.sh"
