#!/bin/sh
# build.sh - Kotlin Android: build the debug APK
#
# WHAT: compiles the Kotlin code and packages it as an APK (the Android
#       application package): app/build/outputs/apk/debug/app-debug.apk
# WHY:  Android does not run Kotlin source or JVM class files as they are.
#       The Android Gradle plugin (AGP) compiles the code, merges the manifest
#       and the resources, converts the classes to Dalvik bytecode, and signs
#       the package with a debug key, so that the emulator can install it [1].
#       Gradle runs AGP, and it downloads AGP and the libraries the first time.
# HOW:  ./build.sh   (after ./install.sh; ./run.sh runs it for you)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon, Linux and Windows (Git Bash) are documented but NOT verified.
# Sources: https://developer.android.com/build (the Android build overview)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh
# ANDROID_HOME and the package versions. Gradle reads ANDROID_HOME from the
# environment, so the variable must be exported before gradle starts.
# shellcheck source=android-env.sh
. ./android-env.sh

step "1/2 Check the build tools"
explain "WHY: building needs Gradle, a JDK and the Android SDK; ./install.sh installs them."
require_cmd gradle "Gradle is needed to build."
require_cmd java "The JVM runs Gradle and the Android Gradle plugin."
[ -d "$ANDROID_HOME/platforms/android-37.0" ] \
    || fail "The Android 37.0 platform is missing from $ANDROID_HOME. Run ./install.sh first."

step "2/2 Build the debug APK"
explain "WHY: assembleDebug compiles the app and signs it with the debug key. The first build downloads AGP and the Compose libraries, which takes several minutes."
explain "--no-daemon stops the Gradle background process when the build ends."
echo "gradle --no-daemon --console=plain assembleDebug"
gradle --no-daemon --console=plain assembleDebug

[ -f app/build/outputs/apk/debug/app-debug.apk ] \
    || fail "The build finished but app-debug.apk is missing. Read the Gradle output above."
ok "Build finished: app/build/outputs/apk/debug/app-debug.apk. Next: ./run.sh"
