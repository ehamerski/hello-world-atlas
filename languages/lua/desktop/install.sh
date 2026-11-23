#!/bin/sh
# install.sh - Lua desktop: check (and optionally install) LÖVE
#
# WHAT: checks that LÖVE (the "love" program) is available.
#       - macOS: downloads the official LÖVE 11.5 zip from the LÖVE GitHub
#         releases into vendor/, checks its SHA-256 checksum, and unpacks it
#         there (vendor/love.app). Nothing goes outside this folder, and no
#         sudo is needed.
#       - Windows: the same with the official 64-bit zip, unpacked into
#         vendor/love-11.5-win64/ (no administrator rights needed).
#       - Linux: shows the install command and runs it only if you answer "y".
# WHY:  main.lua is not run by the "lua" program of ../cli. LÖVE is a
#       separate program with its own copy of Lua (LuaJIT, the Lua 5.1
#       dialect) and the code for windows and graphics.
# HOW:  ./install.sh       (run once; safe to run again)
#       LOVE=/path/to/love ./install.sh   check another LÖVE program
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon
# (same universal zip) is documented but NOT verified; Linux is verified in
# CI; Windows (Git Bash / WSL) is documented but NOT verified.
# Sources for the install commands:
#   https://love2d.org/
#   https://github.com/love2d/love/releases/tag/11.5
#   https://formulae.brew.sh/cask/love
#   https://packages.debian.org/stable/love
#   https://github.com/ScoopInstaller/Extras/blob/master/bucket/love.json   (the Windows zip and its hash)
#   https://learn.microsoft.com/powershell/module/microsoft.powershell.archive/expand-archive

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so vendor/ is created here, not elsewhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# LOVE_VERSION, LOVE_ZIP, LOVE_URL, LOVE_ZIP_SHA256, LOVE_DIR, LOVE_BIN.
# shellcheck source=love-env.sh
. ./love-env.sh

# love_found - true if LOVE_BIN can be run (a path to a file, or a command).
love_found() { [ -x "$LOVE_BIN" ] || has_cmd "$LOVE_BIN"; }

# install_love_macos - download, check, and unpack the official zip.
install_love_macos() {
    explain "Download $LOVE_ZIP (about 10 MB) from the LÖVE releases on GitHub,"
    explain "check its SHA-256 checksum, and unpack it into $LOVE_DIR/ (no sudo)."
    confirm "Download LÖVE $LOVE_VERSION into $LOVE_DIR/ now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }
    has_cmd curl || fail "curl is needed to download LÖVE."

    # A download is untrusted until its checksum matches, so it goes into
    # its own new folder, away from the source code.
    mkdir -p "$LOVE_DIR"
    curl -fL -o "$LOVE_DIR/$LOVE_ZIP" "$LOVE_URL"
    # The checksum proves the file is exactly the release that was checked.
    echo "$LOVE_ZIP_SHA256  $LOVE_DIR/$LOVE_ZIP" | shasum -a 256 -c - \
        || { rm -f "$LOVE_DIR/$LOVE_ZIP"; fail "Checksum mismatch: the download was deleted. Retry, or report it."; }
    # -q: quiet. -o: replace an older copy without asking. -d: where to unpack.
    rm -rf "$LOVE_DIR/love.app"
    unzip -q -o "$LOVE_DIR/$LOVE_ZIP" -d "$LOVE_DIR"
}

# install_love_windows - download, check, and unpack the official Windows zip.
install_love_windows() {
    explain "Download $LOVE_WIN_ZIP (about 7 MB) from the LÖVE releases on GitHub,"
    explain "check its SHA-256 checksum, and unpack it into $LOVE_DIR/ (no administrator rights)."
    confirm "Download LÖVE $LOVE_VERSION into $LOVE_DIR/ now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }
    has_cmd curl || fail "curl is needed to download LÖVE."

    mkdir -p "$LOVE_DIR"
    curl -fL -o "$LOVE_DIR/$LOVE_WIN_ZIP" "$LOVE_WIN_URL"
    # Git Bash has sha256sum (not shasum).
    echo "$LOVE_WIN_SHA256  $LOVE_DIR/$LOVE_WIN_ZIP" | sha256sum -c - \
        || { rm -f "$LOVE_DIR/$LOVE_WIN_ZIP"; fail "Checksum mismatch: the download was deleted. Retry, or report it."; }
    # Git Bash has no unzip, but Windows PowerShell has Expand-Archive (it
    # needs Windows paths, which cygpath -w prints). -Force replaces an older copy.
    rm -rf "${LOVE_DIR:?}/$LOVE_WIN_DIR"
    powershell.exe -NoProfile -Command \
        "Expand-Archive -Force -LiteralPath '$(cygpath -w "$LOVE_DIR/$LOVE_WIN_ZIP")' -DestinationPath '$(cygpath -w "$LOVE_DIR")'"
}

step "1/2 Check whether LÖVE is installed"
explain "WHY: LÖVE runs main.lua and draws the window ('$LOVE_BIN')."
if love_found; then
    ok "LÖVE found: $(command -v "$LOVE_BIN" 2>/dev/null || echo "$LOVE_BIN")"
    exit 0
fi
warn "LÖVE is not installed ('$LOVE_BIN' not found)."

step "2/2 Install LÖVE $LOVE_VERSION"
explain "WHY: LÖVE is not part of Lua, and each OS packages it differently."
case "$TF_OS" in
    macos-intel|macos-arm)
        # The official zip is a universal app (Intel and Apple Silicon). The
        # app is not code-signed (see the README), so it is unpacked here
        # instead of being installed into /Applications.
        install_love_macos ;;
    linux)
        # Debian/Ubuntu package "love".
        install_pkg "LÖVE" sudo apt-get install -y love || exit 1 ;;
    windows)
        # The official 64-bit zip, unpacked into vendor/ like on macOS. Another
        # LÖVE can be used with: LOVE=/path/to/lovec.exe ./install.sh
        install_love_windows ;;
    *)
        fail "Unknown OS. Install LÖVE by hand: https://love2d.org/" ;;
esac

love_found || fail "LÖVE is still not found ('$LOVE_BIN')."
ok "LÖVE is ready. Next: ./run.sh"
