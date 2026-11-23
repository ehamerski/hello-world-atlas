# shellcheck shell=sh
# qcl-env.sh - QCL cli: where QCL is, shared by install.sh, build.sh and run.sh
#              (sourced, not run: it only sets variables)
#
# WHAT: sets QCL_VERSION, QCL_URL, QCL_SHA256, QCL_PREFIX, QCL (the interpreter),
#       QCL_LIB (its library folder), and the readline folder that the build needs.
# WHY:  QCL is a quantum programming language and simulator, distributed by its author
#       as a source archive (no package manager ships it). It is built from source into
#       a folder in your home directory. Its build needs GNU readline: on macOS it is taken
#       from Homebrew, because the readline headers that come with macOS lack the
#       function that QCL calls (rl_unbind_key); on Linux it is the system readline
#       (package libreadline-dev), found under /usr.
#
# QCL_SHA256 is the SHA-256 digest of the file at QCL_URL, as it was downloaded on the
# development machine (2026-11-02). The archive's README identifies the author (Bernhard
# Oemer). The author publishes no signature, so the digest is the only check. The license
# is GPL version 2 or later (GPL-2.0-or-later), as the source file headers state.
# The interpreter prints its version as 0.6.4 (its README also says 0.6.4); the
# archive is named 0.6.7, which is the version used here.

# shellcheck disable=SC2034  # the SHA256 value is used by install.sh
QCL_VERSION=0.6.7
QCL_URL=https://tph.itp.tuwien.ac.at/~oemer/tgz/qcl-$QCL_VERSION.tgz
QCL_SHA256=0dbdbf90d951e518aa0efa822fa0a819cc3e025a6efa768f5d4227cc899d04e6
# Override with: QCL_PREFIX=/some/dir ./install.sh (and the same for build.sh and run.sh)
QCL_PREFIX=${QCL_PREFIX:-$HOME/.local/qcl-$QCL_VERSION}
QCL=$QCL_PREFIX/bin/qcl
QCL_LIB=$QCL_PREFIX/lib
# The folder that holds include/readline/readline.h and lib/ for GNU readline, used for the
# include and link paths. With Homebrew (macOS Intel, Apple Silicon) it is the prefix of the
# formula "readline"; without Homebrew it is /usr (Linux, package libreadline-dev).
# Override with: QCL_READLINE=/some/dir ./install.sh
if [ -z "${QCL_READLINE:-}" ]; then
    if command -v brew >/dev/null 2>&1; then
        QCL_READLINE=$(brew --prefix readline 2>/dev/null) || QCL_READLINE=
    fi
    QCL_READLINE=${QCL_READLINE:-/usr}
fi
export QCL_PREFIX QCL_READLINE
