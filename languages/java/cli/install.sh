#!/bin/sh
# install.sh - Java cli: check (and optionally install) the JDK and Maven
#
# WHAT: 1. checks that a Java Development Kit (JDK) 21 or newer is installed;
#       2. checks that Apache Maven is installed.
#       If either is missing, shows the install command for your operating
#       system and runs it only if you answer "y". Nothing is installed
#       silently and sudo is never hidden.
# WHY:  Java is compiled. The JDK contains the compiler (javac) that turns
#       Hello.java into bytecode, and the java launcher that runs that
#       bytecode on the Java Virtual Machine (JVM). A JRE (runtime only) is
#       not enough. Maven is the build tool: it reads pom.xml, calls javac
#       and packs the result into a .jar file.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/cask/temurin@21
#   https://formulae.brew.sh/formula/maven
#   https://adoptium.net/installation/
#   https://maven.apache.org/install.html

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The oldest Java version this code compiles for (see <maven.compiler.release>
# in pom.xml). Java 21 is a long-term support (LTS) release.
JAVA_MIN=21

# jdk_major prints the major version of javac (e.g. 21), or fails if there is
# no working JDK. On macOS /usr/bin/javac always exists, but without a JDK it
# only prints "Unable to locate a Java Runtime" and fails, so we run it.
jdk_major() {
    javac -version 2>&1 | sed -n 's/^javac \([0-9][0-9]*\).*/\1/p' | grep .
}

step "1/2 Check whether a JDK $JAVA_MIN (or newer) is installed"
explain "WHY: javac compiles the source to bytecode; java runs it on the JVM."
if JDK=$(jdk_major) && [ "$JDK" -ge "$JAVA_MIN" ]; then
    ok "JDK found: $(javac -version 2>&1) ($(java -version 2>&1 | head -n 1))"
else
    warn "No JDK $JAVA_MIN or newer was found (javac missing or too old)."
    explain "Eclipse Temurin is the free OpenJDK build from the Eclipse Adoptium project."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            # The cask runs Adoptium's .pkg installer, which asks for your
            # macOS password because it writes to /Library/Java.
            install_pkg "Eclipse Temurin 21 (JDK)" brew install --cask temurin@21 || exit 1 ;;
        linux)
            # Debian/Ubuntu package; Debian 12 only has openjdk-17, see the README.
            install_pkg "OpenJDK 21" sudo apt-get install -y openjdk-21-jdk || exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id EclipseAdoptium.Temurin.21.JDK -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install a JDK 21 by hand: https://adoptium.net/installation/" ;;
    esac
    JDK=$(jdk_major) && [ "$JDK" -ge "$JAVA_MIN" ] \
        || fail "JDK $JAVA_MIN is still not found. Open a new terminal and retry."
fi

step "2/2 Check whether Apache Maven is installed"
explain "WHY: Maven reads pom.xml, compiles src/main/java and packages target/*.jar."
if has_cmd mvn; then
    ok "Maven found: $(mvn -v 2>&1 | head -n 1)"
    exit 0
fi
warn "Apache Maven is not installed."
case "$TF_OS" in
    macos-intel|macos-arm)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "Apache Maven" brew install maven || exit 1 ;;
    linux)
        install_pkg "Apache Maven" sudo apt-get install -y maven || exit 1 ;;
    windows)
        explain "On Windows, download the binary zip from https://maven.apache.org/download.cgi,"
        explain "unzip it and add its bin folder to PATH (https://maven.apache.org/install.html)."
        exit 1 ;;
    *)
        fail "Unknown OS. Install Maven by hand: https://maven.apache.org/install.html" ;;
esac

has_cmd mvn || fail "Maven is still not on PATH. Open a new terminal and retry."
ok "JDK and Maven are ready. Next: ./build.sh"
