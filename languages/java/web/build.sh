#!/bin/sh
# build.sh - Java web: compile the server into an executable jar
#
# WHAT: runs "mvn package". Maven downloads Spring Boot (first time only),
#       compiles src/main/java/**/*.java into bytecode, packs it into
#       target/hello-web.jar, and the Spring Boot plugin turns that jar into
#       an "executable jar" that also contains Spring and Tomcat.
# WHY:  the JVM runs bytecode, not .java source, so javac (called by Maven)
#       compiles it first. Putting every library inside one jar means
#       run.sh only needs "java -jar".
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so Maven finds pom.xml.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check the build tools"
explain "WHY: building needs the JDK (javac) and Maven; ./install.sh installs them."
require_cmd javac "The JDK compiles the code."
require_cmd mvn "Maven runs the build."

step "2/2 Compile and package with Maven"
explain "WHY: 'mvn package' compiles the code and packs target/hello-web.jar; then the"
explain "     spring-boot-maven-plugin 'repackage' step adds Spring and Tomcat to it."
explain "     The first build downloads Spring Boot and Maven's plugins into ~/.m2."
mvn --batch-mode --quiet package

ok "Built target/hello-web.jar. Next: ./run.sh"
