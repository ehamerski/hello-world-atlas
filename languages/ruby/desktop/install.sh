#!/bin/sh
# install.sh - Ruby desktop: check Ruby, Tcl/Tk and Bundler, then install the tk gem
#
# WHAT: 1. checks that a Ruby interpreter and Bundler are installed;
#       2. checks that the Tcl/Tk libraries are installed (Homebrew
#          "tcl-tk" on macOS);
#       3. installs the pinned tk gem (Ruby/Tk) into vendor/bundle, a
#          private folder of this app, building its C part against Tcl/Tk.
#       Steps that install software ask first. Nothing is installed
#       silently and sudo is never hidden.
# WHY:  Ruby/Tk is a gem with a C extension: it must be compiled against the
#       Tcl/Tk libraries of your computer. On macOS, Homebrew's tcl-tk is
#       used. Installing the gem into
#       vendor/bundle keeps it out of your system Ruby.
# HOW:  ./install.sh       (run once; safe to run again; the gem build takes
#                           a minute or two)
#       RUBY=ruby3.4 ./install.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://github.com/ruby/tk
#   https://github.com/ruby/tk/blob/master/README.tcltklib
#   https://formulae.brew.sh/formula/tcl-tk
#   https://bundler.io/guides/bundler_setup.html
#   https://bundler.io/man/bundle-config.1.html
#   https://packages.debian.org/stable/tk-dev
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-ruby
#   https://packages.ubuntu.com/resolute/bundler
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-tk
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-tcl

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

step "1/4 Check whether Ruby and Bundler are installed"
explain "WHY: hello.rb is run by the Ruby interpreter ('$TOOL'), and Bundler"
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
            install_pkg "Ruby" sudo apt-get install -y ruby-full build-essential || exit 1 ;;
        windows)
            # MSYS2 comes with the GitHub windows-latest image and packages Ruby
            # 4.0 (with Bundler), the GCC compiler and MSYS2's make that build gems with a C
            # part, and Tcl/Tk 8.6 (headers and libraries) for the tk gem. pacman -Sy refreshes the package lists; -S --needed skips what
            # is installed; the login shell (-l) sets MSYS2 up for pacman.
            # use-msys2-ruby.sh then puts C:\msys64\ucrt64\bin first on PATH.
            # Without MSYS2, install RubyInstaller (https://rubyinstaller.org/).
            [ -x /c/msys64/usr/bin/bash.exe ] \
                || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ or use RubyInstaller."
            install_pkg "Ruby (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-ruby mingw-w64-ucrt-x86_64-gcc make mingw-w64-ucrt-x86_64-tcl mingw-w64-ucrt-x86_64-tk" || exit 1
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

step "2/4 Check that the Tcl/Tk libraries are installed"
explain "WHY: the tk gem is a thin layer over the Tcl/Tk libraries, which draw the window."
# BUILD_FLAGS holds the options that tell the gem's build script where Tcl/Tk
# is. It stays empty when the libraries are in a standard place (Linux).
BUILD_FLAGS=''
case "$TF_OS" in
    macos-intel|macos-arm)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        # "brew --prefix tcl-tk" prints the folder of the formula even when it
        # is not installed, so check the library folder itself.
        TCLTK=$(brew --prefix tcl-tk)
        if [ ! -f "$TCLTK/lib/tclConfig.sh" ]; then
            warn "Tcl/Tk is not installed (no $TCLTK/lib/tclConfig.sh)."
            install_pkg "Tcl/Tk 9 (Homebrew tcl-tk)" brew install tcl-tk || exit 1
        fi
        # tclConfig.sh and tkConfig.sh are written by Tcl/Tk's own build and
        # say which version is installed (9.1 on the dev machine).
        TCL_VER=$(sed -n "s/^TCL_VERSION='\(.*\)'/\1/p" "$TCLTK/lib/tclConfig.sh")
        TK_VER=$(sed -n "s/^TK_VERSION='\(.*\)'/\1/p" "$TCLTK/lib/tkConfig.sh")
        ok "Tcl/Tk $TCL_VER found in $TCLTK"
        # Tcl/Tk 9 names its libraries libtcl9.1 and libtcl9tk9.1. Ruby/Tk's
        # build script wants those names, without "lib" and ".dylib".
        BUILD_FLAGS="--with-tcltk-dir=$TCLTK --with-tcl-dir=$TCLTK --with-tk-dir=$TCLTK --with-tcllib=tcl$TCL_VER --with-tklib=tcl9tk$TK_VER" ;;
    linux)
        # tk-dev brings the Tcl/Tk headers; ruby-dev the Ruby headers; build-essential the compiler.
        if [ -f /usr/include/tcl.h ] || [ -f /usr/include/tcl8.6/tcl.h ]; then
            ok "Tcl/Tk headers found"
        else
            install_pkg "Tcl/Tk headers and build tools" sudo apt-get install -y tk-dev ruby-dev build-essential || exit 1
        fi
        # Debian/Ubuntu put the headers in /usr/include/tcl8.6 and the
        # libraries in a per-architecture folder (/usr/lib/x86_64-linux-gnu),
        # where the gem's build script does not look by itself. The ruby/tk
        # README and README.tcltklib list these options.
        TCL_LIBDIR=$(dirname "$(ls /usr/lib/*/libtcl8.6.so /usr/lib/libtcl8.6.so 2>/dev/null | head -n 1)")
        BUILD_FLAGS="--with-tcltkversion=8.6 --with-tcl-include=/usr/include/tcl8.6 --with-tk-include=/usr/include/tcl8.6 --with-tcl-lib=$TCL_LIBDIR --with-tk-lib=$TCL_LIBDIR" ;;
    windows)
        # MSYS2's Tcl/Tk (installed with Ruby in step 1) lives in
        # C:/msys64/ucrt64: headers in include/, import libraries libtcl86 and
        # libtk86 in lib/. The gem's build script needs that folder and the
        # library names (without "lib" and ".dll.a").
        if [ ! -f /c/msys64/ucrt64/lib/tkConfig.sh ]; then
            warn "Tcl/Tk is not installed (no /c/msys64/ucrt64/lib/tkConfig.sh)."
            install_pkg "Tcl/Tk (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-tcl mingw-w64-ucrt-x86_64-tk" || exit 1
        fi
        ok "Tcl/Tk found in C:/msys64/ucrt64"
        BUILD_FLAGS="--with-tcltk-dir=C:/msys64/ucrt64 --with-tcllib=tcl86 --with-tklib=tk86" ;;
    *)
        fail "Unknown OS. See https://github.com/ruby/tk" ;;
esac

step "3/4 Tell Bundler where to put the gems"
explain "WHY: 'path vendor/bundle' installs gems into this folder, not into your system Ruby."
explain "     --local saves the setting in .bundle/config here, not for every project."
bundle config set --local path vendor/bundle
if [ -n "$BUILD_FLAGS" ]; then
    explain "     'build.tk' passes the Tcl/Tk location to the gem's build script."
    bundle config set --local build.tk "$BUILD_FLAGS"
fi

step "4/4 Install the tk gem"
explain "WHY: Gemfile pins tk 0.6.0 and Gemfile.lock records the exact versions."
if bundle check >/dev/null 2>&1; then
    ok "The gems are already installed."
else
    install_pkg "the tk gem (from rubygems.org, compiled here)" bundle install || exit 1
fi

# Load the gem the same way run.sh does, to prove the build worked.
TK_INFO=$(bundle exec "$TOOL" -e 'require "tk"; puts "tk gem #{Gem.loaded_specs["tk"].version}, Tcl/Tk #{Tk::TK_PATCHLEVEL}"' 2>/dev/null) \
    || fail "The tk gem does not load. See the Platform notes in README.md."
ok "$TK_INFO. Next: ./run.sh"
