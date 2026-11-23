# shellcheck shell=sh disable=SC2034  # sourced: install.sh and build.sh use these
# quicklisp-env.sh - sourced by install.sh and build.sh (not run on its own)
#
# WHAT: where Quicklisp lives, and the checksum of its installer.
# WHY:  Quicklisp, the Common Lisp library manager, is not a program on
#       PATH: it is Lisp code that SBCL loads from a folder. Its own
#       default folder is ~/quicklisp/, so install.sh uses that one.
#       install.sh does NOT add Quicklisp to your ~/.sbclrc; build.sh loads
#       $QUICKLISP_HOME/setup.lisp explicitly instead.
# Override the folder with QUICKLISP_HOME=/some/path.

QUICKLISP_HOME=${QUICKLISP_HOME:-$HOME/quicklisp}
# The installer file and its SHA-256, as published on
# https://www.quicklisp.org/beta/ (checked on 2026-11-01).
# QUICKLISP_NATIVE is the same folder written the way sbcl itself needs it
# (on Windows: C:/Users/you/quicklisp, not /c/Users/you/quicklisp).
# native_path comes from ../use-msys2-sbcl.sh, which is sourced first.
QUICKLISP_NATIVE=$(native_path "$QUICKLISP_HOME")
QUICKLISP_URL=https://beta.quicklisp.org/quicklisp.lisp
QUICKLISP_SHA256=4a7a5c2aebe0716417047854267397e24a44d0cce096127411e9ce9ccfeb2c17
