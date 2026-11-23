#!/bin/sh
# run.sh - Kotlin cli: run the Hello World program
#
# WHAT: runs the program, which prints exactly: Hello, World!
# WHY:  "java -jar build/hello.jar" starts the Java Virtual Machine (JVM),
#       which loads the bytecode that ./build.sh wrote into the jar. Kotlin
#       has no launcher of its own for compiled programs: they run on the
#       same JVM as Java programs.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   same as ./run.sh (a cli program already exits by
#                           itself); used by scripts/verify-all.sh
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

require_cmd java "The JVM runs this program."
[ -f build/hello.jar ] || fail "build/hello.jar is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: 'java -jar' starts the JVM and runs the main function in the jar."
java -jar build/hello.jar
