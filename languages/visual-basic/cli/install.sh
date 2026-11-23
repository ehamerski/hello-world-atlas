#!/bin/sh
# install.sh - Visual Basic (VB.NET) cli: check (and optionally install) the .NET 10 SDK
#
# WHAT: checks that the .NET SDK 10 (the dotnet command) is installed. If it is missing,
#       downloads Microsoft's dotnet-install.sh, checks its SHA-256 digest, and runs it to
#       install the SDK into ~/.dotnet. Nothing is installed without your "y", and sudo
#       is not used.
# WHY:  VB.NET is compiled by the .NET SDK. Visual Basic 6 (the classic VB, Windows only)
#       is not used here: VB.NET is the current Visual Basic and runs on macOS and Linux
#       too (see README.md, history section).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). Linux is documented and
# NOT verified for this implementation. Windows (winget) is documented and NOT verified.
# WinForms (the Windows desktop GUI for VB.NET) is NOT verified and is not part of this folder.
# Sources: https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script and
# https://dot.net/ (the SDK download)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# SDK_MIN, DOTNET_INSTALL_SHA256, DOTNET_INSTALL_DIR, telemetry settings.
# shellcheck source=dotnet-env.sh
. ./dotnet-env.sh

# sdk_ok - true if "dotnet --list-sdks" shows an SDK of version $SDK_MIN or newer.
# Each line looks like: 10.0.404 [/Users/you/.dotnet/sdk]
sdk_ok() {
    has_cmd dotnet || return 1
    dotnet --list-sdks 2>/dev/null | awk -F. -v min="$SDK_MIN" '$1 >= min { f = 1 } END { exit !f }'
}

# install_dotnet - download Microsoft's install script, check its digest, run it.
# --channel 10.0 picks the newest .NET 10 SDK; --install-dir is where it goes.
install_dotnet() {
    id_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-visual-basic
    id_script=$id_cache/dotnet-install.sh
    mkdir -p "$id_cache"
    curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$id_script"
    echo "$DOTNET_INSTALL_SHA256  $id_script" | shasum -a 256 -c - \
        || fail "Checksum mismatch for dotnet-install.sh: see the note in dotnet-env.sh."
    bash "$id_script" --channel 10.0 --install-dir "$DOTNET_INSTALL_DIR"
    PATH="$DOTNET_INSTALL_DIR:$PATH"; export PATH
}

step "1/1 Check whether the .NET SDK $SDK_MIN (or newer) is installed"
explain "WHY: the SDK has the VB.NET compiler (vbc), MSBuild and the runtime in one package."
if sdk_ok; then
    ok ".NET SDK found: $(dotnet --version) ($(command -v dotnet))"
else
    warn "No .NET SDK $SDK_MIN or newer was found ('dotnet' missing or too old)."
    case "$TF_OS" in
        macos-intel|macos-arm|linux)
            explain "Microsoft's dotnet-install.sh installs the SDK into $DOTNET_INSTALL_DIR,"
            explain "with no administrator rights. Its digest is checked first (dotnet-env.sh)."
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

ok "Toolchain is ready. Next: ./build.sh"
