#!/bin/sh
# install.sh - R cli: check (and optionally install) R
#
# WHAT: checks that Rscript, the command that runs an R file, is installed and
#       is the version this folder pins (r-env.sh). If it is missing, shows
#       the Homebrew command and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never used.
# WHY:  run.sh starts hello.R with Rscript, which comes with R. The Homebrew
#       formula "r" (version 4.6.2) provides it. Homebrew checks the SHA-256
#       of the source archive before it builds (see r-env.sh). No bottle is
#       listed for macOS Intel, so the install compiles R from source and
#       takes several minutes. It also installs the formula's dependencies.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands: https://formulae.brew.sh/formula/r
# and https://cran.r-project.org/ (Download R)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# R_VERSION and the Homebrew bin folder on PATH.
# shellcheck source=r-env.sh
. ./r-env.sh

step "1/2 Check whether R (Rscript) is installed"
explain "WHY: run.sh needs Rscript to run hello.R."
if has_cmd Rscript; then
    # "Rscript --version" prints: Rscript (R) version 4.6.2 (2026-10-29)
    have=$(Rscript --version 2>&1 | sed -n 's/.*version \([0-9][0-9.]*\).*/\1/p')
    if [ "$have" = "$R_VERSION" ]; then
        ok "Rscript $have found: $(command -v Rscript)"
    else
        warn "Rscript $have found, but this folder pins $R_VERSION. The program should still run."
    fi
    exit 0
fi
warn "Rscript is not installed."

step "2/2 Install R"
explain "WHY: Homebrew is the package manager this folder uses on macOS and Linux."
explain "     It downloads the source archive, checks its SHA-256 ($R_SOURCE_SHA256),"
explain "     and builds it. The build takes several minutes on macOS Intel."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "R $R_VERSION (Homebrew formula r)" brew install r || exit 1 ;;
    *)
        fail "Install R by hand: https://cran.r-project.org/ (this system is not verified for this implementation)." ;;
esac

# Homebrew may have put Rscript in a folder the env file did not know yet.
# shellcheck source=r-env.sh
. ./r-env.sh
has_cmd Rscript || fail "Rscript is still not on PATH. Open a new terminal and run ./install.sh again."
ok "R is ready. Next: ./run.sh"
