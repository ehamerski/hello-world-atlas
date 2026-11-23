# Smalltalk · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Smalltalk](../README.md)

## What this is

A web server that answers every HTTP request for `/` with an HTML page
containing `Hello, World!`. It uses Zinc HTTP Components, the standard HTTP
library included in the Pharo 14 image. Pharo 14.0 is downloaded
automatically by `install.sh` into a local cache.

## Prerequisites

| Tool | Version used | Why it is needed |
|---|---|---|
| Pharo 14 | 14.0 (downloaded by install.sh) | Smalltalk image with Zinc HTTP Components |
| curl | system | Downloads Pharo from files.pharo.org; polls the server in --verify |
| `shasum`, `unzip` | system | Check each download's SHA-256 digest, then unpack it |

## Quick start

```sh
./install.sh   # download Pharo 14 into ../.cache/pharo14/
./run.sh       # start the server (stop with Ctrl+C)
```

Open <http://localhost:8080/> in your browser.

## Scripts explained

| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Asks first, then downloads the Pharo 14 image and the VM for your system from files.pharo.org into a shared cache, checks the SHA-256 digest of each ZIP against `pharo-env.sh`, unpacks them and writes the `pharo` and `pharo-ui` launchers | Pharo is not in any package manager; the Pharo project publishes the image and VM as ZIP files |
| `run.sh` | Non-verify: runs `pharo server.st` in headless mode; `--verify`: starts in background, curls once, stops | The headless launcher runs Pharo without a display |

## Folder structure

```text
web/
├── README.md      this file
├── install.sh     downloads Pharo 14 into ../.cache/pharo14/
├── pharo-env.sh   shared Pharo paths, download URLs and digests (sourced by install.sh and run.sh)
├── run.sh         starts the server or runs the headless self-check
├── screenshot.png the page in a browser, for "Expected output" below
└── server.st      the Zinc HTTP server source code
```

Cache location: `languages/smalltalk/.cache/pharo14/` (git-ignored).
Source: [files.pharo.org](https://files.pharo.org/get-files/140/)

## Step-by-step walkthrough

1. **`port := (OSEnvironment current at: 'PORT' ifAbsent: ['8080']) asInteger`** —
   reads the `PORT` environment variable and converts it to an integer. `OSEnvironment
   current` provides access to the process environment in Pharo 14. `ifAbsent:` is a
   keyword message that returns the block's value when the key is missing. Compare
   with `int(os.environ.get("PORT", 8080))` in Python.

2. **`server := ZnServer startOn: port`** — creates and starts a Zinc HTTP server.
   `ZnServer` is the main class of Zinc HTTP Components. `startOn:` is a class-side
   factory method that binds the server to the given port and starts the listening
   loop synchronously. Compare with Node.js's `http.createServer().listen(port)`.

3. **`server onRequestRespond: [:request | ...]`** — registers a handler block.
   The block receives a `ZnRequest` and must return a `ZnResponse`. Zinc routes
   every incoming request to this block. Compare with Express's `app.get('/', ...)`.

4. **`ZnResponse ok: (ZnEntity html: '...')`** — builds the HTTP response. `ok:`
   wraps an entity in a 200 OK response. `ZnEntity html:` wraps a string in a
   `text/html` entity with the correct Content-Type header. Compare with Express's
   `res.send('<html>...')`.

5. **`Transcript show: ...; nl`** — prints to the Pharo Transcript (standard output
   in headless mode). The semicolon (`;`) sends the next message to the same receiver
   (cascade). `nl` appends a newline. Compare with `console.log(...)` in JavaScript.

6. **`[ server isRunning ] whileTrue: [...]`** — a Smalltalk loop that runs while the
   condition block is true. `Delay forMilliseconds: 500` waits 500 ms per iteration
   to avoid busy-waiting. This keeps the script alive until the process is killed.

## Why this toolchain

Zinc HTTP Components is the standard HTTP library for Pharo Smalltalk. It
provides both client and server capabilities, including `ZnServer` for building
HTTP servers. Zinc is included in the Pharo 14 image by default, so no additional
packages are needed. It is the Smalltalk equivalent of Node.js's `http` module.
Source: [Zinc HTTP Components](https://github.com/svenvc/zinc).

### The image-based workflow

Pharo is an **image-based** system. When you run `pharo Pharo.image st server.st`,
the VM loads the image (which contains the entire standard library including Zinc)
and evaluates `server.st` inside it. The image provides all classes and methods
without a separate compile step. Source: [Pharo by Example](https://books.pharo.org/updated-pharo-by-example/).

## Platform notes

| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | Pharo 14.0, downloaded by install.sh |
| macOS Apple Silicon | ⚠️ not verified | `install.sh` downloads `pharo-vm-Darwin-arm64-stable.zip` |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` downloads `pharo-vm-Linux-x86_64-stable.zip` (x86_64 only); headless mode |
| Windows (Git Bash) | ⚠️ not verified | `install.sh` downloads `pharo-vm-Windows-x86_64-stable.zip` and starts `PharoConsole.exe` |

**Download digests.** Pharo publishes no checksums, so the SHA-256 digests in
`pharo-env.sh` were computed with `shasum -a 256` on files downloaded from
files.pharo.org on 2026-11-19. The image is a fixed build (build 789, commit
`e649a7f87c`). The VM ZIPs are the `stable` files that get.pharo.org itself
downloads, so their names stay the same when Pharo publishes a new VM. If a
download no longer matches its digest, `install.sh` stops before unpacking
anything; check the new file, then update the digest in `pharo-env.sh`.

## Expected output

The server starts and listens on `http://localhost:8080/`. A browser or `curl` shows:

```html
<html><body><p>Hello, World!</p></body></html>
```

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-19 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources

1. Zinc HTTP Components. Sven Van Caekenberghe. <https://github.com/svenvc/zinc> (accessed 2026-11-17)
2. Pharo by Example (updated). Ducasse, Zagidulin, Hess, Chloupis. <https://books.pharo.org/updated-pharo-by-example/> (accessed 2026-11-17)
3. Pharo download (get.pharo.org). Pharo Project. <https://get.pharo.org> (accessed 2026-11-19)
4. ZnServer API. Pharo consortium. <https://pharo.org/documentation> (accessed 2026-11-10)
5. Pharo 14 files (image and VM ZIPs). Pharo Project. <https://files.pharo.org/get-files/140/> (accessed 2026-11-19)
