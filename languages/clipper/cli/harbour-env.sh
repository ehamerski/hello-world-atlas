# shellcheck shell=sh
# harbour-env.sh - Clipper cli: where Harbour is, shared by install.sh and
#                  build.sh (sourced, not run: it only sets variables)
#
# WHAT: sets HB_VERSION, HB_SRC_SHA256 and HB_DIR, and puts $HB_DIR/bin
#       first on PATH when install.sh installed Harbour there.
# WHY:  Harbour (the open-source successor of Clipper) has no up-to-date
#       package on macOS. Homebrew's "harbour" formula still ships 3.0.0
#       (2011), is deprecated and will be disabled on 2027-01-05, and for
#       Intel Macs has a ready-made package (bottle) only for macOS Sonoma
#       (https://formulae.brew.sh/formula/harbour, checked 2026-11-01).
#       For macOS and Linux the Harbour project publishes 3.2.0, its first
#       stable release since 3.0.0, as source code only
#       (https://github.com/harbour/core/releases/tag/v3.2.0). So install.sh
#       builds that release from source and installs it into HB_DIR, a
#       folder in your home directory (no sudo needed).
#
# HB_SRC_SHA256 is the SHA-256 digest GitHub publishes for
# harbour-3.2.0.src.tar.gz on the release page above; the file downloaded
# on the development machine (2026-11-01) matched it.

# shellcheck disable=SC2034  # HB_SRC_SHA256 is used by install.sh
HB_VERSION=3.2.0
HB_SRC_SHA256=48cdab059c8b933ab033868e6cbaa33f5e09a80d42c3d7e5b8299a957ab2989e
# Override with: HB_DIR=/some/dir ./install.sh (and the same for build.sh)
HB_DIR=${HB_DIR:-$HOME/.local/harbour-$HB_VERSION}
if [ -x "$HB_DIR/bin/hbmk2" ]; then
    PATH=$HB_DIR/bin:$PATH
fi
export HB_DIR PATH
