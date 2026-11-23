// hello.swift — Swift iOS Hello World using SwiftUI
//
// SwiftUI is Apple's declarative UI framework, introduced at WWDC 2019.
// The same View code runs on iOS, iPadOS, macOS, watchOS, tvOS and visionOS,
// so this file is close to the desktop version in ../../desktop/hello.swift.
// The differences are the platform: an iOS app is started by iOS, not by a
// command line, and it has no window that the user can resize.
//
// The @main attribute tells the compiler which type starts the app. On iOS,
// the system creates the process and calls this entry point, which hosts the
// SwiftUI scene inside UIKit.
//
// For the --verify self-check, the init() method checks CommandLine.arguments.
// `simctl launch ... --verify` passes that argument to the app, so the app
// prints the greeting and exits. CI can then read the output without looking
// at the screen.

import SwiftUI

@main
struct HelloWorldApp: App {
    // Self-check for --verify: print to stdout and exit, so run.sh can read
    // the output from `xcrun simctl launch --console-pty`.
    init() {
        if CommandLine.arguments.contains("--verify") {
            print("Hello, World!")
            exit(0)
        }
    }

    var body: some Scene {
        // A WindowGroup on iOS shows its content in the one full-screen scene.
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        // Text is a view; .font applies a Dynamic Type style, so the size
        // follows the user's accessibility settings.
        Text("Hello, World!")
            .font(.largeTitle)
    }
}
