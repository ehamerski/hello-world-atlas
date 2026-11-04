#!/bin/sh
# run.sh - Java desktop: open the Hello World window
#
# WHAT: starts HelloApp, which opens a window titled "Hello, World!" that
#       shows the text Hello, World!
# WHY:  the java launcher starts the JVM. JavaFX is not part of the JDK, so
#       we tell the JVM where its modules are (--module-path target/lib) and
#       which one to load (--add-modules javafx.controls). Our own code is
#       on the class path (-cp target/hello-desktop.jar).
# HOW:  ./run.sh            open the window (close it to end the program)
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once the window is shown
#                           and closes itself after about 2 seconds
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so target/ is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd java "The JVM runs this program."
[ -f target/hello-desktop.jar ] && [ -d target/lib ] \
    || fail "target/hello-desktop.jar or target/lib/ is missing. Run ./build.sh first."

step "Open the Hello World window"
explain "WHY: JavaFX draws the window. Its jars in target/lib are loaded as Java modules."
if is_verify "$@"; then
    explain "Self-check: the app prints the label text and closes after ~2 seconds."
    TF_VERIFY=1 java --module-path target/lib --add-modules javafx.controls \
        -cp target/hello-desktop.jar com.example.hello.HelloApp
else
    explain "Close the window to end the program."
    java --module-path target/lib --add-modules javafx.controls \
        -cp target/hello-desktop.jar com.example.hello.HelloApp
fi
