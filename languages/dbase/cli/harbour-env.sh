# shellcheck shell=sh
# harbour-env.sh - dBASE III Plus cli: where Harbour is, shared by install.sh
#                  and build.sh (sourced, not run: it only sets variables and PATH)
#
# WHAT: sets HB_VERSION, HB_SRC_SHA256, HB_DIR, and puts $HB_DIR/bin on PATH
#       when hbmk2 is there.
# WHY:  Harbour is the free, open-source xBase compiler (Clipper-compatible, with
#       dBASE-style commands such as ? and ??). The original dBASE III Plus is
#       proprietary DOS software and cannot be run here (see README.md). Harbour
#       3.2.0 is built from its official source release into your home folder.
#
# HB_SRC_SHA256 is the SHA-256 digest of harbour-3.2.0.src.tar.gz from
# https://github.com/harbour/core/releases/tag/v3.2.0 . The file used on the
# development machine had this digest (checked 2026-11-01). Its licence is in the
# LICENSE.txt file of the source archive (the Harbour project's GPL-compatible
# licence with exceptions; see README.md).

# shellcheck disable=SC2034  # the SHA256 value is used by install.sh
HB_VERSION=3.2.0
HB_SRC_SHA256=48cdab059c8b933ab033868e6cbaa33f5e09a80d42c3d7e5b8299a957ab2989e
HB_DIR=${HB_DIR:-$HOME/.local/harbour-$HB_VERSION}
if [ -x "$HB_DIR/bin/hbmk2" ]; then
    PATH=$HB_DIR/bin:$PATH
fi
export HB_DIR PATH
