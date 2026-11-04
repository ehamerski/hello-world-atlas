# shellcheck shell=sh
# ghcup-env.sh - sourced by install.sh, build.sh and run.sh (not run on its own)
#
# WHAT: puts GHCup's bin folder on PATH for this script only.
# WHY:  GHCup, the official Haskell installer, installs ghc, cabal and ghcup
#       itself into ~/.ghcup/bin, in your home folder, so no sudo is needed.
#       install.sh does not edit your shell profile (~/.zshrc, ~/.bashrc)
#       to add that folder to PATH, so each script adds it here. To use ghc
#       in your own terminal, run:  . ~/.ghcup/env
# Override the location with GHCUP_INSTALL_BASE_PREFIX, the same variable
# GHCup itself reads (default: your home folder).

GHCUP_BIN=${GHCUP_INSTALL_BASE_PREFIX:-$HOME}/.ghcup/bin
case ":$PATH:" in
    *":$GHCUP_BIN:"*) ;;
    *) [ -d "$GHCUP_BIN" ] && PATH="$GHCUP_BIN:$PATH" && export PATH ;;
esac
