#!/bin/sh
# build.sh - Pascal desktop: build the Lazarus project hello.lpi into
#            bin/hello-desktop
#
# WHAT: runs
#         lazbuild hello.lpi
#       lazbuild reads the project file hello.lpi (which units belong to
#       the project, that it needs the LCL package, where the output goes),
#       compiles the LCL if it is not compiled yet, then calls fpc to
#       compile hello.lpr and mainunit.pas and to link bin/hello-desktop.
# WHY:  a Lazarus project is more than one source file: it has a form file
#       (mainunit.lfm) and depends on the LCL, a package of a few hundred
#       units. lazbuild does for Lazarus what Maven and Cargo do for Java and
#       Rust: one command that knows the whole project. It is the same build
#       the Lazarus IDE runs from its "Run > Build" menu.
#       The first build compiles the LCL for your widgetset and takes about
#       a minute; later builds reuse it and take seconds.
#       The widgetset (which native GUI the LCL talks to) is Lazarus'
#       default for the platform: Cocoa on macOS, gtk2 on Linux, win32 on
#       Windows. Select another with LCL_WS, for example LCL_WS=qt5 ./build.sh
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.lpi is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts $FPC_DIR/bin on PATH if ./install.sh installed Free Pascal there.
# shellcheck source=fpc-env.sh
. ./fpc-env.sh
# LAZBUILD and LAZBUILD_OPTS (a lazbuild built by install.sh, or the one on PATH).
# shellcheck source=lazarus-env.sh
. ./lazarus-env.sh

step "1/2 Check Free Pascal and lazbuild"
explain "WHY: lazbuild drives the build and fpc compiles; ./install.sh checks both."
# fpc calls Apple's linker on macOS; make sure it comes from a working
# developer directory.
fix_developer_dir
require_cmd fpc "Free Pascal compiles the Pascal units."
require_cmd "$LAZBUILD" "lazbuild builds the Lazarus project."

step "2/2 Build hello.lpi"
explain "WHY: lazbuild compiles the LCL (first time only), then hello.lpr and mainunit.pas,"
explain "     and links bin/hello-desktop."
ws_opt=
[ -n "${LCL_WS:-}" ] && ws_opt=--ws=$LCL_WS
# set -x prints the exact command, so you can copy it.
set -x
# shellcheck disable=SC2086  # LAZBUILD_OPTS and ws_opt are lists of options
"$LAZBUILD" $LAZBUILD_OPTS $ws_opt hello.lpi
{ set +x; } 2>/dev/null

ok "Built bin/hello-desktop. Next: ./run.sh"
