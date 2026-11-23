#!/bin/sh
# run.sh - Swift iOS: run the Hello World app in the iOS Simulator
#
# WHAT: starts an iPhone Simulator, installs HelloWorld.app and launches it.
#   ./run.sh           launches the app and leaves it open in the Simulator
#   ./run.sh --verify  launches it with --verify: the app prints
#                      "Hello, World!" to the console and exits; this script
#                      checks the output and then stops
# WHY:  an iOS app runs only inside an OS. The Simulator is that OS on the
#   Mac: it starts without a phone, and CI can run it on a headless
#   macOS machine. --verify lets CI check the output without a person
#   looking at the screen.
#
# Simulator device: the first iPhone that is installed. To choose one, set
#   SIM_DEVICE to its UDID (list them with: xcrun simctl list devices available).
#
# Platforms: verified on macOS Intel (macOS 26, Xcode 26.5, iOS 26.5
# Simulator runtime) and on a macOS Apple Silicon CI runner
# (.github/workflows/ios.yml). Linux and Windows cannot run iOS apps.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The bundle identifier from Info.plist. simctl launches an app by this name.
BUNDLE_ID=com.example.helloworld.swift

[ -d HelloWorld.app ] || {
    explain "Building first (HelloWorld.app is missing)."
    sh build.sh
}

step "Choose the Simulator"
explain "WHY: simctl addresses a device by its UDID, the unique id shown in the device list."
DEVICE=${SIM_DEVICE:-}
if [ -z "$DEVICE" ]; then
    # Each line of `simctl list devices available` looks like
    #   iPhone 17 (XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX) (Shutdown)
    # The sed keeps the UDID of the first line that starts with "iPhone".
    DEVICE=$(xcrun simctl list devices available |
        sed -n 's/^ *iPhone .*(\([0-9A-Fa-f-]\{36\}\)) (.*/\1/p' | head -n 1)
fi
[ -n "$DEVICE" ] || fail "No iPhone Simulator is available. Open Xcode > Settings > Platforms and install an iOS Simulator runtime."
ok "Simulator: $DEVICE"

step "Start the Simulator"
explain "WHY: an app cannot be installed on a Simulator that is not running."
# boot fails when the device is already running; that is fine, so ignore it.
xcrun simctl boot "$DEVICE" 2>/dev/null || true
# bootstatus -b boots if needed and waits until the device is ready for apps.
xcrun simctl bootstatus "$DEVICE" -b

step "Install the app"
explain "WHY: installing copies HelloWorld.app into the Simulator's file system."
xcrun simctl install "$DEVICE" HelloWorld.app

if is_verify "$@"; then
    step "Run the program (verify mode)"
    explain "WHY: --console-pty sends the app's output here; --verify makes the app print and exit."
    # Flags go before the device and the bundle id; anything after the bundle
    # id is passed to the app as its arguments.
    if ! out=$(xcrun simctl launch --console-pty --terminate-running-process \
            "$DEVICE" "$BUNDLE_ID" --verify 2>&1); then
        printf '%s\n' "$out"
        fail "simctl could not run the app."
    fi
    printf '%s\n' "$out"
    printf '%s\n' "$out" | grep -q 'Hello, World!' || fail "The app did not print Hello, World!"
    ok "run.sh --verify: Hello, World! printed by the app"
else
    step "Launch the app"
    explain "WHY: the app stays open in the Simulator until you stop it or the device shuts down."
    xcrun simctl launch --terminate-running-process "$DEVICE" "$BUNDLE_ID"
    # Bring the Simulator window to the front. Needs a display; CI has none,
    # so this line only runs on a Mac used by a person.
    open -a Simulator
    echo "run.sh: app launched in the Simulator"
fi
