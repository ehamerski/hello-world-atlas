# Swift · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Swift](../README.md)

## What this is
A command-line program that prints `Hello, World!` to standard output.
The source is a single Swift file compiled with `swiftc` into a native
executable.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Swift (swiftc) | 6.3.2 | Compiles Swift source to native code |

## Quick start
```sh
./install.sh   # check the toolchain
./build.sh     # compile hello.swift → hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `swiftc` (Swift 5 or later) is available and offers to install it | Swift is preinstalled on macOS with Xcode; on Linux it must be installed separately |
| `build.sh` | Runs `swiftc hello.swift -o hello` | Swift is compiled; the source must become a native executable before running |
| `run.sh` | Runs `./hello` (compiles first if needed); `--verify` checks output | The `--verify` flag confirms the program prints the expected string |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks the Swift toolchain
├── build.sh       compiles hello.swift
├── run.sh         runs the program
└── hello.swift    the source code
```
Layout reference: [Swift compiler driver](https://github.com/swiftlang/swift/blob/main/docs/Driver.md)

## Step-by-step walkthrough

1. **`print("Hello, World!")`** — the whole program. Code at global
   scope is the entry point, so there is no `main()` function. `print` is
   part of the Swift standard library (the module named `Swift`), which
   every Swift file imports automatically, so the file has no `import`
   line. Its parameter is `Any...`: it takes any number of values of any
   type and writes their text, followed by a newline. The string literal
   `"Hello, World!"` is inferred as `String`. Compare with C's `printf()`,
   which needs `#include <stdio.h>`, or Java's `System.out.println()`.

2. **`swiftc hello.swift -o hello`** (in `build.sh`) — compiles the file
   into a native executable. On macOS it is linked dynamically against
   `/usr/lib/swift/libswiftCore.dylib`, the Swift standard library that
   ships with macOS since Swift 5. Run `otool -L hello` to see it.

## Why this toolchain
`swiftc` is the official Swift compiler, part of the Swift open-source
project. It produces native executables optimized for the target platform.
Since Swift 5 the ABI is stable on Apple platforms, so the Swift libraries
come with every macOS release instead of being copied into each program.

Source: [Swift 5 Released!](https://www.swift.org/blog/swift-5-released/)

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-19) | Swift 6.3.2 via Xcode CLI tools |
| macOS Apple Silicon | ⚠️ not verified | Swift is native on Apple Silicon; same commands apply |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Install Swift from swift.org; the Swift runtime must be available at runtime |
| Windows (Git Bash / WSL) | ⚠️ not verified | Run through WSL (Linux Swift) or MSYS2 |

## Expected output
```text
Hello, World!
```

## Sources
1. The Swift Programming Language (Swift 6), "A Swift Tour". Apple Inc. [docs.swift.org/latest/documentation/the-swift-programming-language/guidedtour](https://docs.swift.org/latest/documentation/the-swift-programming-language/guidedtour/) (accessed 2026-11-19)
2. Swift compiler driver. Swift project. [github.com/swiftlang/swift](https://github.com/swiftlang/swift/blob/main/docs/Driver.md) (accessed 2026-11-17)
3. Swift 5 Released! Ted Kremenek, Swift.org, 2019-03-25. [swift.org/blog](https://www.swift.org/blog/swift-5-released/) (accessed 2026-11-17)
4. Swift on Linux. Swift.org. [swift.org/install/linux](https://www.swift.org/install/linux/) (accessed 2026-11-06)
5. print(_:separator:terminator:). Apple Inc. [developer.apple.com/documentation/swift](https://developer.apple.com/documentation/swift/print(_:separator:terminator%3A%29) (accessed 2026-11-19)
