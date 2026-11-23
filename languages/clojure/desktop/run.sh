#!/bin/sh
# run.sh - Clojure desktop: open the Hello World window
#
# WHAT: starts hello.core, which opens a window titled "Hello, World!" that
#       shows the text Hello, World!
# WHY:  "clojure -M -m hello.core" starts the Java Virtual Machine (JVM) and
#       calls the -main function of hello.core, which builds the window with
#       Swing on the event dispatch thread. Swing is part of the JDK, so no
#       library is added. There is no ./build.sh: Clojure compiles the source
#       to bytecode in memory when it loads it.
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

# Run from this script's folder so deps.edn is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh
# Puts the Clojure CLI that install.sh installed on PATH.
# shellcheck source=clojure-env.sh
. ./clojure-env.sh

require_cmd clojure "The Clojure CLI starts the program."

step "Open the Hello World window"
explain "WHY: Swing (part of the JDK) draws the window; 'clojure -M -m hello.core' starts it."
if is_verify "$@"; then
    explain "Self-check: the app prints the label text and closes after ~2 seconds."
    TF_VERIFY=1 clojure -M -m hello.core
else
    explain "Close the window to end the program."
    clojure -M -m hello.core
fi
