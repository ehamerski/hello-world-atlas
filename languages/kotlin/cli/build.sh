#!/bin/sh
# build.sh - Kotlin cli: compile the program
#
# WHAT: turns hello.kt into the runnable jar build/hello.jar.
# WHY:  the JVM cannot run Kotlin source directly; the compiler kotlinc
#       translates it into JVM bytecode first, the same kind of bytecode that
#       javac produces for Java. The Kotlin standard library is not part of
#       the JDK, so the jar also carries a copy of it.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

set -eu
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh
# Puts kotlinc on PATH when install.sh unpacked it into ~/.local.
# shellcheck source=kotlinc-env.sh
. ./kotlinc-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs kotlinc; ./install.sh installs it."
require_cmd kotlinc "The Kotlin compiler is needed to compile."
require_cmd java "The JVM runs the compiler and the program."

step "2/2 Compile"
explain "WHY: -d build/hello.jar writes the result into a jar file, and"
explain "-include-runtime copies the Kotlin runtime library into it, so that"
explain "'java -jar' can run it alone (kotlinc documents both flags)."
mkdir -p build
echo "kotlinc hello.kt -include-runtime -d build/hello.jar"
kotlinc hello.kt -include-runtime -d build/hello.jar

ok "Build finished. Next: ./run.sh"
