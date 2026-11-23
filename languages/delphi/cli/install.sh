#!/bin/sh
# install.sh - Delphi-dialect cli: check (and optionally install) Free Pascal 3.2.2
#
# WHAT: checks that the Free Pascal compiler (fpc) is installed. If it is
#       missing, offers to install the official release (see delphi-env.sh).
#       Nothing is installed without your "y", and sudo is never used on macOS.
# WHY:  the Delphi dialect is compiled by Free Pascal with {$mode delphi}.
#       Embarcadero Delphi itself is not used. Free
#       Pascal is free software (GPL/LGPL with the FPC linking exception).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). Linux is
# documented (Debian/Ubuntu package "fpc") and NOT verified for this
# implementation. Windows (Git Bash) is documented and NOT verified.
# Sources: the official Free Pascal download page for macOS
# (https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/3.2.2/), and
# the Free Pascal home page (https://www.freepascal.org/).

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# FPC_VERSION, FPC_DMG_SHA256, FPC_DIR, FPC.
# shellcheck source=delphi-env.sh
. ./delphi-env.sh

# install_fpc_official_macos - download the official Free Pascal 3.2.2 installer
# for macOS, check its digest, and unpack it into $FPC_DIR (no sudo).
install_fpc_official_macos() {
    fpc_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-delphi
    fpc_dmg=fpc-$FPC_VERSION.intelarm64-macosx.dmg
    fpc_url="https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/$FPC_VERSION/$fpc_dmg/download"
    explain "Download $fpc_dmg (about 270 MB) from SourceForge into $fpc_cache,"
    explain "check its SHA-256 digest, and unpack it into $FPC_DIR (no sudo)."
    confirm "Install Free Pascal $FPC_VERSION into $FPC_DIR now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    mkdir -p "$fpc_cache"
    [ -f "$fpc_cache/$fpc_dmg" ] || curl -fL -o "$fpc_cache/$fpc_dmg" "$fpc_url"
    echo "$FPC_DMG_SHA256  $fpc_cache/$fpc_dmg" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $fpc_cache/$fpc_dmg and retry."

    fpc_tmp=$(mktemp -d)
    # Open the disk image read-only, without showing it in Finder.
    hdiutil attach -quiet -nobrowse -readonly -mountpoint "$fpc_tmp/dmg" "$fpc_cache/$fpc_dmg"
    # --expand-full also unpacks the "Payload" archive: the files the installer
    # would copy to /usr/local.
    pkgutil --expand-full \
        "$fpc_tmp/dmg/fpc-$FPC_VERSION-intelarm64-macosx.mpkg/Contents/Packages/fpc-$FPC_VERSION-intelarm64-macosx.pkg" \
        "$fpc_tmp/pkg"
    hdiutil detach -quiet "$fpc_tmp/dmg"
    rm -rf "$FPC_DIR"
    mkdir -p "$FPC_DIR"
    cp -R "$fpc_tmp/pkg/Payload/usr/local/" "$FPC_DIR/"
    rm -rf "$fpc_tmp"
    # samplecfg writes $FPC_DIR/etc/fpc.cfg, which tells fpc where its units are.
    "$FPC_DIR/lib/fpc/$FPC_VERSION/samplecfg" "$FPC_DIR/lib/fpc/$FPC_VERSION" "$FPC_DIR/etc" >/dev/null
    # Read delphi-env.sh again: it now puts $FPC_DIR/bin on PATH.
    . ./delphi-env.sh
}

step "1/2 Check whether Free Pascal (fpc) is installed"
explain "WHY: '$FPC' compiles hello.pas, written in the Delphi dialect, into a program."
if has_cmd "$FPC"; then
    ok "Free Pascal found: version $("$FPC" -iV) ($(command -v "$FPC"))"
    exit 0
fi
warn "Free Pascal is not installed (no '$FPC' on PATH)."

step "2/2 Install Free Pascal $FPC_VERSION"
explain "WHY: each OS packages Free Pascal differently."
case "$TF_OS" in
    macos-intel|macos-arm)
        install_fpc_official_macos ;;
    linux)
        install_pkg "Free Pascal" sudo apt-get install -y fpc || exit 1 ;;
    windows)
        fail "Install Free Pascal $FPC_VERSION from https://sourceforge.net/projects/freepascal/files/Win32/3.2.2/ and retry." ;;
    *)
        fail "Unknown OS. See https://sourceforge.net/projects/freepascal/files/" ;;
esac

has_cmd "$FPC" || fail "'$FPC' is still not on PATH. Open a new terminal and retry."
ok "Free Pascal $("$FPC" -iV) is ready. Next: ./build.sh"
