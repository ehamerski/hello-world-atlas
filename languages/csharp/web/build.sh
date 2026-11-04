#!/bin/sh
# build.sh - C# web: compile Program.cs with "dotnet build"
#
# WHAT: runs  dotnet build -c Release --disable-build-servers
#       and leaves the compiled program in bin/Release/net10.0/hello-web.dll.
# WHY:  "dotnet build" first restores the project (downloads any NuGet
#       packages it lists; this one lists none), then MSBuild reads
#       hello-web.csproj and calls the C# compiler. The compiler does NOT
#       produce machine code: it produces IL (Intermediate Language) in a
#       .dll file, like javac produces bytecode in a .class file. The .NET
#       runtime turns the IL into machine code when the program runs (JIT).
#       -c Release turns on optimizations. --disable-build-servers tells
#       dotnet not to use its persistent build servers (MSBuild and compiler
#       processes that otherwise stay in memory to speed up the next build),
#       so the script leaves no background processes behind.
#       Compare ../../cpp/cli/build.sh, which produces machine code directly.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello-web.csproj is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# Same setup as install.sh: find ~/.dotnet, no telemetry, no banner.
if ! has_cmd dotnet && [ -x "$HOME/.dotnet/dotnet" ]; then
    PATH="$HOME/.dotnet:$PATH"; export PATH
fi
DOTNET_CLI_TELEMETRY_OPTOUT=1; DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO

step "1/2 Check the tools"
explain "WHY: building needs the .NET SDK; ./install.sh checks for it."
require_cmd dotnet "The .NET SDK builds C# projects."

step "2/2 Build (dotnet build -c Release)"
explain "WHY: restores the project, then compiles Program.cs to IL in a .dll file."
# set -x prints the exact command, so you can copy it.
set -x
dotnet build -c Release --disable-build-servers
{ set +x; } 2>/dev/null

ok "Built bin/Release/net10.0/hello-web.dll. Next: ./run.sh"
