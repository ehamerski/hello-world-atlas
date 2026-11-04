#!/bin/sh
# install.sh - Pascal cli: check (and optionally install) Free Pascal
#
# WHAT: checks that fpc, the Free Pascal compiler, is installed. If it is
#       missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  Pascal is compiled ahead of time to machine code, so a Pascal
#       compiler is the only tool this program needs. Free Pascal (FPC) is
#       the maintained open-source Pascal compiler for macOS, Linux and
#       Windows. On macOS this script installs FPC's official release into
#       ~/.local/fpc-3.2.2 without sudo, because Homebrew's fpc fails to
#       build on Intel Macs (see fpc-env.sh for the details).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://sourceforge.net/projects/freepascal/files/  (official FPC releases)
#   https://packages.debian.org/stable/fpc
#   https://www.lazarus-ide.org/index.php?page=downloads

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# FPC_VERSION, FPC_DMG_SHA256, FPC_DIR; puts $FPC_DIR/bin on PATH.
# shellcheck source=fpc-env.sh
. ./fpc-env.sh

# The compiler command. Override: FPC=/path/to/fpc ./install.sh
FPC=${FPC:-fpc}

# install_fpc_official_macos - macOS: download the official FPC release
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

step "1/2 Check whether Free Pascal is installed"
explain "WHY: '$FPC' compiles hello.pas into a program for your computer."
if has_cmd "$FPC"; then
    # -iV prints only the compiler version, for example 3.2.2.
    ok "Free Pascal found: version $("$FPC" -iV) ($(command -v "$FPC"))"
    exit 0
fi
warn "Free Pascal is not installed (no '$FPC' on PATH)."

step "2/2 Install Free Pascal"
explain "WHY: each OS packages Free Pascal differently."
case "$TF_OS" in
    macos-intel|macos-arm)
        # The official release, unpacked into your home folder (see above).
        install_fpc_official_macos ;;
    linux)
        # Debian/Ubuntu package "fpc" (compiler, units and tools). It needs
        # sudo, which is shown.
        install_pkg "Free Pascal" sudo apt-get install -y fpc || exit 1 ;;
    windows)
        explain "Download the Windows installer fpc-3.2.2.win32.and.win64.exe from"
        explain "    https://sourceforge.net/projects/freepascal/files/Win32/3.2.2/"
        explain "(or install Lazarus, which includes Free Pascal), then add the folder"
        explain "that contains fpc.exe to PATH. Reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. See https://sourceforge.net/projects/freepascal/files/" ;;
esac

has_cmd "$FPC" || fail "'$FPC' is still not on PATH. Open a new terminal and retry."
ok "Free Pascal $("$FPC" -iV) is ready. Next: ./build.sh"
