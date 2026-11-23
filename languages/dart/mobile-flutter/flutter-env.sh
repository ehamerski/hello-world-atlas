# shellcheck shell=sh disable=SC2034  # sourced: install.sh and run.sh use these
# flutter-env.sh - versions, checksums and folders shared by install.sh,
# build.sh and run.sh of this Flutter app. It is SOURCED, not run.
#
# WHAT: sets the Flutter SDK version, the SHA-256 checksum of its official
#       archive, the Android SDK folder, the Android emulator (AVD) name and
#       the pinned Android command-line tools archive.
# WHY:  the three scripts must agree on the same versions. One file avoids
#       drift. A pinned version with a checksum installs the same bytes on
#       every machine, and a changed download stops the install
#       (https://github.com/ossf/scorecard/blob/main/docs/checks.md#pinned-dependencies).
# SOURCES: Flutter release index (macOS):
#          https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json
#          Android command-line tools and checksums:
#          https://dl.google.com/android/repository/repository2-3.xml

FLUTTER_VERSION=3.47.9
# Official archive for macOS on Intel (x86_64). The checksum was checked
# against the release index above.
FLUTTER_ARCHIVE=flutter_macos_${FLUTTER_VERSION}-stable.zip
FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/${FLUTTER_ARCHIVE}
FLUTTER_SHA256=0dc38b4038a0b002a6258696a5b327a58473c175c9e334b9f329ef7d79a4fdcd

# Where the Flutter SDK is unpacked. Kept in ~/.local, outside the repository,
# so `git clean` never deletes a multi-gigabyte toolchain.
FLUTTER_HOME="$HOME/.local/flutter"

# Android command-line tools (sdkmanager, avdmanager). The archive is pinned
# by SHA-256; the SDK itself is installed under ANDROID_HOME.
CMDLINE_TOOLS_ARCHIVE=commandlinetools-mac_x86_64-15859902_latest.zip
CMDLINE_TOOLS_URL=https://dl.google.com/android/repository/${CMDLINE_TOOLS_ARCHIVE}
CMDLINE_TOOLS_SHA256=c5a6378ab5cf7e0d5701921405115befff13e9ff7417fb588389338f8bd050f3

# Android SDK location. Flutter and Gradle read ANDROID_HOME from the
# environment, so every script exports it before it runs flutter.
ANDROID_HOME="$HOME/.local/android-sdk"
export ANDROID_HOME

# Android API level and system image for the emulator. API 36 matches the
# compileSdk that the Flutter template generates with this SDK version.
ANDROID_API=36
SYSTEM_IMAGE="system-images;android-${ANDROID_API};google_apis;x86_64"

# Name of the Android Virtual Device (emulator) this app uses. install.sh
# creates it once; run.sh boots it.
AVD_NAME=hello-flutter

# Android application id, from android/app/build.gradle.kts (namespace).
APP_ID=com.example.hello_flutter

# Put the Flutter and Android tools on PATH for this shell only.
PATH="$FLUTTER_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
export PATH
