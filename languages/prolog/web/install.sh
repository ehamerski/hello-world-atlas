#!/bin/sh
# install.sh - Prolog web: check (and optionally install) SWI-Prolog
#
# WHAT: checks that swipl, the SWI-Prolog system, is installed. If it is
#       missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  server.pl is loaded and run by swipl, so that program must be on
#       your PATH. SWI-Prolog is a free (BSD-2 licensed), maintained Prolog
#       system for macOS, Linux and Windows. Its HTTP server libraries
#       (library(http/...)) are part of the standard installation, so,
#       unlike Flask or Scotty, nothing else is downloaded.
# HOW:  ./install.sh       (run once; safe to run again)
#       SWIPL=/path/to/swipl ./install.sh   check another swipl command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/swi-prolog
#   https://www.swi-prolog.org/build/PPA.html
#   https://www.swi-prolog.org/download/stable
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-swi-prolog-core
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-swi-prolog-packages

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=../use-msys2-swipl.sh
. ../use-msys2-swipl.sh

SWIPL=${SWIPL:-swipl}

step "1/2 Check whether SWI-Prolog is installed"
explain "WHY: '$SWIPL' loads server.pl and runs it; the HTTP libraries come with it."
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
        # MSYS2 comes with the GitHub windows-latest image. "core" is the
        # Prolog system (swipl.exe); "packages" adds the libraries such as
        # library(http/...). pacman -Sy refreshes the package lists first; -S
        # --needed skips what is installed. The login shell (-l) sets MSYS2 up
        # for pacman. use-msys2-swipl.sh puts C:\msys64\ucrt64\bin on PATH.
        # Without MSYS2, use the installer on
        # https://www.swi-prolog.org/download/stable
        [ -x /c/msys64/usr/bin/bash.exe ] \
            || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ or use the SWI-Prolog installer."
        install_pkg "SWI-Prolog (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
            "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-swi-prolog-core mingw-w64-ucrt-x86_64-swi-prolog-packages" || exit 1 ;;
    *)
        fail "Unknown OS. See https://www.swi-prolog.org/download/stable" ;;
esac

has_cmd "$SWIPL" || fail "'$SWIPL' is still not on PATH. Open a new terminal and retry."
ok "$("$SWIPL" --version) is ready. Next: ./run.sh"
