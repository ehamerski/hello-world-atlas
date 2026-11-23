#!/bin/sh
# run.sh - C# cli: run the Hello World program
#
# WHAT: runs  dotnet bin/Release/net10.0/hello-cli.dll, which prints
#       exactly: Hello, World!
# WHY:  the .dll made by ./build.sh holds IL, not machine code, so the
#       operating system cannot run it by itself. "dotnet <file>.dll" starts
#       the .NET runtime, which loads the IL, compiles it to machine code
#       just in time (JIT) and runs it. This is the same idea as
#       "java -jar" in ../../java/cli. (build also writes a small
#       native launcher, bin/Release/net10.0/hello-cli, which does the same,
#       but it looks for .NET in the system-wide folder, not in ~/.dotnet.)
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified); Linux and Windows (Git Bash) verified in
# CI; macOS Apple Silicon and WSL are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
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

require_cmd dotnet "The .NET runtime runs the compiled program."
DLL=bin/Release/net10.0/hello-cli.dll
[ -f "$DLL" ] || fail "$DLL is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: 'dotnet' starts the .NET runtime, which JIT-compiles the IL in the .dll and runs it."
dotnet "$DLL"
