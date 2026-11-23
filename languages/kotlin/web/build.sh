#!/bin/sh
# build.sh - Kotlin web: compile and package the server
#
# WHAT: compiles src/main/kotlin/Main.kt and packs the program together with
#       Ktor, Netty and every other library into one executable jar,
#       build/libs/hello-web-all.jar (a "fat jar").
# WHY:  the JVM cannot run Kotlin source directly. Gradle downloads the
#       Kotlin compiler and the Ktor libraries (the first time, this takes
#       a few minutes), compiles the code, and the Ktor Gradle plugin's
#       buildFatJar task builds a jar that runs alone with "java -jar".
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

step "2/2 Compile and package"
explain "WHY: buildFatJar compiles the code and packs it with its libraries."
explain "--no-daemon ends the Gradle background process with the build."
echo "gradle --no-daemon --console=plain buildFatJar"
gradle --no-daemon --console=plain buildFatJar

ok "Build finished. Next: ./run.sh"
