# C · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [C](../README.md)

## What this is
A web server on <http://localhost:8080/> that answers `GET /` with the
HTML `<p>Hello, World!</p>`, like the other web versions (for example
[Go](../../go/web/)). Any other path gets `404` and `<p>Not Found</p>`.

The C standard library has no networking at all, so the HTTP part comes
from **GNU libmicrohttpd**: "a small C library that makes it easy to run an
HTTP server as part of another application" [1]. `hello.c` calls it, and
`build.sh` links it into `bin/hello-web`.

The code is compiled as **C99** (`-std=c99 -pedantic-errors`), not C89 like
[../cli](../cli/): libmicrohttpd's header needs C99 (see
[Why C99 here](#why-c99-here)).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| A C compiler (`cc`) | Apple clang 21.0.0 (Command Line Tools 26.6) | compiles `hello.c` |
| pkg-config | pkgconf 3.0.10 (Homebrew) | prints where libmicrohttpd's header and library are |
| GNU libmicrohttpd | 1.0.10 (Homebrew) | the HTTP server library |
| curl | 8.7.1 (ships with macOS) | only for `./run.sh --verify` |

libmicrohttpd "is free software ... under the GNU LGPL v2.1 or at your
option any later version" and is "part of the GNU project" [1]. Its page
says: "GNU libmicrohttpd 1.x is the stable version, and GNU libmicrohttpd
2.x is experimental" [1], so this folder uses 1.x.

## Quick start
```sh
./install.sh   # check cc, pkg-config and libmicrohttpd (asks before installing)
./build.sh     # compile hello.c as C99 and link libmicrohttpd into bin/hello-web
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Then open <http://localhost:8080/>, or run `curl http://localhost:8080/`.
Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks `cc`. 2. Checks `pkg-config`. 3. Checks `pkg-config --exists libmicrohttpd`. Anything missing is offered with its install command (`brew install libmicrohttpd`, `sudo apt-get install -y libmicrohttpd-dev`, or the MSYS2 `pacman` line on Windows) and runs only if you answer `y`. | C has no package manager of its own (no Maven, no Go modules, no npm). Libraries come from the operating system's package manager [2][3][4]. On Linux, the library is split: the `-dev` package holds the header and the `.pc` file that the compiler and `pkg-config` need. |
| `build.sh` | Runs `cc -std=c99 -pedantic-errors -Wall -Wextra $(pkg-config --cflags libmicrohttpd) -o bin/hello-web hello.c $(pkg-config --libs libmicrohttpd)` and prints the expanded command (`set -x`). | `pkg-config --cflags` gives the `-I` folders where `microhttpd.h` is; `--libs` gives `-L<folder> -lmicrohttpd` for the linker. The flags for strict C are explained in [../cli](../cli/README.md#scripts-explained). |
| `run.sh` | Runs `./bin/hello-web` with `PORT` (default 8080). `--verify` starts it in the background, fetches the page once with `curl`, and stops it. | The program is the server: no separate server process (compare Spring Boot's Tomcat in [../../java/web](../../java/web/)). |

**Linked, not copied.** `otool -L bin/hello-web` (macOS; `ldd` on Linux)
lists `/usr/local/opt/libmicrohttpd/lib/libmicrohttpd.12.dylib` next to
the C library: the library is loaded when the program starts, so it must
stay installed. The executable itself is 9,472 bytes. A Go server
copies its HTTP code into the executable instead
([13.6 MB](../../go/README.md#comparing-the-categories)).

## Folder structure
```text
web/
├── README.md     this file
├── install.sh    checks cc, pkg-config and libmicrohttpd
├── build.sh      compiles and links
├── run.sh        starts the server (or checks it with --verify)
├── hello.c       the program: request handler + main
├── screenshot.png   the page in a browser (see Expected output)
└── bin/          created by build.sh; not committed
    └── hello-web
```
As in [../cli](../cli/README.md#folder-structure), one `.c` file needs no
project file. The HTML is a string in `hello.c`; one line does not need a
template file.

## Step-by-step walkthrough
Open [`hello.c`](hello.c) next to this list.

1. **Headers.** `<stdio.h>`, `<stdlib.h>`, and `<string.h>` are standard
   C. `<netinet/in.h>` is not: it is POSIX, the operating system's network
   interface. On Windows, the same types come from Winsock, so the
   `#ifndef _WIN32 ... #endif` lines make the preprocessor skip the include
   there. `<microhttpd.h>` is libmicrohttpd's API; every name in it starts
   with `MHD_`, because C has no namespaces.
2. **The page** is `static const char page[] = "<p>Hello, World!</p>";`.
   A C string is an array of `char` that ends with an invisible `'\0'`
   byte, so `sizeof page - 1` is the length of the text.
3. **`answer(...)`, the handler.** libmicrohttpd calls it for every
   request. Its long parameter list is fixed by the library: the project
   page's example handler has the same eight parameters [1]. This program
   uses only `connection` and `url`; the `(void) cls;` lines say the
   others are unused on purpose, which keeps `-Wextra` quiet.
   - `strcmp(url, "/") != 0`: strings are compared with `strcmp`, which
     returns 0 when they are equal. `==` would compare two addresses.
   - `MHD_create_response_from_buffer_static(length, body)` wraps the text
     in a response without copying it. The header documents the rule:
     "The buffer must be valid for the lifetime of the response. The
     easiest way to achieve this is to use a statically allocated
     buffer" [5]. The text is a `static` array, so that holds.
   - `MHD_add_response_header` sets `Content-Type: text/html; charset=utf-8`.
   - `MHD_queue_response(connection, status, response)` sends it, and
     `MHD_destroy_response(response)` releases this function's handle at
     once. The tutorial does the same [6], and the header explains why it is
     safe: "libmicrohttpd may keep some of the resources around if the
     response is still in the queue for some clients" [5]. With no garbage
     collector, C code frees what it creates.
4. **`main`: the port.** `getenv("PORT")` returns `NULL` when `PORT` is not
   set; `atoi` turns the text into a number. The range check (1–65535)
   stops with an error instead of listening on an invalid port.
5. **`main`: the address.** `struct sockaddr_in` is filled with
   `127.0.0.1` (`INADDR_LOOPBACK`), so only this computer can connect.
   `memset` zeroes it first, because C does not initialize local
   variables. `htons`/`htonl` convert the numbers to network byte order.
6. **`MHD_start_daemon(...)`** starts the server. After the port come two
   callbacks with their data (`NULL, NULL`: no access check; then
   `&answer, NULL`), then *options* in pairs, ended by `MHD_OPTION_END`.
   `MHD_OPTION_SOCK_ADDR_LEN` "Bind[s] daemon to the supplied 'struct
   sockaddr'" and is "followed by two parameters: 'socklen_t' the size of
   memory at the next pointer and the pointer" [5]. This is a C *variadic*
   call, like `printf`: the compiler cannot check the types after the
   fixed parameters, so a mistake in the order shows up only at run time.
   `MHD_USE_ERROR_LOG` makes the library "print error messages and warnings
   to stderr" [7] (for example "Address already in use").
7. **The loop: `for (;;) MHD_run_wait(daemon, -1);`.** No threading flag
   was passed, so the server runs in this thread, and `MHD_run_wait` does
   the work: it waits for network events ("If set to '-1' then function
   waits for events indefinitely"), handles them, and returns [5]. The
   header calls it "useful for quick and simple (lazy) webserver
   implementation if application needs to run a single thread only" [5].
   The official tutorial instead starts a server thread and waits for the
   Enter key with `getchar()` before `MHD_stop_daemon` [6]. That would make
   the server stop at once when it runs in the background without a
   keyboard, as `run.sh --verify` does, so this version loops forever and
   is stopped with Ctrl+C. The operating system then closes the socket.

### Why C99 here
Compile `hello.c` as C89 and the compiler points into libmicrohttpd's own
header:
```text
$ cc -std=c89 -pedantic $(pkg-config --cflags libmicrohttpd) -fsyntax-only hello.c
.../microhttpd.h:3231:18: warning: 'long long' is an extension when C99 mode is not enabled [-Wlong-long]
```
`long long` (and `<stdint.h>`, which the header includes) arrived in C99:
the C99 list of changes includes "the long long int type and library
functions" [8]. So the header needs C99, and `build.sh` uses `-std=c99
-pedantic-errors`. `hello.c` itself still follows C89 habits:
`/* */` comments and declarations at the top of each block.

## Why this toolchain
- **GNU libmicrohttpd** for the web version. It is designed for this
  case: an HTTP server embedded in a C program [1].
- **Small and in plain C.** One header, one library, no framework, no code
  generator. The whole server is one function call plus a handler.
- **Maintained and portable.** The project page lists "GNU/Linux, FreeBSD,
  OpenBSD, NetBSD, Android, Darwin (macOS), W32, OpenIndiana/Solaris, and
  z/OS" as supported platforms [1]. Homebrew packages 1.0.10 [2], Debian
  stable 1.0.1 [3], and MSYS2 provides it for Windows [4].
  `MHD_create_response_from_buffer_static` and `MHD_OPTION_SOCK_ADDR_LEN`
  need version 0.9.77 or newer (`MHD_VERSION 0x00097701` and `0x00097706`
  in the header [5]); 1.0.1 has both.
- **Not CGI, not a framework.** A C program could also be run behind
  another web server as a CGI script. That would need a second program
  (for example Apache or nginx) before anything is shown, so this folder
  builds the server into the program instead.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Apple clang 21.0.0, libmicrohttpd 1.0.10, and pkgconf 3.0.10 from Homebrew (bottled for Intel [2]). |
| macOS Apple Silicon | ⚠️ not verified | Same commands; Homebrew has arm64 bottles [2]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `build-essential`, `pkg-config` and `libmicrohttpd-dev` with apt when missing [3]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs MSYS2 in `C:\msys64` and installs the UCRT64 packages `gcc`, `pkgconf` and `libmicrohttpd` with `pacman` when missing [4]. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: bin/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
Listening on http://localhost:8080/
<p>Hello, World!</p>
```
And with the server running (`./run.sh` in another terminal):
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Connection: close
Content-Type: text/html; charset=utf-8
Content-Length: 20

<p>Hello, World!</p>
```
(`curl -i` also prints a `Date:` header, left out here.)

![The page in a browser](screenshot.png)

(Taken on 2026-11-01 on macOS Intel with headless Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. GNU libmicrohttpd (project page: description, license, platforms, stable/experimental versions, example handler). GNU Project. <https://www.gnu.org/software/libmicrohttpd/> (accessed 2026-10-31; archived copy: <https://web.archive.org/web/20261113123927/http://www.gnu.org/software/libmicrohttpd/>, accessed 2026-11-22)
2. libmicrohttpd (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/libmicrohttpd> (accessed 2026-10-31)
3. Package libmicrohttpd-dev (stable). Debian. <https://packages.debian.org/stable/libmicrohttpd-dev> (accessed 2026-10-31)
4. mingw-w64-libmicrohttpd. MSYS2 Packages. <https://packages.msys2.org/base/mingw-w64-libmicrohttpd> (accessed 2026-10-31)
5. `microhttpd.h` from libmicrohttpd 1.0.10 (API documentation comments: `MHD_run_wait`, `MHD_create_response_from_buffer_static`, `MHD_destroy_response`, `MHD_OPTION_SOCK_ADDR_LEN`). Installed by Homebrew at `/usr/local/include/microhttpd.h`; the same file is in the release tarball at <https://ftp.gnu.org/gnu/libmicrohttpd/> (accessed 2026-10-31)
6. A Tutorial for GNU libmicrohttpd (chapter "Hello browser example"). GNU Project. <https://www.gnu.org/software/libmicrohttpd/tutorial.html> (accessed 2026-10-31; archived copy: <https://web.archive.org/web/20260219200524/https://www.gnu.org/software/libmicrohttpd/tutorial.html>, accessed 2026-11-22)
7. The GNU libmicrohttpd Reference Manual (`MHD_USE_ERROR_LOG`, `MHD_OPTION_SOCK_ADDR`). GNU Project. <https://www.gnu.org/software/libmicrohttpd/manual/libmicrohttpd.html> (accessed 2026-10-31; archived copy: <https://web.archive.org/web/20250330001954/https://www.gnu.org/software/libmicrohttpd/manual/libmicrohttpd.html>, accessed 2026-11-22)
8. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99; Foreword list of changes). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (accessed 2026-10-31)
