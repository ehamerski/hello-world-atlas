# Bash · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Bash](../README.md)

## What this is
A command-line program, written in Bash, that prints one line:
`Hello, World!`. Bash is an interpreter: the `bash` program reads `hello.sh`
and runs its commands from top to bottom [1]. There is no compile step, so
this folder has no `build.sh`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Bash | 5.3.20 (Homebrew formula `bash`) | runs `hello.sh` |
| Homebrew | any recent version | installs the formula `bash`, only if you choose to (optional) |

The program also runs under the system Bash at `/bin/bash`, which is version
3.2.57 on the development Mac (output of `/bin/bash --version`, 2026-11-12). So
the Homebrew install is optional. The formula page lists version 5.3.20, license
GPL-3.0-or-later, and bottles (prebuilt packages) only for Apple Silicon and
Linux, so on macOS Intel `brew install bash` builds from source [2].

## Quick start
```sh
./install.sh   # check Bash (offers brew install bash if Homebrew is present and Bash is missing from it)
./run.sh       # run it
```
There is no `build.sh`: Bash interprets the script.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `bash` is on your PATH and prints its version and the version of `/bin/bash`. If Homebrew is present but its `bash` is not, offers `brew install bash` and runs it only if you answer `y` | `hello.sh` needs a Bash to run it. The Homebrew step is optional, and no `sudo` is used |
| `run.sh` | Runs `bash hello.sh` (`--verify` runs a self-check and exits) | `verify-all.sh` needs a command that prints `Hello, World!` and exits; a cli program needs no extra check |
| `hello.sh` | The program: one `printf` command | The source file the interpreter reads |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks Bash (optional Homebrew install)
├── run.sh         runs hello.sh
└── hello.sh       the program (one command)
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).
A shell script is a text file of shell commands [1].

## Step-by-step walkthrough
1. **`#!/usr/bin/env bash`** is the shebang line. If a script is run as a
   program (`./hello.sh`) and has its execute bit set, Bash runs it as if you
   had typed `bash hello.sh` [1]. `env` finds the first `bash` on your PATH.
2. **Comments** start with `#`: the shell ignores the `#` and the rest of the
   line [3].
3. **`printf 'Hello, World!\n'`** runs the `printf` builtin, a command that
   is part of the shell and needs no import [4]. The first argument is the
   format: plain characters are copied to the output and the escape sequence
   `\n` becomes a newline [4]. `printf` adds no newline of its own, so the
   format ends with `\n`.
4. **Single quotes** preserve the literal value of each character inside
   them, so the shell leaves the text alone [5].
5. **Why `printf` and not `echo`:** POSIX says "New applications are
   encouraged to use printf instead of echo" [6].
6. **No `main`, no semicolon, no import.** Compare [C](../../c/README.md) and
   [OCaml](../../ocaml/README.md), or see the [comparisons](../../../docs/comparisons.md).

## Why this toolchain
- Bash is the shell of the GNU Project and is largely compatible with `sh` [1].
  The GNU page states it is free software under the GNU GPL, version 3 or
  later [7].
- The Homebrew formula `bash` packages 5.3.20 [2]. The Bash home page says
  Bash is maintained by Chet Ramey [7].
- This program uses only `printf`, so it runs the same under Bash 3.2.57 and
  5.3.20 (both runs below).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-12) | Bash 5.3.20 from Homebrew; `install.sh`, `run.sh`, and `run.sh --verify` exit 0; `/bin/bash hello.sh` (3.2.57) prints the same line |
| macOS Apple Silicon | ⚠️ not verified | Homebrew lists a bottle there [2]; the scripts were not run there |
| Linux (Debian/Ubuntu) | ⚠️ not verified | not run there |
| Windows (Git Bash / WSL) | ⚠️ not verified | not run there |

## Expected output
`./run.sh` prints one line after its step messages and exits with status 0:
```text
==> Run the program
    WHY: 'bash hello.sh' starts the interpreter, which runs the file from top to bottom.
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. Bash Reference Manual: 1.1 What is Bash?, 3.8 Shell Scripts. GNU Project. <https://www.gnu.org/software/bash/manual/bash.html> (accessed 2026-11-12; archived copy: <https://web.archive.org/web/20261117122406/https://www.gnu.org/software/bash/manual/bash.html>, accessed 2026-11-22)
2. Homebrew formula `bash` (version 5.3.20, license GPL-3.0-or-later, bottles). Homebrew. <https://formulae.brew.sh/formula/bash> (accessed 2026-11-12)
3. Bash Reference Manual: 3.1 Shell Syntax (comments). GNU Project. <https://www.gnu.org/software/bash/manual/bash.html> (accessed 2026-11-12; archived copy: <https://web.archive.org/web/20261117122406/https://www.gnu.org/software/bash/manual/bash.html>, accessed 2026-11-22)
4. Bash Reference Manual: 4.2 Bash Builtin Commands, `printf`. GNU Project. <https://www.gnu.org/software/bash/manual/bash.html> (accessed 2026-11-12; archived copy: <https://web.archive.org/web/20261117122406/https://www.gnu.org/software/bash/manual/bash.html>, accessed 2026-11-22)
5. Bash Reference Manual: 3.1.2.2 Single Quotes. GNU Project. <https://www.gnu.org/software/bash/manual/bash.html> (accessed 2026-11-12; archived copy: <https://web.archive.org/web/20261117122406/https://www.gnu.org/software/bash/manual/bash.html>, accessed 2026-11-22)
6. echo, application usage. The Open Group Base Specifications Issue 8, IEEE Std 1003.1-2024. <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/echo.html> (accessed 2026-11-12)
7. Bash home page. GNU Project. <https://www.gnu.org/software/bash/> (accessed 2026-11-12; archived copy: <https://web.archive.org/web/20261104064618/http://www.gnu.org/software/bash/>, accessed 2026-11-22)
