# Start here

> Part of [Hello World in many languages](../README.md)

Every example in this repository is run the same way, on every operating
system: open a terminal in the example's folder and run its scripts. This
page shows how to get a terminal that can run them, and what the scripts do.

## 1. Get the code
- **One example:** on the website, open a language page and click
  **Download ZIP** next to the example. Unzip it. The ZIP keeps the paths of
  the repository, so the example is in `languages/<language>/<category>/`
  inside the unzipped folder, next to the shared `scripts/common.sh`.
- **Everything:** clone the repository with Git.

## 2. Open a terminal that runs `sh` scripts
The scripts are POSIX `sh` scripts ([CONTRIBUTING.md](../CONTRIBUTING.md#script-contract)).

| System | Terminal | Status |
|---|---|---|
| macOS (Intel) | Terminal (in Applications → Utilities) | verified: the development machine |
| macOS (Apple Silicon) | Terminal | documented, not verified |
| Linux | any terminal | verified in CI on Ubuntu on 2026-11-06 for the implementations that existed then; newer ones not verified in CI ([Platform support](platform-support.md#linux-and-windows-in-ci)) |
| Windows | **Git Bash**, which comes with [Git for Windows](https://gitforwindows.org/), or a Linux shell in [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) | Git Bash: verified in CI on 2026-11-06 for the implementations that existed then; newer ones not verified in CI. WSL: documented, not verified. Each README also lists the native Windows commands |

### What each system uses to install a toolchain
`install.sh` shows the install command for the system it runs on:

| System | Package manager the scripts use | Notes |
|---|---|---|
| macOS | [Homebrew](https://brew.sh/) | Some tools come from the vendor instead, when no Homebrew package exists or the version differs; the README of each example says which (for example Zig, Julia and Racket are unpacked from the official download into `~/.local`). |
| Debian and Ubuntu | `apt` | The README's **Platform notes** give the package names. |
| Windows (Git Bash) | `winget` and each vendor's installer | Each README also lists the native Windows commands. |

Some languages take much longer to install than others, because a package
is built from source or is large: QCL, OCaml and R (built from source here)
and the Android SDK are examples. Read the **Prerequisites** of the README
before you answer yes; `install.sh` always asks first.

## 3. Run the three scripts
```sh
cd languages/<language>/<category>   # e.g. languages/python/cli
./install.sh                         # check the toolchain; asks before installing anything
./build.sh                           # compile (compiled languages only)
./run.sh                             # run it
```
- `install.sh` checks whether the toolchain is there. When something is
  missing, it shows the install command for your system (for example with
  [Homebrew](https://brew.sh/) on macOS or `apt` on Debian and Ubuntu) and
  asks before it runs it. If you say no, it only prints the command. It never
  runs `sudo` without showing it first.
- `build.sh` exists only where the language is compiled.
- `run.sh` prints `Hello, World!` (cli), opens a window (desktop), or starts
  a web server on `http://localhost:8080/` (web; change it with `PORT=...`).

Every script says what it does and why while it runs. Each example's README
explains the code step by step ("Step-by-step walkthrough") and has
"Platform notes" for each operating system.

## 4. The categories and what they open
The folder name tells what `run.sh` does:

| Folder (category) | `run.sh` | Extra to know |
|---|---|---|
| `cli` | prints `Hello, World!` in the terminal | nothing else needed |
| `desktop` | opens a window | needs a graphical session (on Linux, a display) |
| `web`, `web-*` | starts a server on `http://localhost:8080/` (a front end on another port, see [Comparisons](comparisons.md#web-with-a-separate-front-end)) | stop it with Ctrl+C |
| `mobile-*` | starts a virtual phone and runs the app on it | needs the Android SDK or Xcode: see section 5 |

## 5. Mobile apps: Android SDK and Xcode
The three `mobile` examples ([`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md),
[`dart/mobile-flutter`](../languages/dart/mobile-flutter/README.md) and
[`swift/mobile-ios`](../languages/swift/mobile-ios/README.md)) run on a
**virtual device**, so they need more than a compiler.

**Android** (Kotlin with Jetpack Compose, and Dart with Flutter)
- You need a JDK and the **Android SDK**: the command-line tools, a platform,
  build-tools, the emulator and a system image. `install.sh` checks each one
  and asks before it downloads anything.
- If you already have an SDK, for example from Android Studio, set
  `ANDROID_HOME` to its folder before you run `./install.sh`; the script then
  uses it ([`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md)).
  Without it, the SDK goes to `~/.local/android-sdk`.
- The SDK and the emulator are the largest part of that folder
  ([`kotlin/mobile-android`](../languages/kotlin/mobile-android/README.md)).
- The system image has to match your CPU. The scripts name the Intel
  (`x86_64`) image, which is what the verified Mac uses. On an Apple Silicon
  Mac the image and the command-line tools must be the arm64 ones, so the
  README marks that platform **not verified** and says what to change.
- On Linux the emulator uses KVM, and on Windows it needs a hypervisor; both
  are **not verified** for these folders (see the **Platform notes** of each
  README).

**iOS** (Swift with SwiftUI)
- You need a **Mac** with the **full Xcode app**, from the Mac App Store or
  [developer.apple.com/xcode](https://developer.apple.com/xcode/). The Command
  Line Tools alone do not include the iOS SDK or the Simulator
  ([`swift/mobile-ios`](../languages/swift/mobile-ios/README.md#what-this-is)).
- `install.sh` only **checks** for Xcode, the iOS Simulator SDK and
  `simctl`. It never installs Xcode: you do that yourself, and you may need
  to install an iOS Simulator runtime in Xcode.
- The app runs in the iOS Simulator, not on a real phone.
- iOS cannot be built on Linux or Windows.

On what has actually been run where, read [Platform support](platform-support.md).

## 6. Where to go next
- New to programming? Follow the
  [guided path through the walkthroughs](comparisons.md#a-guided-path-through-the-walkthroughs).
- Curious about the ideas behind the languages? Read the
  [paradigms](paradigms.md).
