// hello.swift — Swift desktop Hello World using SwiftUI
//
// SwiftUI is Apple's declarative UI framework, introduced at WWDC 2019.
// It lets you describe your interface as a hierarchy of views, and the
// system handles layout, rendering and state management.
//
// On macOS, SwiftUI runs inside an AppKit application. The @main attribute
// tells the compiler to generate the application entry point, which creates
// the AppKit NSApplication and hosts the SwiftUI content.
//
// For the self-check, the init() method of the @main struct reads the
// TF_VERIFY environment variable. When it is 1, the app prints the label
// text to stdout, still opens the window, and quits after about 2 seconds,
// so a script can check the output without a person closing the window.

import AppKit
import SwiftUI

@main
struct HelloWorldApp: App {
    // Self-check (TF_VERIFY=1): print the label text, then quit after ~2 s.
    init() {
        if ProcessInfo.processInfo.environment["TF_VERIFY"] == "1" {
            print("Hello, World!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // terminate(_:) ends the process with exit(), which also
                // flushes the printed line to stdout.
                NSApplication.shared.terminate(nil)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.largeTitle)
            .frame(width: 300, height: 200)
    }
}
