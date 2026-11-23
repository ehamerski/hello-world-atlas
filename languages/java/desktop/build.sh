#!/bin/sh
# build.sh - Java desktop: compile the program and collect JavaFX
#
# WHAT: runs "mvn package". Maven downloads JavaFX (first time only),
#       compiles src/main/java/**/*.java into bytecode, packs it into
#       target/hello-desktop.jar, and copies the JavaFX jars into target/lib.
# WHY:  the JVM runs bytecode, not .java source, so javac (called by Maven)
#       compiles it first. JavaFX is a library outside the JDK, so run.sh
#       needs its jars in a known folder (target/lib).
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so Maven finds pom.xml.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh

step "1/2 Check the build tools"
explain "WHY: building needs the JDK (javac) and Maven; ./install.sh installs them."
require_cmd javac "The JDK compiles the code."
require_cmd mvn "Maven runs the build."

step "2/2 Compile and package with Maven"
explain "WHY: 'mvn package' compiles the code, packs target/hello-desktop.jar and,"
explain "     in the same phase, copies the JavaFX jars for your OS into target/lib."
explain "     The first build downloads JavaFX and Maven's plugins into ~/.m2."
mvn --batch-mode --quiet package

ok "Built target/hello-desktop.jar and target/lib/. Next: ./run.sh"
