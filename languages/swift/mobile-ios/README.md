# Swift · mobile-ios: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Swift](../README.md)

## What this is
An iPhone app that shows "Hello, World!" in large text on the Simulator's
screen. Built with SwiftUI, Apple's declarative UI framework, the same one
as [../desktop](../desktop/). The app runs in the iOS Simulator, which is
part of Xcode, not on a real phone.

**Verification status.** On the maintainer's Mac (macOS 26, Intel, Xcode
26.5, iOS 26.5 Simulator runtime installed), `install.sh`, `build.sh` and
`run.sh --verify` pass, and the screenshot below comes from that run. The
same steps also pass on a GitHub Actions Apple Silicon macOS runner through
[`.github/workflows/ios.yml`](../../../.github/workflows/ios.yml).

**What a student needs.** A Mac with a current Xcode, from the Mac App
Store or [developer.apple.com/xcode](https://developer.apple.com/xcode/).
Command Line Tools alone do not include the iOS SDK or the Simulator.

## Prerequisites
| Tool | Version used (CI runner) | Why it is needed |
|---|---|---|
| Xcode (full app) | the default on the `macos-26` image; the job prints it | Provides `xcodebuild`, the iOS SDK and the Simulator |
| iOS Simulator runtime | the one the image provides; `install.sh` checks for it | Runs the app as an iPhone would |
| Swift (`swiftc`) | the one shipped with that Xcode | Compiles `hello.swift` |

## Quick start
```sh
./install.sh   # check Xcode, the iOS Simulator SDK and simctl (installs nothing)
./build.sh     # compile hello.swift into HelloWorld.app
./run.sh       # boot a Simulator, install the app and launch it
```
To run only the self-check that CI uses: `./run.sh --verify`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks macOS, full Xcode, the `iphonesimulator` SDK, `simctl` and `swiftc` | An iOS app can be built only with the SDK that comes with Xcode; the script says what is missing and never installs it |
| `build.sh` | Compiles `hello.swift` for the Simulator, copies `Info.plist` and signs the bundle | An iOS app is a bundle with an `Info.plist`; the script builds that bundle without an Xcode project |
| `run.sh` | Boots the first iPhone Simulator, installs and launches the app. `--verify` checks that the app prints `Hello, World!` and exits | The app needs a running Simulator; `--verify` lets CI check the output without a person looking at the screen |

## Folder structure
```text
mobile-ios/
├── README.md      this file
├── install.sh     checks Xcode and the Simulator (never installs)
├── build.sh       compiles hello.swift into HelloWorld.app
├── run.sh         boots the Simulator, installs and launches the app
├── hello.swift    the SwiftUI source code
├── Info.plist     the bundle description (name, identifier, minimum iOS)
└── .gitignore     keeps the built HelloWorld.app out of git
```
Layout reference: [Placing content in a bundle](https://developer.apple.com/documentation/bundleresources/placing-content-in-a-bundle)
and [Information Property List](https://developer.apple.com/documentation/bundleresources/information-property-list).

## Step-by-step walkthrough

1. **`import SwiftUI`** imports the framework, as in the desktop version.
   The same `View` code runs on iOS and macOS.

2. **`@main struct HelloWorldApp: App`**: the `@main` attribute marks the
   entry point. On iOS the system starts the process; the app does not get
   a command line from a shell. Compare with the desktop version, where the
   same attribute starts an AppKit application.

3. **`init()` with `CommandLine.arguments`**: `simctl launch ... --verify`
   passes `--verify` to the app. The app prints the greeting and calls
   `exit(0)`. The desktop version uses the same self-check.

4. **`WindowGroup { ContentView() }`**: on iOS the group fills the one
   full-screen scene. There is no window to resize.

5. **`Text("Hello, World!").font(.largeTitle)`**: `.largeTitle` is a
   Dynamic Type style, so the text size follows the user's accessibility
   setting. The desktop version sets a fixed frame instead.

6. **`build.sh` compiles with `xcrun --sdk iphonesimulator swiftc`**: the
   `xcrun` tool picks the Simulator SDK, and the `-simulator` target suffix
   builds for the Simulator rather than for a device. The desktop version
   needs no SDK choice because the Mac is the target.

7. **`Info.plist`** names the executable (`HelloWorld`), the bundle
   identifier (`com.example.helloworld.swift`) and the lowest iOS version
   (17.0). iOS installs nothing that lacks these keys.

## Why this toolchain
SwiftUI is Apple's UI framework for all of its platforms, and Xcode is the
official IDE and build tool for iOS. Apple documents the Simulator as the
way to run an app without a device, in the Xcode documentation
(see Sources). Using `swiftc` and `simctl` directly keeps every step of the
build visible in this folder. A student who later opens the app in Xcode
will find the same source and bundle layout.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Apple Silicon, CI runner (`macos-26`) | ✅ verified (2026-11-12) | `ios.yml` runs `install.sh`, `build.sh` and `run.sh --verify` on the arm64 runner image and uploads a Simulator screenshot |
| macOS Intel (maintainer's Mac, macOS 26, Xcode 26.5) | ✅ verified (2026-11-12) | `install.sh`, `build.sh` and `run.sh --verify` pass on the x86_64 iOS 26.5 Simulator; the screenshot is from this Mac |
| macOS with current Xcode (student) | ⚠️ not verified | Expected to work with the same commands; not tested |
| Linux (Debian/Ubuntu) | ❌ not available | iOS SDK and Simulator exist only in Xcode on macOS |
| Windows (Git Bash / WSL) | ❌ not available | iOS SDK and Simulator exist only in Xcode on macOS |

## Expected output
`./run.sh --verify` prints:
```text
==> Run the program (verify mode)
    WHY: --console-pty sends the app's output here; --verify makes the app print and exit.
Hello, World!
com.example.helloworld.swift: 2733
[ok] run.sh --verify: Hello, World! printed by the app
```
`./run.sh` (without `--verify`) launches the app and opens the Simulator
window. The screenshot below was taken on an iPhone 17 Simulator (iOS 26.5):

![Simulator screenshot of the app](screenshot.png)

## Sources
1. SwiftUI. Apple Inc. [developer.apple.com/xcode/swiftui](https://developer.apple.com/xcode/swiftui/) (accessed 2026-11-11)
2. Running your app on simulated or physical devices. Apple Inc. [developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device) (accessed 2026-11-11)
3. Information Property List. Apple Inc. [developer.apple.com/documentation/bundleresources/information-property-list](https://developer.apple.com/documentation/bundleresources/information-property-list) (accessed 2026-11-11)
4. Xcode. Apple Inc. [developer.apple.com/xcode](https://developer.apple.com/xcode/) (accessed 2026-11-11)
5. The Swift Programming Language (Swift 6). Apple Inc. [docs.swift.org/latest/documentation/the-swift-programming-language](https://docs.swift.org/latest/documentation/the-swift-programming-language/) (accessed 2026-11-11)
6. GitHub-hosted runners: macOS labels (`macos-26`). GitHub [docs.github.com/en/actions/reference/runners/github-hosted-runners](https://docs.github.com/en/actions/reference/runners/github-hosted-runners) (accessed 2026-11-11)
7. Runner images: the Xcode versions installed. The project [actions/runner-images](https://github.com/actions/runner-images) (accessed 2026-11-11)
8. About billing for GitHub Actions: minutes per runner type. GitHub [docs.github.com/en/billing/concepts/product-billing/github-actions](https://docs.github.com/en/billing/concepts/product-billing/github-actions) (accessed 2026-11-11)
