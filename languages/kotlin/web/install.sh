#!/bin/sh
# install.sh - Kotlin web: check (and optionally install) the JDK and Gradle
#
# WHAT: 1. checks that a Java Development Kit (JDK) 21 or newer is installed;
#       2. checks that Gradle is installed.
#       If either is missing, shows the install command for your operating
#       system and runs it only if you answer "y". Nothing is installed
#       silently and sudo is never hidden.
# WHY:  Ktor runs on the JVM, so it needs a JDK.
#       Gradle is the build tool: it reads build.gradle.kts, downloads the
#       Kotlin compiler, the Ktor plugin and the Ktor libraries, and
#       compiles and packs the program. This repository does not commit the
#       Gradle wrapper (a jar and scripts that download Gradle), so Gradle
#       is installed once on your computer instead.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/cask/temurin@21
#   https://formulae.brew.sh/formula/gradle
#   https://docs.gradle.org/current/userguide/installation.html
#   https://adoptium.net/installation/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh

# The oldest JDK this project is tested with. Java 21 is a long-term
# support (LTS) release; the other Kotlin folders use the same one.
JAVA_MIN=21

# java_major prints the major version of the java launcher (for example 21),
# or fails if there is no working Java. On macOS /usr/bin/java always exists,
# but without a JDK it only prints "Unable to locate a Java Runtime".
java_major() {
    java -version 2>&1 | sed -n '1s/^[^"]*"\([0-9][0-9]*\).*/\1/p' | grep .
}

step "1/2 Check whether a JDK $JAVA_MIN (or newer) is installed"
explain "WHY: Gradle and the Ktor server both run on the JVM."
if JAVA=$(java_major) && [ "$JAVA" -ge "$JAVA_MIN" ]; then
    ok "Java found: $(java -version 2>&1 | head -n 1)"
else
    warn "No Java $JAVA_MIN or newer was found."
    explain "Eclipse Temurin is the free OpenJDK build from the Eclipse Adoptium project."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            # The cask runs Adoptium's .pkg installer, which asks for your
            # macOS password because it writes to /Library/Java.
            install_pkg "Eclipse Temurin 21 (JDK)" brew install --cask temurin@21 || exit 1 ;;
        linux)
            install_pkg "OpenJDK 21" sudo apt-get install -y openjdk-21-jdk || exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id EclipseAdoptium.Temurin.21.JDK -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install a JDK 21 by hand: https://adoptium.net/installation/" ;;
    esac
    JAVA=$(java_major) && [ "$JAVA" -ge "$JAVA_MIN" ] \
        || fail "Java $JAVA_MIN is still not found. Open a new terminal and retry."
fi

step "2/2 Check whether Gradle is installed"
explain "WHY: Gradle reads build.gradle.kts, downloads the dependencies and builds the program."
if has_cmd gradle; then
    ok "Gradle found: $(gradle --version 2>&1 | sed -n 's/^Gradle /Gradle /p' | head -n 1)"
    exit 0
fi
warn "Gradle is not installed."
case "$TF_OS" in
    macos-intel|macos-arm)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "Gradle" brew install gradle || exit 1 ;;
    linux)
        explain "Debian and Ubuntu package an old Gradle. Install a current one with SDKMAN!"
        explain "(https://sdkman.io/) or as described at"
        explain "    https://docs.gradle.org/current/userguide/installation.html"
        explain "For example, after installing SDKMAN!:  sdk install gradle"
        exit 1 ;;
    windows)
        explain "On Windows run this in PowerShell, then reopen Git Bash:"
        explain "    winget install --id Gradle.Gradle -e"
        exit 1 ;;
    *)
        fail "Unknown OS. Install Gradle by hand: https://docs.gradle.org/current/userguide/installation.html" ;;
esac

has_cmd gradle || fail "Gradle is still not on PATH. Open a new terminal and retry."
ok "Gradle is ready. Next: ./build.sh"
