#!/bin/sh
# install.sh - Common Lisp cli: check (and optionally install) SBCL
#
# WHAT: checks that sbcl, Steel Bank Common Lisp, is installed. If it is
#       missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  SBCL is a free, maintained Common Lisp implementation that compiles
#       every function to machine code. build.sh uses it to load hello.lisp
#       and save a standalone executable. The cli version needs nothing else.
# HOW:  ./install.sh       (run once; safe to run again)
#       SBCL=/path/to/sbcl ./install.sh   check another sbcl command
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/sbcl
#   https://www.sbcl.org/platform-table.html
#   https://www.sbcl.org/getting.html

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

SBCL=${SBCL:-sbcl}

step "1/2 Check whether SBCL is installed"
explain "WHY: '$SBCL' compiles hello.lisp and saves it as an executable."
if has_cmd "$SBCL"; then
    # --version prints, for example, "SBCL 2.6.10".
    ok "SBCL found: $("$SBCL" --version) ($(command -v "$SBCL"))"
    exit 0
fi
warn "SBCL is not installed (no '$SBCL' on PATH)."

step "2/2 Install SBCL"
explain "WHY: each OS packages SBCL differently."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh). On Intel Macs Homebrew has no ready-made
        # package (bottle) for SBCL, so it compiles it from source; SBCL is
        # written in Lisp, so Homebrew first installs ECL, another Common
        # Lisp, to compile it with.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "SBCL" brew install sbcl || exit 1 ;;
    linux)
        # Debian/Ubuntu package "sbcl" (may be older than sbcl.org's
        # release; binaries for other systems are on sbcl.org).
        install_pkg "SBCL" sudo apt-get install -y sbcl || exit 1 ;;
    windows)
        explain "Download the Windows installer (.msi) from"
        explain "    https://www.sbcl.org/platform-table.html"
        explain "then add the SBCL folder to PATH and reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. See https://www.sbcl.org/platform-table.html" ;;
esac

has_cmd "$SBCL" || fail "'$SBCL' is still not on PATH. Open a new terminal and retry."
ok "$("$SBCL" --version) is ready. Next: ./build.sh"
