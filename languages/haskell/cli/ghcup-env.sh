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

# Why an if/for and not "[ -d ... ] && PATH=...": the scripts run with
# "set -e", and a "[ -d ]" that fails on its own (the folder does not exist
# yet) would make this "." (source) command return 1 and stop the script
# silently. The final "return 0" keeps that from happening.
#
# Folders added to the front of PATH, so the LAST one in the list wins:
#   - GHCup's own folder, ~/.ghcup/bin (macOS, Linux, a GHCup you installed);
#   - on the GitHub Actions Windows image, GHCup is preinstalled in
#      C:\ghcup\bin and Cabal in C:\cabal\bin, but Git Bash does not always
#      have them on PATH. Source: "Installed software" of the image,
#      https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md
for GHCUP_BIN in \
    /c/cabal/bin /c/ghcup/bin \
    "${GHCUP_INSTALL_BASE_PREFIX:-$HOME}/.ghcup/bin"
do
    [ -d "$GHCUP_BIN" ] || continue
    case ":$PATH:" in
        *":$GHCUP_BIN:"*) ;;
        *) PATH="$GHCUP_BIN:$PATH" ;;
    esac
done
export PATH
unset GHCUP_BIN
return 0
