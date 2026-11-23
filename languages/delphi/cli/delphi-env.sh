# shellcheck shell=sh
# delphi-env.sh - Delphi-dialect cli: where Free Pascal is, shared by
#                 install.sh and build.sh (sourced, not run: it only sets
#                 variables and PATH)
#
# WHAT: sets FPC_VERSION, FPC_DMG_SHA256 and FPC_DIR, puts $FPC_DIR/bin on
#       PATH when it exists, and sets FPC to the compiler command.
# WHY:  the Delphi dialect is compiled here by Free Pascal (fpc), the free
#       Pascal compiler; Embarcadero Delphi is a separate product and is not
#       used here. Free Pascal 3.2.2 is the version that Lazarus 4.8
#       uses (see ../desktop/README.md). The macOS download is the official
#       installer, which is checked with its SHA-256 digest (the same release
#       page as the Pascal folder, https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/3.2.2/).
#       The digest was matched on the development machine (2026-11-01).

# shellcheck disable=SC2034  # the SHA256 value is used by install.sh
FPC_VERSION=3.2.2
FPC_DMG_SHA256=05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d
FPC_DIR=${FPC_DIR:-$HOME/.local/fpc-$FPC_VERSION}
if [ -x "$FPC_DIR/bin/fpc" ]; then
    PATH=$FPC_DIR/bin:$PATH
fi
FPC=fpc
export FPC_DIR PATH
