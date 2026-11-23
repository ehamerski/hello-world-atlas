#!/bin/sh
# run.sh - Clojure cli: run the Hello World program
#
# WHAT: runs the namespace hello.core, which prints exactly: Hello, World!
# WHY:  "clojure -M -m hello.core" starts the Java Virtual Machine (JVM)
#       with the classpath from deps.edn. -M runs clojure.main, and -m tells
#       it to load the namespace hello.core (compiling it to bytecode in
#       memory) and call its -main function. There is no ./build.sh: see
#       the README.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so deps.edn is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh
# Puts the Clojure CLI that install.sh installed on PATH.
# shellcheck source=clojure-env.sh
. ./clojure-env.sh

require_cmd clojure "The Clojure CLI starts the program."

step "Run the program"
explain "WHY: 'clojure -M -m hello.core' loads hello.core and calls its -main function."
clojure -M -m hello.core
