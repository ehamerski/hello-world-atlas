#!/bin/sh
# install.sh - Ruby web: check Ruby and Bundler, then install Sinatra into vendor/bundle
#
# WHAT: 1. checks that a Ruby interpreter and Bundler are installed (and
#          shows how to install Ruby if not);
#       2. tells Bundler to keep the gems in vendor/bundle, a private
#          folder of this app only;
#       3. installs the pinned gems from Gemfile (Sinatra, Rackup, Puma).
#       Steps 1 and 3 download software, so they ask first.
# WHY:  Sinatra is a third-party gem, not part of Ruby. Installing it into
#       the project folder keeps it out of your system Ruby, so this app
#       cannot break (or be broken by) other projects. The Sinatra README
#       recommends Bundler for running an app with specific versions.
# HOW:  ./install.sh       (run once; safe to run again)
#       RUBY=ruby3.4 ./install.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://sinatrarb.com/
#   https://github.com/sinatra/sinatra#readme
#   https://guides.rubygems.org/command-reference/bundle-config/
#   https://www.ruby-lang.org/en/documentation/installation/
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-ruby
#   https://packages.ubuntu.com/resolute/bundler

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so Gemfile and vendor/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Ruby (and its gcc) first on PATH and picks MSYS2's make.
# shellcheck source=../use-msys2-ruby.sh
. ../use-msys2-ruby.sh

TOOL=${RUBY:-ruby}

step "1/3 Check whether Ruby and Bundler are installed"
explain "WHY: app.rb is run by the Ruby interpreter ('$TOOL'), and Bundler"
explain "     (the 'bundle' command, installed with Ruby) installs the gems."
# On Windows, Ruby counts as installed only if Bundler comes with it: the Ruby
# of the GitHub runner image has no 'bundle' on PATH, and MSYS2's Ruby has.
if has_cmd "$TOOL" && { [ "$TF_OS" != windows ] || has_cmd bundle; }; then
    ok "Ruby found: $("$TOOL" --version 2>&1 | head -n 1)"
else
    warn "Ruby is not installed (no '$TOOL' on PATH)."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Ruby" brew install ruby || exit 1 ;;
        linux)
            # ruby-full brings the headers and build tools some gems need.
            install_pkg "Ruby" sudo apt-get install -y ruby-full build-essential || exit 1 ;;
        windows)
            # MSYS2 comes with the GitHub windows-latest image and packages Ruby
            # 4.0 (with Bundler), the GCC compiler and MSYS2's make that build gems with a C
            # part. pacman -Sy refreshes the package lists; -S --needed skips what
            # is installed; the login shell (-l) sets MSYS2 up for pacman.
            # use-msys2-ruby.sh then puts C:\msys64\ucrt64\bin first on PATH.
            # Without MSYS2, install RubyInstaller (https://rubyinstaller.org/).
            [ -x /c/msys64/usr/bin/bash.exe ] \
                || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ or use RubyInstaller."
            install_pkg "Ruby (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-ruby mingw-w64-ucrt-x86_64-gcc make" || exit 1
            . ../use-msys2-ruby.sh ;;
        *)
            fail "Unknown OS. Install Ruby by hand: https://www.ruby-lang.org/en/downloads/" ;;
    esac
    has_cmd "$TOOL" || fail "Ruby is still not on PATH. Open a new terminal and retry."
fi
# Debian/Ubuntu ship Bundler as its own package, and the Ruby of the GitHub
# runner image comes without it. ruby-dev has the Ruby headers and
# build-essential the compiler, for the gems with a C part (Puma).
if ! has_cmd bundle && [ "$TF_OS" = linux ]; then
    warn "Bundler is not installed (no 'bundle' on PATH)."
    install_pkg "Bundler" sudo apt-get install -y bundler ruby-dev build-essential || exit 1
fi
has_cmd bundle || fail "Bundler ('bundle') is missing. It comes with Ruby: reinstall Ruby, or run 'gem install bundler'."
ok "Bundler found: $(bundle --version)"

step "2/3 Tell Bundler where to put the gems"
explain "WHY: 'path vendor/bundle' installs gems into this folder, not into your system Ruby."
explain "     --local saves the setting in .bundle/config here, not for every project."
bundle config set --local path vendor/bundle

step "3/3 Install Sinatra, Rackup and Puma"
explain "WHY: Gemfile pins the versions and Gemfile.lock records the exact ones Bundler chose."
explain "     Puma has a small C part, so a C compiler is needed (on macOS: the Command Line Tools)."
if bundle check >/dev/null 2>&1; then
    ok "The gems are already installed."
else
    install_pkg "the gems from Gemfile (from rubygems.org)" bundle install || exit 1
fi

ok "Sinatra $(bundle exec "$TOOL" -e 'require "sinatra/version"; print Sinatra::VERSION' 2>/dev/null || echo '?') is ready. Next: ./run.sh"
