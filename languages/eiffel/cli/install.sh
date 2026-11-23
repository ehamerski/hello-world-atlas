#!/bin/sh
# install.sh - Eiffel cli: check (and optionally install) the Gobo Eiffel compiler
#
# WHAT: checks that gec, the Gobo Eiffel compiler, is on your PATH. If it is
#       missing, shows the Homebrew command and runs it only if you answer
#       "y". Nothing is installed silently and sudo is never used.
# WHY:  gec compiles Eiffel (.e files) to C and then to a native program.
#       Gobo is a free (MIT-licensed) Eiffel library and compiler project.
#       The Homebrew formula "gobo" ships a ready-built binary (a "bottle"),
#       so nothing is compiled on your computer.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified
# for this implementation.
# Sources for the install commands and the licence: the Homebrew formula
# (`brew info gobo`, licence MIT, version 26.03) and https://www.gobosoft.com/ .

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check whether the Gobo Eiffel compiler (gec) is installed"
explain "WHY: gec turns hello.e into a native program."
if has_cmd gec; then
    ok "gec found: $(command -v gec)"
    exit 0
fi
warn "gec is not on PATH."

step "2/2 Install the Gobo Eiffel compiler"
explain "WHY: gec is distributed as the Homebrew formula 'gobo' (a ready-built bottle)."
case "$TF_OS" in
    macos-intel|macos-arm)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "Gobo Eiffel (Homebrew formula gobo)" brew install gobo || exit 1 ;;
    *)
        fail "Install Gobo from https://www.gobosoft.com/ (this system is not verified for this implementation)." ;;
esac

has_cmd gec || fail "gec is still not on PATH. Open a new terminal and run ./install.sh again."
ok "Gobo Eiffel is ready. Next: ./build.sh"
