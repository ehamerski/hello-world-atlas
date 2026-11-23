#!/bin/sh
# install.sh - Scala cli: check (and optionally install) the JDK and Scala 3
#
# WHAT: 1. checks that a Java Development Kit (JDK) 17 or newer is installed;
#       2. checks that scalac, the Scala 3 compiler, is installed.
#       If either is missing, shows the install command and runs it only if
#       you answer "y". Nothing is installed silently and sudo is never hidden.
# WHY:  Scala is compiled. scalac turns hello.scala into JVM bytecode, and the
#       scala command runs it on the Java Virtual Machine (JVM). Scala 3.8 and
#       newer need JDK 17 or newer. This script unpacks the official Scala 3.10.1
#       archive from the scala/scala3 GitHub release into ~/.local (see
#       scala-env.sh), so no administrator password is needed for Scala itself.
#       It never installs a JDK on its own: it shows the command and asks.
# HOW:  ./install.sh       (run once; safe to run again)
#       TF_NONINTERACTIVE=1 ./install.sh   only checks; never asks
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon and Linux use the other official archives (checksums in scala-env.sh)
# and are documented but NOT verified. Windows is NOT verified: use the Scala
# installer from https://www.scala-lang.org/download/.
# Sources for the install commands:
#   https://github.com/scala/scala3/releases/tag/3.10.1
#   https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html
#   https://formulae.brew.sh/cask/temurin@21
#   https://adoptium.net/installation/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# SCALA_VERSION, SCALA_ASSET, SCALA_TGZ_SHA256, SCALA_DIR; puts scalac on PATH.
# shellcheck source=scala-env.sh
. ./scala-env.sh

# The oldest JDK that Scala 3.10.1 supports. Java 17 and 21 are long-term
# support (LTS) releases; the Kotlin folder of this repository uses 21.
JAVA_MIN=17

# java_major prints the major version of the java launcher (for example 21),
# or fails if there is no working Java. On macOS /usr/bin/java always exists,
# but without a JDK it only prints "Unable to locate a Java Runtime".
java_major() {
    java -version 2>&1 | sed -n '1s/^[^"]*"\([0-9][0-9]*\).*/\1/p' | grep .
}

# install_scala_tgz - download the official archive, check its SHA-256
# checksum, and unpack it into $SCALA_DIR. Only tools that come with macOS
# and Linux are used (curl, shasum or sha256sum, tar).
install_scala_tgz() {
    sc_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-scala
    sc_file=$SCALA_ASSET.tar.gz
    sc_url="https://github.com/scala/scala3/releases/download/$SCALA_VERSION/$sc_file"
    explain "Download $sc_file (about 100 MB) from the Scala 3 releases on GitHub"
    explain "into $sc_cache, check its SHA-256 checksum, and unpack it into"
    explain "$SCALA_DIR (no sudo)."
    confirm "Install Scala $SCALA_VERSION into $SCALA_DIR now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd curl || fail "curl is needed to download the compiler."
    has_cmd tar || fail "tar is needed to unpack the compiler."
    mkdir -p "$sc_cache"
    [ -f "$sc_cache/$sc_file" ] || curl -fL -o "$sc_cache/$sc_file" "$sc_url"
    # The checksum proves the file is exactly the Scala release.
    if has_cmd shasum; then
        echo "$SCALA_TGZ_SHA256  $sc_cache/$sc_file" | shasum -a 256 -c - \
            || fail "Checksum mismatch: delete $sc_cache/$sc_file and retry."
    else
        echo "$SCALA_TGZ_SHA256  $sc_cache/$sc_file" | sha256sum -c - \
            || fail "Checksum mismatch: delete $sc_cache/$sc_file and retry."
    fi

    sc_tmp=$(mktemp -d)
    tar -xzf "$sc_cache/$sc_file" -C "$sc_tmp"
    # The archive holds one folder, named like the archive, with bin/ and lib/ inside.
    rm -rf "$SCALA_DIR"
    mkdir -p "$(dirname -- "$SCALA_DIR")"
    mv "$sc_tmp/$SCALA_ASSET" "$SCALA_DIR"
    rm -rf "$sc_tmp"
    # Read scala-env.sh again: it now puts $SCALA_DIR/bin on PATH.
    . ./scala-env.sh
}

step "1/2 Check whether a JDK $JAVA_MIN (or newer) is installed"
explain "WHY: scalac and scala run on the JVM. Scala 3.8 and newer need JDK $JAVA_MIN or newer."
if JAVA=$(java_major) && [ "$JAVA" -ge "$JAVA_MIN" ]; then
    ok "Java found: $(java -version 2>&1 | head -n 1)"
else
    warn "No Java $JAVA_MIN or newer was found. This script needs your approval to install one."
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

step "2/2 Check whether the Scala compiler (scalac) is installed"
explain "WHY: scalac compiles hello.scala into class files the JVM can run."
if has_cmd scalac; then
    ok "Scala compiler found: $(scalac -version 2>&1 | head -n 1)"
    exit 0
fi
warn "scalac is not installed."
if [ -z "$SCALA_ASSET" ]; then
    fail "No Scala archive is listed for this system. Use the Scala installer: https://www.scala-lang.org/download/"
fi
install_scala_tgz

has_cmd scalac || fail "scalac is still not on PATH. Open a new terminal and retry."
ok "Scala compiler $(scalac -version 2>&1 | head -n 1) is ready. Next: ./build.sh"
