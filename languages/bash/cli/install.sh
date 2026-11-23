#!/bin/sh
# install.sh - Bash cli: check (and optionally install) a newer Bash
#
# WHAT: checks that a bash program is on your PATH and prints its version. If the
#       Homebrew package manager is present and its GNU Bash is not installed, it
#       offers to install it with "brew install bash" and runs the command only if
#       you answer "y". Nothing is downloaded or installed silently, and sudo is
#       never used. If you say no, the script still succeeds when a bash exists.
# WHY:  hello.sh is run by Bash, so bash must be on your PATH. On the development
#       Mac, /bin/bash is Bash 3.2.57 (observed with "/bin/bash --version"),
#       which is enough for this program. The Homebrew formula "bash" installs
#       GNU Bash 5.3.20. The newer one is optional here.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources: https://www.gnu.org/software/bash/ and https://formulae.brew.sh/formula/bash

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check whether Bash is installed"
explain "WHY: hello.sh is run by Bash ('bash hello.sh')."
has_cmd bash || fail "No bash found on PATH. Install it from https://www.gnu.org/software/bash/ (macOS and Linux have it by default)."
# "bash --version" prints the version on its first line.
ok "Bash found: $(bash --version 2>&1 | head -n 1)"
if [ -x /bin/bash ]; then
    explain "The system Bash in /bin/bash is: $(/bin/bash --version 2>&1 | head -n 1)"
fi

step "2/2 Optional: GNU Bash from Homebrew"
explain "WHY: on the development Mac /bin/bash is 3.2.57; the Homebrew formula bash is 5.3.20."
explain "     hello.sh runs the same on both, so this step is optional."
case "$TF_OS" in
    macos-intel|macos-arm)
        if has_cmd brew; then
            brew_bash="$(brew --prefix)/bin/bash"
            if [ -x "$brew_bash" ]; then
                ok "Homebrew Bash found: $("$brew_bash" --version 2>&1 | head -n 1)"
            else
                # Homebrew lists no bottle (prebuilt package) for macOS Intel, so this builds Bash from source.
                install_pkg "GNU Bash (Homebrew formula bash)" brew install bash || true
            fi
        else
            explain "Homebrew is not installed (https://brew.sh). Skipping the optional step."
        fi ;;
    *)
        explain "Your operating system packages Bash already. Skipping the optional step." ;;
esac

ok "Bash is ready. Next: ./run.sh"
