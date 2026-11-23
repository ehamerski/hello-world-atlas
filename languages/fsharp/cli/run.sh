#!/bin/sh
# run.sh - F# cli: run the Hello World program
#
# WHAT: runs the built program, which prints exactly: Hello, World!
# WHY:  "dotnet build/hello.dll" starts the .NET runtime, which runs the CIL that
#       build.sh made from hello.fs. Running the dll directly does not compile again.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows are
# documented and NOT verified for this implementation.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# The dotnet command and the telemetry settings.
# shellcheck source=dotnet-env.sh
. ./dotnet-env.sh

require_cmd dotnet "The .NET runtime runs this program. (run ./install.sh first)"

step "Run the program"
explain "WHY: dotnet starts the runtime, which loads build/hello.dll and runs it."
[ -f build/hello.dll ] || fail "build/hello.dll was not found. Run ./build.sh first."
dotnet build/hello.dll
