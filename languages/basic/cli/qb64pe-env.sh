# shellcheck shell=sh
# qb64pe-env.sh - BASIC cli: where QB64 Phoenix Edition is, shared by
#                 install.sh and build.sh (sourced, not run: it only sets
#                 variables)
#
# WHAT: sets QB64PE_VERSION, QB64PE_SHA256 and QB64PE_DIR, and picks the
#       qb64pe command: $QB64PE_DIR/qb64pe if install.sh built it there,
#       otherwise "qb64pe" from PATH.
# WHY:  QB64 Phoenix Edition (QB64-PE) is not in Homebrew or in the
#       Debian/Ubuntu archives. Its official macOS download is a source
#       package that you compile on your own Mac with Apple's compiler
#       (https://github.com/QB64-Phoenix-Edition/QB64pe#macos). QB64-PE
#       must stay in the folder where it was built, because it compiles
#       your program with the C++ files in its internal/ subfolder. So
#       install.sh unpacks and builds it in QB64PE_DIR, a folder in your
#       home directory (no sudo needed).
#
# QB64PE_SHA256 is the SHA-256 digest GitHub publishes for
# qb64pe_osx-4.7.0-GLFW.tar.gz on
# https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v4.7.0-GLFW;
# the file downloaded on the development machine (2026-11-01) matched it.

# shellcheck disable=SC2034  # QB64PE_SHA256 is used by install.sh
QB64PE_VERSION=4.7.0
QB64PE_SHA256=270f4b11df2d88b476a34b0f3d942ce7d06913333eec9912fc29f3a4ba50a6f3
# Override with: QB64PE_DIR=/some/dir ./install.sh (and the same for build.sh)
QB64PE_DIR=${QB64PE_DIR:-$HOME/.local/qb64pe-$QB64PE_VERSION}
if [ -x "$QB64PE_DIR/qb64pe" ]; then
    QB64PE=$QB64PE_DIR/qb64pe
else
    QB64PE=qb64pe
fi
export QB64PE_DIR
