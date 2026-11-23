# shellcheck shell=sh
# cim-env.sh - Simula cli: where GNU Cim is, shared by install.sh and
#              build.sh (sourced, not run: it only sets variables)
#
# WHAT: sets CIM_VERSION, CIM_SHA256, CIM_URL, CIM_PREFIX and CIM (the
#       compiler program, $CIM_PREFIX/bin/cim).
# WHY:  GNU Cim is a Simula 67 compiler that translates Simula to C and
#       then calls the C compiler (see README.md, "Why this toolchain").
#       It is GNU software under GPL-2.0, so its source tarball is on
#       the GNU server, and install.sh builds it on your computer into a
#       folder in your home directory (no sudo needed).
#
# CIM_SHA256 is the SHA-256 digest of cim-5.1.tar.gz from
# https://ftp.gnu.org/gnu/cim/ . The file downloaded on the development
# machine (2026-11-02) had this digest. Its GPG signature is also good with the
# maintainer's key in the GNU keyring (https://ftp.gnu.org/gnu/gnu-keyring.gpg).

# shellcheck disable=SC2034  # the SHA256 value is used by install.sh
CIM_VERSION=5.1
CIM_SHA256=b90717b66ec400503bdd69e537e8b7f3e8a9d106c3ba9a08a04ae57369a069a9
CIM_URL=https://ftp.gnu.org/gnu/cim/cim-$CIM_VERSION.tar.gz
# Override with: CIM_PREFIX=/some/dir ./install.sh (and the same for build.sh)
CIM_PREFIX=${CIM_PREFIX:-$HOME/.local/cim-$CIM_VERSION}
CIM=$CIM_PREFIX/bin/cim
export CIM_PREFIX
