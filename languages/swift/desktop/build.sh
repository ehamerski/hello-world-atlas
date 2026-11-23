#!/bin/sh
# build.sh - Swift desktop: compile the SwiftUI app hello.swift into hello
#
# WHAT: runs
#         swiftc -parse-as-library hello.swift -o hello
#       swiftc type-checks hello.swift, compiles it to machine code and links
#       it into the macOS executable `hello`.
# WHY:  Swift is compiled ahead of time. The flags:
#         -parse-as-library  read the file as a library file, not as a main
#                            file with top-level code. swiftc reads a single
#                            input file as a main file by default, and `@main`
#                            is not allowed in a module that has top-level
#                            code ("'main' attribute cannot be used in a
#                            module that contains top-level code"). With the
#                            flag, `@main struct HelloWorldApp` marks the
#                            entry point.
#         -o hello           the name of the output file
#       The executable is linked dynamically against the SwiftUI and AppKit
#       frameworks and the Swift standard library
#       (/usr/lib/swift/libswiftCore.dylib), which all ship with macOS
#       (check with: otool -L hello).
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon
# is not verified. Linux and Windows cannot run it: SwiftUI exists only on
# Apple platforms.
# Sources:
#   swiftc options: `swiftc -help` ("Parse the input file(s) as libraries,
#     not scripts")
#   @main and top-level code: https://docs.swift.org/latest/documentation/the-swift-programming-language/attributes/

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

step "2/2 Compile hello.swift (SwiftUI)"
explain "WHY: -parse-as-library lets @main mark the entry point; -o names the executable."
# set -x prints the exact command, so you can copy it.
set -x
swiftc -parse-as-library hello.swift -o hello
{ set +x; } 2>/dev/null

ok "Built hello with $(swiftc --version 2>&1 | head -n 1). Next: ./run.sh"
