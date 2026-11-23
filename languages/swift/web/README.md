# Swift · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Swift](../README.md)

## What this is
A web server on <http://localhost:8080/> that answers `GET /` with the
plain text `Hello, World!`, like the other web versions (for example
[Python](../../python/web/)). Any other path gets Vapor's built-in error
answer: status `404` with the JSON body
`{"error":true,"reason":"Not Found"}`.

It is written with **Vapor**: "Vapor provides a safe, performant and easy
to use foundation to build HTTP servers, backends and APIs in Swift" [1].
The project is a **Swift Package**: "The Swift Package Manager lets you
share your code as a package, depend on and use other shared packages, as
well as build, test, document, and run your code" [2]. Swift compiles
everything into one native executable.

Compare the [cli](../cli/) first: there, `main` calls `print()` once.
Here, `main` starts a server that handles many requests. The program
is still compiled to native code; see the
[walkthrough](#step-by-step-walkthrough).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Swift (`swift`) | 6.3.2 (Xcode CLI tools) | compiles Vapor and the application |
| Swift Package Manager (`swift package`) | shipped with Swift | downloads Vapor and builds the package |
| Vapor | 4 (`from: "4.0.0"` in `Package.swift`; resolved to 4.122.3 on 2026-11-20) | the web framework |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

Swift and SPM come from Xcode Command Line Tools on macOS [3].
`from: "4.0.0"` lets SPM pick the newest Vapor 4 release; the version it
picked is written to `Package.resolved` on the first build.

## Quick start
```sh
./install.sh   # check Swift and SPM
./build.sh     # download Vapor and build (first build: a few minutes)
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Then open <http://localhost:8080/>, or run `curl http://localhost:8080/`.
Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `swift --version` and that SPM can describe the package. | Vapor is a Swift package, so SPM must work. |
| `build.sh` | Runs `swift build`, which resolves dependencies, downloads Vapor, and compiles the app into `.build/debug/App`. | Like `cargo build` for Rust or `npm run build` for Node, SPM manages the full build. |
| `run.sh` | Runs `.build/debug/App serve --port "$PORT"` (`PORT` defaults to `8080`), which starts the Vapor server. `--verify` starts it in the background, waits until it answers, fetches the page once with `curl`, then stops it. | The executable is the server: there is no separate server program to install. |

**Where things go.** The build output goes into `.build/`, together with
the downloaded source of Vapor and its dependencies (`.build/checkouts/`).

## Folder structure
```text
web/
├── README.md              this file
├── install.sh             checks Swift and SPM
├── build.sh               swift build
├── run.sh                 starts the server (or checks it with --verify)
├── Package.swift          Swift Package Manager manifest
├── screenshot.png         the page in a browser, for "Expected output" below
└── Sources/
    └── App/
        └── main.swift     the web application
```
- `Package.swift` declares the Vapor dependency and the executable target [2].
- `Sources/App/main.swift` is the entry point: SPM compiles it as the
  `App` target and runs it with `swift run App`.

## Step-by-step walkthrough

1. **`import Vapor`** — imports the Vapor framework. The compiler links
   the Vapor libraries into the executable. Compare with Python's
   `import flask` or Go's `import "net/http"`.

2. **`@main struct HelloWeb`** with **`static func main() async throws`**
   — the entry point. `@main` goes on a type "to indicate that it contains
   the top-level entry point for program flow" [4]; `async` lets it wait
   for the server without blocking a thread, and `throws` passes any start-up error up so the program stops with it.

3. **`let app = try await Application.make()`** — creates the Vapor
   application. Vapor configures defaults (logging, middleware, the HTTP
   server). Compare with Flask's `app = Flask(__name__)`.

4. **`app.get { req in "Hello, World!" }`** — registers a route handler
   for `GET /`. The closure receives a `Request` and returns a string;
   Vapor turns it into an HTTP response with status 200 and content type
   `text/plain`. Compare with Express's
   `app.get("/", (req, res) => res.send("Hello, World!"))`.

5. **`try await app.execute()`** — runs the command given on the command
   line (`serve` by default), which starts the server. Vapor binds to port
   8080 unless the `serve` command gets another port with `--port`; it does
   not read a `PORT` environment variable. `run.sh` passes `PORT` through
   as `serve --port "$PORT"`, so `PORT=9000 ./run.sh` serves on port
   9000 [5]. The call returns when the server stops (for example after
   Ctrl+C).

## Why this toolchain
Vapor's home page shows the same pattern as this program:
`Application.make()`, a route, then `app.execute()` [1]. On 2026-11-20 the
[vapor/vapor repository on GitHub](https://github.com/vapor/vapor) had
about 26,000 stars.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-19) | Swift 6.3.2 via Xcode CLI tools |
| macOS Apple Silicon | ⚠️ not verified | Swift is native on Apple Silicon; same commands apply |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Install Swift from swift.org; Vapor runs on Ubuntu |
| Windows (Git Bash / WSL) | ⚠️ not verified | Run through WSL (Linux Swift) |

## Expected output
```text
Hello, World!
```
The server sends plain text, so the browser shows the line as it is:

![The page at http://localhost:8080/ showing "Hello, World!" as plain text](screenshot.png)

(Taken on 2026-11-19 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)


## Sources
1. Vapor. Vapor.codes. [vapor.codes](https://vapor.codes/) (accessed 2026-11-20)
2. Swift Package Manager. Swift.org. [docs.swift.org/latest/documentation/packagemanagerdocs](https://docs.swift.org/latest/documentation/packagemanagerdocs/) (accessed 2026-11-20)
3. Swift on macOS. Apple Inc. [developer.apple.com/swift](https://developer.apple.com/swift/) (accessed 2026-11-06)
4. The Swift Programming Language, "Attributes". Swift.org. [docs.swift.org/latest/documentation/the-swift-programming-language/attributes](https://docs.swift.org/latest/documentation/the-swift-programming-language/attributes/) (accessed 2026-11-20)
5. Server. Vapor documentation. [docs.vapor.codes/advanced/server](https://docs.vapor.codes/advanced/server/) (accessed 2026-11-19)
