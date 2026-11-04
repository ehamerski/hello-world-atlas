# C# · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [C#](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one line of C# in `Program.cs`, plus the project file `hello-cli.csproj`,
built with the **.NET 10 SDK**, the current Long Term Support (LTS) release
of .NET [1].

Like [Java](../../java/cli/), C# is compiled to an intermediate language
(IL), not to machine code. The .NET runtime turns it into machine code while
the program runs. The program uses a newer C# feature, *top-level
statements*, so it has no class and no `Main` method. The comments in
`Program.cs` show the classic form, which looks almost the same as the
Java version.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| .NET SDK 10 | 10.0.403 (runtime 10.0.14), installed with `dotnet-install.sh` into `~/.dotnet` | the C# compiler, MSBuild, the .NET runtime and the base class library (`Console`) |
| `curl` and `bash` | system versions | only if `install.sh` has to download the SDK |

## Quick start
```sh
./install.sh   # check for the .NET 10 SDK (asks before installing)
./build.sh     # compile into bin/Release/net10.0/hello-cli.dll
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `dotnet --list-sdks` for an SDK of version 10 or newer. If none is found, on macOS/Linux it offers Microsoft's `dotnet-install.sh --channel 10.0` (into `~/.dotnet`, without `sudo`); on Windows it prints the `winget` command. It runs nothing without your `y`. | One package, the SDK, contains everything a C# program needs. |
| `build.sh` | Runs `dotnet build -c Release --disable-build-servers` and prints the command. | Restores the project, then compiles `Program.cs` to IL in `bin/Release/net10.0/hello-cli.dll`. |
| `run.sh` | Runs `dotnet bin/Release/net10.0/hello-cli.dll`. `--verify` does the same (a CLI program ends by itself). | The `.dll` holds IL, so the .NET runtime has to load it, compile it to machine code while the program runs (JIT compilation), and run it. |

**How the SDK is installed.** Microsoft's `dotnet-install` scripts
"perform a non-admin installation of the .NET SDK", and by default they
install into "*$HOME/.dotnet* on Linux/macOS" [2]. `--channel 10.0` picks
the newest .NET 10 SDK; `--channel LTS` would pick the newest LTS release,
which was the same release on 2026-11-01 [2]. The scripts do not change `PATH` and do
not set `DOTNET_ROOT` [2]. That is why every script here adds
`~/.dotnet` to `PATH` when `dotnet` is not already on it.

Microsoft cautions: "The intended use of the scripts is for
Continuous Integration (CI) scenarios" and "To set up a development
environment or to run apps, use the installers rather than these
scripts" [2]. The installer for macOS is a `.pkg` file (also available as
`brew install --cask dotnet-sdk` [3]). It installs into the
system-wide folder `/usr/local/share/dotnet` [3]. The rule of this repository is
that scripts never run `sudo` or install anything system-wide without
asking. Homebrew's `dotnet` formula has no ready-made build for Intel
Macs, so it would compile .NET from source [4]. For these reasons,
`install.sh` offers the script. If you prefer the installer, install it
first. `install.sh` then finds `dotnet` on `PATH` and uses it.

**What `dotnet build` produces.** "The binaries include the project's code
in Intermediate Language (IL) files with a *.dll* extension", and the
default output folder is `./bin/<configuration>/<framework>/` [5].
`dotnet build` also restores the project's dependencies first [5]. This
project has none. `-c Release` builds with optimizations.
`--disable-build-servers` "forces the command to ignore any persistent
build servers" [5]. Those are MSBuild and compiler processes that `dotnet`
otherwise keeps running after a build, to make the next build faster
(`dotnet build-server shutdown` stops them [16]). With the option, the
script leaves no background processes behind.

**What `dotnet <file>.dll` does.** The `dotnet` command is "the generic
driver for the .NET CLI". When you give it "the path to an application
`.dll` file", it runs the application [6]. "At execution time, a
just-in-time (JIT) compiler translates the CIL into native code" [7]. CIL
(Common Intermediate Language) is another name for IL.

**Telemetry.** "The .NET SDK telemetry feature is enabled by default for
Microsoft distributions of the SDK. To opt out of the telemetry feature,
set the `DOTNET_CLI_TELEMETRY_OPTOUT` environment variable to `1` or
`true`" [8]. All three scripts set it, and they also set `DOTNET_NOLOGO`,
which hides the first-run welcome message [9].

## Folder structure
```text
cli/
├── README.md          this file
├── install.sh         checks / installs the .NET SDK
├── build.sh           compiles with dotnet build
├── run.sh             runs the .dll with dotnet
├── hello-cli.csproj   the project file (MSBuild)
├── Program.cs         the program
├── obj/               created by build.sh (restore and intermediate files); not committed
└── bin/Release/net10.0/   created by build.sh; not committed
    ├── hello-cli.dll                the program, as IL
    ├── hello-cli                    a native launcher (apphost) for the .dll
    ├── hello-cli.runtimeconfig.json which .NET runtime version to load
    ├── hello-cli.deps.json          the program's dependencies
    └── hello-cli.pdb                debug symbols
```
- **One folder, one project file.** This is the layout `dotnet new
  console` creates: a `.csproj` and a `Program.cs` that "uses top-level
  statements by default" [10]. By default the compiler builds every `.cs`
  file in the folder, so the project file needs no list of sources [11].
- `bin/` and `obj/` are build output. The root `.gitignore` ignores them.

## Step-by-step walkthrough
Open [`Program.cs`](Program.cs) and [`hello-cli.csproj`](hello-cli.csproj).

1. **The project file.** `<Project Sdk="Microsoft.NET.Sdk">` selects the
   .NET SDK's build rules. `<OutputType>Exe</OutputType>` makes a program
   instead of a library. `<TargetFramework>net10.0</TargetFramework>`
   targets .NET 10. Compare Java's `pom.xml` in
   [../../java/cli](../../java/cli/) and `CMakeLists.txt` in
   [../../cpp/cli](../../cpp/cli/): here the defaults do most of the work.
2. **One statement, no class.** "By using top-level statements, you can
   write executable code directly at the root of a file" [10]. The
   compiler generates the class and the `Main` method. Before C# 9
   (released in November 2020 [12]) every C# program needed them. The
   comment at the top of `Program.cs` shows that form. It resembles Java's
   `public static void main`.
3. **No `using System;`.** `Console` lives in the `System` namespace.
   "Starting in .NET 6, implicit `global using` directives are added to new
   C# projects", and they are written "to a generated file in the
   project's *obj* directory" [11]. `<ImplicitUsings>enable</ImplicitUsings>`
   turns this on. After a build, `obj/Release/net10.0/hello-cli.GlobalUsings.g.cs`
   contains `global using System;` and six more namespaces.
4. **`Console.WriteLine("Hello, World!");`** calls a *static* method on the
   `Console` class, with no object created first, like Java's
   `System.out.println`. `WriteLine` adds the line break itself, so there
   is no `\n` as in C's `printf` or C++'s `std::cout`.
5. **The size of the result.** `hello-cli.dll` is 4,608 bytes on the development
   machine. It holds only the IL of this program; `Console` stays in the
   .NET runtime's own libraries. The native launcher `hello-cli` (88,024
   bytes) is used when you run the program without the `dotnet`
   command. It looks for .NET via `DOTNET_ROOT` and in the default
   location, `/usr/local/share/dotnet` on macOS [9], so it fails with
   "You must install .NET to run this application" when .NET is only in
   `~/.dotnet` (tested on the development machine). That is why `run.sh` uses
   `dotnet hello-cli.dll`.

## Why this toolchain
- **The .NET SDK**, published by Microsoft, includes the C# compiler, the
  build engine, and the runtime in one download, so nothing else is needed.
- **.NET 10** is an LTS release, published on 2025-11-11 and
  supported until November 2028. "LTS releases get free support and
  patches for three years", and "Even numbered releases are LTS" [1].
  On 2026-11-01, .NET 11 was not released yet (it was at release
  candidate 3 on 2026-10-25) [1]. .NET 10 comes with C# 14 [13].
- **The `dotnet` CLI instead of an IDE.** The same commands work on every
  operating system and in scripts. Visual Studio, Rider, and VS Code call
  the same SDK.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | .NET SDK 10.0.403 (x64) from `dotnet-install.sh` into `~/.dotnet`. The supported macOS versions for .NET 10 are 14, 15, and 26 [14]. |
| macOS Apple Silicon | ⚠️ not verified | Same commands; the script picks the Arm64 SDK. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | The same `dotnet-install.sh` works without `sudo` [2]. Microsoft also documents distribution packages: see <https://learn.microsoft.com/dotnet/core/install/linux> [15]. |
| Windows (Git Bash / WSL) | ⚠️ not verified | `winget install --id Microsoft.DotNet.SDK.10 -e` in PowerShell. Native commands: `dotnet build -c Release` and `dotnet bin\Release\net10.0\hello-cli.dll` (or `bin\Release\net10.0\hello-cli.exe`). WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: 'dotnet' starts the .NET runtime, which JIT-compiles the IL in the .dll and runs it.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. .NET and .NET Core official support policy (release dates, LTS/STS, .NET 11 RC3). Microsoft. <https://dotnet.microsoft.com/platform/support/policy/dotnet-core> (accessed 2026-11-01)
2. `dotnet-install` scripts reference. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script> (accessed 2026-11-01)
3. `dotnet-sdk` (Homebrew cask: .pkg installer, `/usr/local/share/dotnet`). Homebrew. <https://formulae.brew.sh/cask/dotnet-sdk> (accessed 2026-11-01)
4. `dotnet` (Homebrew formula: version and bottles). Homebrew. <https://formulae.brew.sh/formula/dotnet> (accessed 2026-11-01)
5. `dotnet build` command. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-build> (accessed 2026-11-01)
6. `dotnet` command. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet> (accessed 2026-11-01)
7. Managed execution process. Microsoft Learn. <https://learn.microsoft.com/dotnet/standard/managed-execution-process> (accessed 2026-11-01)
8. .NET SDK and .NET CLI telemetry. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/telemetry> (accessed 2026-11-01)
9. .NET environment variables (DOTNET_NOLOGO, DOTNET_ROOT). Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-environment-variables> (accessed 2026-11-01)
10. Top-level statements - programs without Main methods. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/fundamentals/program-structure/top-level-statements> (accessed 2026-11-01)
11. .NET project SDK overview (implicit using directives, default includes). Microsoft Learn. <https://learn.microsoft.com/dotnet/core/project-sdk/overview> (accessed 2026-11-01)
12. The history of C#. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/whats-new/csharp-version-history> (accessed 2026-11-01)
13. "What's new in .NET 10". Microsoft Learn. <https://learn.microsoft.com/dotnet/core/whats-new/dotnet-10/overview> (accessed 2026-11-01)
14. Install .NET on macOS. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/install/macos> (accessed 2026-11-01)
15. Install .NET on Linux. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/install/linux> (accessed 2026-11-01)
16. `dotnet build-server` command. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-build-server> (accessed 2026-11-01)
