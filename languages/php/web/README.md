# PHP · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [PHP](../README.md)

## What this is
A web page written in plain PHP and served by the web server that is
built into the `php` program (`php -S`). When a browser asks for
`http://localhost:8080/`, the server runs `public/index.php`, which outputs
the HTML `<p>Hello, World!</p>`. The browser shows it as the text
**Hello, World!**. The server sends the HTML itself; there is no separate
front end, no framework, and no package to download.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| PHP 8 (`php`) | 8.5.11 (Homebrew `php`) | runs `public/index.php` and contains the built-in web server |
| `curl` | system `curl` | only for `./run.sh --verify` and for testing by hand |

Set `PHP=/path/to/php` to use another interpreter.

## Quick start
```sh
./install.sh   # check / install PHP (asks before installing)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `php` is on your `PATH` (and warns if `curl` is missing). If PHP is missing, it shows the install command for your operating system and runs it only if you answer `y`. | The built-in server is part of the `php` program, so PHP is the only dependency. |
| `run.sh` | Starts `php -S 127.0.0.1:8080 -t public`. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | `php -S` starts PHP's development web server [1]. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`: PHP is interpreted, as in [../cli](../cli/README.md#why-there-is-no-build-step).

## Folder structure
```text
web/
├── README.md          this file
├── install.sh         checks / installs PHP
├── run.sh             starts the built-in web server
├── screenshot.png     the page in a browser
└── public/            the document root: only files in here can be requested
    └── index.php      the page
```
Why a `public/` folder? The built-in server sends any file in its document
root. "URI requests are served from the current working directory where
PHP was started, unless the -t option is used to specify an explicit
document root" [1]. Without `-t public`, a request for `/run.sh` returns
the script's source code (checked on the test machine: `200`,
`application/x-sh`). With `-t public`, only `public/` is reachable, and
that is where the page lives.

Why `index.php`? "If a URI request does not specify a file, then either
index.php or index.html in the given directory are returned" [1].

## Step-by-step walkthrough
Open [`public/index.php`](public/index.php) next to this list.

1. **No server code.** Flask (Python), Express (Node.js), Spring Boot (Java),
   and Go's `net/http` versions all create the server and register a
   route for `/` in code. Here the file *is* the page: the PHP server maps
   the URL `/` to `public/index.php` [1] and sends what the file outputs.
2. **`<?php ... ?>` around the comment.** The file starts in PHP mode with
   a `/* */` block comment. "When PHP processes a file, it recognizes the
   opening and closing tags, `<?php` and `?>` to define the boundaries of
   PHP code execution" [2].
3. **Back to HTML.** After `?>`, everything "outside of a pair of opening
   and closing tags is ignored by the PHP parser", that is, it is sent as
   it is [3]. The newline right after `?>` is not sent: "The closing tag
   for the block will include the immediately trailing newline if one is
   present" [4]. So the response starts with `<p>`.
4. **Code inside HTML.** `<p><?php echo "Hello, World!"; ?></p>` is HTML
   with one PHP statement inside. `echo` writes the text where the tag
   stands, between `<p>` and `</p>` [5]. This is PHP's oldest idea; the
   other languages in this repository build the HTML as a string instead.
5. **Content type.** The code sets no header. PHP sends
   `Content-type: text/html; charset=UTF-8` on its own, from the
   `default_mimetype` (`"text/html"`) and `default_charset` (`"UTF-8"`)
   settings [6]. You can see it in the `curl -i` output below.
6. **Every URL answers.** For a path that is not a file, such as `/nothing`,
   the server looks for an `index.php`: "If neither file exists, the
   lookup for index.php and index.html will be continued in the parent
   directory and so on until one is found or the document root has been
   reached" [1]. So `/nothing` also returns the Hello page (checked on the
   test machine), whereas the [Python/Flask](../../python/web/) version,
   which only has a route for `/`, answers `404` (also checked).

## Why this toolchain
- **Plain PHP, no framework.** A framework (e.g. Laravel or Symfony) would
  add a Composer project, a router, and configuration. PHP can already
  serve a page from one file, which fits this repository's "most simple
  and direct" goal.
- **The built-in web server (`php -S`)** comes with the `php` program, so
  nothing else is installed. It has existed since PHP 5.4.0 (2012-03-01): the
  release announcement lists a "Built-in webserver" [7][8].
- **Development only.** The manual is explicit: "This web server is
  designed to aid application development. ... It is not intended to be a
  full-featured web server. It should not be used on a public network" [1].
  Also, "The web server runs only one single-threaded process, so PHP
  applications will stall if a request is blocked" [1]. In production, PHP
  runs behind a web server such as Apache or nginx; that is out of scope
  for a Hello World.
- **127.0.0.1**, not `0.0.0.0`: the server is reachable from this computer
  only, which matches "should not be used on a public network" [1].
- **Port 8080** is the convention of this repository for every web
  implementation.
- **PHP 8.5**: see [../cli](../cli/README.md#why-this-toolchain) for the
  version and support dates.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Homebrew `php` 8.5.11. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel (`brew install php`). |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `php-cli` with apt when `php` is missing. The built-in server is part of the `php` command, so no Apache package is needed [9]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install PHP: if `php` is missing it prints the steps for the "VS17 x64 Non Thread Safe" ZIP from windows.php.net [10] and stops. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'php -S 127.0.0.1:8080 -t public' serves the public/ folder on this computer only.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
[Sat Oct 31 19:09:23 2026] PHP 8.5.11 Development Server (http://127.0.0.1:8080) started
```
Each request is logged on the terminal (`Accepted`, `[200]: GET /`,
`Closing`). In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Host: localhost:8080
Date: Sat, 31 Oct 2026 22:09:30 GMT
Connection: close
X-Powered-By: PHP/8.5.11
Content-type: text/html; charset=UTF-8

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Built-in web server. The PHP Group. <https://www.php.net/manual/en/features.commandline.webserver.php> (accessed 2026-10-31)
2. PHP tags. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.phptags.php> (accessed 2026-10-31)
3. Escaping from HTML. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.phpmode.php> (accessed 2026-10-31)
4. Instruction separation. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.instruction-separation.php> (accessed 2026-10-31)
5. echo. The PHP Group. <https://www.php.net/manual/en/function.echo.php> (accessed 2026-10-31)
6. Description of core php.ini directives (`default_mimetype`, `default_charset`). The PHP Group. <https://www.php.net/manual/en/ini.core.php> (accessed 2026-10-31)
7. PHP 5.4.0 Release Announcement. The PHP Group. <https://www.php.net/releases/5_4_0.php> (accessed 2026-10-31)
8. PHP releases (JSON, version 5.4.0). The PHP Group. <https://www.php.net/releases/index.php?json&version=5.4.0> (accessed 2026-10-31)
9. php-cli package (Debian stable). Debian. <https://packages.debian.org/stable/php-cli> (accessed 2026-10-31)
10. Downloads (Windows). The PHP Group. <https://www.php.net/downloads.php?os=windows> (accessed 2026-10-31)
