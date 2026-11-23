#!/bin/sh
# install.sh - Kotlin Android: check (and optionally install) what the app needs
#
# WHAT: 1. checks that a Java Development Kit (JDK) 21 or newer is installed;
#       2. checks that Gradle 9.6 or newer is installed;
#       3. checks the Android command-line tools (sdkmanager, avdmanager);
#       4. checks the SDK packages: platform-tools, emulator, the Android 37.0
#          platform, build-tools 37.0.0 and the Android 36 x86_64 system image;
#       5. checks that the emulator can use hardware acceleration;
#       6. checks the emulator device (AVD) that ./run.sh starts.
#       Anything missing is explained, and installed only after you answer
#       "y". The SDK downloads are several gigabytes. Nothing is accepted or
#       installed silently, and sudo is never run.
# WHY:  The Android Gradle plugin (AGP) builds the app. AGP 9.5.1 needs a JDK
#       17 or newer and Gradle 9.6.0 or newer [1]. The app runs on an emulator,
#       a virtual Android device that needs the SDK packages, an Android system
#       image, and the hardware accelerator of the computer to run at a
#       usable speed [2][3][4].
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon, Linux and Windows (Git Bash) are documented but NOT verified; the
# README's "Platform notes" table has the details.
# Sources for the install commands and the versions:
#   https://developer.android.com/build/releases/gradle-plugin
#   https://developer.android.com/studio#command-line-tools-only
#   https://developer.android.com/tools/sdkmanager
#   https://developer.android.com/tools/avdmanager
#   https://developer.android.com/studio/run/emulator-commandline
#   https://formulae.brew.sh/formula/gradle
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
# The SDK folder, the package versions, the AVD name and the checksums.
# shellcheck source=android-env.sh
. ./android-env.sh

# The oldest JDK this project is tested with. Java 21 is a long-term support
# (LTS) release; the other Kotlin folders use the same one.
JAVA_MIN=21

# java_major prints the major version of the java launcher (for example 21),
# or fails if there is no working Java. On macOS /usr/bin/java always exists,
# but without a JDK it only prints "Unable to locate a Java Runtime".
java_major() {
    java -version 2>&1 | sed -n '1s/^[^"]*"\([0-9][0-9]*\).*/\1/p' | grep .
}

# gradle_ok: true when the installed Gradle is 9.6 or newer. awk compares the
# major and minor numbers of "9.8.0"; an empty version (no Gradle) is "too old".
gradle_ok() {
    gradle --version 2>/dev/null | sed -n 's/^Gradle //p' | head -n 1 \
        | awk -F. '{ exit !($1 > 9 || ($1 == 9 && $2 >= 6)) }'
}

# package_dir "platforms;android-37.0" prints the folder where sdkmanager puts
# that package: the semicolons become slashes, for example platforms/android-37.0.
package_dir() {
    printf '%s/%s\n' "$ANDROID_HOME" "$(printf '%s' "$1" | tr ';' '/')"
}

# sha256_of FILE prints the SHA-256 checksum of FILE. macOS has shasum; Linux
# and Git Bash have sha256sum.
sha256_of() {
    if has_cmd shasum; then
        shasum -a 256 "$1" | awk '{ print $1 }'
    else
        sha256sum "$1" | awk '{ print $1 }'
    fi
}

# install_cmdline_tools downloads the command-line tools zip, checks its
# SHA-256 against the value published by Google, and unpacks it into
# $ANDROID_HOME/cmdline-tools/latest. The zip contains a folder named
# cmdline-tools; sdkmanager needs it to be named "latest" [2].
install_cmdline_tools() {
    # An Apple Silicon Mac needs the arm64 zip. Intel Macs use the x86_64 zip.
    if [ "$TF_OS" = macos-arm ]; then
        zip_name="commandlinetools-mac_arm64-${CMDLINE_TOOLS_BUILD}_latest.zip"
        expected=$CMDLINE_TOOLS_SHA256_MAC_ARM64
    else
        zip_name="commandlinetools-mac_x86_64-${CMDLINE_TOOLS_BUILD}_latest.zip"
        expected=$CMDLINE_TOOLS_SHA256_MAC_X86_64
    fi
    explain "The zip is about 156 MB. Its SHA-256 checksum must match the value Google publishes, or nothing is unpacked."
    confirm "Download $zip_name and unpack it into $ANDROID_HOME now?" || {
        warn "Skipped. Download the zip yourself from https://developer.android.com/studio#command-line-tools-only and unpack it into $ANDROID_HOME/cmdline-tools/latest."
        exit 1
    }

    # A temporary folder for the download. It is removed when the script ends.
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    # -f: fail on an HTTP error; -L: follow redirects; --proto/--tlsv1.2: HTTPS only.
    curl -fL --proto '=https' --tlsv1.2 -o "$tmp/$zip_name" "$CMDLINE_TOOLS_URL_BASE/$zip_name"

    actual=$(sha256_of "$tmp/$zip_name")
    [ "$actual" = "$expected" ] \
        || fail "The checksum of $zip_name is $actual, not $expected. Nothing was unpacked. Download it again, and do not trust the file if the checksum still differs."
    ok "Checksum matches the value that Google publishes."

    unzip -q "$tmp/$zip_name" -d "$tmp"
    mkdir -p "$ANDROID_HOME/cmdline-tools"
    mv "$tmp/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
    ok "Command-line tools unpacked into $ANDROID_HOME/cmdline-tools/latest"
}

step "1/6 Check whether a JDK $JAVA_MIN (or newer) is installed"
explain "WHY: Gradle and the Android Gradle plugin run on the JVM [1]."
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

step "2/6 Check whether Gradle 9.6 or newer is installed"
explain "WHY: the Android Gradle plugin 9.5.1 needs Gradle 9.6.0 or newer [1]. Gradle reads the build files and downloads the plugins."
if has_cmd gradle && gradle_ok; then
    ok "Gradle found: $(gradle --version 2>&1 | sed -n 's/^Gradle /Gradle /p' | head -n 1)"
else
    warn "Gradle 9.6 or newer was not found."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            # "brew upgrade" replaces an older Gradle; "brew install" adds a missing one.
            if has_cmd gradle; then
                install_pkg "Gradle 9.6 or newer" brew upgrade gradle || exit 1
            else
                install_pkg "Gradle" brew install gradle || exit 1
            fi ;;
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
    has_cmd gradle && gradle_ok || fail "Gradle 9.6 or newer is still not found. Open a new terminal and retry."
fi

SDKMANAGER="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"

step "3/6 Check the Android command-line tools"
explain "WHY: sdkmanager installs the SDK packages and avdmanager creates the emulator device. Both come in the command-line tools zip [2]."
explain "Note: sdkmanager, avdmanager and emulator are marked deprecated in favor of the android command. They still work when this was verified (2026-11-11), so the scripts use them [2][3][4]."
if [ -x "$SDKMANAGER" ]; then
    ok "Command-line tools found in $ANDROID_HOME/cmdline-tools/latest"
else
    warn "The command-line tools are not in $ANDROID_HOME/cmdline-tools/latest."
    case "$TF_OS" in
        macos-intel|macos-arm) install_cmdline_tools ;;
        *) fail "This script downloads the tools on macOS only. Download the command-line tools from https://developer.android.com/studio#command-line-tools-only, unpack them into $ANDROID_HOME/cmdline-tools/latest, and run this script again." ;;
    esac
fi

step "4/6 Check the SDK packages and the licence agreements"
explain "WHY: the app compiles against the Android platform, builds with build-tools, and runs on the emulator with the system image [2]."
missing=''
for dir in \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/emulator" \
    "$(package_dir "$ANDROID_PLATFORM")" \
    "$(package_dir "$ANDROID_BUILD_TOOLS")" \
    "$(package_dir "$ANDROID_IMAGE")"; do
    if [ -d "$dir" ]; then
        ok "Found $dir"
    else
        warn "Missing $dir"
        missing=1
    fi
done
if [ -z "$missing" ]; then
    ok "All SDK packages are installed."
else
    if [ ! -f "$ANDROID_HOME/licenses/android-sdk-license" ]; then
        explain "sdkmanager asks you to accept the Android SDK licence agreements before it installs packages [2]."
        explain "Run sdkmanager --licenses later if you want to read them first."
        confirm "Accept the licence agreements and continue?" || {
            warn "Skipped. Run the command by hand, then run this script again: sdkmanager --licenses"
            exit 1
        }
        # With a keyboard attached, sdkmanager shows each licence and asks.
        # Without one (TF_ASSUME_YES=1), "yes" answers every question with yes.
        if [ -t 0 ]; then
            "$SDKMANAGER" --sdk_root="$ANDROID_HOME" --licenses
        else
            yes | "$SDKMANAGER" --sdk_root="$ANDROID_HOME" --licenses
        fi
    fi
    explain "The packages are several gigabytes in total. The image is the largest. The sizes are listed in the README."
    confirm "Download and install the missing packages now?" || {
        warn "Skipped. Run this script again when you are ready."
        exit 1
    }
    "$SDKMANAGER" --sdk_root="$ANDROID_HOME" \
        "platform-tools" "emulator" "$ANDROID_PLATFORM" "$ANDROID_BUILD_TOOLS" "$ANDROID_IMAGE"
    ok "SDK packages installed."
fi

step "5/6 Check that the emulator can use hardware acceleration"
explain "WHY: without an accelerator the emulator runs the Android system in software, which is very slow. On macOS the accelerator is Hypervisor.Framework (HVF) [3]."
if emulator -accel-check; then
    ok "Hardware acceleration is available."
else
    warn "The emulator reports no hardware accelerator. It still runs, but slowly. The message above says which one is missing."
fi

step "6/6 Check the emulator device ($AVD_NAME)"
explain "WHY: run.sh starts this device. It is a virtual phone that uses the system image and the hardware profile $AVD_DEVICE [4]."
if avdmanager list avd -c 2>/dev/null | grep -qx "$AVD_NAME"; then
    ok "The emulator device $AVD_NAME exists."
else
    confirm "Create the emulator device $AVD_NAME ($AVD_DEVICE, Android 36, x86_64)?" || {
        warn "Skipped. Run this script again when you are ready to create it."
        exit 1
    }
    # "echo no" answers avdmanager's question about a custom hardware profile,
    # because $AVD_DEVICE is one of the built-in profiles.
    echo no | avdmanager create avd --name "$AVD_NAME" --package "$ANDROID_IMAGE" --device "$AVD_DEVICE"
    ok "Created the emulator device $AVD_NAME."
fi

ok "The Android tools are ready. Next: ./build.sh, then ./run.sh"
