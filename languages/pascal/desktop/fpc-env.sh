# shellcheck shell=sh
# fpc-env.sh - Pascal: where Free Pascal is, shared by install.sh and
#              build.sh (sourced, not run: it only sets variables)
#
# WHAT: sets FPC_VERSION, FPC_DMG_SHA256 and FPC_DIR, and puts
#       $FPC_DIR/bin first on PATH when install.sh installed Free Pascal
#       there.
# WHY:  on Linux and Windows Free Pascal comes from a package or an
#       installer. On macOS, Homebrew's fpc formula has no ready-made
#       package for Intel Macs, and building it from source failed on the
#       dev machine (2026-11-01): Apple's current assembler rejects code
#       that FPC 3.2.2 generates while it compiles its own library
#       ("non-private labels cannot appear between .cfi_startproc /
#       .cfi_endproc pairs"). FPC's official macOS release is already
#       compiled, so install.sh unpacks it into FPC_DIR, a folder in your
#       home directory (no sudo needed). fpc then finds its settings file,
#       $FPC_DIR/etc/fpc.cfg, by itself.
#
# FPC_DMG_SHA256 matches both checks made on the dev machine (2026-11-01):
# the MD5 that SourceForge publishes for the file
# (50babbde74790a5b86bc63c1fa3250d0, see
# https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/3.2.2/)
# and the SHA-256 that Homebrew's fpc formula pins for the same file.
# This file is the same in ../cli and ../desktop, so each folder stays
# independent.

# shellcheck disable=SC2034  # FPC_DMG_SHA256 is used by install.sh
FPC_VERSION=3.2.2
FPC_DMG_SHA256=05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d
# Override with: FPC_DIR=/some/dir ./install.sh (and the same for build.sh)
FPC_DIR=${FPC_DIR:-$HOME/.local/fpc-$FPC_VERSION}
if [ -x "$FPC_DIR/bin/fpc" ]; then
    PATH=$FPC_DIR/bin:$PATH
fi
export FPC_DIR PATH
