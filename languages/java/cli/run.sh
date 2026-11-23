#!/bin/sh
# run.sh - Java cli: run the Hello World program
#
# WHAT: runs target/hello-cli.jar, which prints exactly: Hello, World!
# WHY:  "java -jar" starts the Java Virtual Machine (JVM), which loads the
#       bytecode from the jar and starts the main class named in its
#       manifest (com.example.hello.Hello). ./build.sh must run first.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so target/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh

require_cmd java "The JVM runs this program."
[ -f target/hello-cli.jar ] || fail "target/hello-cli.jar is missing. Run ./build.sh first."

step "Run the program"
explain "WHY: 'java -jar target/hello-cli.jar' starts the JVM, which runs Hello.main()."
java -jar target/hello-cli.jar
