#!/bin/sh
# run.sh - Scala cli: run the Hello World program
#
# WHAT: runs the program, which prints exactly: Hello, World!
# WHY:  "scala run" starts the JVM and runs the class files that ./build.sh wrote
#       into build/. --classpath build tells it where the classes are, and
#       --main-class hello names the class that holds the entry point (the
#       @main method "hello" becomes the class "hello").
# HOW:  ./run.sh            run it
#       ./run.sh --verify   same as ./run.sh (a cli program already exits by
#                           itself); used by scripts/verify-all.sh
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon, Linux and Windows are documented but NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts scala on PATH when install.sh unpacked it into ~/.local.
# shellcheck source=scala-env.sh
. ./scala-env.sh

require_cmd scala "The Scala runner runs this program."
require_cmd java "The JVM runs this program."
[ -f build/hello.class ] || fail "build/hello.class is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: scala run starts the JVM and runs the main method in build/."
echo "scala run --main-class hello --classpath build"
scala run --main-class hello --classpath build
