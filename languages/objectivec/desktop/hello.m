// hello.m — Objective-C desktop Hello World using AppKit
//
// AppKit is the macOS desktop application framework. It provides windows,
// views, controls and event handling. Every macOS GUI application uses
// AppKit (or SwiftUI, which runs on top of AppKit on macOS).
//
// The program follows the standard AppKit pattern:
//   1. Create an NSApplication instance.
//   2. Create an NSWindow with an NSViewController.
//   3. Add an NSTextField to display "Hello, World!".
//   4. Run the application event loop.
//
// Self-check: when the TF_VERIFY environment variable is 1, the program
// prints the label text to stdout, still opens the window, and quits after
// about 2 seconds, so a script can check the output without a person
// closing the window.

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Create the application instance.
        // NSApplication is the central object that manages the event loop,
        // menus, windows and the connection to the window server.
        NSApplication *app = [NSApplication sharedApplication];
        [app setActivationPolicy:NSApplicationActivationPolicyRegular];
        [app activateIgnoringOtherApps:YES];

        // Create a window (600x400, centered on screen).
        NSRect screenRect = [[NSScreen mainScreen] visibleFrame];
        NSRect windowRect = NSMakeRect(
            screenRect.origin.x + (screenRect.size.width - 600) / 2,
            screenRect.origin.y + (screenRect.size.height - 400) / 2,
            600, 400
        );
        NSWindow *window = [[NSWindow alloc]
            initWithContentRect:windowRect
            styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                      NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable
            backing:NSBackingStoreBuffered
            defer:NO];
        [window setTitle:@"Hello, World!"];
        [window makeKeyAndOrderFront:nil];

        // Create a text field to display the greeting.
        NSTextField *label = [[NSTextField alloc]
            initWithFrame:NSMakeRect(150, 170, 300, 60)];
        [label setStringValue:@"Hello, World!"];
        [label setBezeled:NO];
        [label setDrawsBackground:NO];
        [label setEditable:NO];
        [label setSelectable:NO];
        [label setAlignment:NSTextAlignmentCenter];
        [label setFont:[NSFont boldSystemFontOfSize:48]];
        // labelColor follows the light or dark appearance; black is unreadable
        // on a dark window.
        [label setTextColor:[NSColor labelColor]];
        [[window contentView] addSubview:label];

        // Self-check (TF_VERIFY=1): print the label text, then quit after ~2 s.
        // fflush sends the line before the app exits; terminate: ends the
        // event loop and the process.
        const char *verify = getenv("TF_VERIFY");
        if (verify != NULL && strcmp(verify, "1") == 0) {
            printf("%s\n", [[label stringValue] UTF8String]);
            fflush(stdout);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                           dispatch_get_main_queue(), ^{
                [app terminate:nil];
            });
        }

        // Run the application event loop.
        // This blocks until the last window is closed.
        [app run];
    }
    return 0;
}
