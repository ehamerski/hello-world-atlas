# Objective-C · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Objective-C](../README.md)

## What this is

A minimal HTTP/1.1 server that listens on `localhost:8080` and returns
`Hello, World!` in an HTML page for every request. Built with BSD sockets
and Foundation — no extra libraries or frameworks needed.

## Prerequisites

| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Clang | 21.0.0 (Apple clang) | Compiles Objective-C source |
| Foundation framework | macOS system | NSString, NSLog |
| GNUstep (Linux only) | GNUstep (`gnustep-devel`) | Foundation-compatible runtime on Linux |

## Quick start

```sh
./install.sh   # check the toolchain
./build.sh     # compile server.m → server
./run.sh       # start the server (stop with Ctrl+C)
```

Open <http://localhost:8080/> in your browser.

## Scripts explained

| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks clang ObjC support and Foundation (or GNUstep on Linux) | The compiler and Foundation are prerequisites for build.sh |
| `build.sh` | Runs `clang -framework Foundation server.m -o server` (macOS) or the GNUstep equivalent (Linux) | Compiles server.m to a native executable |
| `run.sh` | Runs `./server`; `--verify`: starts in background, curls once, stops | The server binary starts the accept loop; --verify proves it responds |

## Folder structure

```text
web/
├── README.md      this file
├── install.sh     checks the toolchain
├── build.sh       compiles server.m → server
├── run.sh         starts the server
├── screenshot.png the page in a browser, for "Expected output" below
└── server.m       the HTTP server source code
```

Source: [Foundation framework](https://developer.apple.com/documentation/foundation),
[POSIX socket API](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/sys_socket.h.html)

## Step-by-step walkthrough

1. **`signal(SIGINT, handle_signal)`** — registers a signal handler for Ctrl+C
   (SIGINT) and SIGTERM. The handler closes the server socket so `accept()` returns
   immediately, letting the main loop exit cleanly. Compare with Node.js's
   `process.on('SIGINT', ...)`.

2. **`socket(AF_INET, SOCK_STREAM, 0)`** — creates a TCP/IPv4 socket. `AF_INET`
   specifies IPv4; `SOCK_STREAM` specifies TCP (reliable, ordered byte stream). The
   returned file descriptor (`g_server_fd`) identifies the socket for all subsequent
   calls. Compare with Python's `socket.socket()`.

3. **`setsockopt(..., SO_REUSEADDR, ...)`** — allows the server to re-bind the same
   port immediately after restart, without waiting for the kernel's TIME_WAIT period
   (typically 60 s). Without this, restarting the server quickly fails with
   "Address already in use". Compare with Python's `socket.SO_REUSEADDR`.

4. **`bind(g_server_fd, &addr, sizeof(addr))`** — associates the socket with the
   address `127.0.0.1:PORT`. Binding to 127.0.0.1 (INADDR_LOOPBACK) means only
   local connections are accepted. Compare with `server.listen(PORT, '127.0.0.1')` in Node.js.

5. **`listen(g_server_fd, 10)`** — marks the socket as passive (ready to accept
   connections). The second argument (10) is the backlog: the maximum number of
   pending connections queued before the kernel starts refusing new ones.

6. **`NSString *response = [NSString stringWithFormat: ...]`** — builds the HTTP
   response using Foundation's `NSString`. The response includes the HTTP status
   line, headers (`Content-Type`, `Content-Length`, `Connection: close`), a blank
   line, and the HTML body. `%lu` formats the byte length; `%@` inserts the body
   string. Compare with sprintf in C or string interpolation in Swift.

7. **`accept(g_server_fd, NULL, NULL)`** — blocks until a client connects and
   returns a new file descriptor for that connection. The main loop accepts one
   connection at a time (single-threaded), which is enough for a demo.

8. **`recv(client_fd, buf, ...)`** — reads the HTTP request into a buffer. The
   loop reads until it sees `\r\n\r\n` (the end of the HTTP headers) or the buffer
   is full. The request body is not read (GET requests have no body).

9. **`write(client_fd, resp_bytes, resp_len)`** — sends the HTTP response. The
   response bytes come from `[response UTF8String]`, which returns a C string
   pointer valid within the `@autoreleasepool` block.

10. **`close(client_fd)`** — closes the connection. Because the response includes
    `Connection: close`, the browser knows not to reuse the connection.

## Why this toolchain

BSD sockets are the standard POSIX networking API, available on macOS, Linux,
and most Unix-like systems. Foundation provides Objective-C string handling
(NSString) and logging (NSLog). Together, they let the program serve HTTP without
any third-party library or framework. This makes the dependency list minimal and
the HTTP model explicit.

On Linux, [GNUstep] provides a compatible Foundation implementation, so the same
source compiles with different linker flags. Source: [GNUstep](https://www.gnustep.org/).

## Platform notes

| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | Clang 21.0.0, Foundation via Xcode CLI tools |
| macOS Apple Silicon | ⚠️ not verified | Same commands; universal binary |
| Linux (Debian/Ubuntu) | ⚠️ not verified | GNUstep (`apt-get install gnustep-devel`) |
| Windows (Git Bash / WSL) | ⚠️ not verified | Requires GNUstep through WSL |

## Expected output

```
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 46
Connection: close

<html><body><p>Hello, World!</p></body></html>
```

The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-19 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources

1. POSIX socket API. The Open Group. <https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/sys_socket.h.html> (accessed 2026-11-10)
2. Foundation framework. Apple Inc. <https://developer.apple.com/documentation/foundation> (accessed 2026-11-10)
3. HTTP/1.1 response format. RFC 9110. <https://www.rfc-editor.org/rfc/rfc9110> (accessed 2026-11-10)
4. GNUstep — open-source Cocoa. <https://www.gnustep.org/> (accessed 2026-11-10)
5. Clang compiler user manual. LLVM Project. <https://clang.llvm.org/docs/UsersManual.html> (accessed 2026-11-10)
