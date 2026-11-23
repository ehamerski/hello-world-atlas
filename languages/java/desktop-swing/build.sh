#!/bin/sh
# build.sh - Java desktop-swing: compile the program
#
# WHAT: runs "mvn package". Maven compiles src/main/java/**/*.java into
#       bytecode and packs it into target/hello-swing.jar.
# WHY:  the JVM runs bytecode, not .java source, so javac (called by Maven)
#       compiles it first. Unlike ../desktop (JavaFX), there is no library
#       to download or copy: Swing is already part of the JDK.
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
explain "WHY: 'mvn package' compiles the code and packs target/hello-swing.jar."
explain "     Swing comes with the JDK, so only Maven's own plugins are downloaded"
explain "     (the first time, into ~/.m2)."
mvn --batch-mode --quiet package

ok "Built target/hello-swing.jar. Next: ./run.sh"
