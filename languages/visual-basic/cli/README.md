# Visual Basic (VB.NET) · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Visual Basic (VB.NET)](../README.md)

## What this is
A console program, written in VB.NET, that prints one line: `Hello, World!`. The
.NET SDK compiles it to Common Intermediate Language (CIL), and the .NET runtime runs it.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| .NET SDK (`dotnet`) | 10.0.404 (channel 10.0, installed into `~/.dotnet`) | compiles and runs VB.NET |
| `curl`, `shasum` | macOS system tools | download and check Microsoft's `dotnet-install.sh` (only if the SDK is missing) |

## Quick start
```sh
./install.sh   # check / install the .NET 10 SDK (asks before installing)
./build.sh     # compile Program.vb to bin/Debug/net10.0/
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for an SDK 10 or newer. If it is missing, downloads `dotnet-install.sh`, checks its SHA-256 digest and runs it with `--channel 10.0` into `~/.dotnet` | VB.NET is compiled by the .NET SDK |
| `build.sh` | Runs `dotnet build --configuration Debug vbcli.vbproj` | writes the program into `bin/` |
| `run.sh` | Runs `dotnet run --no-build --project vbcli.vbproj`. `--verify` runs the same check and exits | `verify-all.sh` needs a command that prints `Hello, World!` and exits |
| `dotnet-env.sh` | Sets the digest, the install folder and `PATH`, and turns telemetry off (sourced, not run) | shared by all three scripts |

## Folder structure
```text
cli/
├── README.md          this file
├── install.sh         checks / installs the .NET 10 SDK
├── dotnet-env.sh      install folder, digest, telemetry settings (sourced)
├── build.sh           dotnet build
├── run.sh             dotnet run --no-build
├── Program.vb         the program (module Program, Sub Main)
├── vbcli.vbproj       the project file (Microsoft.NET.Sdk, net10.0)
├── bin/ and obj/      build output, ignored by git
```
Layout reference: the .NET project file format, [Microsoft Learn](https://learn.microsoft.com/dotnet/core/project-sdk/overview).

## Step-by-step walkthrough
`Program.vb` in order:

1. **`Module Program`** declares a module: VB.NET's container for code that is not
   tied to an object, like a class with only static members.
2. **`Sub Main()`** is the entry point of a console application. It runs first.
3. **`Console.WriteLine("Hello, World!")`** writes the text and a line end.
4. **`End Sub`** and **`End Module`** close the blocks. VB.NET uses words, not braces.

Differences from other languages in this repository: blocks end with words
(`End Sub`), and comments start with an apostrophe (`'`).

## Why this toolchain
- **VB.NET** is the current Visual Basic. It is compiled by the .NET SDK, and the
  SDK's `dotnet` command builds and runs it [1][2].
- **Visual Basic 6** (the classic language): its IDE is no longer supported, and its
  runtime is supported only on Windows, so it is not used here [3].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-20) | `install.sh` (SDK already present), `build.sh`, `run.sh --verify` |
| macOS Apple Silicon | ⚠️ not verified | the .NET SDK supports it; not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` uses the same script; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` points to `winget install Microsoft.DotNet.SDK.10`; not run |

## Expected output
`./run.sh` (after `./build.sh`) prints one line and exits with status 0:
```text
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. Visual Basic documentation (VB.NET). Microsoft Learn. <https://learn.microsoft.com/dotnet/visual-basic/> (accessed 2026-11-10)
2. .NET SDK installation and the dotnet-install script. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script> (accessed 2026-11-10)
3. "Support Statement for Visual Basic 6.0" (IDE no longer supported as of April 8, 2008; runtime supported for the support lifetime of Windows versions). Microsoft Learn. <https://learn.microsoft.com/previous-versions/visualstudio/visual-basic-6/visual-basic-6-support-policy> (accessed 2026-11-20)
