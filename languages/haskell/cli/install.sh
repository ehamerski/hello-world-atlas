#!/bin/sh
# install.sh - Haskell cli: check (and optionally install) GHC with GHCup
#
# WHAT: checks that ghc, the Glasgow Haskell Compiler, is installed. If it
#       is missing, shows GHCup's official install command and runs it only
#       if you answer "y". Nothing is installed silently and sudo is never
#       used: GHCup installs into ~/.ghcup.
# WHY:  Haskell is compiled ahead of time to machine code, and GHC is the
#       compiler the Haskell community uses. GHCup is the installer that
#       haskell.org recommends: it installs GHC and Cabal (the build tool
#       ../web needs) and lets you switch between GHC versions.
#       GHCup's bootstrap script is the vendor's documented installer (see
#       https://www.haskell.org/ghcup/). It is saved to a file first, so
#       you can read it before it runs.
# HOW:  ./install.sh       (run once; safe to run again)
#       GHC=/path/to/ghc ./install.sh   check another compiler command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://www.haskell.org/ghcup/
#   https://www.haskell.org/ghcup/install/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts ~/.ghcup/bin on PATH.
# shellcheck source=ghcup-env.sh
. ./ghcup-env.sh

GHC=${GHC:-ghc}

# install_ghcup - save GHCup's official bootstrap script to a file, then run it
# without questions:
#   BOOTSTRAP_HASKELL_NONINTERACTIVE=1  use the defaults: the "recommended"
#                                       GHC and Cabal versions
#   BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1  skip Stack, a second build tool
#                                       these examples do not use
# The script does not change your shell profile in this mode; ghcup-env.sh
# adds ~/.ghcup/bin to PATH for these scripts instead.
install_ghcup() {
    ghcup_script=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-haskell/bootstrap-haskell.sh
    explain "GHCup's bootstrap script (https://get-ghcup.haskell.org) is saved to a file"
    explain "first, so you can read it before it runs. It installs GHC and Cabal"
    explain "into ~/.ghcup (no sudo)."
    # --proto '=https' and --tlsv1.2 refuse plain HTTP and old TLS, as on
    # the GHCup page; -fsSL: quiet, but show errors and fail on HTTP errors.
    install_pkg "GHCup's bootstrap script (download only)" \
        curl --proto '=https' --tlsv1.2 -fsSL --create-dirs https://get-ghcup.haskell.org -o "$ghcup_script" \
        || exit 1
    explain "The script is saved in $ghcup_script; you can read it before the next step."
    install_pkg "GHC and Cabal (GHCup)" env BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
        BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 sh "$ghcup_script" || exit 1
    # ~/.ghcup/bin exists now: read ghcup-env.sh again to put it on PATH.
    . ./ghcup-env.sh
}

step "1/2 Check whether GHC is installed"
explain "WHY: '$GHC' compiles hello.hs into a program for your computer."
if has_cmd "$GHC"; then
    ok "GHC found: $("$GHC" --version) ($(command -v "$GHC"))"
    exit 0
fi
warn "GHC is not installed (no '$GHC' on PATH or in ~/.ghcup/bin)."

step "2/2 Install GHC with GHCup"
explain "WHY: GHCup is the official installer on macOS, Linux and Windows."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        # GHC uses the system C compiler and linker: the Xcode Command Line
        # Tools on macOS; on Linux, GHCup's page lists packages such as
        # build-essential, libgmp-dev and libffi-dev.
        [ "$TF_OS" = linux ] || fix_developer_dir
        install_ghcup ;;
    windows)
        explain "Run this in PowerShell (not as administrator), as shown on"
        explain "https://www.haskell.org/ghcup/ , then reopen Git Bash:"
        explain "    Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; try { & ([ScriptBlock]::Create((Invoke-WebRequest https://www.haskell.org/ghcup/sh/bootstrap-haskell.ps1 -UseBasicParsing))) -Interactive -DisableCurl } catch { Write-Error \$_ }"
        exit 1 ;;
    *)
        fail "Unknown OS. See https://www.haskell.org/ghcup/" ;;
esac

has_cmd "$GHC" || fail "'$GHC' is still not found. Open a new terminal and retry."
ok "$("$GHC" --version) is ready. Next: ./build.sh"
