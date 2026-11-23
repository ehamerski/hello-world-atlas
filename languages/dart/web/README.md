# Dart · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Dart](../README.md)

## What this is

A web server that answers every HTTP request for `/` with an HTML page containing `Hello, World!`. It uses only the Dart standard library (`dart:io`), no third-party framework.

## Prerequisites

| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Dart SDK | 3.13.7 (verified 2026-11-19) | The Dart VM runs server.dart |

## Quick start

```sh
./install.sh   # check / install the Dart SDK (asks before installing)
./run.sh       # start the server (stop with Ctrl+C)
```

Open <http://localhost:8080/> in your browser.

## Scripts explained

| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for the `dart` command; installs via Homebrew or APT if missing, asking before each step | The Dart VM is needed to run server.dart |
| `run.sh` | Runs `dart server.dart`; `--verify` starts the server, curls it, then stops | Serves the HTML page on localhost:8080 |

## Folder structure

```text
web/
├── README.md      this file
├── install.sh     checks / installs the Dart SDK
├── run.sh         runs the server
├── screenshot.png the page in a browser, for "Expected output" below
└── server.dart    the source code
```

Layout reference: [HttpServer class](https://api.dart.dev/dart-io/HttpServer-class.html) — a single `.dart` file is a complete server.

## Step-by-step walkthrough

1. **`import 'dart:io';`** — `dart:io` is the standard library for I/O operations: files, sockets, HTTP. It is available only when running on the Dart VM (not when compiled to JavaScript for the browser). Reference: [dart:io library](https://api.dart.dev/dart-io/dart-io-library.html).

2. **`final port = ...`** — The port number is read from the `PORT` environment variable, defaulting to `8080`. `Platform.environment` is a map of environment variables. On macOS 12 and later, port 5000 is often occupied by the AirPlay Receiver service, so 8080 is used instead.

3. **`void main() async`** — The `main` function is the entry point. It is declared `async` because it uses `await` to wait for the server to start. Dart's `async`/`await` model is similar to JavaScript's. Reference: [Asynchronous programming](https://dart.dev/libraries/async/async-await).

4. **`await HttpServer.bind('localhost', port)`** — `HttpServer.bind` creates a server listening on `localhost` (127.0.0.1) at the given port. It returns a `Future<HttpServer>`, so `await` is used. The server listens only on localhost, not on all network interfaces.

5. **`await for (final request in server)`** — The server is an async stream of `HttpRequest` objects. `await for` processes each request as it arrives. This is Dart's equivalent of a callback-based event loop.

6. **`request.response ...`** — The response is configured using the cascade operator (`..`), which allows chaining method calls on the same object. `statusCode` is set to 200 (OK), `contentType` to HTML, and the body is written with `write()`. `close()` sends the response and closes the connection.

## Why this toolchain

`dart:io` HttpServer is the lowest-level HTTP server in the Dart standard library. It requires no packages and works on any platform that supports the Dart VM (macOS, Linux, Windows). For larger servers, the [Shelf](https://pub.dev/packages/shelf) package from the Dart team (publisher `tools.dart.dev`) offers "a model for web server middleware that encourages composition and easy reuse" [5]. For a Hello World example, the standard library is enough. Reference: [dart:io documentation](https://api.dart.dev/dart-io/dart-io-library.html).

## Platform notes

| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-19) | Dart SDK 3.13.7, Homebrew `dart-sdk` |
| macOS Apple Silicon | ⚠️ not verified | Homebrew `dart-sdk` provides arm64 builds |
| Linux (Debian/Ubuntu) | ⚠️ not verified | APT repository from Google |
| Windows (Git Bash / WSL) | ⚠️ not verified | `winget install --id Google.DartSDK` |

**Google's signing key is checked by fingerprint, not by digest.** On Linux,
`install.sh` saves the key for Google's APT repository to
`~/.cache/hello-world-dart/linux_signing_key.pub` and checks that its primary
key has the fingerprint Google publishes, `EB4C 1BFD 4F04 2F6D DDCC EC91 7721
F63B D38B 4796` [11], before it adds the key. Google publishes no digest of
the file, and it signs with periodically rotated subkeys of this key [11], so
the file changes over time.

## Expected output

The server starts and listens on `http://localhost:8080/`. A browser or `curl` shows:

```html
<html><body><p>Hello, World!</p></body></html>
```

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-19 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources

1. dart:io library. Dart Team, Google. <https://api.dart.dev/dart-io/dart-io-library.html> (accessed 2026-11-20)
2. HttpServer class. Dart Team, Google. <https://api.dart.dev/dart-io/HttpServer-class.html> (accessed 2026-11-20)
3. Asynchronous programming: futures and async/await. Dart Team, Google. <https://dart.dev/libraries/async/async-await> (accessed 2026-11-06)
4. The main() function. Dart Team, Google. <https://dart.dev/language/functions#the-main-function> (accessed 2026-11-06)
5. shelf. Dart Team, Google (publisher tools.dart.dev). <https://pub.dev/packages/shelf> (accessed 2026-11-20)
11. Linux Software Repositories. Google. <https://www.google.com/linuxrepositories/> (accessed 2026-11-19)
