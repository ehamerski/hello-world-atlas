# shellcheck shell=sh
# lazarus-env.sh - Delphi-dialect desktop: where Free Pascal and Lazarus are,
#                  shared by install.sh, build.sh and run.sh (sourced, not run:
#                  it only sets variables and PATH)
#
# WHAT: sets FPC_VERSION, FPC_DMG_SHA256, FPC_DIR, LAZARUS_VERSION,
#       LAZARUS_SHA256, LAZARUS_DIR, LAZBUILD and LAZBUILD_OPTS (the options
#       that tell lazbuild where Lazarus and its settings are).
# WHY:  the Delphi-dialect desktop program is a Lazarus project (hello.lpi)
#       built by lazbuild, which calls Free Pascal (fpc). Lazarus is the
#       free, Delphi-like IDE and component library (LCL) for Free Pascal.
#       Lazarus 4.8 is built from its official source archive, with
#       "make lazbuild", into $LAZARUS_DIR (no sudo). Its "config" folder
#       knows where fpc is, and --pcp points lazbuild at that folder.
#
# LAZARUS_SHA256 is the SHA-256 digest of lazarus-4.8-0.tar.gz from SourceForge
# (Lazarus Zip _ GZip / Lazarus 4.8). FPC_DMG_SHA256 is the digest of the
# Free Pascal 3.2.2 macOS installer (see ../cli/delphi-env.sh). Both digests
# matched the files downloaded on the development machine (2026-11-01).
# Sources: https://www.lazarus-ide.org/ (Lazarus 4.8 with Free Pascal 3.2.2),
# https://www.lazarus-ide.org/index.php?page=downloads, and the Free Pascal
# download page https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/3.2.2/.

# shellcheck disable=SC2034  # the SHA256 values are used by install.sh
FPC_VERSION=3.2.2
FPC_DMG_SHA256=05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d
FPC_DIR=${FPC_DIR:-$HOME/.local/fpc-$FPC_VERSION}
if [ -x "$FPC_DIR/bin/fpc" ]; then
    PATH=$FPC_DIR/bin:$PATH
fi
FPC=fpc

LAZARUS_VERSION=4.8
LAZARUS_SHA256=6b4c9ec94fe79fe4e58027dd7bf10d9b6c35c9cb2f91db5930b7580b4a201a99
# Override with: LAZARUS_DIR=/some/dir ./install.sh (and the same for build.sh)
LAZARUS_DIR=${LAZARUS_DIR:-$HOME/.local/lazarus-$LAZARUS_VERSION}
if [ -x "$LAZARUS_DIR/lazbuild" ]; then
    LAZBUILD=$LAZARUS_DIR/lazbuild
    LAZBUILD_OPTS="--lazarusdir=$LAZARUS_DIR --pcp=$LAZARUS_DIR/config"
else
    LAZBUILD=lazbuild
    LAZBUILD_OPTS=
fi
export FPC_DIR PATH LAZARUS_DIR
