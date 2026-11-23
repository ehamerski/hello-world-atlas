#!/bin/sh
# install.sh - Pascal desktop: check (and optionally install) Free Pascal
#              and Lazarus (lazbuild and the LCL)
#
# WHAT: 1. checks for fpc, the Free Pascal compiler;
#       2. checks for lazbuild, Lazarus' command-line build tool, which
#          also brings the LCL (Lazarus Component Library), the GUI library
#          the window is made with.
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  standard Pascal has no windows or graphics, so the window comes
#       from a library, the LCL. Lazarus is the IDE (editor) that ships it;
#       this project only needs lazbuild, which builds a Lazarus project
#       without opening the IDE.
#       macOS is a special case. Homebrew's Lazarus package (cask) was
#       disabled on 2026-01-27, and the official macOS download of Lazarus
#       4.8 is meant to be used with a Free Pascal 3.2.4 release candidate,
#       while this project uses the stable 3.2.2 (see README.md). So
#       on macOS this script offers to build lazbuild from the official
#       Lazarus source release instead, into ~/.local/lazarus-4.8 (see
#       lazarus-env.sh), with "make lazbuild". No sudo is needed. On the
#       dev machine "make lazbuild" took about 2 minutes (2026-11-01).
#       Free Pascal itself is installed the same way as in ../cli: from
#       its official macOS release into ~/.local/fpc-3.2.2 (fpc-env.sh).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://sourceforge.net/projects/freepascal/files/  (official FPC releases)
#   https://gitlab.com/freepascal.org/lazarus/lazarus/-/blob/main/README.md  (building from source)
#   https://packages.debian.org/stable/lazarus
#   https://www.lazarus-ide.org/index.php?page=downloads

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# confirm, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# FPC_VERSION, FPC_DMG_SHA256, FPC_DIR; puts $FPC_DIR/bin on PATH.
# shellcheck source=fpc-env.sh
. ./fpc-env.sh
# LAZARUS_VERSION, LAZARUS_SHA256, LAZARUS_DIR, LAZBUILD.
# shellcheck source=lazarus-env.sh
. ./lazarus-env.sh

FPC=${FPC:-fpc}

# install_fpc_official_macos - macOS: download FPC's official release
# (a disk image with an installer package inside), check it, and unpack the
# package's files into $FPC_DIR instead of running the installer, which
# would install into /usr/local and ask for an administrator password.
# Only tools that come with macOS are used: hdiutil opens the disk image
# and pkgutil unpacks the package.
install_fpc_official_macos() {
    fpc_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-pascal
    fpc_dmg=fpc-$FPC_VERSION.intelarm64-macosx.dmg
    fpc_url="https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/$FPC_VERSION/$fpc_dmg/download"
    explain "Download $fpc_dmg (about 270 MB; one file for Intel and Apple"
    explain "Silicon Macs) from SourceForge, where the Free Pascal team publishes its"
    explain "releases, into $fpc_cache; check its SHA-256 checksum and"
    explain "unpack it into $FPC_DIR (no sudo)."
    confirm "Install Free Pascal $FPC_VERSION into $FPC_DIR now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    mkdir -p "$fpc_cache"
    [ -f "$fpc_cache/$fpc_dmg" ] || curl -fL -o "$fpc_cache/$fpc_dmg" "$fpc_url"
    # The checksum proves the file is exactly the Free Pascal release.
    echo "$FPC_DMG_SHA256  $fpc_cache/$fpc_dmg" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $fpc_cache/$fpc_dmg and retry."

    fpc_tmp=$(mktemp -d)
    # Open the disk image read-only, without showing it in Finder.
    hdiutil attach -quiet -nobrowse -readonly -mountpoint "$fpc_tmp/dmg" "$fpc_cache/$fpc_dmg"
    # The package files are inside the installer bundle (.mpkg). --expand-full
    # also unpacks the "Payload" archive, which holds the files the installer
    # would copy to /usr/local.
    pkgutil --expand-full \
        "$fpc_tmp/dmg/fpc-$FPC_VERSION-intelarm64-macosx.mpkg/Contents/Packages/fpc-$FPC_VERSION-intelarm64-macosx.pkg" \
        "$fpc_tmp/pkg"
    hdiutil detach -quiet "$fpc_tmp/dmg"
    rm -rf "$FPC_DIR"
    mkdir -p "$FPC_DIR"
    cp -R "$fpc_tmp/pkg/Payload/usr/local/" "$FPC_DIR/"
    rm -rf "$fpc_tmp"
    # Write $FPC_DIR/etc/fpc.cfg, which tells fpc where its units are. This is
    # what the official installer's own "postinstall" script runs.
    "$FPC_DIR/lib/fpc/$FPC_VERSION/samplecfg" "$FPC_DIR/lib/fpc/$FPC_VERSION" "$FPC_DIR/etc" >/dev/null
    # Read fpc-env.sh again: it now puts $FPC_DIR/bin on PATH.
    . ./fpc-env.sh
}

# install_lazarus_windows - Windows: the official Lazarus installer includes
# Free Pascal, so one package is enough. Chocolatey's "lazarus" package runs
# that installer (Lazarus 4.0 with Free Pascal 3.2.2) silently and checks the
# SHA-256 of the download: https://community.chocolatey.org/packages/lazarus
# Chocolatey needs an administrator terminal, which a CI runner is.
install_lazarus_windows() {
    has_cmd choco || fail "Chocolatey (choco) is missing. Install it from https://chocolatey.org/install or download Lazarus from https://www.lazarus-ide.org/index.php?page=downloads"
    install_pkg "Lazarus 4.0 with Free Pascal 3.2.2" choco install -y --no-progress lazarus --version=4.0.0 || exit 1
    # Read both env files again: they now find C:\lazarus.
    . ./fpc-env.sh
    . ./lazarus-env.sh
}

# build_lazbuild_from_source - macOS: download the Lazarus source release,
# check it, unpack it into $LAZARUS_DIR and build lazbuild there.
build_lazbuild_from_source() {
    laz_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-pascal
    laz_tar=lazarus-$LAZARUS_VERSION-0.tar.gz
    laz_url="https://sourceforge.net/projects/lazarus/files/Lazarus%20Zip%20_%20GZip/Lazarus%20$LAZARUS_VERSION/$laz_tar/download"
    explain "Download $laz_tar (about 90 MB) from SourceForge, where the Lazarus team"
    explain "publishes its releases, into $laz_cache;"
    explain "check its SHA-256 checksum, unpack it into $LAZARUS_DIR and run 'make lazbuild'."
    confirm "Build lazbuild $LAZARUS_VERSION from source now (a few minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    mkdir -p "$laz_cache"
    [ -f "$laz_cache/$laz_tar" ] || curl -fL -o "$laz_cache/$laz_tar" "$laz_url"
    # The checksum proves the file is exactly the Lazarus release.
    echo "$LAZARUS_SHA256  $laz_cache/$laz_tar" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $laz_cache/$laz_tar and retry."

    # The tarball contains one folder, "lazarus/"; strip it so the files
    # land directly in LAZARUS_DIR.
    rm -rf "$LAZARUS_DIR"
    mkdir -p "$LAZARUS_DIR"
    tar -xzf "$laz_cache/$laz_tar" -C "$LAZARUS_DIR" --strip-components 1

    # "make lazbuild" compiles only the command-line tool and the packages
    # it needs, not the whole IDE. FPC's linker on macOS needs Apple's
    # tools (fix_developer_dir above).
    make -C "$LAZARUS_DIR" lazbuild FPC="$(command -v "$FPC")"
}

step "1/2 Check Free Pascal"
explain "WHY: Lazarus is written in Pascal and compiles every project with fpc."
fix_developer_dir
if has_cmd "$FPC"; then
    ok "Free Pascal found: version $("$FPC" -iV) ($(command -v "$FPC"))"
else
    case "$TF_OS" in
        macos-*)
            # The official release, unpacked into your home folder (see
            # install_fpc_official_macos above and fpc-env.sh).
            install_fpc_official_macos ;;
        linux)
            # Debian/Ubuntu package "fpc". It needs sudo, which is shown.
            install_pkg "Free Pascal" sudo apt-get install -y fpc || exit 1 ;;
        windows) install_lazarus_windows ;;
        *)       fail "Unknown OS. See https://sourceforge.net/projects/freepascal/files/" ;;
    esac
    has_cmd "$FPC" || fail "'$FPC' is still not on PATH. Open a new terminal and retry."
fi

step "2/2 Check lazbuild (Lazarus $LAZARUS_VERSION or another recent version)"
explain "WHY: lazbuild reads hello.lpi, compiles the LCL the first time, then compiles"
explain "     and links the program."
if has_cmd "$LAZBUILD"; then
    ok "lazbuild found: version $("$LAZBUILD" --version 2>/dev/null | tail -n 1) ($(command -v "$LAZBUILD"))"
else
    case "$TF_OS" in
        macos-*)
            warn "Homebrew's Lazarus package was disabled (see the comment at the top)."
            build_lazbuild_from_source ;;
        linux)
            # Debian/Ubuntu: the "lazarus" package installs the IDE, lazbuild,
            # the LCL and fpc. It needs sudo, which is shown.
            install_pkg "Lazarus" sudo apt-get install -y lazarus || exit 1 ;;
        windows) install_lazarus_windows ;;
        *)       fail "Unknown OS. See https://www.lazarus-ide.org/index.php?page=downloads" ;;
    esac
    # Read lazarus-env.sh again: it now finds $LAZARUS_DIR/lazbuild.
    . ./lazarus-env.sh
    has_cmd "$LAZBUILD" || fail "lazbuild is still not found. Open a new terminal and retry."
    ok "lazbuild found: version $("$LAZBUILD" --version 2>/dev/null | tail -n 1)"
fi

# The LCL's default widgetset on Linux is GTK 2. The "lazarus" package does
# not depend on its development files, and without them linking fails with
# "cannot find -lgtk-x11-2.0". libgtk2.0-dev is the Debian/Ubuntu package:
# https://packages.ubuntu.com/search?keywords=libgtk2.0-dev
if [ "$TF_OS" = linux ]; then
    step "Linux only: GTK 2 development files"
    explain "WHY: the LCL draws the window with GTK 2; linking needs libgtk-x11-2.0 and libgdk-x11-2.0."
    if dpkg -s libgtk2.0-dev >/dev/null 2>&1; then
        ok "libgtk2.0-dev is installed."
    else
        install_pkg "the GTK 2 development files" sudo apt-get install -y libgtk2.0-dev || exit 1
    fi
fi
ok "Ready. Next: ./build.sh"
