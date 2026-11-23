// hello.m — Objective-C command-line Hello World
//
// The simplest possible Objective-C program: one message send that prints
// "Hello, World!" to standard output.
//
// Objective-C is a superset of C. The `main()` function is the entry point,
// just like in C. The `@import Foundation` directive imports the Foundation
// framework, which provides `NSString` and `NSLog`.
//
// Unlike C's `printf()`, Objective-C uses `NSLog()` which adds a timestamp
// and newline automatically. For plain output without the timestamp,
// `[NSString UTF8String]` converts to a C string for `printf()`.
//
// The program is compiled with `clang` (the Clang compiler), which handles
// both C and Objective-C. The `-framework Foundation` flag links against
// the Foundation framework.

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    // Create an autorelease pool to manage memory.
    // With ARC (Automatic Reference Counting), the compiler inserts
    // retain/release calls, but the pool is still needed for
    // autoreleased objects in a command-line program.
    @autoreleasepool {
        // NSLog adds a timestamp and newline; for plain output we use
        // printf with the UTF-8 representation of the NSString.
        printf("%s\n", [[NSString stringWithFormat:@"Hello, World!"] UTF8String]);
    }
    return 0;
}
