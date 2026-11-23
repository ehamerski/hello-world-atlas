#!/bin/sh
# run.sh — Smalltalk desktop: open the Hello World window
#
# WHAT: opens a Morphic window showing "Hello, World!" using Pharo 14.
#       In verify mode, the window also prints the greeting to stdout and
#       closes after about 2 seconds.
# WHY:  Pharo evaluates hello.st inside its image, which includes Morphic.
#       The pharo-ui launcher enables the graphical event loop.
# HOW:  ./run.sh            open the window (close the Pharo window to exit)
#       ./run.sh --verify   self-check: print greeting to stdout, close after ~2 s
#
# Platforms: macOS Intel (verified on the dev machine); Linux with Xvfb
# (CI uses xvfb-run -a scripts/verify-all.sh, so verify mode has a display);
# Windows (Git Bash) with an X server should work but is NOT verified.
# Source: https://pharo.org/documentation

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# PHARO_CACHE, PHARO_HEADLESS, PHARO_UI, PHARO_IMAGE
# shellcheck source=pharo-env.sh
. ./pharo-env.sh

[ -f "$PHARO_IMAGE" ] \
    || fail "Pharo.image not found in $PHARO_CACHE. Run ./install.sh first."
[ -x "$PHARO_HEADLESS" ] \
    || fail "pharo launcher not found in $PHARO_CACHE. Run ./install.sh first."

step "Open the Hello World window"
explain "WHY: pharo-ui enables Pharo's Morphic graphical event loop."
explain "     hello.st creates a SystemWindow, adds a greeting TextMorph,"
explain "     and opens it."
[ -x "$PHARO_UI" ] \
    || fail "pharo-ui launcher not found in $PHARO_CACHE. Run ./install.sh first."
if is_verify "$@"; then
    explain "Self-check: the app prints the greeting and closes after ~2 seconds."
    TF_VERIFY=1 "$PHARO_UI" "$PHARO_IMAGE" st hello.st
else
    explain "Close the Pharo window to exit."
    "$PHARO_UI" "$PHARO_IMAGE" st hello.st
fi
