#!/bin/sh
# install.sh - Clojure desktop: check (and optionally install) Java and the Clojure CLI
#
# WHAT: 1. checks that a Java runtime 21 or newer is installed;
#       2. checks that the Clojure CLI (the clojure command) is installed;
#       3. runs "clojure -P", which downloads the libraries listed in
#          deps.edn (here only Clojure itself; Swing is in the JDK) before the first run.
#       If Java or the Clojure CLI is missing, shows the install command and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  Clojure runs on the Java Virtual Machine (JVM), so it needs Java.
#       The Clojure CLI starts the JVM with the right classpath: it reads
#       deps.edn, downloads the libraries from Maven Central and Clojars
#       into ~/.m2, and runs your code. There is no separate compiler to
#       install: Clojure compiles each function to JVM bytecode in memory
#       when it loads the source (see ../cli/README.md). Swing needs
#       nothing else: it is part of the JDK itself (the java.desktop
#       module), reached through Java interop.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://clojure.org/guides/install_clojure
#   https://github.com/clojure/brew-install/releases/tag/1.12.6.1673
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
# CLOJURE_CLI_VERSION, CLOJURE_INSTALLER_SHA256, CLOJURE_DIR; puts
# $CLOJURE_DIR/bin on PATH.
# shellcheck source=clojure-env.sh
. ./clojure-env.sh

# The oldest Java this repository tests with (Java 21 is a long-term
# support release). Clojure itself needs Java 8 or newer.
JAVA_MIN=21

# java_major prints the major version of java (e.g. 21), or fails if there is
# no working Java. On macOS /usr/bin/java always exists, but without a JDK it
# only prints "Unable to locate a Java Runtime" and fails, so we run it.
java_major() {
    java -version 2>&1 | sed -n 's/^[a-z]* version "\([0-9][0-9]*\).*/\1/p' | head -n 1 | grep .
}

# install_clojure_posix - download the official POSIX installer, check its
# SHA-256 and run it with --prefix, so the CLI goes into $CLOJURE_DIR and
# no administrator password is needed. The installer downloads the tools
# archive into the folder it runs in and checks that archive's SHA-256
# itself, so it runs in a temporary folder.
install_clojure_posix() {
    cj_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-clojure
    cj_script=posix-install.sh
    cj_url="https://github.com/clojure/brew-install/releases/download/$CLOJURE_CLI_VERSION/$cj_script"
    explain "Download the official installer $cj_script for version $CLOJURE_CLI_VERSION"
    explain "from the clojure/brew-install release on GitHub into $cj_cache,"
    explain "check its SHA-256 checksum, and run it with --prefix $CLOJURE_DIR (no sudo)."
    confirm "Install the Clojure CLI $CLOJURE_CLI_VERSION into $CLOJURE_DIR now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }
    has_cmd curl || fail "curl is missing. Install it first."

    mkdir -p "$cj_cache"
    [ -f "$cj_cache/$cj_script" ] || curl -fL -o "$cj_cache/$cj_script" "$cj_url"
    # The checksum proves the file is exactly the release that was checked.
    echo "$CLOJURE_INSTALLER_SHA256  $cj_cache/$cj_script" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $cj_cache/$cj_script and retry."

    cj_tmp=$(mktemp -d)
    # A subshell, so the cd does not change this script's folder.
    (cd "$cj_tmp" && sh "$cj_cache/$cj_script" --prefix "$CLOJURE_DIR") \
        || fail "The Clojure installer failed. See the messages above."
    rm -rf "$cj_tmp"
    # Read clojure-env.sh again: it now puts $CLOJURE_DIR/bin on PATH.
    . ./clojure-env.sh
}

# install_clojure_windows - the Clojure guide's Windows route is clj-msi, an
# MSI package that installs clojure.exe (it bundles deps.clj and the
# ClojureTools files). Same version number as the macOS/Linux CLI. The
# checksum is the SHA-256 that GitHub lists for the release asset.
# Sources:
#   https://clojure.org/guides/install_clojure#_windows_installer
#   https://github.com/casselc/clj-msi/releases/tag/v1.12.6.1673
#   https://learn.microsoft.com/windows/win32/msi/command-line-options  (msiexec /i, /qn)
install_clojure_windows() {
    cj_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-clojure
    cj_msi=clojure-$CLOJURE_CLI_VERSION.msi
    cj_url="https://github.com/casselc/clj-msi/releases/download/v$CLOJURE_CLI_VERSION/$cj_msi"
    explain "Download the Windows installer $cj_msi from the casselc/clj-msi release on"
    explain "GitHub into $cj_cache, check its SHA-256 checksum, and run it silently"
    explain "(msiexec /i ... /qn) into $CLOJURE_DIR."
    confirm "Install the Clojure CLI $CLOJURE_CLI_VERSION into $CLOJURE_DIR now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }
    has_cmd curl || fail "curl is missing. Install it first."

    mkdir -p "$cj_cache"
    [ -f "$cj_cache/$cj_msi" ] || curl -fL -o "$cj_cache/$cj_msi" "$cj_url"
    echo "$CLOJURE_MSI_SHA256  $cj_cache/$cj_msi" | sha256sum -c - \
        || fail "Checksum mismatch: delete $cj_cache/$cj_msi and retry."

    # msiexec wants Windows paths (cygpath -w), and Git Bash must not turn
    # the /i and /qn switches into paths (MSYS_NO_PATHCONV=1, documented at
    # https://www.msys2.org/docs/filesystem-paths/#automatic-unix-windows-path-conversion).
    MSYS_NO_PATHCONV=1 msiexec /i "$(cygpath -w "$cj_cache/$cj_msi")" /qn \
        APPLICATIONFOLDER="$(cygpath -w "$CLOJURE_DIR")" \
        || fail "The Clojure installer failed. See the messages above."
    # Read clojure-env.sh again: it now puts the install folder on PATH.
    . ./clojure-env.sh
}

step "1/3 Check whether Java $JAVA_MIN (or newer) is installed"
explain "WHY: Clojure compiles to JVM bytecode, so a Java runtime must run it."
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
            fail "Unknown OS. Install Java 21 by hand: https://adoptium.net/installation/" ;;
    esac
    JAVA=$(java_major) && [ "$JAVA" -ge "$JAVA_MIN" ] \
        || fail "Java $JAVA_MIN is still not found. Open a new terminal and retry."
fi

step "2/3 Check whether the Clojure CLI is installed"
explain "WHY: the 'clojure' command reads deps.edn, builds the classpath and starts the JVM."
if has_cmd clojure; then
    ok "Clojure CLI found: $(clojure --version 2>&1 | head -n 1) ($(command -v clojure))"
else
    warn "The Clojure CLI is not installed (no 'clojure' on PATH)."
    case "$TF_OS" in
        macos-intel|macos-arm|linux)
            # The official POSIX installer, run into your home folder (see above).
            # Homebrew users can run instead:
            #   brew install clojure/tools/clojure
            install_clojure_posix ;;
        windows)
            # The Windows installer clj-msi (linked from the official guide).
            install_clojure_windows ;;
        *)
            fail "Unknown OS. See https://clojure.org/guides/install_clojure" ;;
    esac
    has_cmd clojure || fail "'clojure' is still not on PATH. Open a new terminal and retry."
    ok "Clojure CLI installed: $(clojure --version 2>&1 | head -n 1)"
fi

step "3/3 Download the libraries named in deps.edn"
explain "WHY: 'clojure -P' (prepare) downloads the dependencies and caches the"
explain "classpath, without running the program, so ./run.sh starts at once."
# clojure -P writes the computed classpath to .cpcache/; if it is there, the
# libraries were already downloaded (the clojure command redoes it when
# deps.edn changes).
if ls .cpcache/*.cp >/dev/null 2>&1; then
    ok "Libraries already downloaded (.cpcache/ holds the classpath)."
else
    install_pkg "the libraries in deps.edn" clojure -P || exit 1
fi
ok "Clojure is ready. Next: ./run.sh (there is no build step)"
