# Perl · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Perl](../README.md)

## What this is
A small web server written with Mojolicious, in its one-file mode
Mojolicious::Lite. When a browser asks for `http://localhost:8080/`, the
server answers with the HTML `<p>Hello, World!</p>`, which the browser shows
as the text **Hello, World!**. The server sends the HTML itself; there is no
separate front end.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Perl 5 (`perl`) | 5.34.1 (the `/usr/bin/perl` that comes with macOS) | runs Mojolicious and `app.pl` |
| Mojolicious | 9.53 (CPAN, pinned in `mojo-env.sh`, installed into `local/`) | the web framework [1] |
| `curl` and `shasum` | the ones that come with macOS | download and check the tarball; `curl` also serves `./run.sh --verify` |

Mojolicious 9.53 declares that it needs Perl 5.016 or newer, plus
`IO::Socket::IP` 0.37 and `Sub::Util` 1.41 [2]. On the macOS system Perl
5.34.1 nothing else had to be installed. The Mojolicious FAQ says the
project keeps the distribution installable down to Perl 5.16.0 [3].

## Quick start
```sh
./install.sh   # check Perl, download and install Mojolicious into local/ (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks `perl` and shows how to install it. 2. Downloads the Mojolicious tarball from CPAN, checks its SHA-256 checksum against the one pinned in `mojo-env.sh`, then runs `perl Makefile.PL INSTALL_BASE=...`, `make` and `make install` to put it into `local/`. The install asks first. | Mojolicious is not part of Perl. A private `local/` folder keeps it out of your system Perl, and `INSTALL_BASE` is the MakeMaker setting for that [4]. The checksum proves that the file is the pinned release. Mojolicious has no C code, so `make` only copies files. |
| `mojo-env.sh` | Sourced by the other scripts: the pinned version, URL and checksum, and `PERL5LIB`. Not run on its own. | One place for the pinned values, shared by `install.sh` and `run.sh`. |
| `run.sh` | Starts `perl app.pl daemon -l http://127.0.0.1:8080` with `local/lib/perl5` on `PERL5LIB` [5]. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | The `daemon` command starts Mojolicious's built-in web server [6]. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`, because Perl is interpreted, as in the
[cli](../cli/README.md#why-there-is-no-build-step).

## Folder structure
```text
web/
├── README.md      this file
├── install.sh     checks Perl, installs Mojolicious into local/
├── mojo-env.sh    pinned version, URL, checksum and PERL5LIB (sourced)
├── run.sh         starts the server
├── app.pl         the web application (a Mojolicious::Lite app)
├── .gitignore     keeps local/ out of git
└── local/         created by install.sh: tarball in src/, modules in lib/perl5/
```
- `app.pl` is a Mojolicious::Lite app: the whole application is one script
  [2]. The Mojolicious documentation shows how to grow it into a full
  application with controllers and templates when it gets bigger [7]. A
  single page needs neither.
- `local/` is the private library that `INSTALL_BASE` creates (`lib/perl5` for
  the modules) [4]. It is deleted and rebuilt safely by `install.sh`.

## Step-by-step walkthrough
Open [`app.pl`](app.pl) next to this list.

1. **`use Mojolicious::Lite;`** loads the framework. Unlike the
   [cli](../cli/hello.pl), which uses only the built-in `print`, this program
   depends on a module from CPAN. Mojolicious::Lite "automatically enables
   'strict', 'warnings', 'utf8' and Perl 5.16 features" [2], so the program does
   not need the `use strict; use warnings;` lines of the cli version. It
   also adds the functions `get` and `app` to the file.
2. **`get '/' => sub { ... };`** registers a handler for GET requests to the
   URL `/`. `sub { ... }` is an anonymous function, a value that holds code,
   and `=>` is Perl's "fat comma" that pairs the URL with it. Other frameworks
   in this repository register routes in their own way: Flask uses
   `@app.route("/")`, Express uses `app.get("/", ...)`, and Go uses
   `http.HandleFunc("/", ...)`.
3. **`my $c = shift;`** takes the first argument of the function. Perl passes
   arguments in the array `@_`, and `shift` removes the first one. Mojolicious
   passes a controller object, which holds the request and builds the
   response. (With newer Perl, `sub ($c) { ... }` is possible, but it needs
   Perl 5.20 or later [2][3].)
4. **`$c->render(text => '<p>Hello, World!</p>', format => 'html');`** sends
   the text as the body of the response. The `text` value is encoded to bytes
   by Mojolicious [8], and `format => 'html'` makes the content type `text/html`, so
   the browser shows the text inside the `<p>` paragraph tag. You can see
   this in the `curl -i` output below.
5. **`app->start;`** hands control to Mojolicious's command system. With the
   command `daemon` and the option `-l` (listen), it starts the web server on
   the given address [6][9]. The program stays in this call, waiting for
   requests. This is the biggest difference from the cli version, which runs
   once and exits.

## Why this toolchain
- **Mojolicious** describes itself as "an amazing real-time web framework"
  with routes, plugins, commands and templates built in [1]. Mojolicious::Lite
  "is a tiny domain specific language built around Mojolicious, made up of
  only about a dozen Perl functions" [2]. That makes it the smallest setup for
  an HTML Hello World in Perl: one file, no configuration, and a server
  included.
- **Pure Perl.** The distribution is installed with `make`, but nothing is
  compiled. This is the opposite of the [desktop](../desktop/README.md)
  version, which has to build Tcl.pm.
- **Why not the others.** CPAN has other web frameworks (and PSGI, the
  interface that many of them share), but this page does not compare them:
  the version here is the one that needs the fewest steps. Choosing it is a
  decision about this repository, not a ranking of Perl frameworks.
- **Port 8080** instead of Mojolicious's default `http://*:3000` [6], to match
  every web implementation in this repository.
- **127.0.0.1**, so the server is reachable from this computer only.
- **Development server.** The built-in server "is usually used during
  development" and is "solid and fast enough for small to mid sized
  applications" [10]. `daemon` starts it in "development" mode by default
  [6], where the log level is "trace" and messages go to `STDERR` [9]: that
  is why the terminal shows a line for every request. For production the
  Mojolicious docs describe Hypnotoad, a server "optimized for high
  availability non-containerized production environments" [11]. That is out
  of scope for a Hello World program.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | System Perl 5.34.1, Mojolicious 9.53. Nothing was compiled. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `perl` with apt when it is missing [12]. Then it downloads Mojolicious from CPAN, checks its SHA-256 checksum, and installs it into `local/`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. The Perl of Git Bash cannot build modules (it has no `ExtUtils::MakeMaker`), so `install.sh` installs the MSYS2 packages for Perl, GCC and `mingw32-make` with `pacman` (MSYS2 is pre-installed in `C:\msys64`) and puts `C:\msys64\ucrt64\bin` first on PATH. Then it builds Mojolicious into `local/`. Mojolicious says that "Windows is not officially supported" [3]; it works in this check. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'perl app.pl daemon' serves app.pl; 127.0.0.1 means this computer only.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
[2026-11-04 13:16:12.02311] [12921] [info] Listening at "http://127.0.0.1:8080"
Web application available at http://127.0.0.1:8080
```
(Each log line starts with the date and the process id. The server also
logs a `[trace]` line for every request.) In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html;charset=UTF-8
Date: Wed, 04 Nov 2026 16:15:25 GMT
Server: Mojolicious (Perl)

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Mojolicious: Real-time web framework (release 9.53). Sebastian Riedel and others, MetaCPAN. <https://metacpan.org/pod/Mojolicious> (accessed 2026-11-04)
2. Mojolicious::Lite: Micro real-time web framework. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Lite> (accessed 2026-11-04)
3. Mojolicious::Guides::FAQ. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::FAQ> (accessed 2026-11-04)
4. ExtUtils::MakeMaker: INSTALL_BASE. Perl 5 porters, MetaCPAN. <https://metacpan.org/pod/ExtUtils::MakeMaker#INSTALL_BASE> (accessed 2026-11-04)
5. perlrun: PERL5LIB. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlrun> (accessed 2026-11-04)
6. Mojolicious::Command::daemon: Daemon command. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Command::daemon> (accessed 2026-11-04)
7. Mojolicious::Guides::Growing. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Growing> (accessed 2026-11-04)
8. Mojolicious::Guides::Rendering. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Rendering> (accessed 2026-11-04)
9. Mojolicious::Guides::Tutorial. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Tutorial> (accessed 2026-11-04)
10. Mojolicious::Guides::Cookbook. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Cookbook> (accessed 2026-11-04)
11. Mojolicious::Guides::Cookbook: Hypnotoad. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Cookbook#Hypnotoad> (accessed 2026-11-04)
12. Package perl (trixie). Debian. <https://packages.debian.org/stable/perl> (accessed 2026-11-04)
