#!/bin/sh
# build.sh - Kotlin desktop: compile the program
#
# WHAT: compiles src/main/kotlin/Main.kt into JVM bytecode in build/.
# WHY:  the JVM cannot run Kotlin source directly. Gradle downloads the
#       Kotlin compiler and the Compose libraries (the first time, this
#       takes a few minutes), then runs the compiler. The Compose compiler
#       plugin also rewrites the @Composable functions on the way.
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

step "1/2 Check the build tool"
explain "WHY: building needs Gradle and a JDK; ./install.sh installs them."
require_cmd gradle "Gradle is needed to build."
require_cmd java "The JVM runs Gradle and the program."

step "2/2 Compile"
explain "WHY: the 'classes' task compiles the main source set. --no-daemon ends the"
explain "Gradle background process with the build, so nothing keeps running."
echo "gradle --no-daemon --console=plain classes"
gradle --no-daemon --console=plain classes

ok "Build finished. Next: ./run.sh"
