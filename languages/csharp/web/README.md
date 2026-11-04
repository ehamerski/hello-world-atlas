# C# · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [C#](../README.md)

## What this is
A web server written in C# with **ASP.NET Core**. It listens on
`http://localhost:8080` (or `$PORT`) and answers `GET /` with the HTML
`<p>Hello, World!</p>`, which a browser shows as **Hello, World!**

The server builds the HTML itself; there is no separate front end. Compare
[../web-angular](../web-angular/), where the page is drawn in the browser
by Angular and the C# server only sends JSON.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| .NET SDK 10 | 10.0.403 (ASP.NET Core runtime 10.0.14), in `~/.dotnet` | the C# compiler, MSBuild, the .NET runtime, and ASP.NET Core |
| `curl` | system `curl` | only for `./run.sh --verify` and for testing by hand |

ASP.NET Core is part of the SDK: "`Microsoft.AspNetCore.App` is installed
when the .NET Core 3.0 or later SDK is installed" [1]. So, unlike Java's
Spring Boot in [../../java/web](../../java/web/), nothing is downloaded.

## Quick start
```sh
./install.sh   # check for the .NET 10 SDK (asks before installing)
./build.sh     # compile into bin/Release/net10.0/hello-web.dll
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Another port: `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Same as [../cli](../cli/README.md#scripts-explained): checks for a .NET SDK 10 or newer and offers `dotnet-install.sh` (macOS/Linux) or `winget` (Windows). | The SDK contains ASP.NET Core too. |
| `build.sh` | Runs `dotnet build -c Release --disable-build-servers`. | Compiles `Program.cs` to IL in `bin/Release/net10.0/hello-web.dll`. |
| `run.sh` | Runs `dotnet bin/Release/net10.0/hello-web.dll`. `--verify` starts it in the background, fetches `/` once with `curl`, then stops it (a `trap` ensures that it stops). | The program starts Kestrel, the web server built into ASP.NET Core, so no separate server is needed. |

The install, telemetry and build details are the same as in
[../cli](../cli/README.md#scripts-explained).

## Folder structure
```text
web/
├── README.md          this file
├── install.sh         checks / installs the .NET SDK
├── build.sh           compiles with dotnet build
├── run.sh             starts the server
├── screenshot.png     the page in a browser, for "Expected output" below
├── hello-web.csproj   the project file, using the Web SDK
├── Program.cs         the server
├── appsettings.json   configuration: log levels
├── obj/               created by build.sh; not committed
└── bin/Release/net10.0/   created by build.sh; not committed
```
- This is the layout of Microsoft's `dotnet new web` template ("ASP.NET
  Core Empty") [2], without `Properties/launchSettings.json` and
  `appsettings.Development.json`, which only matter when you run the app
  from Visual Studio or with `dotnet run`. `run.sh` runs the built `.dll`.
- `appsettings.json` is read at startup from the content root. That is the
  current folder, and the server log shows it as `Content root path`.
  `run.sh` starts the server from this folder.
  `"Microsoft.AspNetCore": "Warning"` hides the framework's
  log lines for each request, the same setting as the template's file [2].
  JSON has no comments, so the explanation is here.

## Step-by-step walkthrough
Open [`Program.cs`](Program.cs) and [`hello-web.csproj`](hello-web.csproj).

1. **`<Project Sdk="Microsoft.NET.Sdk.Web">`**: the only real difference
   from [../cli](../cli/hello-cli.csproj). "Projects that target the
   `Microsoft.NET.Sdk.Web` SDK implicitly reference the
   `Microsoft.AspNetCore.App` framework" [1]. The Web SDK also adds the
   ASP.NET Core namespaces to the implicit `using` lines (see
   `obj/Release/net10.0/hello-web.GlobalUsings.g.cs` after a build), so
   `Program.cs` needs no `using`.
2. **`var builder = WebApplication.CreateBuilder(args);`** creates a
   builder with the default configuration, logging and web server.
   `var` lets the compiler infer the type. C# stays statically typed, as
   with `auto` in C++ and `var` in Java 10 and later.
   **`var app = builder.Build();`** creates the application.
3. **`app.MapGet("/", () => Results.Content("<p>Hello, World!</p>", "text/html"));`**
   maps `GET /` to a lambda. Microsoft writes: "For new projects, we
   recommend using Minimal APIs" [3]. That is this style, with no
   controller classes, as opposed to the `@RestController` class in
   [../../java/web](../../java/web/). `Results.Content` "Writes the
   `content` string to the HTTP response" with the given content type
   [4]. Returning a plain string would also work, but "The framework
   writes the string directly to the response" as `text/plain` [5]. The
   browser would then show the tags instead of a paragraph.
4. **`Environment.GetEnvironmentVariable("PORT") ?? "8080"`** reads the
   port. `??` is the null-coalescing operator: it gives the right side when
   the left side is `null`, that is, when the variable is not set.
5. **`app.Run($"http://127.0.0.1:{port}")`** starts the server on that
   address and blocks until Ctrl+C. The docs show the same form,
   `app.Run("http://localhost:3000")`, where "the app responds to port
   `3000`" [6]. `$"..."` is an interpolated string, like Python's
   f-strings. `127.0.0.1` means only this computer can connect. (ASP.NET
   Core's own setting for this is the `ASPNETCORE_URLS` variable [6]. This
   repository uses `PORT` in every web folder.)
6. **Kestrel.** `run.sh` starts no separate web server: "Kestrel is a
   cross-platform web server for ASP.NET Core. Kestrel is the recommended
   server for ASP.NET Core, and it's configured by default in ASP.NET Core
   project templates" [7]. The response header `Server: Kestrel` below
   shows it.

## Why this toolchain
- **ASP.NET Core** is Microsoft's web framework for .NET: "a
  cross-platform, high-performance, open-source framework for building
  modern web apps using .NET" [8]. In the Stack Overflow Developer Survey
  2026, 19.9% of the 10,281 respondents to the web frameworks question
  used ASP.NET Core and 13.9% used ASP.NET (the .NET Framework version) [9].
- **Minimal APIs** are the style Microsoft recommends for new projects
  [3], and they keep this Hello World to five statements.
- **No extra packages**: ASP.NET Core comes with the SDK [1], like Go's
  `net/http` in [../../go/web](../../go/web/).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | .NET SDK 10.0.403, ASP.NET Core 10.0.14. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Install the SDK as in [../cli](../cli/README.md#platform-notes); the SDK includes ASP.NET Core [1]. |
| Windows (Git Bash / WSL) | ⚠️ not verified | `winget install --id Microsoft.DotNet.SDK.10 -e`. Native PowerShell: `dotnet build -c Release`, `$env:PORT=8080; dotnet bin\Release\net10.0\hello-web.dll`. |

## Expected output
`./run.sh --verify`:
```text
==> Start the web server on http://localhost:8080
    WHY: Kestrel, ASP.NET Core's web server, listens on 127.0.0.1 (this computer only).
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://127.0.0.1:8080
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: .../csharp/web
<p>Hello, World!</p>
info: Microsoft.Hosting.Lifetime[0]
      Application is shutting down...
```
By hand, with `./run.sh` running:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html
Date: Sun, 01 Nov 2026 11:30:08 GMT
Server: Kestrel

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-01 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Microsoft.AspNetCore.App for ASP.NET Core (shared framework). Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/metapackage-app> (accessed 2026-11-01)
2. `dotnet new web` template ("ASP.NET Core Empty"), as generated by .NET SDK 10.0.403 on the dev machine; template list: .NET default templates for `dotnet new`. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-new-sdk-templates> (accessed 2026-11-01)
3. APIs overview (Minimal APIs and controllers). Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis/overview> (accessed 2026-11-01)
4. Results.Content method. Microsoft Learn (.NET API browser). <https://learn.microsoft.com/dotnet/api/microsoft.aspnetcore.http.results.content> (accessed 2026-11-01)
5. Create responses in Minimal API applications. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis/responses> (accessed 2026-11-01)
6. Minimal APIs quick reference (ports, app.Run). Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis> (accessed 2026-11-01)
7. Kestrel web server in ASP.NET Core. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/servers/kestrel> (accessed 2026-11-01)
8. Overview of ASP.NET Core. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/introduction-to-aspnet-core> (accessed 2026-11-01)
9. 2026 Stack Overflow Developer Survey: web frameworks and technologies (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/web-framework> (accessed 2026-11-01)
