# shellcheck shell=sh disable=SC2034  # sourced: install.sh and run.sh use these
# android-env.sh - settings that install.sh, build.sh and run.sh share.
#
# WHAT: the folder of the Android SDK, the versions of its packages, the name
#   of the emulator device, and the checksums of the command-line tools zip.
#   It is sourced (". ./android-env.sh"), not run, so it only sets variables
#   and PATH. Its file mode is 644 for that reason.
# WHY:  the platform, the build tools and the system image must belong to the
#   same Android version, and every script has to find the same SDK. One file
#   keeps them in step. The checksums let install.sh prove that the zip it
#   downloaded is the file Google published, before it runs anything from it.
#
# Sources for the values:
#   Command-line tools zip and its SHA-256: https://developer.android.com/studio
#   sdkmanager and package names: https://developer.android.com/tools/sdkmanager
#   avdmanager: https://developer.android.com/tools/avdmanager
#   Compose needs compileSdk 37 with AGP 9:
#       https://developer.android.com/develop/ui/compose/setup-compose-dependencies-and-compiler

# The SDK folder. An ANDROID_HOME that you already set is kept, so an SDK you
# installed with Android Studio can be reused. Otherwise the SDK goes to
# ~/.local/android-sdk, a folder in your home directory that needs no sudo.
: "${ANDROID_HOME:=$HOME/.local/android-sdk}"
export ANDROID_HOME

# The Android version that the code is compiled against (compileSdk in
# app/build.gradle.kts). The SDK names this platform android-37.0.
ANDROID_PLATFORM='platforms;android-37.0'

# The build tools that aapt2, dx and the packager use. They version with the
# platform, so this is the 37.0.0 release.
ANDROID_BUILD_TOOLS='build-tools;37.0.0'

# The system image is the Android software that the emulator runs. "google_apis"
# is the image variant with the Google APIs; "x86_64" is the Intel CPU type.
# An Apple Silicon Mac needs an arm64 image instead (see the README).
ANDROID_IMAGE='system-images;android-36;google_apis;x86_64'

# The emulator device, created by install.sh with avdmanager. Its name is
# free to choose; the hardware profile pixel_6 is one of avdmanager's
# built-in device definitions (run: avdmanager list device).
AVD_NAME='hello-mobile'
AVD_DEVICE='pixel_6'

# The command-line tools zip holds sdkmanager and avdmanager. Build 15859902
# is the build that the official page lists for Mac. Mac Intel and Mac Apple
# Silicon have different zips, each with its own SHA-256 value.
CMDLINE_TOOLS_BUILD='15859902'
CMDLINE_TOOLS_URL_BASE='https://dl.google.com/android/repository'
CMDLINE_TOOLS_SHA256_MAC_X86_64='c5a6378ab5cf7e0d5701921405115befff13e9ff7417fb588389338f8bd050f3'
CMDLINE_TOOLS_SHA256_MAC_ARM64='835b62a26162b229b441d1f6d4680383815a270809eb33522c0d480fa5002c4e'

# The folders that the tools use. Adding them to PATH lets the scripts call
# sdkmanager, avdmanager, adb and emulator by name.
#   cmdline-tools/latest/bin  sdkmanager, avdmanager
#   platform-tools            adb (install apps, run commands on the device)
#   emulator                  the emulator program
PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
export PATH
