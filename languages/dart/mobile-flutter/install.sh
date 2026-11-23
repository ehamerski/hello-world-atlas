#!/bin/sh
# install.sh - Flutter app: check (and, after you agree, install) the Flutter
# SDK, the Android SDK and one Android emulator (AVD) for this app.
#
# WHAT: 1. Flutter SDK 3.47.9 in ~/.local/flutter, from the official archive.
#       2. Android command-line tools, with their SHA-256 checked first.
#       3. Android SDK packages: platform-tools, emulator, platform 36,
#          build-tools 36.0.0 and the x86_64 system image for the emulator.
#       4. The Android Virtual Device (AVD) named in flutter-env.sh.
#       Each download is checked against a pinned SHA-256 before it is used.
#       Nothing is installed without your "y".
# WHY:  build.sh needs the Flutter SDK (it contains the Dart SDK that
#       compiles lib/main.dart) and the Android SDK (Gradle builds the APK
#       with it). run.sh needs the emulator and an AVD to run the APK.
#       Flutter does not ship an Android SDK: it finds one through ANDROID_HOME.
# HOW:  ./install.sh      (run once; safe to run again: it skips what exists)
#
# Platforms: macOS Intel is verified on the dev machine (this file's pins
# were checked there). macOS Apple Silicon, Linux and Windows (Git Bash)
# are documented but NOT verified: install Flutter from
# https://docs.flutter.dev/install and the Android SDK from
# https://developer.android.com/studio#command-line-tools-only by hand,
# then run ./build.sh.
#
# Sources:
#   Flutter install: https://docs.flutter.dev/install
#   Android command-line tools: https://developer.android.com/studio#command-line-tools-only
#   Android emulator and AVDs: https://developer.android.com/studio/run/emulator-commandline
#   Checksums and versions: flutter-env.sh (each line cites its source)

set -eu

# Go to this script's folder, so every relative path below works from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step, explain, ok, warn, fail, confirm, has_cmd, TF_OS.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Versions, checksums and folders. Sourced so that every script agrees.
# shellcheck source=./flutter-env.sh
. ./flutter-env.sh

# sha256_of FILE - print the SHA-256 digest of FILE. macOS ships `shasum`;
# Linux and Git Bash ship `sha256sum`. Both print the digest first.
sha256_of() {
    if has_cmd shasum; then
        shasum -a 256 "$1" | cut -d ' ' -f 1
    else
        sha256sum "$1" | cut -d ' ' -f 1
    fi
}

# fetch_verified URL SHA256 FILE - download URL to FILE, but keep it only if
# its SHA-256 equals the pinned value. A mismatch deletes the download, so a
# changed or tampered file is never unpacked.
fetch_verified() {
    tf_url=$1; tf_want=$2; tf_file=$3
    if [ -f "$tf_file" ] && [ "$(sha256_of "$tf_file")" = "$tf_want" ]; then
        ok "Already downloaded and checked: $(basename "$tf_file")"
        return 0
    fi
    require_cmd curl "curl downloads the official archive."
    mkdir -p "$(dirname "$tf_file")"
    explain "Downloading $tf_url"
    # -f: fail on HTTP errors; -L: follow the redirect to the CDN; --retry: retry network errors.
    curl -fL --retry 3 -o "$tf_file.part" "$tf_url"
    tf_got=$(sha256_of "$tf_file.part")
    if [ "$tf_got" != "$tf_want" ]; then
        rm -f "$tf_file.part"
        fail "Checksum mismatch for $(basename "$tf_file"). Expected $tf_want, got $tf_got. The file was deleted and nothing was installed."
    fi
    mv "$tf_file.part" "$tf_file"
    ok "Checksum matches the pinned SHA-256: $(basename "$tf_file")"
}

# Archives are kept here, outside the repository, so re-running is cheap.
CACHE_DIR="$HOME/.cache/hello-flutter"

# ------------------------------------------------------------------ Java ---
step "1/5 Check Java (needed by Android's sdkmanager and Gradle)"
explain "WHY: sdkmanager, avdmanager and Gradle are Java programs, so they need a Java runtime."
require_cmd java "Install a JDK 17 or newer, for example Temurin 21 from https://adoptium.net."
ok "Java found: $(java -version 2>&1 | head -n 1)"
explain "The generated Gradle files target JVM 17 (android/app/build.gradle.kts), so a JDK 17 or newer is enough."

# ---------------------------------------------------------------- Flutter ---
step "2/5 Flutter SDK $FLUTTER_VERSION"
explain "WHY: the Flutter SDK contains the 'flutter' tool and the Dart SDK. build.sh uses both."
if [ -x "$FLUTTER_HOME/bin/flutter" ] && "$FLUTTER_HOME/bin/flutter" --version 2>/dev/null | grep -q "Flutter $FLUTTER_VERSION "; then
    ok "Flutter $FLUTTER_VERSION found in $FLUTTER_HOME"
else
    if [ "$TF_OS" != macos-intel ]; then
        fail "Automatic install is verified only on macOS Intel. Install Flutter $FLUTTER_VERSION by hand (see the header of this script), then re-run."
    fi
    warn "Flutter $FLUTTER_VERSION is not installed in $FLUTTER_HOME."
    if confirm "Download Flutter $FLUTTER_VERSION (about 2.3 GB) and unpack it into $HOME/.local?"; then
        fetch_verified "$FLUTTER_URL" "$FLUTTER_SHA256" "$CACHE_DIR/$FLUTTER_ARCHIVE"
        require_cmd unzip "unzip unpacks the Flutter archive (it ships with macOS)."
        # The archive has one top-level folder, flutter/, so unpacking into
        # ~/.local creates ~/.local/flutter.
        mkdir -p "$HOME/.local"
        unzip -q "$CACHE_DIR/$FLUTTER_ARCHIVE" -d "$HOME/.local"
        ok "Flutter unpacked to $FLUTTER_HOME"
    else
        warn "Skipped. Install Flutter $FLUTTER_VERSION yourself, then re-run this script."
        exit 1
    fi
fi
# Flutter writes its own first-run files into ~/.flutter/ on first use.
"$FLUTTER_HOME/bin/flutter" --version | head -n 1

# ---------------------------------------------------- Android: cmdline-tools ---
step "3/5 Android command-line tools (sdkmanager, avdmanager)"
explain "WHY: Flutter's Android build calls sdkmanager to fetch the NDK and platform packages it needs."
SDKMANAGER="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
if [ -x "$SDKMANAGER" ]; then
    ok "Android command-line tools found in $ANDROID_HOME"
else
    warn "Android command-line tools are not installed in $ANDROID_HOME."
    if confirm "Download the Android command-line tools (about 156 MB, SHA-256 checked) into $ANDROID_HOME?"; then
        fetch_verified "$CMDLINE_TOOLS_URL" "$CMDLINE_TOOLS_SHA256" "$CACHE_DIR/$CMDLINE_TOOLS_ARCHIVE"
        # Google's archive contains one folder, cmdline-tools/. The SDK
        # expects it under cmdline-tools/latest/, so move it there.
        rm -rf "$ANDROID_HOME/cmdline-tools"
        mkdir -p "$ANDROID_HOME/cmdline-tools"
        unzip -q "$CACHE_DIR/$CMDLINE_TOOLS_ARCHIVE" -d "$ANDROID_HOME/cmdline-tools"
        mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
        ok "Android command-line tools unpacked to $ANDROID_HOME/cmdline-tools/latest"
    else
        warn "Skipped. Install the Android command-line tools yourself, then re-run this script."
        exit 1
    fi
fi

# ------------------------------------------------- Android: SDK packages ---
step "4/5 Android SDK packages and the emulator image"
explain "WHY: the APK is built for platform 36, and run.sh needs the emulator and the x86_64 system image."
explain "The Android SDK license must be accepted once. Its text: https://developer.android.com/studio/terms"
# Each package leaves a folder behind once sdkmanager has installed it. If all
# of them are there, a re-run skips the download and the license question.
SDK_PACKAGES_PRESENT=1
for tf_path in "$ANDROID_HOME/platform-tools/adb" "$ANDROID_HOME/emulator/emulator" \
    "$ANDROID_HOME/platforms/android-$ANDROID_API" "$ANDROID_HOME/build-tools/36.0.0" \
    "$ANDROID_HOME/system-images/android-$ANDROID_API/google_apis/x86_64"; do
    [ -e "$tf_path" ] || SDK_PACKAGES_PRESENT=0
done
if [ "$SDK_PACKAGES_PRESENT" = 1 ]; then
    ok "Android SDK packages already installed"
elif confirm "Accept the Android SDK license and install the packages (several GB)?"; then
    # `yes` answers the license prompts with "y". Accept only after your "y" above.
    yes | "$SDKMANAGER" --sdk_root="$ANDROID_HOME" --licenses >/dev/null
    "$SDKMANAGER" --sdk_root="$ANDROID_HOME" \
        "platform-tools" "emulator" "platforms;android-$ANDROID_API" \
        "build-tools;36.0.0" "$SYSTEM_IMAGE"
    ok "Android SDK packages installed"
else
    warn "Skipped. Run sdkmanager yourself with the packages listed in flutter-env.sh, then re-run."
    exit 1
fi

# ------------------------------------------------------------ the AVD ---
step "5/5 Android Virtual Device (emulator): $AVD_NAME"
explain "WHY: the emulator needs a virtual device. Its settings come from the system image above."
AVDMANAGER="$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager"
if "$AVDMANAGER" list avd -c 2>/dev/null | grep -qx "$AVD_NAME"; then
    ok "AVD $AVD_NAME already exists"
else
    if confirm "Create the AVD $AVD_NAME from the system image?"; then
        # `no` answers avdmanager's "custom hardware profile?" question with no.
        echo no | "$AVDMANAGER" create avd --name "$AVD_NAME" --package "$SYSTEM_IMAGE"
        ok "AVD $AVD_NAME created"
    else
        warn "Skipped. Create the AVD with avdmanager, then re-run this script."
        exit 1
    fi
fi

ok "Everything is in place. Next: ./build.sh, then ./run.sh"
