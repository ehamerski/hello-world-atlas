#!/bin/sh
# build.sh - Visual Basic (VB.NET) cli: compile Program.vb into an executable
#
# WHAT: runs "dotnet build" on vbcli.vbproj. The compiler turns Program.vb into
#       Common Intermediate Language (CIL), and the SDK writes the program and
#       the vbcli.dll library into bin/Debug/net10.0/.
# WHY:  VB.NET is compiled, not interpreted. The .NET runtime then runs the CIL
#       on any supported system. bin/ and obj/ are build output (git ignores them).
# HOW:  ./build.sh         (after ./install.sh; run again after editing Program.vb)
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows
# are documented and NOT verified for this implementation.
# Sources: https://learn.microsoft.com/dotnet/core/tools/dotnet-build and
# https://learn.microsoft.com/dotnet/visual-basic/

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
require_cmd dotnet "The .NET SDK is needed to compile VB.NET."

step "2/2 Compile Program.vb"
explain "WHY: dotnet build runs the VB.NET compiler and writes bin/Debug/net10.0/."
set -x
dotnet build --configuration Debug vbcli.vbproj
{ set +x; } 2>/dev/null

ok "Build finished. Next: ./run.sh"
