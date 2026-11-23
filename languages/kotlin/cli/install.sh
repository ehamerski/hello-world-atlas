#!/bin/sh
# install.sh - Kotlin cli: check (and optionally install) the JDK and kotlinc
#
# WHAT: 1. checks that a Java Development Kit (JDK) 21 or newer is installed;
#       2. checks that kotlinc, the Kotlin compiler, is installed.
#       If either is missing, shows the install command for your operating
#       system and runs it only if you answer "y". Nothing is installed
#       silently and sudo is never hidden.
# WHY:  Kotlin is compiled. kotlinc turns hello.kt into JVM bytecode, which
#       the java launcher then runs. The compiler itself is a Java program,
#       so it needs a JDK or JRE, and the finished program needs a Java
#       runtime to run. On macOS and Linux this script unpacks JetBrains'
#       official zip into ~/.local/kotlinc-2.4.21 (see kotlinc-env.sh), so
#       no administrator password is needed.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://kotlinlang.org/docs/command-line.html
#   https://github.com/JetBrains/kotlin/releases/tag/v2.4.21
#   https://formulae.brew.sh/cask/temurin@21
#   https://adoptium.net/installation/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh
# KOTLINC_VERSION, KOTLINC_ZIP_SHA256, KOTLINC_DIR; puts the compiler on PATH.
# shellcheck source=kotlinc-env.sh
. ./kotlinc-env.sh

# The oldest JDK this project is tested with. Java 21 is a long-term
# support (LTS) release; the other Kotlin folders use the same one.
JAVA_MIN=21

# java_major prints the major version of the java launcher (for example 21),
# or fails if there is no working Java. On macOS /usr/bin/java always exists,
# but without a JDK it only prints "Unable to locate a Java Runtime".
java_major() {
    java -version 2>&1 | sed -n '1s/^[^"]*"\([0-9][0-9]*\).*/\1/p' | grep .
}

# install_kotlinc_zip - download JetBrains' official compiler zip, check its
# SHA-256 checksum, and unpack it into $KOTLINC_DIR. Only tools that come
# with macOS and Linux are used (curl, shasum or sha256sum, unzip).
install_kotlinc_zip() {
    kc_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-kotlin
    kc_zip=kotlin-compiler-$KOTLINC_VERSION.zip
    kc_url="https://github.com/JetBrains/kotlin/releases/download/v$KOTLINC_VERSION/$kc_zip"
    explain "Download $kc_zip (about 85 MB) from the Kotlin releases on GitHub"
    explain "into $kc_cache, check its SHA-256 checksum, and unpack it into"
    explain "$KOTLINC_DIR (no sudo)."
    confirm "Install Kotlin $KOTLINC_VERSION into $KOTLINC_DIR now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd curl || fail "curl is needed to download the compiler."
    # Git Bash on the Windows runner has no unzip; 7-Zip is on the image
    # (https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md).
    has_cmd unzip || has_cmd 7z || fail "unzip is needed to unpack the compiler."
    mkdir -p "$kc_cache"
    [ -f "$kc_cache/$kc_zip" ] || curl -fL -o "$kc_cache/$kc_zip" "$kc_url"
    # The checksum proves the file is exactly the JetBrains release.
    if has_cmd shasum; then
        echo "$KOTLINC_ZIP_SHA256  $kc_cache/$kc_zip" | shasum -a 256 -c - \
            || fail "Checksum mismatch: delete $kc_cache/$kc_zip and retry."
    else
        echo "$KOTLINC_ZIP_SHA256  $kc_cache/$kc_zip" | sha256sum -c - \
            || fail "Checksum mismatch: delete $kc_cache/$kc_zip and retry."
    fi

    kc_tmp=$(mktemp -d)
    if has_cmd unzip; then
        unzip -q "$kc_cache/$kc_zip" -d "$kc_tmp"
    else
        # 7z: x = extract with paths, -o<dir> = output folder (no space), -y = yes to all.
        7z x -y "-o$kc_tmp" "$kc_cache/$kc_zip" >/dev/null
    fi
    # The zip holds one folder, kotlinc/, with bin/ and lib/ inside.
    rm -rf "$KOTLINC_DIR"
    mkdir -p "$(dirname -- "$KOTLINC_DIR")"
    mv "$kc_tmp/kotlinc" "$KOTLINC_DIR"
    rm -rf "$kc_tmp"
    # Read kotlinc-env.sh again: it now puts $KOTLINC_DIR/bin on PATH.
    . ./kotlinc-env.sh
}

step "1/2 Check whether a JDK $JAVA_MIN (or newer) is installed"
explain "WHY: kotlinc runs on the JVM, and 'java -jar' runs the compiled program."
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

step "2/2 Check whether the Kotlin compiler (kotlinc) is installed"
explain "WHY: kotlinc compiles hello.kt into a jar file the JVM can run."
if has_cmd kotlinc; then
    ok "Kotlin compiler found: $(kotlinc -version 2>&1 | head -n 1)"
    exit 0
fi
warn "kotlinc is not installed."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        # The same official zip on every system (see above).
        install_kotlinc_zip ;;
    windows)
        # The same official zip; Git Bash runs its bin/kotlinc script.
        install_kotlinc_zip ;;
    *)
        fail "Unknown OS. See https://kotlinlang.org/docs/command-line.html" ;;
esac

has_cmd kotlinc || fail "kotlinc is still not on PATH. Open a new terminal and retry."
ok "Kotlin compiler $(kotlinc -version 2>&1 | head -n 1) is ready. Next: ./build.sh"
