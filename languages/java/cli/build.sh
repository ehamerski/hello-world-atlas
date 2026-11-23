#!/bin/sh
# build.sh - Java cli: compile the program into target/hello-cli.jar
#
# WHAT: runs "mvn package". Maven compiles src/main/java/**/*.java into
#       .class files (bytecode) in target/classes, then packs them into
#       target/hello-cli.jar together with a manifest naming the main class.
# WHY:  the JVM does not run .java source files; it runs bytecode. javac (the
#       Java compiler, called by Maven) translates the source to bytecode
#       first. Unlike C, the result is not machine code for your CPU: the same
#       .jar runs on every operating system that has a JVM 21 or newer.
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
explain "WHY: 'mvn package' runs Maven's lifecycle phases in order: compile the code,"
explain "     run the tests (there are none here), then package target/hello-cli.jar."
explain "     --batch-mode: plain output, no colors or questions; --quiet: only errors."
explain "     The first build downloads Maven's plugins into ~/.m2 and takes longer."
mvn --batch-mode --quiet package

ok "Built target/hello-cli.jar. Next: ./run.sh"
