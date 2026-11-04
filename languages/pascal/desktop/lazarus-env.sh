# shellcheck shell=sh
# lazarus-env.sh - Pascal desktop: where Lazarus is, shared by install.sh
#                  and build.sh (sourced, not run: it only sets variables)
#
# WHAT: sets LAZARUS_VERSION, LAZARUS_SHA256 and LAZARUS_DIR, and picks the
#       lazbuild command: $LAZARUS_DIR/lazbuild if install.sh built it
#       there, otherwise "lazbuild" from PATH (installed by apt or by the
#       official Lazarus installer).
# WHY:  on Linux and Windows Lazarus comes from a package or an installer.
#       On macOS, Homebrew's Lazarus package (cask) was disabled on
#       2026-01-27, and the official macOS download of Lazarus 4.8 is
#       meant to be used with a Free Pascal 3.2.4 release candidate, while
#       this project uses the stable 3.2.2. So install.sh can build lazbuild
#       from the official Lazarus source release into LAZARUS_DIR, a folder
#       in your home directory (no sudo needed). Lazarus runs from its source
#       folder: lazbuild compiles the LCL from there the first time a
#       project needs it.
#
# LAZARUS_SHA256 was computed on the dev machine (2026-11-01) from the file
# whose MD5 matches the one SourceForge publishes for it
# (d0b3083cae4f185052698824fc457220, see the file list at
# https://sourceforge.net/projects/lazarus/files/Lazarus%20Zip%20_%20GZip/Lazarus%204.8/).

# shellcheck disable=SC2034  # LAZARUS_SHA256 is used by install.sh
LAZARUS_VERSION=4.8
LAZARUS_SHA256=6b4c9ec94fe79fe4e58027dd7bf10d9b6c35c9cb2f91db5930b7580b4a201a99
# Override with: LAZARUS_DIR=/some/dir ./install.sh (and the same for build.sh)
LAZARUS_DIR=${LAZARUS_DIR:-$HOME/.local/lazarus-$LAZARUS_VERSION}

# lazbuild keeps its settings in a "primary config path" (by default
# ~/.lazarus). A Lazarus built by install.sh gets its own, inside
# LAZARUS_DIR, so it never mixes with another Lazarus on the same computer.
if [ -x "$LAZARUS_DIR/lazbuild" ]; then
    LAZBUILD=$LAZARUS_DIR/lazbuild
    LAZBUILD_OPTS="--lazarusdir=$LAZARUS_DIR --pcp=$LAZARUS_DIR/config"
else
    LAZBUILD=lazbuild
    LAZBUILD_OPTS=
fi
export LAZARUS_DIR
