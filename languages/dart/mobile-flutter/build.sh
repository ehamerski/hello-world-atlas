#!/bin/sh
# build.sh - Flutter app: compile lib/main.dart into an Android APK.
#
# WHAT: 1. flutter pub get: resolves the Dart packages listed in pubspec.yaml
#          (this app uses only the Flutter SDK itself, so the list is short).
#       2. flutter build apk --release: compiles the Dart code ahead of time
#          to native machine code and packs it, with the Android project
#          under android/, into app-release.apk.
# WHY:  a phone runs the APK, not the Dart source. Flutter compiles Dart in
#       release builds (AOT, ahead of time), which is what Google Play gets.
#       `flutter run` (run.sh without --verify) builds a debug version for
#       hot reload; this script builds the release version that --verify uses.
# HOW:  ./build.sh    (needs ./install.sh to have run once)
#
# Output: build/app/outputs/flutter-apk/app-release.apk (git-ignored).
# Platforms: macOS Intel is verified on the dev machine. Other platforms are
# NOT verified: see the header of install.sh.
# Sources: https://docs.flutter.dev/deployment/android (build an APK)

set -eu

# Go to this script's folder, so the relative paths below work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step, explain, ok, fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Flutter version, install folder, ANDROID_HOME and PATH.
# shellcheck source=./flutter-env.sh
. ./flutter-env.sh

require_cmd flutter "The Flutter SDK is missing. Run ./install.sh first."

step "1/2 Resolve the Dart packages"
explain "WHY: 'flutter pub get' reads pubspec.yaml and writes pubspec.lock, which pins each package version."
flutter pub get

step "2/2 Build the release APK"
explain "WHY: --release compiles the Dart code ahead of time (AOT). It is slower to build than a debug build and faster to run."
flutter build apk --release
ok "APK written to build/app/outputs/flutter-apk/app-release.apk. Next: ./run.sh --verify"
