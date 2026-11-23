# shellcheck shell=sh disable=SC2034  # sourced: install.sh and run.sh use these
# love-env.sh - Lua desktop: which LÖVE to use, shared by install.sh and run.sh
#
# WHAT: sets the LÖVE version, the official download address, the SHA-256
#       checksum of the download, and where the program ends up (the
#       variable LOVE_BIN). It only sets variables: it is sourced, not run.
# WHY:  install.sh and run.sh must agree on these values. Keeping them in
#       one file means there is only one place to change when LÖVE is updated.
# HOW:  . ./love-env.sh        (from install.sh and run.sh)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon
# (same universal download) is documented but NOT verified; Linux is verified
# in CI; Windows is documented but NOT verified.

LOVE_VERSION=11.5
LOVE_ZIP=love-$LOVE_VERSION-macos.zip
LOVE_URL=https://github.com/love2d/love/releases/download/$LOVE_VERSION/$LOVE_ZIP
# SHA-256 of the zip. The LÖVE release page publishes no checksum, so this
# value was checked against a second source: the Homebrew cask "love" lists
# the same hash for this file (https://formulae.brew.sh/cask/love).
LOVE_ZIP_SHA256=6795bb3a1656af6a2fdfe741e150787b481886d3a280327a261a3fdded586913
# The download goes into vendor/ (ignored by git), never next to the source.
LOVE_DIR=vendor

# On macOS the program is inside the app bundle that the zip contains.
# On Windows it is "lovec.exe" in the folder of the official 64-bit zip. It
# is the console build of LÖVE (love.exe is the same program without a
# console, so its output, such as the "Hello, World!" of --verify, is lost).
# Elsewhere "love" comes from the system package (see install.sh).
case "$(uname -s)" in
    Darwin) LOVE_BIN=${LOVE:-$LOVE_DIR/love.app/Contents/MacOS/love} ;;
    MINGW*|MSYS*|CYGWIN*)
        LOVE_WIN_DIR=love-$LOVE_VERSION-win64
        LOVE_WIN_ZIP=$LOVE_WIN_DIR.zip
        LOVE_WIN_URL=https://github.com/love2d/love/releases/download/$LOVE_VERSION/$LOVE_WIN_ZIP
        # SHA-256 of the Windows zip, computed from the download and equal to
        # the hash in the Scoop manifest "love" of the Extras bucket
        # (https://github.com/ScoopInstaller/Extras/blob/master/bucket/love.json).
        LOVE_WIN_SHA256=ba6e56be2685e53c817749c4a5007f51137136fe5a3ab64920508babc2e74369
        LOVE_BIN=${LOVE:-$LOVE_DIR/$LOVE_WIN_DIR/lovec.exe} ;;
    *)      LOVE_BIN=${LOVE:-love} ;;
esac
