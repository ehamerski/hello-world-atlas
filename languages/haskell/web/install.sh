#!/bin/sh
# install.sh - Haskell web: check (and optionally install) GHC and Cabal with GHCup
#
# WHAT: checks that ghc, the Glasgow Haskell Compiler, and cabal, its build
#       tool, are installed. If they are missing, shows GHCup's official
#       install command and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never used: GHCup installs into
#       ~/.ghcup.
# WHY:  Haskell is compiled ahead of time to machine code, and GHC is the
#       compiler the Haskell community uses. This version needs libraries
#       (Scotty and the packages it depends on), so it also needs Cabal,
#       which downloads them from Hackage and builds the package. GHCup is
#       the installer that haskell.org recommends: it installs both.
#       It is a "curl ... | sh" installer; the project's source policy allows
#       this only because it is the vendor's documented installer (see
#       https://www.haskell.org/ghcup/).
# HOW:  ./install.sh       (run once; safe to run again)
#       GHC=/path/to/ghc CABAL=/path/to/cabal ./install.sh
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://www.haskell.org/ghcup/
#   https://www.haskell.org/ghcup/install/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts ~/.ghcup/bin on PATH.
# shellcheck source=ghcup-env.sh
. ./ghcup-env.sh

GHC=${GHC:-ghc}
CABAL=${CABAL:-cabal}

# install_ghcup - run GHCup's official bootstrap script without questions:
#   BOOTSTRAP_HASKELL_NONINTERACTIVE=1  use the defaults: the "recommended"
#                                       GHC and Cabal versions
#   BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1  skip Stack, a second build tool
#                                       these examples do not use
# The script does not change your shell profile in this mode; ghcup-env.sh
# adds ~/.ghcup/bin to PATH for these scripts instead.
install_ghcup() {
    explain "This downloads GHCup's bootstrap script from https://get-ghcup.haskell.org"
    explain "and runs it. It installs GHC and Cabal into ~/.ghcup (no sudo):"
    explain "    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \\"
    explain "      | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 sh"
    confirm "Install GHC and Cabal with GHCup now?" \
        || { warn "Skipped. Run the command above yourself, then re-run this script."; exit 1; }
    # --proto '=https' and --tlsv1.2 refuse plain HTTP and old TLS, as on
    # the GHCup page; -sSf: quiet, but show errors and fail on HTTP errors.
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \
        | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 sh
    # ~/.ghcup/bin exists now: read ghcup-env.sh again to put it on PATH.
    . ./ghcup-env.sh
}

step "1/2 Check whether GHC and Cabal are installed"
explain "WHY: '$CABAL' downloads the libraries and calls '$GHC' to compile them"
explain "     and app/Main.hs."
if has_cmd "$GHC" && has_cmd "$CABAL"; then
    ok "GHC found: $("$GHC" --version) ($(command -v "$GHC"))"
    ok "Cabal found: $("$CABAL" --version | head -n 1) ($(command -v "$CABAL"))"
    exit 0
fi
warn "GHC or Cabal is not installed (not on PATH or in ~/.ghcup/bin)."

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

has_cmd "$GHC" && has_cmd "$CABAL" \
    || fail "'$GHC' or '$CABAL' is still not found. Open a new terminal and retry."
ok "$("$GHC" --version) and Cabal $("$CABAL" --numeric-version) are ready. Next: ./build.sh"
