#!/bin/sh
# install.sh - Java web-react: check (and optionally install) the toolchains
#
# WHAT: 1. checks that a Java Development Kit (JDK) 21 or newer is installed;
#       2. checks that Apache Maven is installed;
#       3. checks that Node.js (20.19+ or 22.12+) and npm are installed;
#       4. installs the front end's packages into frontend/node_modules.
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  this app has two separate parts, each with its own toolchain:
#       - backend/ is Java: the JDK compiles and runs it, Maven builds it
#         (and downloads Spring Boot during ./build.sh);
#       - frontend/ is JavaScript: Node.js runs Vite (the build tool and
#         front-end server), and npm downloads React and Vite from the npm
#         registry. Vite requires Node.js 20.19+ or 22.12+.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/cask/temurin@21
#   https://formulae.brew.sh/formula/maven
#   https://formulae.brew.sh/formula/node
#   https://adoptium.net/installation/
#   https://maven.apache.org/install.html
#   https://nodejs.org/en/download
#   https://docs.npmjs.com/cli/commands/npm-ci

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh

# The oldest Java version the backend compiles for (<java.version> in
# backend/pom.xml). Java 21 is a long-term support (LTS) release.
JAVA_MIN=21

# jdk_major prints the major version of javac (e.g. 21), or fails if there is
# no working JDK. On macOS /usr/bin/javac always exists, but without a JDK it
# only prints "Unable to locate a Java Runtime" and fails, so we run it.
jdk_major() {
    javac -version 2>&1 | sed -n 's/^javac \([0-9][0-9]*\).*/\1/p' | grep .
}

# node_ok succeeds if the installed Node.js is one Vite supports:
# 20.19 or newer in the 20.x line, or 22.12 and newer.
node_ok() {
    node -e 'const [a, b] = process.versions.node.split(".").map(Number);
             process.exit((a === 20 && b >= 19) || (a === 22 && b >= 12) || a > 22 ? 0 : 1)' \
        2>/dev/null
}

step "1/4 Check whether a JDK $JAVA_MIN (or newer) is installed"
explain "WHY: the backend is Java: javac compiles it to bytecode, java runs it on the JVM."
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

step "2/4 Check whether Apache Maven is installed"
explain "WHY: Maven reads backend/pom.xml, downloads Spring Boot and packages the API jar."
if has_cmd mvn; then
    ok "Maven found: $(mvn -v 2>&1 | head -n 1)"
else
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
fi

step "3/4 Check whether Node.js (20.19+ or 22.12+) and npm are installed"
explain "WHY: the front end is JavaScript; Node.js runs Vite, npm installs the packages."
if has_cmd node && has_cmd npm && node_ok; then
    ok "Node.js found: $(node --version), npm $(npm --version)"
else
    warn "Node.js 20.19+ / 22.12+ with npm was not found."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Node.js" brew install node || exit 1 ;;
        linux)
            explain "Debian/Ubuntu's own nodejs package may be older than Vite needs."
            explain "Install a current LTS version as shown on https://nodejs.org/en/download"
            exit 1 ;;
        windows)
            explain "On Windows run this in PowerShell, then reopen Git Bash:"
            explain "    winget install --id OpenJS.NodeJS.LTS -e"
            exit 1 ;;
        *)
            fail "Unknown OS. Install Node.js by hand: https://nodejs.org/en/download" ;;
    esac
    node_ok || fail "Node.js is still missing or too old. Open a new terminal and retry."
fi

step "4/4 Install the front end's packages into frontend/node_modules"
explain "WHY: 'npm ci' installs exactly the versions recorded in package-lock.json,"
explain "     so every student builds the front end with the same React and Vite."
if [ -x frontend/node_modules/.bin/vite ]; then
    ok "Packages found: $(cd frontend && node -p 'require("vite/package.json").version' | sed 's/^/vite /')"
else
    install_pkg "the front end's packages (React, Vite)" \
        sh -c 'cd frontend && npm ci --no-fund --no-audit' || exit 1
fi

ok "Ready. Next: ./build.sh"
