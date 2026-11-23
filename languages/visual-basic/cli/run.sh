#!/bin/sh
# run.sh - Visual Basic (VB.NET) cli: run the Hello World program
#
# WHAT: runs the built program, which prints exactly: Hello, World!
# WHY:  dotnet runs the CIL that build.sh made from Program.vb. "--no-build" makes sure
#       this script runs what build.sh built and does not compile again.
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

require_cmd dotnet "The .NET SDK runs this program. (run ./install.sh first)"

step "Run the program"
explain "WHY: dotnet runs the built program; --no-build reuses what build.sh made."
[ -f bin/Debug/net10.0/vbcli.dll ] || fail "vbcli.dll was not found. Run ./build.sh first."
dotnet run --configuration Debug --no-build --project vbcli.vbproj
