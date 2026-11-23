#!/bin/sh
# run.sh - Kotlin Android: build the app, start the emulator, install and open it
#
# WHAT: 1. builds the APK (./build.sh);
#       2. starts the emulator device, unless one is already running, and waits
#          until Android has finished booting;
#       3. installs the APK on the emulator with adb;
#       4. starts MainActivity with am;
#       5. checks the screen. With --verify, it stops the emulator afterwards
#          when this script started it.
# WHY:  an Android app runs on a device, so the emulator is the device here.
#       adb (Android Debug Bridge) talks to it: it installs packages, starts
#       activities and reads the screen. An activity is one screen of the app.
# HOW:  ./run.sh            run it; the emulator window stays open
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the
#                           emulator has no window, the activity must be on
#                           top and "Hello, World!" must be on the screen, and
#                           the emulator is stopped at the end
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple
# Silicon, Linux and Windows (Git Bash) are documented but NOT verified.
# Sources: [1] https://developer.android.com/tools/adb
#          [2] https://developer.android.com/studio/run/emulator-commandline
#          [3] https://developer.android.com/topic/performance/vitals/anr
#          [4] the usage text of the device's own input command, printed by:
#              adb shell input

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Windows runners: select JDK 21 (see scripts/use-runner-jdk.sh).
# shellcheck source=../../../scripts/use-runner-jdk.sh
. ../../../scripts/use-runner-jdk.sh
# ANDROID_HOME, the emulator name and the PATH that finds adb and emulator.
# shellcheck source=android-env.sh
. ./android-env.sh

APK=app/build/outputs/apk/debug/app-debug.apk
PACKAGE=com.example.hello
ACTIVITY=$PACKAGE/.MainActivity
# Seconds to wait for the emulator to appear and to finish booting. A fresh
# boot takes about 2 minutes on the development machine, so 600 leaves room.
WAIT=600

VERIFY=0
if is_verify "$@"; then VERIFY=1; fi

# EMU_PORT is the console port of this app's emulator. The emulator is then
# known to adb as emulator-5580. A fixed port keeps this script away from an
# emulator that another task started on the same Mac; the port must be even.
# See: https://developer.android.com/studio/run/emulator-commandline (-port)
EMU_PORT=5580
SERIAL="emulator-$EMU_PORT"

# running_our_emulator succeeds when the device on $SERIAL is ready and runs
# $AVD_NAME. ro.boot.qemu.avd_name is the device property that holds the name
# of the AVD (virtual device) the emulator was started with.
running_our_emulator() {
    [ "$(adb -s "$SERIAL" get-state 2>/dev/null)" = device ] \
        && [ "$(adb -s "$SERIAL" shell getprop ro.boot.qemu.avd_name 2>/dev/null | tr -d '\r')" = "$AVD_NAME" ] \
        && [ "$(adb -s "$SERIAL" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]
}

step "1/5 Build the app"
explain "WHY: the emulator installs the APK, not the source code, so the APK is built first. Gradle skips the steps whose inputs did not change."
sh ./build.sh

# STARTED is 1 when this script starts the emulator, so that only such an
# emulator is stopped later.
STARTED=0
if running_our_emulator; then
    step "2/5 Use the emulator that is already running"
    explain "WHY: one emulator is enough. This script leaves an emulator it did not start running."
    ok "Found $AVD_NAME on $SERIAL"
else
    step "2/5 Start the emulator $AVD_NAME"
    explain "WHY: the device must be running before adb can install the app. -no-snapshot starts a full boot, so every run begins from the same state [2]."
    explain "-no-audio: the app makes no sound and the emulator needs no audio device [2]. -gpu chooses who draws the screen: with a window, swiftshader_indirect (the CPU) is used, because the window did not finish booting with -gpu host on the development machine; without a window (--verify), -gpu host (the Mac graphics card) is used, because the CPU renderer left System UI unresponsive there [2]."
    # Another device on the port: it may be a previous run's emulator still
    # dying. Wait up to 30 s for the port to clear before giving up.
    if adb devices 2>/dev/null | grep -q "^${SERIAL}[[:space:]]"; then
        dying=30
        while adb devices 2>/dev/null | grep -q "^${SERIAL}[[:space:]]" && [ "$dying" -gt 0 ]; do
            sleep 1; dying=$((dying - 1))
        done
        if adb devices 2>/dev/null | grep -q "^${SERIAL}[[:space:]]"; then
            fail "Port $EMU_PORT is used by another emulator ($SERIAL). Stop it with: adb -s $SERIAL emu kill, then run this script again."
        fi
    fi
    mkdir -p build
    STARTED=1
    # When the self-check ends, for any reason, stop the emulator this script
    # started, so no virtual device is left running behind verify-all.sh.
    trap 'if [ "$VERIFY" -eq 1 ] && [ "$STARTED" -eq 1 ]; then adb -s "$SERIAL" emu kill >/dev/null 2>&1 || true; fi' EXIT
    if [ "$VERIFY" -eq 1 ]; then
        explain "--verify: the emulator runs without a window, because nobody looks at it [2]."
        nohup emulator -avd "$AVD_NAME" -port "$EMU_PORT" -no-snapshot -no-audio -gpu host -no-window \
            > build/emulator.log 2>&1 &
    else
        nohup emulator -avd "$AVD_NAME" -port "$EMU_PORT" -no-snapshot -no-audio -gpu swiftshader_indirect \
            > build/emulator.log 2>&1 &
    fi
    # nohup and & keep the emulator running after this script ends. Its log is
    # in build/emulator.log, which Git ignores.

    # Wait until adb lists the device as ready (get-state prints "device").
    tries=$WAIT
    while [ "$(adb -s "$SERIAL" get-state 2>/dev/null)" != device ]; do
        [ "$tries" -gt 0 ] || fail "The emulator did not appear within $WAIT s. Its log is build/emulator.log."
        sleep 1
        tries=$((tries - 1))
    done

    # sys.boot_completed becomes 1 when Android has finished starting.
    tries=$WAIT
    while [ "$(adb -s "$SERIAL" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" != 1 ]; do
        [ "$tries" -gt 0 ] || fail "The emulator did not finish booting within $WAIT s. Its log is build/emulator.log."
        sleep 1
        tries=$((tries - 1))
    done
    # sys.boot_completed=1 precedes the package manager being ready.
    # Wait until `pm path android` succeeds, which means PM accepts installs.
    tries=$WAIT
    while ! adb -s "$SERIAL" shell pm path android >/dev/null 2>&1; do
        [ "$tries" -gt 0 ] || fail "The package manager did not become ready within $WAIT s. Its log is build/emulator.log."
        sleep 1
        tries=$((tries - 1))
    done
    ok "Android has started on $SERIAL"
fi

step "3/5 Install the app on the emulator"
explain "WHY: adb install copies the APK to the device. -r replaces an older copy of the app and keeps its data [1]."
adb -s "$SERIAL" install -r "$APK"

step "4/5 Start MainActivity"
explain "WHY: am start opens the activity named by its package and class. -W waits until the activity is on the screen [1]."
adb -s "$SERIAL" shell am start -W -n "$ACTIVITY"

step "5/5 Check the screen"
if [ "$VERIFY" -eq 1 ]; then
    explain "WHY: --verify checks two things. The activity must be the one on top (dumpsys lists it), and the text must be in the screen's view tree (uiautomator dump lists the text of every view) [1]."
    explain "WHY: on a cold boot the system can still be busy, and Android then shows an ANR dialog (Application Not Responding), for example \"System UI isn't responding\", on top of the app [3]. The dialog lets the user choose Wait; the check taps Wait the way a user would (input tap) [4], then looks at the screen again."
    # Compose draws the first frame a moment after the activity starts, and the
    # ANR dialog can appear a few seconds later, so the check is repeated for up
    # to 120 seconds (a cold boot inside a long run is slower than a lone run).
    tries=120
    # Bound ANR taps: a dialog that keeps reappearing must not loop indefinitely.
    # While the system is still busy after a cold boot, several dialogs can
    # follow one another (one per unresponsive process), so allow 30 taps.
    anr_taps=0
    ANR_TAP_MAX=30
    found=''
    while [ -z "$found" ] && [ "$tries" -gt 0 ]; do
        # dump the view tree first so we can detect the ANR dialog even when it
        # sits on top of the activity (topResumedActivity would not show $ACTIVITY).
        adb -s "$SERIAL" shell uiautomator dump /data/local/tmp/ui.xml >/dev/null 2>&1 || true
        ui=$(adb -s "$SERIAL" shell cat /data/local/tmp/ui.xml 2>/dev/null || true)
        # The ANR dialog's Wait button has the resource id android:id/aerr_wait.
        # Its bounds="[x1,y1][x2,y2]" give the rectangle to tap, at its centre.
        # Some variants omit aerr_wait and only carry text="Wait"; match both.
        wait_bounds=$(printf '%s' "$ui" | grep -o '<node[^>]*aerr_wait[^>]*>' | grep -o 'bounds="[^"]*"' | tr -c '0-9\n' ' ' || true)
        if [ -z "$wait_bounds" ]; then
            wait_bounds=$(printf '%s' "$ui" | grep -o '<node[^>]*text="Wait"[^>]*>' | grep -o 'bounds="[^"]*"' | head -1 | tr -c '0-9\n' ' ' || true)
        fi
        if [ -n "$wait_bounds" ] && [ "$anr_taps" -lt "$ANR_TAP_MAX" ]; then
            # shellcheck disable=SC2086 # split the four numbers on purpose
            set -- $wait_bounds
            adb -s "$SERIAL" shell input tap $((($1 + $3) / 2)) $((($2 + $4) / 2)) || true
            printf '%s\n' 'An ANR dialog was on the screen; tapped Wait.'
            anr_taps=$((anr_taps + 1))
            sleep 2
            continue
        fi
        top=$(adb -s "$SERIAL" shell dumpsys activity activities | grep 'topResumedActivity' || true)
        case "$top" in
            *"$ACTIVITY"*) ;;
            *) tries=$((tries - 1)); sleep 1; continue ;;
        esac
        found=$(printf '%s' "$ui" | grep -o 'text="Hello, World!"' || true)
        [ -n "$found" ] || { tries=$((tries - 1)); sleep 1; }
    done
    if [ -z "$found" ]; then
        printf '%s\n' '[diagnostic] topResumedActivity:'
        adb -s "$SERIAL" shell dumpsys activity activities | grep 'topResumedActivity' || true
        printf '%s\n' '[diagnostic] mCurrentFocus:'
        adb -s "$SERIAL" shell dumpsys window | grep 'mCurrentFocus' || true
        printf '%s\n' '[diagnostic] UI node resource-ids and texts:'
        adb -s "$SERIAL" shell uiautomator dump /data/local/tmp/ui.xml >/dev/null 2>&1 || true
        adb -s "$SERIAL" shell cat /data/local/tmp/ui.xml 2>/dev/null \
            | grep -o 'resource-id="[^"]*"\|text="[^"]*"' | grep -v 'text=""' || true
        fail "The activity $ACTIVITY is not on top, or the text is not on the screen."
    fi
    ok "The activity $ACTIVITY is on top of the screen."
    ok "The text is on the screen:"
    printf '%s\n' 'Hello, World!'
    # The EXIT trap above stops the emulator this script started.
else
    explain "The app is running in the emulator window. Close the window, or run: adb -s $SERIAL emu kill"
    ok "Installed and started $ACTIVITY."
fi
