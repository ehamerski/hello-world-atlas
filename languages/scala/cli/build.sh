#!/bin/sh
# build.sh - Scala cli: compile the program
#
# WHAT: turns hello.scala into class files (JVM bytecode) in build/.
# WHY:  the JVM cannot run Scala source directly; the compiler scalac
#       translates it into bytecode first, the same kind of bytecode that javac
#       produces for Java. scalac -d needs an existing folder, so this script
#       creates build/ first.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon, Linux and Windows are documented but NOT verified.
# Sources: https://docs.scala-lang.org/scala3/book/taste-hello-world.html

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts scalac on PATH when install.sh unpacked it into ~/.local.
# shellcheck source=scala-env.sh
. ./scala-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs scalac and a JDK; ./install.sh installs them."
require_cmd scalac "The Scala compiler is needed to compile."
require_cmd java "The JVM runs the compiler and the program."

step "2/2 Compile"
explain "WHY: -d build writes the class files into the folder build/."
mkdir -p build
echo "scalac -d build hello.scala"
scalac -d build hello.scala

ok "Build finished. Next: ./run.sh"
