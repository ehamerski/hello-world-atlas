# shellcheck shell=sh
# dotnet-env.sh - Visual Basic (VB.NET) web: where the .NET SDK is, shared by
#                 install.sh, build.sh and run.sh (sourced, not run: it only sets
#                 variables and PATH)
#
# WHAT: sets DOTNET_INSTALL_DIR, DOTNET_INSTALL_SHA256 and SDK_MIN, puts the .NET SDK on
#       PATH when it is in $DOTNET_INSTALL_DIR, and turns off the dotnet CLI's telemetry
#       and welcome banner.
# WHY:  VB.NET is compiled by the .NET SDK (the dotnet command). Microsoft's
#       dotnet-install.sh puts the SDK in ~/.dotnet without administrator rights, but it
#       does not change PATH, so this file does that. The dotnet CLI sends usage data
#       to Microsoft unless DOTNET_CLI_TELEMETRY_OPTOUT is set.
#
# DOTNET_INSTALL_SHA256 is the SHA-256 digest of https://dot.net/v1/dotnet-install.sh as it
# was downloaded on 2026-11-10 (Microsoft's installer script). If Microsoft changes the
# script, install.sh stops with a checksum mismatch; check the new script, then update
# this value. Sources: https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script
# and https://learn.microsoft.com/dotnet/core/install/macos

# shellcheck disable=SC2034  # used by install.sh
SDK_MIN=10
DOTNET_INSTALL_SHA256=082f7685e156738a1b2e2ed8381a621870d4ce8e8c59278034556f05c186eb2e
DOTNET_INSTALL_DIR=${DOTNET_INSTALL_DIR:-$HOME/.dotnet}
if [ -x "$DOTNET_INSTALL_DIR/dotnet" ]; then
    PATH=$DOTNET_INSTALL_DIR:$PATH
fi
# Usage data goes to Microsoft unless this is set; the banner is printed on first use unless DOTNET_NOLOGO is set.
DOTNET_CLI_TELEMETRY_OPTOUT=1
DOTNET_NOLOGO=1
export DOTNET_INSTALL_DIR PATH DOTNET_CLI_TELEMETRY_OPTOUT DOTNET_NOLOGO
