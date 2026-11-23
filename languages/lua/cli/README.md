# Lua · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Lua](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and a newline,
then exits. The whole program is one line of Lua: `print("Hello, World!")`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Lua (`lua`; `lua5.4` on Debian and Ubuntu) | 5.5.1 (Homebrew formula `lua`) | the interpreter that runs `hello.lua` |

Any Lua 5.x version works, because this program uses only `print`. Lua 5.5
is the current version, and 5.5.1 is its current release [1]. Homebrew's
`lua` formula installs it [2].

## Quick start
```sh
./install.sh   # check / install Lua (asks before installing)
./run.sh       # run it
```
There is no `build.sh`. Lua is run from source, so you run the source file
directly (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that the interpreter (`lua`, or `lua5.4` on Linux) is on your PATH. If it is missing, it shows the install command for your OS (Homebrew or apt) and runs it only if you answer `y`. | The program cannot run without the interpreter. |
| `run.sh` | Runs `lua hello.lua`. `--verify` does the same thing, because a cli program ends on its own. | One command to run the program, with an explanation of what happens. |

Both scripts accept `LUA=<command>` to use another interpreter, for example
`LUA=lua5.4 ./run.sh`.

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Lua
├── run.sh         runs the program
└── hello.lua      the program (one line of code plus teaching comments)
```
A single `.lua` file is a complete Lua program. The reference manual calls a
unit of Lua code a *chunk* and says that "a chunk can be stored in a file
or in a string inside the host program" [3]. The `lua` program is the
"stand-alone" host program that runs a file [3]. A project needs more structure only when it uses modules,
as the [web](../web/README.md) implementation does with LuaRocks.

## Step-by-step walkthrough
Open [`hello.lua`](hello.lua) next to this list.

1. **Comments.** "A comment starts with a double hyphen (`--`) anywhere
   outside a string" [3]. The interpreter skips them. Python and Perl use
   `#` instead, and C, Java, and Go use `//`.
2. **No entry point.** Lua runs a file from top to bottom. The first line of
   code is where the program starts. C, Java, C#, and Go need a function
   called `main` instead (in Java and C#, it lives inside a class).
3. **No import.** `print` belongs to the base library, which every Lua
   program has [3]. In C you first write `#include <stdio.h>` to use `printf`.
4. **The call.** `print("Hello, World!")` "prints their values to stdout"
   [3]. Strings can use double or single quotes: `'Hello, World!'` works
   the same [3]. The manual adds that `print` "is not intended for
   formatted output, but only as a quick way to show a value" [3].
5. **No braces, and the semicolon is optional.** A line ends the statement.
   The manual says Lua lets you separate statements with semicolons [3],
   but this program has none.

### Why there is no build step
Lua is "a powerful, efficient, lightweight, embeddable scripting language"
[4]. The manual explains how a chunk runs: "Lua first loads it,
precompiling the chunk's code into instructions for a virtual machine, and
then Lua executes the compiled code with an interpreter for the virtual
machine" [3]. That happens in memory, each time the program runs. A
compiled language like C needs a separate `build.sh` that turns the source
into an executable before `run.sh` can start it. Lua can also save
precompiled chunks with the `luac` program [3], but this program does not
need them.

## Why this toolchain
- **The reference implementation.** "The Lua distribution includes a host
  program called `lua`, which uses the Lua library to offer a complete,
  standalone Lua interpreter" [3]. The distribution is "implemented in pure
  ISO C" [1]. The language is designed, implemented, and maintained at
  PUC-Rio [4].
- **Lua 5.5.1.** Lua 5.5 was released on 2025-12-22, and 5.5.1 is its
  current release, released on 2026-08-03 [5]. Homebrew's `lua` formula
  packages 5.5.1 [2].
- **Homebrew** (macOS) and **apt** (Debian and Ubuntu) are the standard
  package managers there. Lua.org distributes the source code, and lists
  third-party binaries separately [1].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Homebrew `lua` 5.5.1. |
| macOS Apple Silicon | ⚠️ not verified | Same command as Intel (`brew install lua`). |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `lua5.4` with apt when it is missing [6]. The scripts call `lua5.4`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. Lua.org distributes source code only [1]. If `lua` is missing, `install.sh` installs the MSYS2 Lua package (Lua 5.5) with `pacman` (MSYS2 is pre-installed in `C:\msys64`) and adds `C:\msys64\ucrt64\bin` to the end of PATH. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ lua hello.lua
Hello, World!
```
`./run.sh` prints its explanation first (lines starting with `==>` and
`WHY:`), then the same line.

## Sources
1. Download. Lua.org, PUC-Rio. <https://www.lua.org/download.html> (accessed 2026-11-04)
2. `lua` formula. Homebrew. <https://formulae.brew.sh/formula/lua> (accessed 2026-11-04)
3. Lua 5.5 Reference Manual. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. <https://www.lua.org/manual/5.5/manual.html> (accessed 2026-11-04)
4. About Lua. Lua.org, PUC-Rio. <https://www.lua.org/about.html> (accessed 2026-11-04)
5. Version history. Lua.org, PUC-Rio. <https://www.lua.org/versions.html> (accessed 2026-11-04)
6. `lua5.4` package (Debian stable). Debian. <https://packages.debian.org/stable/lua5.4> (accessed 2026-11-04)
