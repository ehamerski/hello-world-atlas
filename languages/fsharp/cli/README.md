# F# · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [F#](../README.md)

## What this is
A console program, written in F# 10, that prints one line: `Hello, World!`.
The .NET SDK compiles it to Common Intermediate Language (CIL), and the .NET
runtime runs it [1][4].

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| .NET SDK (`dotnet`) | 10.0.404 (channel 10.0, installed into `~/.dotnet`) | compiles and runs F#; F# 10 ships with .NET 10 [7] |
| `curl`, `shasum` | macOS system tools | download and check Microsoft's `dotnet-install.sh` (only if the SDK is missing) [5] |

## Quick start
```sh
./install.sh   # check / install the .NET 10 SDK (asks before installing)
./build.sh     # compile hello.fs into build/hello.dll
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for an SDK 10 or newer. If it is missing, downloads `dotnet-install.sh`, checks its SHA-256 digest, and runs it with `--channel 10.0` into `~/.dotnet`. It asks first and never uses `sudo` | F# is compiled by the .NET SDK |
| `dotnet-env.sh` | Sets the digest, the install folder, and `PATH`, and turns telemetry off (sourced, not run) | shared by all three scripts, so they find `dotnet` without your shell `PATH` |
| `build.sh` | Runs `dotnet build hello.fsproj --configuration Debug -o build` | writes `build/hello.dll` [4] |
| `run.sh` | Runs `dotnet build/hello.dll`. `--verify` runs the same command and exits | `verify-all.sh` needs a command that prints `Hello, World!` and exits |

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / installs the .NET 10 SDK
├── dotnet-env.sh    install folder, digest, telemetry settings (sourced)
├── build.sh         dotnet build -o build
├── run.sh           dotnet build/hello.dll
├── hello.fs         the program
├── hello.fsproj     the project file (Microsoft.NET.Sdk, net10.0)
├── build/           build output, ignored by git
└── obj/             intermediate files, ignored by git
```
Layout reference: [F# project and console application structure](https://learn.microsoft.com/dotnet/fsharp/get-started/get-started-command-line), Microsoft Learn [6].

## Step-by-step walkthrough
`hello.fs` in order:

1. **`printfn "Hello, World!"`** is the whole program. The compiler runs the
   statements at the top level of the last file from the first line to the
   last. This is the implicit entry point [2].
2. **`printfn`** writes the text and a line break. The `f` stands for
   format: F# checks the format string against its arguments when it
   compiles [3].
3. The call has no parentheses and no semicolon. A function name followed by
   a value applies the function to the value.

`hello.fsproj` has one `Compile` item, `hello.fs`, and sets
`OutputType` to `Exe`, `TargetFramework` to `net10.0`, and `AssemblyName` to
`hello`. The assembly name decides the file name `hello.dll`.

Differences from the other .NET folders in this repository:

- [Visual Basic](../../visual-basic/cli/README.md) needs `Module Program` and
  `Sub Main()`. F# needs neither.
- F# also has an explicit entry point: the `EntryPoint` attribute on a
  function that takes the arguments and returns the exit code [2]. A program
  that needs arguments or an exit code uses it.
- The F# project file lists its source files in a `Compile` item. The
  [Visual Basic](../../visual-basic/cli/vbcli.vbproj) project file has no such
  list.
- The compiler wraps the file in a module named after the file [8].

See the comparison of languages in [docs/comparisons.md](../../../docs/comparisons.md).

## Why this toolchain
- F# is part of the .NET SDK: F# 10 ships with .NET 10 and Visual Studio
  2026 [7]. .NET 10 is the current long-term support (LTS) release, and its
  latest SDK is 10.0.404 [9]. One SDK builds F#, C#, and Visual Basic, so the install step is
  the same as in the other .NET folders [5].
- The `dotnet new console -lang "F#"` command creates an F# console project
  with a `Program.fs` file and an `.fsproj` file [6]. This folder uses the
  same two kinds of file, named `hello.fs` and `hello.fsproj`.
- `dotnet build` compiles the project into a `.dll` file of IL code, with
  a `.runtimeconfig.json` file that names the runtime [4]. `run.sh` passes
  that `.dll` to `dotnet`.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-20) | .NET SDK 10.0.404; `install.sh` (SDK present), `build.sh`, `run.sh`, and `run.sh --verify` run from a clean shell |
| macOS Apple Silicon | ⚠️ not verified | the .NET SDK supports it; not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` uses the same script; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` points to `winget install --id Microsoft.DotNet.SDK.10 -e`; not run |

## Expected output
Run `./run.sh` after `./build.sh`. The program prints one line and exits with
status 0:

```text
Hello, World!
```
`./run.sh` also prints its own step lines before the program output.

## Sources
1. F# documentation. Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/> (accessed 2026-11-11)
2. Console applications and explicit entry points. F# language reference. Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/language-reference/functions/entry-point> (accessed 2026-11-11)
3. Plain text formatting. F# language reference. Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/language-reference/plaintext-formatting> (accessed 2026-11-11)
4. `dotnet build` command. .NET CLI. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-build> (accessed 2026-11-11)
5. `dotnet-install` scripts. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script> (accessed 2026-11-11)
6. Get started with F# with command-line tools. Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/get-started/get-started-command-line> (accessed 2026-11-11)
7. "What's new in F# 10". Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/whats-new/fsharp-10> (accessed 2026-11-11)
8. Modules. F# language reference. Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/language-reference/modules> (accessed 2026-11-11)
9. Microsoft .NET release index (release metadata: channel, latest SDK, release type). Microsoft. <https://builds.dotnet.microsoft.com/dotnet/release-metadata/releases-index.json> (accessed 2026-11-20)
