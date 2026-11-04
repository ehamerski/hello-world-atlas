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
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
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
ALR_BIN_DIR=$HOME/.local/bin

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
        windows-*)
            explain "On Windows download and run the official installer, then reopen Git Bash:"
            explain "    https://github.com/alire-project/alire/releases/download/v$ALR_VERSION/alr-$ALR_VERSION-installer-x86_64-windows.exe"
            exit 1 ;;
        *)  fail "Unknown OS. Download alr from https://github.com/alire-project/alire/releases" ;;
    esac
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
