#!/bin/sh
# install.sh - C# desktop: check the .NET 10 SDK and download Avalonia
#
# WHAT: 1. checks that the "dotnet" command is installed with a .NET SDK of
#          version 10 or newer. If not, shows the install command for your
#          operating system and runs it only if you answer "y". Nothing is
#          installed silently and sudo is never used;
#       2. runs "dotnet restore", which downloads the Avalonia packages
#          listed in hello-desktop.csproj from NuGet (nuget.org).
# WHY:  the .NET SDK contains everything this program needs: the C#
#       compiler, MSBuild (the build engine behind "dotnet build"), the
#       runtime that runs the result and the base class library.
#       The UI toolkit, Avalonia, is not part of .NET: it is a set of NuGet
#       packages, downloaded into ~/.nuget/packages (shared by all projects).
#       .NET 10 is the current Long Term Support (LTS) release.
#       On macOS and Linux the script offers Microsoft's official
#       dotnet-install.sh, which installs into ~/.dotnet without admin
#       rights (the .pkg installer and Homebrew's dotnet-sdk cask need sudo,
#       and Homebrew's dotnet formula has no ready-made Intel-Mac build).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script
#   https://learn.microsoft.com/dotnet/core/install/macos
#   https://learn.microsoft.com/dotnet/core/install/linux
#   https://learn.microsoft.com/dotnet/core/install/windows
#   https://learn.microsoft.com/dotnet/core/tools/dotnet-restore

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# dotnet-install.sh puts .NET in ~/.dotnet but does not change PATH. If
# "dotnet" is not on PATH yet, use that copy for this script.
if ! has_cmd dotnet && [ -x "$HOME/.dotnet/dotnet" ]; then
    PATH="$HOME/.dotnet:$PATH"; export PATH
fi
# The dotnet CLI sends usage telemetry to Microsoft unless this is set, and
# prints a welcome banner on first use unless DOTNET_NOLOGO is set.
# Avalonia's packages add a build step (Avalonia.BuildServices) that sends
# anonymous usage data to Avalonia at build time unless
# AVALONIA_TELEMETRY_OPTOUT is set.
DOTNET_CLI_TELEMETRY_OPTOUT=1; DOTNET_NOLOGO=1; AVALONIA_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO AVALONIA_TELEMETRY_OPTOUT

# The oldest SDK major version that can build net10.0 projects.
SDK_MIN=10

# sdk_ok succeeds if "dotnet --list-sdks" shows an SDK of version 10 or
# newer. Each line looks like: 10.0.403 [/Users/you/.dotnet/sdk]
sdk_ok() {
    has_cmd dotnet || return 1
    dotnet --list-sdks 2>/dev/null | awk -F. -v min="$SDK_MIN" '$1 >= min { f = 1 } END { exit !f }'
}

# install_dotnet downloads Microsoft's install script to a temporary file
# and runs it: --channel 10.0 picks the newest .NET 10 SDK, and
# --install-dir is where it goes (the script's default on macOS/Linux).
install_dotnet() {
    id_script=$(mktemp)
    curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$id_script"
    bash "$id_script" --channel 10.0 --install-dir "$HOME/.dotnet"
    rm -f "$id_script"
    PATH="$HOME/.dotnet:$PATH"; export PATH
}

step "1/2 Check whether the .NET SDK $SDK_MIN (or newer) is installed"
explain "WHY: the SDK has the C# compiler, MSBuild and the .NET runtime in one package."
if sdk_ok; then
    ok ".NET SDK found: $(dotnet --version) ($(command -v dotnet))"
else
    warn "No .NET SDK $SDK_MIN or newer was found ('dotnet' missing or too old)."
    case "$TF_OS" in
        macos-intel|macos-arm|linux)
            explain "Microsoft's dotnet-install.sh (https://dot.net/v1/dotnet-install.sh)"
            explain "installs the SDK into ~/.dotnet, no sudo needed. It runs:"
            explain "    bash dotnet-install.sh --channel 10.0 --install-dir \$HOME/.dotnet"
            explain "Afterwards add ~/.dotnet to PATH in your shell profile to use 'dotnet' by hand."
            install_pkg "the .NET $SDK_MIN SDK" install_dotnet || exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id Microsoft.DotNet.SDK.10 -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install the .NET SDK by hand: https://dotnet.microsoft.com/download" ;;
    esac
    sdk_ok || fail "The .NET SDK is still not found. Open a new terminal and retry."
fi

step "2/2 Download the Avalonia packages (dotnet restore)"
explain "WHY: hello-desktop.csproj lists Avalonia 12.1.4 as PackageReference items;"
explain "     restore downloads exactly those versions from NuGet. Already-downloaded"
explain "     packages are reused, so a second run takes a few seconds."
# set -x prints the exact command, so you can copy it.
set -x
dotnet restore --disable-build-servers
{ set +x; } 2>/dev/null

ok "Ready. Next: ./build.sh"
