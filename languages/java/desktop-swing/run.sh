#!/bin/sh
# run.sh - Java desktop-swing: open the Hello World window
#
# WHAT: starts HelloSwing, which opens a window titled "Hello, World!" that
#       shows the text Hello, World!
# WHY:  the java launcher starts the JVM. "java -jar" reads the Main-Class
#       from the jar's manifest (set in pom.xml). No --module-path is
#       needed, unlike ../desktop: Swing is part of the JDK.
# HOW:  ./run.sh            open the window (close it to end the program)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once the window is shown
#                           and closes itself after about 2 seconds
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so target/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh

require_cmd java "The JVM runs this program."
[ -f target/hello-swing.jar ] || fail "target/hello-swing.jar is missing. Run ./build.sh first."

step "Open the Hello World window"
explain "WHY: Swing (part of the JDK) draws the window; 'java -jar' starts it."
if is_verify "$@"; then
    explain "Self-check: the app prints the label text and closes after ~2 seconds."
    TF_VERIFY=1 java -jar target/hello-swing.jar
else
    explain "Close the window to end the program."
    java -jar target/hello-swing.jar
fi
