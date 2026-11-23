#!/bin/sh
# build.sh - Visual Basic (VB.NET) web: compile the ASP.NET Core server in Program.vb
#
# WHAT: runs "dotnet build" on vbweb.vbproj. It compiles Program.vb into a web server
#       (an ASP.NET Core application) in bin/Debug/net10.0/.
# WHY:  the .NET SDK has no VB.NET web template, so vbweb.vbproj is written by hand. It
#       uses the Microsoft.NET.Sdk.Web SDK, which adds the ASP.NET Core libraries.
# HOW:  ./build.sh         (after ./install.sh; run again after editing Program.vb)
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows are
# documented and NOT verified for this implementation.
# Sources: https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis and
# https://learn.microsoft.com/dotnet/core/tools/dotnet-build

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
require_cmd dotnet "The .NET SDK is needed to compile the web server."

step "2/2 Compile Program.vb"
explain "WHY: dotnet build runs the VB.NET compiler on the ASP.NET Core project."
set -x
dotnet build --configuration Debug vbweb.vbproj
{ set +x; } 2>/dev/null

ok "Build finished. Next: ./run.sh"
