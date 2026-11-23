# Swift · desktop: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Swift](../README.md)

## What this is
A macOS desktop application that opens a window showing "Hello, World!"
in large title text. Built with SwiftUI, Apple's declarative UI framework.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Swift (swiftc) | 6.3.2 | Compiles Swift source with SwiftUI |
| macOS SDK | 26 (Tahoe) | Provides AppKit and SwiftUI frameworks |

## Quick start
```sh
./install.sh   # check the toolchain
./build.sh     # compile hello.swift → hello
./run.sh       # open the window
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that this is macOS and that `swiftc` (Swift 5 or later) is available; offers to install the Command Line Tools | SwiftUI requires Apple platform SDKs; it does not run on Linux or Windows |
| `build.sh` | Runs `swiftc -parse-as-library hello.swift -o hello` | Compiles the SwiftUI app into a Mach-O executable linked against AppKit and SwiftUI |
| `run.sh` | Runs `./hello`, which opens the window until you quit the app. `--verify` runs it with `TF_VERIFY=1`: the app prints `Hello, World!` and closes after about 2 seconds | The self-check confirms the output without a person closing the window |

## Folder structure
```text
desktop/
├── README.md      this file
├── install.sh     checks the Swift toolchain and macOS
├── build.sh       compiles hello.swift
├── run.sh         runs the program
├── screenshot.png the window, for "Expected output" below
└── hello.swift    the SwiftUI source code
```
Layout reference: [SwiftUI App protocol](https://developer.apple.com/documentation/swiftui/app)

## Step-by-step walkthrough

1. **`import SwiftUI`** — imports the SwiftUI framework. This gives access
   to `View`, `App`, `Text`, `WindowGroup`, and all SwiftUI primitives.
   Compare with Java's `import javafx.application.Application` or
   Python's `import tkinter`.
   `import AppKit` gives access to `NSApplication`, which the self-check
   (step 6) uses to quit the app.

2. **`@main struct HelloWorldApp: App`** — the `@main` attribute marks
   this struct as the application entry point. The compiler generates
   `main()` that creates an `NSApplication` and hosts the SwiftUI content.
   The `App` protocol requires a `body` property returning `some Scene`.
   Compare with C#'s `static void Main()` or Go's `func main()`.

3. **`WindowGroup { ContentView() }`** — declares a window containing
   the `ContentView`. `WindowGroup` manages the window lifecycle (opening,
   closing, multiple instances). Compare with JavaFX's `Stage` or
   C++ Qt's `QMainWindow`.

4. **`struct ContentView: View`** — a SwiftUI view is a struct conforming
   to the `View` protocol. Its `body` property describes the UI hierarchy
   using a declarative syntax. Compare with React's JSX or Vue templates.

5. **`Text("Hello, World!")`** — creates a text view displaying the string.
   `.font(.largeTitle)` applies a system font at the large title size.
   `.frame(width:300, height:200)` sets the view's dimensions.

6. **`ProcessInfo.processInfo.environment["TF_VERIFY"]`** — a self-check:
   `./run.sh --verify` starts the app with `TF_VERIFY=1`. The app prints
   `Hello, World!` to stdout, opens the window, and quits after about
   2 seconds with `NSApplication.shared.terminate(nil)`. This lets a script
   check the output without a person closing the window.

## Why this toolchain
SwiftUI is Apple's modern UI framework, introduced at WWDC 2019. It uses
a declarative syntax similar to React or Jetpack Compose, where you describe
what the UI should look like, and the framework handles the rendering.
SwiftUI runs on all Apple platforms (iOS, macOS, watchOS, tvOS) with a
shared API.

Source: [SwiftUI — developer.apple.com](https://developer.apple.com/xcode/swiftui/)

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-19) | Swift 6.3.2, SwiftUI via Xcode CLI tools |
| macOS Apple Silicon | ⚠️ not verified | Same commands; SwiftUI is native on Apple Silicon |
| Linux (Debian/Ubuntu) | ❌ not available | SwiftUI requires Apple platform SDKs |
| Windows (Git Bash / WSL) | ❌ not available | SwiftUI requires Apple platform SDKs |

## Expected output
A macOS window titled "hello" (the name of the executable) showing
"Hello, World!" in large title text. The text view is 300×200 points; the
window around it can be larger.

![The window titled "hello" showing the text "Hello, World!"](screenshot.png)

(Taken on 2026-11-19 on macOS Intel with `screencapture -x -o -l <window-id> screenshot.png`,
which captures only that window. It needs the Screen & System Audio
Recording permission in System Settings → Privacy & Security. The window is gray at the
top because it is not the active window while the screenshot is taken.)

## Sources
1. SwiftUI documentation. Apple Inc. [developer.apple.com/xcode/swiftui](https://developer.apple.com/xcode/swiftui/) (accessed 2026-11-06)
2. The Swift Programming Language (Swift 6). Apple Inc. [docs.swift.org/latest/documentation/the-swift-programming-language](https://docs.swift.org/latest/documentation/the-swift-programming-language/) (accessed 2026-11-06)
3. @main attribute. Swift documentation. [docs.swift.org/latest/documentation/the-swift-programming-language/attributes](https://docs.swift.org/latest/documentation/the-swift-programming-language/attributes/) (accessed 2026-11-06)
