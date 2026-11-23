#!/bin/sh
# install.sh - Ruby cli: check (and optionally install) the toolchain
#
# WHAT: checks that a Ruby interpreter is installed. If it is missing,
#       shows the install command for your operating system and runs it
#       only if you answer "y". Nothing is installed silently and sudo is
#       never hidden.
# WHY:  Ruby is interpreted: hello.rb is run by the ruby program, so that
#       program must be on your PATH. The cli version needs nothing else,
#       only the language itself.
# HOW:  ./install.sh       (run once; safe to run again)
#       RUBY=ruby3.4 ./install.sh   check another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://www.ruby-lang.org/en/documentation/installation/
#   https://formulae.brew.sh/formula/ruby
#   https://rubyinstaller.org/
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-ruby

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Ruby first on PATH once it is installed.
# shellcheck source=../use-msys2-ruby.sh
. ../use-msys2-ruby.sh

TOOL=${RUBY:-ruby}
TOOL_NAME="Ruby"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: hello.rb is run by the Ruby interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" --version 2>&1 | head -n 1)"
    exit 0
fi
warn "$TOOL_NAME is not installed (no '$TOOL' on PATH)."

step "2/2 Install $TOOL_NAME"
explain "WHY: each OS has a standard way to install Ruby; a package manager"
explain "     also keeps it up to date."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) installs command-line tools on macOS.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install ruby ;;
    linux)
        # Debian/Ubuntu shown; other distributions have their own packages.
        install_pkg "$TOOL_NAME" sudo apt-get install -y ruby-full ;;
    windows)
        # MSYS2 comes with the GitHub windows-latest image and packages Ruby 4.0;
        # see ../use-msys2-ruby.sh. pacman -Sy refreshes the package lists; -S
        # --needed skips what is installed; the login shell (-l) sets MSYS2 up
        # for pacman. Without MSYS2, RubyInstaller is the installer the Ruby
        # project lists for Windows: https://rubyinstaller.org/
        [ -x /c/msys64/usr/bin/bash.exe ] \
            || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ or use RubyInstaller."
        install_pkg "$TOOL_NAME (MSYS2 package)" /c/msys64/usr/bin/bash.exe -lc \
            "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-ruby" || exit 1
        . ../use-msys2-ruby.sh ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://www.ruby-lang.org/en/downloads/" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
