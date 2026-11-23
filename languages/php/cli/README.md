# PHP · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [PHP](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and a newline,
then exits. The program is one statement: `echo "Hello, World!\n";`, after
the `<?php` opening tag that every PHP file starts with.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| PHP 8 (`php`) | 8.5.11 (Homebrew `php`) | the interpreter that runs `hello.php` |

Any supported PHP 8 version works: this program uses only `echo`. On
2026-10-31 the supported branches were 8.2, 8.3, 8.4, and 8.5 [7].

Set `PHP=/path/to/php` to use another interpreter, for example a second
PHP version.

## Quick start
```sh
./install.sh   # check / install PHP (asks before installing)
./run.sh       # run it
```
There is no `build.sh`. PHP is an interpreted language, so you run the
source file directly (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `php` is on your `PATH` and prints its version. If it is missing, it shows the install command for your operating system (Homebrew, apt, or the ZIP download on Windows) and runs it only if you answer `y`. | The program cannot run without the interpreter. |
| `run.sh` | Runs `php hello.php`. `--verify` does the same thing, because a cli program ends on its own. | One command for students, with an explanation of what happens. |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs PHP
├── run.sh         runs the program
└── hello.php      the program (one statement plus teaching comments)
```
A single `.php` file is a complete PHP program. The manual's first way to
use the command line is "Tell PHP to execute a certain file", as in
`php my_script.php` [3]. A project only needs a `composer.json` (and a
`vendor/` folder) when it uses third-party packages: "Composer is a tool for
dependency management in PHP" [13]. This program uses none.

## Step-by-step walkthrough
Open [`hello.php`](hello.php) next to this list.

1. **The opening tag `<?php`.** "When PHP processes a file, it recognizes
   the opening and closing tags, `<?php` and `?>` to define the boundaries
   of PHP code execution" [1]. Text outside the tags is copied to the
   output unchanged; that is how PHP mixes code into HTML (see the
   [web](../web/README.md) version). Python, Java, and Go have no such tag.
2. **Comments.** `/* ... */` spans several lines; `//` and `#` run to the
   end of the line. Note: "The 'one-line' comment styles only comment
   to the end of the line or the current block of PHP code, whichever comes
   first" [4], so a `?>` inside a `//` comment ends PHP mode. That is why
   `hello.php` only mentions the closing tag inside its `/* */` block.
3. **No entry point.** Like Python, PHP runs the file from top to bottom.
   C, Java, C#, and Go need a `main` function instead.
4. **`echo`.** "`echo` is not a function but a language construct" [2],
   so it needs no parentheses. It "Outputs one or more expressions, with no
   additional newlines or spaces" [2]: unlike Python's `print()`, the
   newline is written by hand, as in C's `printf`.
5. **Double quotes and `\n`.** In a double-quoted string PHP turns `\n`
   into a "linefeed (LF or 0x0A (10) in ASCII)" [5]. In a single-quoted string
   "escape sequences for special characters will not be expanded" [5], so
   `'Hello, World!\n'` would print a backslash and an `n`.
6. **The semicolon** ends the statement, as in C and Java.
7. **No closing tag.** "If a file ends with PHP code, it is preferable to
   omit the PHP closing tag at the end of the file. This prevents
   accidental whitespace or new lines being added after the PHP closing
   tag" [1].

Compare with the web version in [../README.md](../README.md#comparing-the-categories).

### Why there is no build step
`php hello.php` reads the source and runs it: "The PHP executable can be
used to run PHP scripts absolutely independent of the web server" [3].
Internally the engine still compiles the script to bytecode before running
it; the OPcache extension exists to keep that "precompiled script
bytecode in shared memory, thereby removing the need for PHP to load and
parse scripts on each request" [6]. Either way it happens automatically.
A compiled language like C needs a separate `build.sh` that turns the
source into an executable before `run.sh` can start it.

## Why this toolchain
- **The `php` command (CLI SAPI)** is the official PHP interpreter from
  php.net, built for the command line: "The main focus of CLI SAPI is for
  developing shell applications with PHP" [12]. `php -v` prints `(cli)` to
  show this build.
- **PHP 8.5** is the newest release branch. It was first released on
  2025-11-20, has active support until 2027-12-31 and security support
  until 2029-12-31 (php.net, checked 2026-10-31) [7]. The test machine
  (macOS Intel) has 8.5.11; Homebrew's stable `php` was 8.5.12 on 2026-10-31 [8].
  `hello.php` also runs on older PHP versions, because `echo` has not
  changed.
- **Homebrew** (macOS) is the install method the PHP manual describes:
  "An easy way to install PHP on macOS is with the Homebrew packaging
  manager" [9]. Linux uses the distribution's packages [10]; Windows uses
  the official ZIP builds from php.net [11].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Homebrew `php` 8.5.11. |
| macOS Apple Silicon | ⚠️ not verified | Same command as Intel (`brew install php`); Homebrew builds `php` for Apple Silicon [8]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `php-cli` with apt when `php` is missing [14]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install PHP: if `php` is missing it prints the steps for the "VS17 x64 Non Thread Safe" ZIP from windows.php.net [11] and stops. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ php hello.php
Hello, World!
```
`./run.sh` prints its explanation first (lines starting with `==>` and
`WHY:`), then the same line.

## Sources
1. PHP tags. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.phptags.php> (accessed 2026-10-31)
2. echo. The PHP Group. <https://www.php.net/manual/en/function.echo.php> (accessed 2026-10-31)
3. Usage: Executing PHP files. The PHP Group. <https://www.php.net/manual/en/features.commandline.usage.php> (accessed 2026-10-31)
4. Comments. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.comments.php> (accessed 2026-10-31)
5. Strings. The PHP Group. <https://www.php.net/manual/en/language.types.string.php> (accessed 2026-10-31)
6. OPcache: Introduction. The PHP Group. <https://www.php.net/manual/en/book.opcache.php> (accessed 2026-10-31)
7. Supported Versions. The PHP Group. <https://www.php.net/supported-versions.php> (accessed 2026-10-31)
8. `php` formula. Homebrew. <https://formulae.brew.sh/formula/php> (accessed 2026-10-31)
9. Installation on macOS: Using Packages. The PHP Group. <https://www.php.net/manual/en/install.macosx.packages.php> (accessed 2026-10-31)
10. Installing PHP on Debian GNU/Linux and Ubuntu. The PHP Group. <https://www.php.net/manual/en/install.unix.debian.php> (accessed 2026-10-31)
11. Downloads (Windows). The PHP Group. <https://www.php.net/downloads.php?os=windows> (accessed 2026-10-31)
12. Command line usage. The PHP Group. <https://www.php.net/manual/en/features.commandline.php> (accessed 2026-10-31)
13. Introduction. Composer. <https://getcomposer.org/doc/00-intro.md> (accessed 2026-10-31)
14. php-cli package (Debian stable). Debian. <https://packages.debian.org/stable/php-cli> (accessed 2026-10-31)
15. Manual installation of pre-built binaries (Windows). The PHP Group. <https://www.php.net/manual/en/install.windows.manual.php> (accessed 2026-10-31)
