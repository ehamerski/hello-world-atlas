# shellcheck shell=sh
# algol68-env.sh - ALGOL 68 cli: which Algol 68 Genie version and where it
#                  is, shared by install.sh and run.sh
#                  (sourced, not run: it only sets variables)
#
# WHAT: sets A68G_VERSION, A68G_URL, A68G_SHA256 and A68G_DIR, and puts
#       $A68G_DIR/bin first on PATH when install.sh installed Algol 68 Genie
#       there.
# WHY:  Homebrew has an algol68g formula, but with no bottle for macOS Intel
#       (checked on 2026-11-20). The project publishes its releases as source
#       archives, so install.sh builds the pinned release into A68G_DIR, a
#       folder in your home directory (no sudo needed), and every platform
#       gets the same version. The scripts must find a68g without
#       your shell setup, so this file adds it to PATH.
#
# A68G_URL is the source archive on the project's own site
# (https://algol68genie.nl). The project publishes no checksum or signature
# for it. A68G_SHA256 is the SHA-256 digest of the archive as downloaded
# from that URL on 2026-11-12 (two separate downloads gave the same digest).
# It proves that the file you build is the file the author of this folder
# built and read, not that the project signed it.
# The licence is GPL-3.0-or-later (the COPYING file in the archive is the
# GNU GPL version 3, and the source headers say "either version 3 of the
# License, or (at your option) any later version").

# shellcheck disable=SC2034  # A68G_URL and A68G_SHA256 are used by install.sh
A68G_VERSION=3.13.4
A68G_URL=https://algol68genie.nl/algol68g-$A68G_VERSION.tar.gz
A68G_SHA256=625746ccb08e6fbfea1f526400cf21068ab2af34f6b64756ccc20e37e4d2d4f8
# Override with: A68G_DIR=/some/dir ./install.sh (and the same for run.sh)
A68G_DIR=${A68G_DIR:-$HOME/.local/algol68g-$A68G_VERSION}
if [ -x "$A68G_DIR/bin/a68g" ]; then
    PATH=$A68G_DIR/bin:$PATH
fi
export A68G_DIR PATH
