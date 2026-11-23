#!/bin/sh
# install.sh - Ada cli: check (and optionally install) Alire and its GNAT toolchain
#
# WHAT: 1. checks that "alr", the Alire command, is installed. If it is
#          missing, shows the commands that download the official release
#          archive from GitHub and put alr in ~/.local/bin, and runs them
#          only if you answer "y";
#       2. checks that Alire has a toolchain selected (the GNAT Ada compiler
#          "gnat_native" and the "gprbuild" build tool). If not, offers to
#          run "alr toolchain --select", which downloads them into Alire's
#          own folder (~/.local/share/alire). Nothing goes to system folders
#          and sudo is never used.
# WHY:  Ada is compiled ahead of time. GNAT is the Ada compiler of GCC, and
#       Alire is the Ada package manager that installs it, much like rustup
#       and Cargo do for Rust. ada-lang.io calls Alire "by far the easiest
#       way to get hold of an Ada toolchain".
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); Linux and
# Windows (Git Bash) verified in CI; macOS Apple Silicon and WSL are
# documented but NOT verified.
# Sources for the install commands:
#   https://alire.ada.dev/docs/                        (install, toolchain)
#   https://github.com/alire-project/alire/releases    (official downloads)
#   https://ada-lang.io/docs/learn/getting-started/installation

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The Alire release this folder was verified with, and where alr goes.
ALR_VERSION=2.1.1
# ALR_BIN_DIR (where alr goes) and its place on PATH; see alire-env.sh.
# shellcheck source=alire-env.sh
. ./alire-env.sh

# SHA-256 of the Windows archive, as listed for the release asset on
# https://github.com/alire-project/alire/releases/tag/v2.1.1 (the "digest"
# field of the GitHub releases API for alr-2.1.1-bin-x86_64-windows.zip).
ALR_WINDOWS_SHA256=863013b1f94da6f3b7d0d5a74022ac3370424eeea9a470ebdb33d188d61b9125

# install_alr_windows - Windows (Git Bash): Git for Windows ships neither
# unzip nor a tar that reads zip files, but PowerShell is always there, so
# Expand-Archive unpacks the official archive. The archive holds bin/alr.exe
# (https://learn.microsoft.com/powershell/module/microsoft.powershell.archive/expand-archive).
# cygpath -w turns a Git Bash path into the Windows path PowerShell needs.
install_alr_windows() {
    ALR_ZIP=alr-$ALR_VERSION-bin-x86_64-windows.zip
    ALR_URL=https://github.com/alire-project/alire/releases/download/v$ALR_VERSION/$ALR_ZIP
    alr_tmp=$(mktemp -d)
    explain "To install Alire $ALR_VERSION (official release archive), the commands are:"
    explain "    curl -fL -o $alr_tmp/$ALR_ZIP $ALR_URL"
    explain "    sha256sum -c  (against $ALR_WINDOWS_SHA256)"
    explain "    powershell Expand-Archive  (then copy bin/alr.exe to $ALR_BIN_DIR)"
    confirm "Run them now?" \
        || { warn "Skipped. Run the commands above yourself, then re-run this script."; exit 1; }
    curl -fL -o "$alr_tmp/$ALR_ZIP" "$ALR_URL"
    # The checksum proves the file is exactly the official release.
    echo "$ALR_WINDOWS_SHA256  $alr_tmp/$ALR_ZIP" | sha256sum -c - \
        || fail "Checksum mismatch for $ALR_ZIP."
    powershell -NoProfile -Command \
        "Expand-Archive -LiteralPath '$(cygpath -w "$alr_tmp/$ALR_ZIP")' -DestinationPath '$(cygpath -w "$alr_tmp/x")'"
    mkdir -p "$ALR_BIN_DIR"
    cp "$alr_tmp/x/bin/alr.exe" "$ALR_BIN_DIR/"
    rm -rf "$alr_tmp"
    # Read alire-env.sh again: ALR_BIN_DIR exists now, so it goes on PATH.
    . ./alire-env.sh
}

step "1/2 Check whether Alire (alr) is installed"
explain "WHY: 'alr' installs the GNAT compiler and builds the program ('alr build')."
if has_cmd alr; then
    ok "Alire found: $(alr version 2>/dev/null | sed -n 's/^alr version: *//p')"
else
    warn "Alire is not installed (no 'alr' on PATH)."
    # Pick the release archive for this computer (names as published on
    # https://github.com/alire-project/alire/releases).
    case "$TF_OS-$(uname -m)" in
        macos-intel-*)       ALR_ASSET=x86_64-macos ;;
        macos-arm-*)         ALR_ASSET=aarch64-macos ;;
        linux-x86_64)        ALR_ASSET=x86_64-linux ;;
        linux-aarch64)       ALR_ASSET=aarch64-linux ;;
        windows-*)           ALR_ASSET=x86_64-windows ;;
        *)  fail "Unknown OS. Download alr from https://github.com/alire-project/alire/releases" ;;
    esac
    if [ "$TF_OS" = windows ]; then
        install_alr_windows
        has_cmd alr || fail "alr was installed in $ALR_BIN_DIR but is not on PATH."
        ok "Alire installed: $ALR_BIN_DIR/alr.exe"
    else
        ALR_ZIP=alr-$ALR_VERSION-bin-$ALR_ASSET.zip
        ALR_URL=https://github.com/alire-project/alire/releases/download/v$ALR_VERSION/$ALR_ZIP
        # Alire's docs: download the archive, extract it and put alr on PATH.
        # unzip -j keeps only bin/alr, without the folder, in $ALR_BIN_DIR.
        explain "To install Alire $ALR_VERSION (official release archive), the commands are:"
        explain "    curl -fL -o /tmp/$ALR_ZIP $ALR_URL"
        explain "    unzip -o -j /tmp/$ALR_ZIP bin/alr -d $ALR_BIN_DIR"
        if confirm "Run them now?"; then
            require_cmd curl "curl downloads the Alire archive."
            require_cmd unzip "unzip extracts the Alire archive."
            mkdir -p "$ALR_BIN_DIR"
            curl -fL -o "/tmp/$ALR_ZIP" "$ALR_URL"
            unzip -o -j "/tmp/$ALR_ZIP" bin/alr -d "$ALR_BIN_DIR"
            rm -f "/tmp/$ALR_ZIP"
        else
            warn "Skipped. Run the commands above yourself, then re-run this script."
            exit 1
        fi
        # ~/.local/bin must be on PATH so the shell finds alr.
        case ":$PATH:" in
            *":$ALR_BIN_DIR:"*) ;;
            *) fail "Add $ALR_BIN_DIR to PATH (e.g. in ~/.profile: export PATH=\"\$HOME/.local/bin:\$PATH\"), open a new terminal and retry." ;;
        esac
        ok "Alire installed: $ALR_BIN_DIR/alr"
    fi
fi

step "2/2 Check whether Alire has a GNAT toolchain"
explain "WHY: alr builds with the compiler (gnat_native) and build tool (gprbuild)"
explain "     selected in its settings; 'alr toolchain' lists them."
# "alr toolchain" prints the toolchain crates Alire has installed;
# a gnat_native line marked Default means the compiler is ready.
if alr toolchain 2>/dev/null | grep -q '^gnat_native .*Default'; then
    ok "Toolchain ready: $(alr toolchain 2>/dev/null | awk '$3 == "Default" { printf "%s=%s ", $1, $2 }')"
    exit 0
fi
warn "No default GNAT toolchain is selected yet."
explain "To download the default GNAT compiler and gprbuild (a few hundred MB,"
explain "into ~/.local/share/alire), the command is:"
explain "    alr -n toolchain --select"
explain "(-n: non-interactive, take the default answers; without -n alr asks.)"
if confirm "Run it now?"; then
    alr -n toolchain --select
else
    warn "Skipped. Run the command above yourself, then re-run this script."
    exit 1
fi
ok "Alire and GNAT are ready. Next: ./build.sh"
