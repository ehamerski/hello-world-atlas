#!/bin/sh
# run.sh - Kotlin desktop: run the Hello World program
#
# WHAT: opens a window titled "Hello, World!" that shows Hello, World!
# WHY:  the Compose Gradle plugin adds a `run` task that starts the main
#       class (MainKt) on the JVM with the Compose libraries on the class
#       path. Compose then asks the operating system for a native window and
#       draws the text into it with the Skia graphics library.
# HOW:  ./run.sh            run it for yourself (close the window to end it)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints Hello, World! once its window is shown,
#                           closes itself after about 2 seconds and exits
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

require_cmd gradle "Gradle starts this program."
require_cmd java "The JVM runs this program."

step "Open the Hello World window"
explain "WHY: Compose Multiplatform draws the window; 'gradle run' starts it."
# --quiet hides Gradle's own messages, so the terminal shows only the program.
if is_verify "$@"; then
    explain "Self-check: the app prints Hello, World! and closes after about 2 seconds."
    TF_VERIFY=1 gradle --no-daemon --quiet --console=plain run
else
    explain "Close the window to end the program."
    gradle --no-daemon --quiet --console=plain run
fi
