#!/bin/sh
# install.sh - Prolog cli: check (and optionally install) SWI-Prolog
#
# WHAT: checks that swipl, the SWI-Prolog system, is installed. If it is
#       missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  hello.pl is loaded and run by swipl, so that program must be on
#       your PATH. SWI-Prolog is a free (BSD-2 licensed), maintained Prolog
#       system for macOS, Linux and Windows. The cli version needs nothing
#       else.
# HOW:  ./install.sh       (run once; safe to run again)
#       SWIPL=/path/to/swipl ./install.sh   check another swipl command
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/swi-prolog
#   https://www.swi-prolog.org/build/PPA.html
#   https://www.swi-prolog.org/download/stable

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

SWIPL=${SWIPL:-swipl}

step "1/2 Check whether SWI-Prolog is installed"
explain "WHY: '$SWIPL' loads hello.pl and runs it."
if has_cmd "$SWIPL"; then
    # --version prints, for example, "SWI-Prolog version 10.0.2 for x86_64-darwin".
    ok "SWI-Prolog found: $("$SWIPL" --version) ($(command -v "$SWIPL"))"
    exit 0
fi
warn "SWI-Prolog is not installed (no '$SWIPL' on PATH)."

step "2/2 Install SWI-Prolog"
explain "WHY: each OS packages SWI-Prolog differently."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh). On Intel Macs Homebrew has no ready-made
        # package (bottle) for it, so it compiles SWI-Prolog from source, which
        # takes a while. The other official option is the macOS disk image
        # from https://www.swi-prolog.org/download/stable
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "SWI-Prolog" brew install swi-prolog || exit 1 ;;
    linux)
        # Ubuntu: the SWI-Prolog team's PPA has the current stable version;
        # "swi-prolog-nox" is the build without the graphical tools. Debian's
        # own package "swi-prolog-nox" works too, but may be older.
        install_pkg "SWI-Prolog" sudo apt-get install -y swi-prolog-nox || exit 1 ;;
    windows)
        explain "Download the Windows installer (swipl-<version>-1.x64.exe) from"
        explain "    https://www.swi-prolog.org/download/stable"
        explain "or run in PowerShell:  winget install SWI-Prolog.SWI-Prolog"
        explain "Select 'Add swipl to the system PATH', then reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. See https://www.swi-prolog.org/download/stable" ;;
esac

has_cmd "$SWIPL" || fail "'$SWIPL' is still not on PATH. Open a new terminal and retry."
ok "$("$SWIPL" --version) is ready. Next: ./run.sh"
