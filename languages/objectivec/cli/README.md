# Objective-C · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Objective-C](../README.md)

## What this is
A command-line program that prints `Hello, World!` to standard output.
The source is a single Objective-C file compiled with `clang` into a native
executable.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Clang | 21.0.0 (Apple clang) | Compiles Objective-C source to native code |
| Foundation framework | macOS system | Provides NSString and core Objective-C classes |

## Quick start
```sh
./install.sh   # check the toolchain
./build.sh     # compile hello.m → hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `clang` with Objective-C support is available | Clang ships with Xcode Command Line Tools on macOS |
| `build.sh` | Runs `clang hello.m -o hello -framework Foundation` | Objective-C is compiled; the source must become a native executable |
| `run.sh` | Runs `./hello` (compiles first if needed) | The executable links against Foundation at runtime |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks the Clang toolchain
├── build.sh       compiles hello.m
├── run.sh         runs the program
└── hello.m        the source code
```
Layout reference: [Clang user manual](https://clang.llvm.org/docs/UsersManual.html)

## Step-by-step walkthrough

1. **`#import <Foundation/Foundation.h>`** — imports the Foundation framework
   header. This is the Objective-C equivalent of C's `#include`. The `#import`
   directive (instead of `#include`) prevents double-inclusion automatically.
   Foundation provides `NSString`, `NSArray`, `NSDictionary` and other core
   classes. Compare with Java's `import java.lang.String` or Swift's
   `import Foundation`.

2. **`int main(int argc, const char * argv[])`** — the program entry point,
   identical to C's `main()`. Objective-C is a superset of C, so all C
   constructs are valid. The `argc` and `argv` parameters carry command-line
   arguments. Compare with Go's `func main()` or Python's `if __name__ ==
   "__main__"`.

3. **`@autoreleasepool { ... }`** — creates an autorelease pool. In
   Objective-C with ARC (Automatic Reference Counting), objects are
   automatically retained and released. Autoreleased objects are added to
   the current pool and released when the pool drains. In a command-line
   program, you must create the pool yourself (unlike GUI apps, where the
   framework creates it). Compare with C++'s RAII or Rust's scopes.

4. **`[NSString stringWithFormat:@"Hello, World!"]`** — creates an NSString
   using the class method `stringWithFormat:`. The square-bracket syntax is
   Objective-C's message-sending mechanism: `[receiver message:argument]`.
   This is equivalent to Swift's `String(format: "Hello, World!")` or
   Java's `String.format("Hello, World!")`.

5. **`[... UTF8String]`** — converts the NSString to a C `const char *`
   encoded in UTF-8. This allows passing the string to C's `printf()`.
   Compare with Swift's `String.utf8` or Java's
   `String.getBytes(StandardCharsets.UTF_8)`.

6. **`printf("%s\n", ...)`** — prints the string using C's standard I/O.
   We use `printf` instead of `NSLog` because `NSLog` adds a timestamp and
   is written to stderr, not stdout. Compare with C's `puts()` or Python's
   `print()`.

## Why this toolchain
Clang (part of the LLVM project) is the default C/C++/Objective-C compiler
on macOS. It was adopted by Apple as the default compiler in Xcode 4.1
(2011). Clang produces native Mach-O executables on macOS and ELF on Linux.
The Foundation framework provides the core Objective-C classes and is
preinstalled on macOS. On Linux, GNUstep provides a compatible Foundation
implementation, but it is not verified on this machine.

Sources: [Clang user manual](https://clang.llvm.org/docs/UsersManual.html),
[Foundation framework](https://developer.apple.com/documentation/foundation),
[GNUstep](https://www.gnustep.org/)

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-06) | Clang 21.0.0 via Xcode CLI tools |
| macOS Apple Silicon | ⚠️ not verified | Same commands; Clang is native on Apple Silicon |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Requires GNUstep for Foundation; `sudo apt install gnustep-devel` |
| Windows (Git Bash / WSL) | ⚠️ not verified | Run through WSL with GNUstep |

## Expected output
```text
Hello, World!
```

## Sources
1. Clang user manual. LLVM.org. [clang.llvm.org/docs/UsersManual.html](https://clang.llvm.org/docs/UsersManual.html) (accessed 2026-11-06)
2. Foundation framework. Apple Inc. [developer.apple.com/documentation/foundation](https://developer.apple.com/documentation/foundation) (accessed 2026-11-06)
3. Objective-C Programming Language. Apple Inc. [developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html) (accessed 2026-11-06)
4. GNUstep — Open-source Cocoa. [GNUstep](https://www.gnustep.org/) (accessed 2026-11-06)
