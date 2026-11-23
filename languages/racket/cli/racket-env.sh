# shellcheck shell=sh
# racket-env.sh - Racket cli: where Racket is, shared by install.sh and run.sh
#                 (sourced, not run: it only sets variables and PATH)
#
# WHAT: sets RACKET_VERSION, RACKET_FILE, RACKET_URL, RACKET_SHA256, RACKET_PREFIX and
#       RACKET_BIN, and puts the Racket bin folder on PATH for the scripts that source it.
# WHY:  Racket is installed from the project's own tarball into a folder in your home
#       directory, so no package manager and no sudo are needed. The tarball holds one
#       folder named racket, so the programs are in $RACKET_PREFIX/racket/bin (not in
#       $RACKET_PREFIX/bin). The PATH change lasts only while a script runs; your shell
#       is not changed.
#
# RACKET_SHA256 is the SHA-256 digest that the official release page
# (https://download.racket-lang.org/releases/9.3/) shows for this file. The project
# publishes the digest on that page and no signature, so the digest is the only check.
# The file is Racket 9.3 "minimal" (Minimal Racket, which has just enough to install more
# with raco pkg), CS variant, for macOS x86_64. Racket is licensed under MIT and
# Apache-2.0 (see the README in the archive).

# shellcheck disable=SC2034  # the SHA256 and URL values are used by install.sh
RACKET_VERSION=9.3
RACKET_FILE=racket-minimal-$RACKET_VERSION-x86_64-macosx-cs.tgz
RACKET_URL=https://download.racket-lang.org/releases/$RACKET_VERSION/installers/$RACKET_FILE
RACKET_SHA256=f427944a13d53097dad58f26e62749b7883ffa4e5dd6e86dcd6224e16e57c6ae
# Override with: RACKET_PREFIX=/some/dir ./install.sh (and the same for run.sh)
RACKET_PREFIX=${RACKET_PREFIX:-$HOME/.local/racket-$RACKET_VERSION}
RACKET_BIN=$RACKET_PREFIX/racket/bin
export RACKET_PREFIX
PATH=$RACKET_BIN:$PATH
export PATH
