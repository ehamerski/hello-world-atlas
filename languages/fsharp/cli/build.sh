#!/bin/sh
# build.sh - F# cli: compile hello.fs into build/hello.dll
#
# WHAT: runs "dotnet build" on hello.fsproj. The F# compiler turns hello.fs into
#       Common Intermediate Language (CIL) and the SDK writes hello.dll, with its
#       runtime settings, into build/.
# WHY:  F# is compiled, not interpreted. The .NET runtime then runs the CIL on any
#       supported system. build/ and obj/ are build output (git ignores them).
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.fs)
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows
# are documented and NOT verified for this implementation.
# Sources: https://learn.microsoft.com/dotnet/core/tools/dotnet-build and
# https://learn.microsoft.com/dotnet/fsharp/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# The dotnet command and the telemetry settings.
# shellcheck source=dotnet-env.sh
. ./dotnet-env.sh

step "1/2 Check the SDK"
explain "WHY: building needs the .NET SDK; ./install.sh installs it."
require_cmd dotnet "The .NET SDK is needed to compile F#."

step "2/2 Compile hello.fs"
explain "WHY: dotnet build runs the F# compiler. -o build puts hello.dll in build/."
set -x
dotnet build hello.fsproj --configuration Debug -o build
{ set +x; } 2>/dev/null

ok "Build finished. Next: ./run.sh"
