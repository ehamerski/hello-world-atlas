# shellcheck shell=sh
# r-env.sh - R cli: which R version and where it is, shared by install.sh and
#            run.sh (sourced, not run: it only sets variables)
#
# WHAT: sets R_VERSION, R_SOURCE_URL and R_SOURCE_SHA256, and puts the
#       Homebrew bin folder first on PATH when it exists.
# WHY:  the scripts must find Rscript without your shell setup. Homebrew
#       installs it in <prefix>/bin: /usr/local on macOS Intel, /opt/homebrew
#       on macOS Apple Silicon, /home/linuxbrew/.linuxbrew on Linux (brew
#       itself lives there too).
#
# R_VERSION is the version of the Homebrew formula "r" used here.
# R_SOURCE_SHA256 is the SHA-256 digest of the source archive at R_SOURCE_URL,
# as the formula lists it (version 4.6.2, checked on 2026-11-11). Homebrew
# verifies this digest before it builds. No Homebrew bottle is listed for macOS
# Intel, so Homebrew builds R from that archive. The license is
# GPL-2.0-or-later.
# Source: https://formulae.brew.sh/formula/r

# shellcheck disable=SC2034  # these variables are used by install.sh
R_VERSION=4.6.2
R_SOURCE_URL=https://cran.r-project.org/src/base/R-4/R-4.6.2.tar.gz
R_SOURCE_SHA256=c297040f6392b1dac6e5c0eb398422cfdaedf540ae2205edb9ad0d10cb10ee00
for tf_brew_bin in /usr/local/bin /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin; do
    if [ -x "$tf_brew_bin/Rscript" ] || [ -x "$tf_brew_bin/brew" ]; then
        PATH=$tf_brew_bin:$PATH
        export PATH
        break
    fi
done
