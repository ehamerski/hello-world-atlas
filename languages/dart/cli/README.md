# Dart · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Dart](../README.md)

## What this is

A command-line program that prints `Hello, World!` to standard output. It uses only the Dart standard library, no framework or third-party package.

## Prerequisites

| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Dart SDK | 3.13.7 (verified 2026-11-06) | The Dart VM runs hello.dart directly |

## Quick start

```sh
./install.sh   # check / install the Dart SDK (asks before installing)
./run.sh       # run it
```

## Scripts explained

| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for the `dart` command; installs via Homebrew or APT if missing, asking before each step | The Dart VM is needed to run hello.dart |
| `run.sh` | Runs `dart hello.dart` (`--verify` does the same) | Compiles and executes the program in one step |

## Folder structure

```text
cli/
├── README.md      this file
├── install.sh     checks / installs the Dart SDK
├── run.sh         runs the program
└── hello.dart     the source code
```

Layout reference: [The Dart language](https://dart.dev/language) — a single `.dart` file is a complete program.

## Step-by-step walkthrough

1. **`void main()`** — Every Dart program must have a `main` function. It is the entry point, analogous to `int main()` in C or `public static void main(String[] args)` in Java. Dart does not require a return type annotation (`void`), but it is good practice. Reference: [The main() function](https://dart.dev/language/functions#the-main-function).

2. **`print('Hello, World!');`** — `print` is a top-level function in `dart:core`, which is imported automatically. It converts its argument to a string, writes it to standard output, and appends a newline. Unlike C's `printf`, it does not require a format string for simple output.

## Why this toolchain

The Dart SDK (dart.dev) is the official distribution from Google. It includes the Dart VM for running programs, the `dart` command-line tool, and the front-end compiler, which `dart compile kernel` also exposes. For a simple cli program, no additional tools are needed. The SDK is available for macOS, Linux, and Windows. Reference: [Get Dart](https://dart.dev/get-dart).

## Platform notes

| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-06) | Dart SDK 3.13.7, Homebrew `dart-sdk` |
| macOS Apple Silicon | ⚠️ not verified | Homebrew `dart-sdk` provides arm64 builds |
| Linux (Debian/Ubuntu) | ⚠️ not verified | APT repository from Google |
| Windows (Git Bash / WSL) | ⚠️ not verified | `winget install --id Google.DartSDK` |

**Google's signing key is checked by fingerprint, not by digest.** On Linux,
`install.sh` saves the key for Google's APT repository to
`~/.cache/hello-world-dart/linux_signing_key.pub` and checks that its primary
key has the fingerprint Google publishes, `EB4C 1BFD 4F04 2F6D DDCC EC91 7721
F63B D38B 4796` [7], before it adds the key. Google publishes no digest of
the file, and it signs with periodically rotated subkeys of this key [7], so
the file changes over time.

## Expected output

```text
Hello, World!
```

## Sources

1. The Dart language. Dart Team, Google. <https://dart.dev/language> (accessed 2026-11-06)
2. The main() function. Dart Team, Google. <https://dart.dev/language/functions#the-main-function> (accessed 2026-11-06)
3. Get Dart. Dart Team, Google. <https://dart.dev/get-dart> (accessed 2026-11-06)
4. dart:core library. Dart Team, Google. <https://api.dart.dev/dart-core/dart-core-library.html> (accessed 2026-11-20)
7. Linux Software Repositories. Google. <https://www.google.com/linuxrepositories/> (accessed 2026-11-19)
