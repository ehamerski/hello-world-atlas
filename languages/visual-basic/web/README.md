# Visual Basic (VB.NET) · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Visual Basic (VB.NET)](../README.md)

## What this is
A web server, written in VB.NET with ASP.NET Core, that answers `GET /` with the
text `Hello, World!`. It listens on `http://localhost:8080` by default; set `PORT` to
use another port.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| .NET SDK (`dotnet`) | 10.0.404 (channel 10.0, installed into `~/.dotnet`) | builds and runs the ASP.NET Core server |
| `curl` | macOS system tool | `run.sh --verify` reads the page with it |
| `shasum` | macOS system tool | checks Microsoft's `dotnet-install.sh` (only if the SDK is missing) |

## Quick start
```sh
./install.sh   # check / install the .NET 10 SDK (asks before installing)
./build.sh     # compile Program.vb to bin/Debug/net10.0/
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```

In another terminal: `curl -i http://localhost:8080/`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for an SDK 10 or newer. If it is missing, downloads `dotnet-install.sh`, checks its digest and installs the SDK into `~/.dotnet` | the server needs the .NET SDK and runtime |
| `build.sh` | Runs `dotnet build --configuration Debug vbweb.vbproj` | writes the server into `bin/` |
| `run.sh` | Serves until Ctrl+C. `--verify` starts the server in the background, reads `/` with `curl`, and stops it | `verify-all.sh` needs a command that answers and exits. `--verify` refuses to start if the port already answers, so another program cannot pass the check |
| `dotnet-env.sh` | Sets the digest, the install folder and `PATH`, and turns telemetry off (sourced, not run) | shared by all three scripts |

## Folder structure
```text
web/
├── README.md          this file
├── install.sh         checks / installs the .NET 10 SDK
├── dotnet-env.sh      install folder, digest, telemetry settings (sourced)
├── build.sh           dotnet build
├── run.sh             serves on PORT (default 8080); --verify
├── Program.vb         the server (WebApplication, MapGet)
├── vbweb.vbproj       the project file (Microsoft.NET.Sdk.Web, net10.0)
├── bin/ and obj/      build output, ignored by git
```
Layout reference: [ASP.NET Core minimal APIs](https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis).
The SDK has no VB.NET web template, so `vbweb.vbproj` is written by hand.

## Step-by-step walkthrough
`Program.vb` in order:

1. **`Imports System`** and **`Imports Microsoft.AspNetCore.Builder`** bring in the
   library names used below.
2. **`WebApplication.CreateBuilder(args)`** prepares the server. **`builder.Build()`**
   creates the application.
3. **`app.MapGet("/", Function() "Hello, World!")`** maps a `GET` request for `/` to a
   function that returns the text. The same mapping in C# is `app.MapGet("/", () => "Hello, World!")`.
4. **`PORT`** is read from the environment; if it is not set, the server uses `8080`.
5. **`app.Run()`** starts the server and blocks until it is stopped.

Difference from other languages in this repository: a handler is a `Function`
expression (VB.NET's lambda form), and the server is one short module.

## Why this toolchain
- **ASP.NET Core minimal APIs** let a short program serve HTTP without controllers
  or a startup class [1]. They were added in ASP.NET Core in .NET 6 [5].
- **VB.NET** is compiled by the .NET 10 SDK, the same SDK as the `cli` program [2].
- **Why not VB6 or WinForms:** the VB6 IDE is no longer supported and its runtime is
  supported only on Windows [3]; WinForms is Windows-only [4], so neither runs on
  macOS or Linux.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-20) | `build.sh`, `run.sh --verify`, and `curl -i http://localhost:8080/` returned `HTTP/1.1 200 OK` with the body `Hello, World!` |
| macOS Apple Silicon | ⚠️ not verified | the .NET SDK supports it; not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` uses the same script; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` points to `winget install Microsoft.DotNet.SDK.10`; not run |

## Expected output
`./run.sh` serves the page. In another terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Server: Kestrel

Hello, World!
```
(The `Date` and `Transfer-Encoding` headers are also printed; the body is the last line.)
`./run.sh --verify` prints the server log lines, then `Hello, World!`, and exits with status 0.
`web` has no screenshot: the page is plain text, shown above.

## Sources
1. ASP.NET Core minimal APIs. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis> (accessed 2026-11-10)
2. Visual Basic documentation (VB.NET). Microsoft Learn. <https://learn.microsoft.com/dotnet/visual-basic/> (accessed 2026-11-10)
3. "Support Statement for Visual Basic 6.0" (IDE no longer supported as of April 8, 2008; runtime supported for the support lifetime of Windows versions). Microsoft Learn. <https://learn.microsoft.com/previous-versions/visualstudio/visual-basic-6/visual-basic-6-support-policy> (accessed 2026-11-20)
4. Windows Forms (WinForms) documentation. Microsoft Learn. <https://learn.microsoft.com/dotnet/desktop/winforms/> (accessed 2026-11-10)
5. "What's new in ASP.NET Core in .NET 6" (minimal APIs). Microsoft Learn. <https://learn.microsoft.com/aspnet/core/release-notes/aspnetcore-6.0> (accessed 2026-11-20)
