#!/bin/sh
# run.sh - Flutter app: start the Android emulator, install the app, run it.
#
# WHAT: ./run.sh            starts the emulator if it is not running, then
#                           `flutter run` (debug build, hot reload; Ctrl+C stops it).
#       ./run.sh --verify   self-check for scripts/verify-all.sh: builds the APK
#                           if it is missing, installs it, starts it, waits for
#                           the app to log "Hello, World!", prints it, stops the
#                           app and exits. It also stops the emulator if this
#                           script started it.
# WHY:  an Android app runs in a virtual phone (the emulator), so the phone
#       must boot first. `adb` (Android Debug Bridge) installs the APK and reads
#       the log. The app's print() writes to logcat under the tag "flutter".
# HOW:  ./run.sh            or  ./run.sh --verify
#
# Platforms: macOS Intel is verified on the dev machine (x86_64 emulator with
# hardware acceleration). Other platforms are NOT verified (see install.sh).
# iOS is not run here: see README.md, "Platform notes".
# Sources: https://developer.android.com/studio/run/emulator-commandline
#          https://developer.android.com/tools/adb

set -eu

# Go to this script's folder, so the relative paths below work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step, explain, ok, warn, fail, has_cmd, require_cmd, is_verify, TF_OS.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Versions, the AVD name, the application id and PATH (adb, emulator, flutter).
# shellcheck source=./flutter-env.sh
. ./flutter-env.sh

APK=build/app/outputs/flutter-apk/app-release.apk
EMU_LOG="$HOME/.cache/hello-flutter/emulator.log"
# Set to 1 below only when this script starts the emulator, so --verify stops
# only what it started and never shuts down an emulator you were using.
STARTED_EMULATOR=0

require_cmd flutter "The Flutter SDK is missing. Run ./install.sh first."
require_cmd adb "adb ships with the Android SDK platform-tools. Run ./install.sh first."
require_cmd emulator "The emulator ships with the Android SDK. Run ./install.sh first."

# wait_for_boot SERIAL - poll until Android reports that boot has finished.
# The emulator answers adb before the system is ready, so the script waits for the
# system property sys.boot_completed to become 1 (about 2 minutes on this Mac).
wait_for_boot() {
    tf_tries=240                           # 240 tries x 2 s = 8 minutes at most
    while [ "$tf_tries" -gt 0 ]; do
        if [ "$(adb -s "$1" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ]; then
            return 0
        fi
        tf_tries=$((tf_tries - 1))
        sleep 2
    done
    fail "The emulator did not finish booting. Read $EMU_LOG."
}

# boot_emulator - reuse a running emulator, or start $AVD_NAME and wait.
boot_emulator() {
    step "Start the Android emulator"
    # adb lists running emulators as emulator-<port>, for example emulator-5554.
    SERIAL=$(adb devices | awk '/^emulator-/ && $2 == "device" { print $1; exit }')
    if [ -n "$SERIAL" ]; then
        ok "An emulator is already running: $SERIAL"
        return 0
    fi
    explain "WHY: the app needs a phone to run on. Starting $AVD_NAME takes about 2 minutes."
    explain "Flags: -no-window keeps the emulator in the background, -no-snapshot boots clean,"
    explain "-gpu swiftshader_indirect uses software rendering (the only GPU mode that worked on this Mac)."
    mkdir -p "$(dirname "$EMU_LOG")"
    # nohup keeps the emulator alive after this script exits; its log goes to EMU_LOG.
    nohup emulator -avd "$AVD_NAME" -no-window -no-audio -no-snapshot -no-boot-anim \
        -gpu swiftshader_indirect >"$EMU_LOG" 2>&1 &
    STARTED_EMULATOR=1
    # Wait until the new device appears in `adb devices`, then until it has booted.
    tf_tries=60
    while [ -z "$(adb devices | awk '/^emulator-/ && $2 == "device" { print $1 }')" ]; do
        tf_tries=$((tf_tries - 1))
        [ "$tf_tries" -gt 0 ] || fail "The emulator did not appear in adb devices. Read $EMU_LOG."
        sleep 2
    done
    SERIAL=$(adb devices | awk '/^emulator-/ && $2 == "device" { print $1; exit }')
    wait_for_boot "$SERIAL"
    ok "Emulator $SERIAL booted"
}

# stop_emulator - shut down the emulator only if boot_emulator started it.
stop_emulator() {
    if [ "$STARTED_EMULATOR" = 1 ] && [ -n "${SERIAL:-}" ]; then
        explain "Stopping the emulator that this script started."
        adb -s "$SERIAL" emu kill >/dev/null 2>&1 || true
    fi
}

if is_verify "$@"; then
    # ------------------------------------------------------ --verify mode ---
    step "Build the APK if it is missing"
    explain "WHY: the emulator installs a file; build.sh creates it."
    [ -f "$APK" ] || ./build.sh

    boot_emulator

    step "Install the APK on the emulator"
    explain "WHY: adb install copies the APK to the virtual phone and installs it. -r replaces an older install."
    adb -s "$SERIAL" install -r "$APK"

    step "Start the app and wait for its log line"
    explain "WHY: logcat holds what the app printed. The script clears it first so only this run's lines are read."
    adb -s "$SERIAL" logcat -c
    adb -s "$SERIAL" shell am start -n "$APP_ID/.MainActivity" >/dev/null
    tf_tries=60                            # 60 tries x 2 s = 2 minutes at most
    until adb -s "$SERIAL" logcat -d -s flutter | grep -q 'Hello, World!'; do
        tf_tries=$((tf_tries - 1))
        [ "$tf_tries" -gt 0 ] || { stop_emulator; fail "The app did not log 'Hello, World!'. Run: adb -s $SERIAL logcat -d -s flutter"; }
        sleep 2
    done
    adb -s "$SERIAL" shell am force-stop "$APP_ID"
    stop_emulator
    # The contract for scripts/verify-all.sh: print the greeting on stdout.
    echo "Hello, World!"
    exit 0
fi

# ------------------------------------------------------- normal run mode ---
boot_emulator
step "Run the app with flutter run"
explain "WHY: flutter run builds a debug version, installs it and keeps the connection for hot reload. Press Ctrl+C to stop."
flutter run -d "$SERIAL"
