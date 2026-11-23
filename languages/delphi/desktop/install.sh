#!/bin/sh
# install.sh - Delphi-dialect desktop: check (and optionally install) Free Pascal and lazbuild
#
# WHAT: checks fpc (Free Pascal 3.2.2) and lazbuild (Lazarus 4.8). If one is
#       missing, offers to install it (see lazarus-env.sh). Nothing is installed
#       without your "y", and sudo is never used on macOS.
# WHY:  the desktop program is a Lazarus project (hello.lpi) in the Delphi
#       dialect. lazbuild compiles it with fpc, and the Lazarus Component
#       Library (LCL) draws the window. Embarcadero Delphi itself is not
#       used.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine: Lazarus 4.8 built
# from source with Free Pascal 3.2.2, Cocoa widgetset). Linux (Debian/Ubuntu
# apt packages, GTK 2) and Windows (links to the download pages) are documented and NOT verified
# for this implementation. macOS Apple Silicon and WSL are not verified.
# Sources: the Lazarus 4.8 source archive on SourceForge (checksum in
# lazarus-env.sh) and the Free Pascal macOS installer (checksum in lazarus-env.sh).

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# FPC_VERSION, FPC_DMG_SHA256, FPC_DIR, LAZARUS_VERSION, LAZARUS_SHA256,
# LAZARUS_DIR, LAZBUILD, LAZBUILD_OPTS, FPC.
# shellcheck source=lazarus-env.sh
. ./lazarus-env.sh

# install_fpc_official_macos - the official Free Pascal 3.2.2 installer for macOS,
# checked and unpacked into $FPC_DIR (no sudo). The same steps as ../cli/install.sh.
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
    hdiutil attach -quiet -nobrowse -readonly -mountpoint "$fpc_tmp/dmg" "$fpc_cache/$fpc_dmg"
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
    . ./lazarus-env.sh
}

# build_lazbuild_from_source - macOS: download the Lazarus 4.8 source archive,
# check it, unpack it into $LAZARUS_DIR and build only lazbuild (no IDE).
build_lazbuild_from_source() {
    laz_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-delphi
    laz_tar=lazarus-$LAZARUS_VERSION-0.tar.gz
    laz_url="https://sourceforge.net/projects/lazarus/files/Lazarus%20Zip%20_%20GZip/Lazarus%20$LAZARUS_VERSION/$laz_tar/download"
    explain "Download $laz_tar (about 90 MB) from SourceForge into $laz_cache,"
    explain "check its SHA-256 digest, unpack it into $LAZARUS_DIR and run 'make lazbuild'."
    explain "'make lazbuild' builds only the project builder, not the Lazarus IDE."
    confirm "Build lazbuild $LAZARUS_VERSION from source now (a few minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }
    mkdir -p "$laz_cache"
    [ -f "$laz_cache/$laz_tar" ] || curl -fL -o "$laz_cache/$laz_tar" "$laz_url"
    echo "$LAZARUS_SHA256  $laz_cache/$laz_tar" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $laz_cache/$laz_tar and retry."
    rm -rf "$LAZARUS_DIR"
    mkdir -p "$LAZARUS_DIR"
    tar -xzf "$laz_cache/$laz_tar" -C "$LAZARUS_DIR" --strip-components 1
    # FPC= tells the Lazarus makefile which fpc compiles it.
    make -C "$LAZARUS_DIR" lazbuild FPC="$(command -v "$FPC")"
}

step "1/2 Check Free Pascal (fpc $FPC_VERSION)"
explain "WHY: Lazarus is written in Pascal, and every project is compiled by fpc."
fix_developer_dir
if has_cmd "$FPC"; then
    ok "Free Pascal found: version $("$FPC" -iV) ($(command -v "$FPC"))"
else
    warn "Free Pascal is not on PATH."
    case "$TF_OS" in
        macos-*) install_fpc_official_macos ;;
        linux)   install_pkg "Free Pascal" sudo apt-get install -y fpc || exit 1 ;;
        *)       fail "Install Free Pascal from https://sourceforge.net/projects/freepascal/files/" ;;
    esac
    has_cmd "$FPC" || fail "'$FPC' is still not on PATH. Open a new terminal and retry."
fi

step "2/2 Check lazbuild (Lazarus $LAZARUS_VERSION)"
explain "WHY: lazbuild reads hello.lpi, compiles the LCL the first time, then compiles and links the program."
if has_cmd "$LAZBUILD"; then
    ok "lazbuild found: version $("$LAZBUILD" --version 2>/dev/null | tail -n 1) ($(command -v "$LAZBUILD"))"
else
    warn "lazbuild is not installed at $LAZARUS_DIR."
    case "$TF_OS" in
        macos-*) build_lazbuild_from_source ;;
        linux)   install_pkg "Lazarus" sudo apt-get install -y lazarus || exit 1 ;;
        *)       fail "Install Lazarus from https://www.lazarus-ide.org/index.php?page=downloads" ;;
    esac
    . ./lazarus-env.sh
    has_cmd "$LAZBUILD" || [ -x "$LAZBUILD" ] || fail "lazbuild is still not found. Open a new terminal and retry."
    ok "lazbuild found: version $("$LAZBUILD" --version 2>/dev/null | tail -n 1)"
fi

if [ "$TF_OS" = linux ]; then
    step "Linux only: GTK 2 development files"
    explain "WHY: the LCL draws the window with GTK 2; linking needs libgtk2.0-dev."
    if dpkg -s libgtk2.0-dev >/dev/null 2>&1; then
        ok "libgtk2.0-dev is installed."
    else
        install_pkg "the GTK 2 development files" sudo apt-get install -y libgtk2.0-dev || exit 1
    fi
fi

ok "Ready. Next: ./build.sh"
