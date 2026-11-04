#!/bin/sh
# run.sh - C# desktop: open the Hello World window
#
# WHAT: runs  dotnet bin/Release/net10.0/hello-desktop.dll, which opens a
#       window titled "Hello, World!" that shows the text Hello, World!
# WHY:  the .dll made by ./build.sh holds IL; "dotnet <file>.dll" starts the
#       .NET runtime, which JIT-compiles and runs it (see ../cli/run.sh).
#       Avalonia's .dll files were copied next to it by the build. Its
#       native libraries (Skia for drawing, HarfBuzz for text and, on macOS,
#       libAvaloniaNative for Cocoa windows) are in
#       bin/Release/net10.0/runtimes/<platform>/native/ (osx, linux-x64, ...).
# HOW:  ./run.sh            open the window (close it to end the program)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once the window is shown
#                           and closes itself after about 2 seconds
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so bin/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# Same setup as install.sh: find ~/.dotnet, no telemetry, no banner.
if ! has_cmd dotnet && [ -x "$HOME/.dotnet/dotnet" ]; then
    PATH="$HOME/.dotnet:$PATH"; export PATH
fi
DOTNET_CLI_TELEMETRY_OPTOUT=1; DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO

require_cmd dotnet "The .NET runtime runs the compiled program."
DLL=bin/Release/net10.0/hello-desktop.dll
[ -f "$DLL" ] || fail "$DLL is missing. Run ./build.sh first."

step "Open the Hello World window"
explain "WHY: the .NET runtime runs the program; Avalonia opens the window and draws the text."
if is_verify "$@"; then
    explain "Self-check: the app prints the text and closes after ~2 seconds."
    TF_VERIFY=1 dotnet "$DLL"
else
    explain "Close the window to end the program."
    dotnet "$DLL"
fi
