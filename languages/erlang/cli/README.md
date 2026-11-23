# Erlang · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Erlang](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.erl`](hello.erl), with one function call, run by the
`escript` command. Erlang is "a programming language used to build
massively scalable soft real-time systems" "with requirements on high
availability" [1]. It runs on the BEAM, the Erlang virtual machine, the
same one that runs the [Elixir](../../elixir/cli/) version of this program.

An *escript* is an Erlang program that runs like a shell script: the
Erlang documentation says that `escript` "provides support for running
short Erlang programs without having to compile them first" [2]. As in the
[Python `cli` version](../../python/cli/), there is no `build.sh`. The
[desktop](../desktop/) and [web](../web/) versions are compiled modules
and do have one.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Erlang/OTP (`escript`, `erl`, `erlc`) | 29.1.2 (Homebrew `erlang` 29.1.2) | `escript` compiles `hello.erl` in memory and runs it on the BEAM |

OTP stands for Open Telecom Platform. It is "set of Erlang libraries and
design principles providing middle-ware to develop these systems" [1], and
it is also the name of the Erlang software distribution [3]. The program
uses only `io:format/1`, from the standard library, so other current
versions should work. Only 29.1.2 was tested.

On Intel Macs, Homebrew has no pre-built package (bottle) for `erlang`: the
formula page lists bottles only for macOS on Apple Silicon and for Linux
[4]. So `brew install erlang` compiles Erlang from source. On the test
machine (2026-11-01), Erlang took about 15 minutes, plus about 7 minutes
for `wxWidgets`, a dependency that Homebrew builds for Erlang [4]. On
Apple Silicon and Linux, the same command installs a bottle.

## Quick start
```sh
./install.sh   # check / install Erlang/OTP (asks before installing)
./run.sh       # run it
```
There is no `build.sh` (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `erl`, `erlc`, and `escript` are on `PATH`. If one is missing, offers `brew install erlang` (macOS), `apt-get install erlang` (Debian and Ubuntu), or explains how to get the Windows installer [5], and runs an install only if you answer `y`. | Erlang code needs the BEAM and `escript`, which come in one package. |
| `run.sh` | Runs `escript hello.erl`. `--verify` does the same (a CLI program ends by itself). | `escript` followed by a file name compiles that file and calls its `main/1` function. |

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks / installs Erlang/OTP
├── run.sh        runs escript hello.erl
└── hello.erl     the program (one function call, teaching comments)
```
- One `.erl` file is a complete program. Nothing is written to disk, so
  nothing needs to be ignored by Git.
- The [desktop](../desktop/) and [web](../web/) folders have an `ebin/`
  folder for compiled code, which `.gitignore` keeps out of Git.

## Step-by-step walkthrough
Open [`hello.erl`](hello.erl) next to this list.

1. **The interpreter line.** `#!/usr/bin/env escript` is the first line.
   The documentation calls it "the interpreter line, which invokes
   `escript`" [2]. When the file is run as `./hello.erl`, the system hands
   it to `escript`. This repository runs it as `escript hello.erl`, so the
   line is only a convention.
2. **Comments** start with `%`. A comment on its own line is usually
   written `%%`.
3. **`-export([main/1]).`** lists the functions that other code may call.
   `main/1` means the function named `main` that takes one argument. The
   number is part of the name, so `main/1` and `main/2` are different
   functions. In an escript, "Both the module declaration and the export
   declaration of the `main/1` function are optional" [2]. The file keeps
   the export to show how a module is written.
4. **`main(_Args) ->`** is the entry point: "the `main/1` function is
   called with a list of strings representing the arguments specified to
   the script" [2]. A name that starts with an uppercase letter is a
   variable, and "Variables start with an uppercase letter or underscore"
   [6]. The underscore in `_Args` tells the compiler and the reader that
   the variable is not used. `->` separates the head of the function from
   its body, and the final `.` ends the function.
5. **`io:format("Hello, World!~n").`** is the whole program. `io` is a
   module, a named group of functions, and `format` is a function in it.
   The colon selects the function from the module. `format/1` is
   "Equivalent to format(Format, [])" [7]. In a format string, "`~n`"
   "Writes a new line" [7]. Python's `print` and Java's `println` add the
   newline by themselves. Erlang does not, so `~n` is required.
6. **Strings are lists.** `"Hello, World!"` is in double quotes, but
   "Strings are enclosed in double quotes ("), but are not a data type in
   Erlang"; a string `"hello"` is shorthand for a list of character codes
   [8].
7. **No assignment.** "Erlang uses single assignment, that is, a variable
   can only be bound once" [6]. The program has no variable except the
   unused `_Args`.
8. **The BEAM.** `escript` starts the Erlang virtual machine, compiles the
   file, and runs it. "By default, the script will be compiled by the
   Erlang compiler" [2]. An escript keeps the
   compiled code in memory.

**Try it** (from this folder, any shell):
```sh
erl -noshell -eval 'io:format("~s~n", [string:uppercase("Hello, World!")]), halt().'
erl -noshell -eval 'io:format("~w~n", [hd("Hello")]), halt().'
```
The first line calls `string:uppercase/1` and prints `HELLO, WORLD!`. The
second prints `72`, the character code of `H`, because a string is a list
of character codes: `~w` "Writes data with the standard syntax" [7].
`-noshell` "Starts an Erlang runtime system with no shell" [9], and
`halt()` ends the virtual machine after the output.

### Why there is no build step
`escript` compiles the file in memory each time it runs [2]. A project
that is installed or shared as compiled code keeps its `.beam` files in an
`ebin/` folder [10]. The [desktop](../desktop/) and [web](../web/)
versions do that, and `erlc` writes the files, so they have a `build.sh`.

## Why this toolchain
- **`escript`** is the way the Erlang documentation describes for running
  a short program without compiling it first [2]. It ships with Erlang/OTP.
- **Homebrew** is the package manager this repository uses on macOS. Its
  `erlang` formula was at 29.1.2 on 2026-11-04 [4], the version that the
  Erlang download page lists as the latest [5]. The download page lists
  `brew install erlang` for macOS [5].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Erlang/OTP 29.1.2 from Homebrew, built from source (no Intel bottle) [4]. |
| macOS Apple Silicon | ⚠️ not verified | `brew install erlang` installs a pre-built bottle [4]. Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `erlang` with apt when `erl`, `erlc` or `escript` is missing [5]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not use a package manager. If Erlang/OTP is missing, it downloads the official 64-bit zip (`otp_win64_29.1.2.zip`), checks its SHA-256 checksum, and unpacks it into `~/.local/otp-29.1.2` (with 7-Zip when Git Bash has no `unzip`) [5]. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: escript compiles hello.erl in memory and calls main/1; there is no build step.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`. To see the exact bytes:
```text
$ escript hello.erl | od -c
0000000    H   e   l   l   o   ,       W   o   r   l   d   !  \n
0000016
```

## Sources
1. Erlang/OTP home page. Ericsson AB, erlang.org. <https://www.erlang.org/> (accessed 2026-11-04)
2. escript. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/escript_cmd.html> (accessed 2026-11-04)
3. A History of Erlang. Joe Armstrong, HOPL III, ACM, 2007. Author's copy. <https://lfe.io/papers/%5B2007%5D%20Armstrong%20-%20HOPL%20III%20A%20History%20of%20Erlang.pdf> (accessed 2026-11-04)
4. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (accessed 2026-11-04)
5. Downloads. Ericsson AB, erlang.org. <https://www.erlang.org/downloads> (accessed 2026-11-04)
6. Expressions (variables, single assignment). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (accessed 2026-11-04)
7. `io` (`format/1`, control sequences `~n` and `~w`). Erlang/OTP documentation, stdlib. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/stdlib/io.html> (accessed 2026-11-04)
8. Data types (atom, list, string). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/data_types.html> (accessed 2026-11-04)
9. `erl` (`-noshell`, `-pa`, `-s`, `+B`). Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erl_cmd.html> (accessed 2026-11-04)
10. Applications (directory structure, `ebin`). Erlang/OTP documentation, Design Principles. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/applications.html> (accessed 2026-11-04)
