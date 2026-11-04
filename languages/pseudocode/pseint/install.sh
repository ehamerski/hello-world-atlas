#!/bin/sh
# install.sh - Pseudocode (PSeInt): check (and optionally install) PSeInt
#
# WHAT: checks that the PSeInt interpreter is installed. If it is missing,
#       downloads PSeInt's official release for your OS from SourceForge,
#       checks its SHA-256 checksum and unpacks it into
#       ~/.local/pseint-20250314. It asks first; nothing is installed
#       silently and sudo is never used.
# WHY:  pseudocode is normally read, not run. PSeInt is one of the few
#       pseudocode dialects with an interpreter: the "pseint" program reads
#       hola.psc and executes it. It is a teaching tool, so there is no
#       Homebrew formula or Debian package; its author publishes ready-made
#       archives that only need to be unpacked (see pseint-env.sh).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install steps:
#   https://pseint.sourceforge.net/index.php?page=descargas.php
#   https://sourceforge.net/projects/pseint/files/20250314/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# PSEINT_VERSION, PSEINT_DIR, PSEINT_PKG, PSEINT_SHA256, PSEINT.
# shellcheck source=pseint-env.sh
. ./pseint-env.sh

step "1/2 Check whether the PSeInt interpreter is installed"
explain "WHY: the 'pseint' program reads hola.psc and executes it, step by step."
if [ -n "$PSEINT" ] && [ -x "$PSEINT" ]; then
    ok "PSeInt found: $PSEINT"
    exit 0
fi
warn "PSeInt $PSEINT_VERSION is not installed (looked for it in $PSEINT_DIR)."

step "2/2 Install PSeInt $PSEINT_VERSION into $PSEINT_DIR"
explain "WHY: PSeInt is distributed as an archive to unpack, not as a package."
case "$TF_OS" in
    macos-intel|macos-arm|linux) ;;
    windows)
        # The zip holds pseint/pseint.exe (the interpreter) and
        # pseint/wxPSeInt.exe (the editor); listed on 2026-11-01.
        explain "Download the official zip pseint-w64-$PSEINT_VERSION.zip from"
        explain "    https://pseint.sourceforge.net/index.php?page=descargas.php&os=w32"
        explain "unzip it (for example into C:\\pseint-$PSEINT_VERSION), then in Git Bash:"
        explain "    PSEINT=/c/pseint-$PSEINT_VERSION/pseint/pseint.exe ./run.sh"
        exit 1 ;;
    *)
        fail "Unknown OS. See https://pseint.sourceforge.net/ for downloads." ;;
esac
require_cmd curl "curl downloads the PSeInt archive."

pseint_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-pseudocode
pseint_url="https://downloads.sourceforge.net/project/pseint/$PSEINT_VERSION/$PSEINT_PKG"
explain "Download $PSEINT_PKG (about 9 MB) from SourceForge, where PSeInt's author"
explain "publishes its releases, into $pseint_cache; check its SHA-256"
explain "checksum and unpack it into $PSEINT_DIR (no sudo)."
confirm "Install PSeInt $PSEINT_VERSION into $PSEINT_DIR now?" \
    || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

mkdir -p "$pseint_cache"
[ -f "$pseint_cache/$PSEINT_PKG" ] || curl -fL -o "$pseint_cache/$PSEINT_PKG" "$pseint_url"
# The checksum proves the file is exactly the published PSeInt release.
# shasum comes with macOS; Linux has sha256sum with the same input format.
if has_cmd shasum; then sha_check='shasum -a 256 -c -'; else sha_check='sha256sum -c -'; fi
echo "$PSEINT_SHA256  $pseint_cache/$PSEINT_PKG" | $sha_check \
    || fail "Checksum mismatch: delete $pseint_cache/$PSEINT_PKG and retry."

rm -rf "$PSEINT_DIR"
mkdir -p "$PSEINT_DIR"
# macOS archive: pseint.app/...; Linux archive: pseint/...
tar -xzf "$pseint_cache/$PSEINT_PKG" -C "$PSEINT_DIR"

# Read pseint-env.sh again: it now finds the unpacked interpreter.
PSEINT=''
. ./pseint-env.sh
[ -n "$PSEINT" ] || fail "The interpreter was not found in $PSEINT_DIR after unpacking."
ok "PSeInt is ready: $PSEINT. Next: ./run.sh"
