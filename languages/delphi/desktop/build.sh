#!/bin/sh
# build.sh - Delphi-dialect desktop: build the Lazarus project hello.lpi into build/hello
#
# WHAT: runs lazbuild on hello.lpi. lazbuild compiles the LCL (the first time only),
#       then hello.lpr, and writes the program to build/hello.
# WHY:  a Lazarus project is more than one source file: it lists its units, the
#       packages it needs (LCL) and the widget set (LCLWidgetType=cocoa on macOS).
#       lazbuild reads that file, so you do not type the compiler options by hand.
#       The output goes into build/, which git ignores.
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.lpr)
#
# COMPROMISE: this is the Delphi dialect compiled by Free Pascal with the Lazarus LCL,
# not Delphi (Embarcadero, commercial, Windows). Delphi itself is NOT verified.
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows
# are documented and NOT verified for this implementation: on Linux, change the
# LCLWidgetType macro in hello.lpi from cocoa to gtk2 first (not tested).
# Source for the widget set and the project format: the Lazarus example projects
# shipped with Lazarus 4.8 (examples/pen_brush/project1.lpi) and https://www.lazarus-ide.org/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# LAZBUILD, LAZBUILD_OPTS.
# shellcheck source=lazarus-env.sh
. ./lazarus-env.sh

# On macOS, make sure the Apple compiler tools are usable (see common.sh).
fix_developer_dir

step "1/2 Check the builder"
explain "WHY: building needs lazbuild (Lazarus 4.8); ./install.sh installs it."
require_cmd "$LAZBUILD" "lazbuild builds the Lazarus project."

step "2/2 Build hello.lpi"
explain "WHY: lazbuild compiles the LCL units once, then hello.lpr with fpc in Delphi mode."
explain "     --bm=Default selects the build mode defined in hello.lpi."
mkdir -p build
# set -x prints the exact command, so you can copy it. LAZBUILD_OPTS holds the
# --lazarusdir and --pcp options (see lazarus-env.sh); it is left unquoted on purpose.
set -x
# shellcheck disable=SC2086
"$LAZBUILD" $LAZBUILD_OPTS --bm=Default hello.lpi
{ set +x; } 2>/dev/null

[ -x build/hello ] || fail "build/hello was not produced. See the messages above."
ok "Built build/hello. Next: ./run.sh"
