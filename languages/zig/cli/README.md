# Zig · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Zig](../README.md)

## What this is
A command-line program, written in Zig, that prints one line:
`Hello, World!`. The compiler command `zig build-exe` turns `hello.zig`
into a native executable, `build/hello` [1][2]. The program writes to standard
output (stdout), so a pipe such as `./run.sh | cat` receives the line.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Zig | 0.17.0 (official tarball from ziglang.org) | compiles `hello.zig` to a native program; the tarball also holds the standard library |
| `curl`, `shasum`, `tar` | from macOS | `install.sh` downloads the tarball, checks its SHA-256 digest, and unpacks it (only if Zig is missing) |

The Zig project publishes the URL and SHA-256 digest of every tarball in its
download index. For `0.17.0` / `x86_64-macos` the index lists
`4f9a1c5269aa17ebda5e6d3c2b89d6cbf36f7d2b22a0306e9ab98f25f95529c6` [3].
`zig-env.sh` pins the same digest, and `install.sh` checks the download
against it. The download page also lists a minisign signature for each file [4];
this folder checks the SHA-256 digest only.

## Quick start
```sh
./install.sh   # check / install Zig 0.17.0 (asks before downloading)
./build.sh     # compile hello.zig to build/hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `zig` is in `~/.local/zig-x86_64-macos-0.17.0`. If not, asks, then downloads the tarball, checks its SHA-256 digest, and unpacks it there. Never uses `sudo` | the program cannot be built without the compiler; a folder in your home directory needs no administrator rights |
| `zig-env.sh` | Sourced by the other scripts: version, URL, digest, install folder, `PATH` | the three scripts then find the same compiler whatever your shell `PATH` is |
| `build.sh` | Runs `zig build-exe hello.zig -femit-bin=build/hello --cache-dir build/cache` | `-femit-bin` names the output file and `--cache-dir` keeps the compiler cache in `build/` [2] |
| `run.sh` | Runs `build/hello`. `--verify` runs the same check and exits by itself | `verify-all.sh` needs a command that prints `Hello, World!` and exits |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Zig from the official tarball
├── zig-env.sh     pinned version, URL, SHA-256, install folder (sourced)
├── build.sh       compiles hello.zig
├── run.sh         runs build/hello
├── hello.zig      the program
└── build/         generated files, ignored by git
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).
A single Zig file builds with `zig build-exe hello.zig` [1]. Larger Zig
projects use `build.zig`; this program does not need it.

## Step-by-step walkthrough
1. **`const std = @import("std");`** `@import` is a built-in function:
   built-in functions start with `@` and are provided by the compiler [1].
   `"std"` names the standard library. `const` binds a name that does not
   change; the language reference prefers `const` over `var` [1].
2. **`pub fn main(init: std.process.Init) !void`** is the entry point. `pub`
   makes the function visible outside the file. In Zig 0.17.0, the startup code
   passes `init`, a value whose fields include `io`, `gpa`, `arena`, and
   `environ_map` [5]. The `!` in `!void` marks an error union: `main` returns
   nothing or returns an error [1]. Compare [C](../../c/README.md), where `main`
   takes no such argument.
3. **`std.Io.File.stdout()`** is the standard output file. **`writeStreamingAll`**
   writes every byte of the text; it takes `init.io` as its second argument [1][5].
   Zig makes the program pass the `Io` value to any code that does input or output.
4. **`"Hello, World!\n"`** ends with `\n`, the newline character. This call does
   not add one.
5. **`try`** returns the error from `main` when the write fails.
6. **`std.debug.print`** is the other way to print in the language reference,
   and it writes to standard error (stderr), not stdout [1]. This program does not
   use it.
7. **Compare** the other languages in [comparisons](../../../docs/comparisons.md).

## Why this toolchain
- `zig build-exe` is the compiler command of the Zig distribution. The language
  reference builds its Hello World with `zig build-exe hello.zig` [1].
- The tarball needs no installer: it holds the `zig` program and its standard
  library [3][4]. This is the Zig project's own distribution, so `install.sh`
  needs no package manager.
- Zig 0.17.0 is dated 2026-10-01 in the download index, and 0.17.1 is dated
  2026-11-02 [3]. This folder pins 0.17.0, the version whose documentation
  the source was checked against.
- The default optimization mode of `zig build-exe` is Debug: its help lists
  `-O` with "debug (default)" [2].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-12) | Zig 0.17.0 from the official tarball; `install.sh`, `build.sh`, `run.sh`, and `run.sh --verify` |
| macOS Apple Silicon | ⚠️ not verified | the pinned tarball is for Intel; the download index lists other tarballs [3]; the scripts were not run there |
| Linux (Debian/Ubuntu) | ⚠️ not verified | same: `install.sh` stops with a message; not run there |
| Windows (Git Bash / WSL) | ⚠️ not verified | not run; see the download page [4] |

## Expected output
Run these commands in this folder:
```sh
./build.sh
./run.sh
```
`./run.sh` prints one line after its step messages and exits with status 0:
```text
==> Run the program
    WHY: build/hello is the native program that build.sh made from hello.zig.
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. Zig Language Reference 0.17.0. Zig Software Foundation. <https://ziglang.org/documentation/0.17.0/> (accessed 2026-11-12)
2. `zig build-exe --help`, Zig 0.17.0 (options `-femit-bin`, `--cache-dir`, `-O`). Zig Software Foundation. Output of the installed compiler (run 2026-11-12)
3. Zig download index (JSON): tarballs, SHA-256 digests, dates. Zig Software Foundation. <https://ziglang.org/download/index.json> (accessed 2026-11-12)
4. Download & Documentation. Zig Software Foundation. <https://ziglang.org/download/> (accessed 2026-11-12)
5. Zig standard library 0.17.0 (`std.process.Init`, `std.Io.File.writeStreamingAll`). Zig Software Foundation. <https://ziglang.org/documentation/0.17.0/std/> (accessed 2026-11-12)
