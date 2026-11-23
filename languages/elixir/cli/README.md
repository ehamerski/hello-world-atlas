# Elixir · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Elixir](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.exs`](hello.exs), with one function call, run by the
`elixir` command. Elixir is "a dynamic, functional language designed for
building scalable and maintainable applications" [1]. It runs on the
Erlang virtual machine (the BEAM), the same one that runs the
[Erlang](../../erlang/cli/) version of this program.

As in the [Python `cli` version](../../python/cli/), there is no
`build.sh`: `elixir` compiles the script in memory each time it starts.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Elixir (`elixir`) | 1.20.5 (Homebrew `elixir` 1.20.5) | compiles `hello.exs` in memory and runs it |
| Erlang/OTP | 29.1.2 (Homebrew `erlang` 29.1.2, installed as a dependency) | the virtual machine and runtime that Elixir runs on |

The Elixir install page says that "Elixir v1.20.5 requires Erlang 27.0 or
later" [2]. The program uses only `IO.puts/1`, which is in Elixir's
standard library, so other current versions should work. Only 1.20.5 was
tested.

On Intel Macs, Homebrew has no pre-built package (bottle) for `elixir` or
for `erlang`: the formula pages list bottles only for macOS on Apple
Silicon and for Linux [3][4]. So `brew install elixir` compiles Erlang
and Elixir from source. On the test machine (2026-11-01), Erlang took
about 15 minutes, plus about 7 minutes for `wxWidgets`, a dependency that
Homebrew builds for Erlang, and Elixir took 1 minute 41 seconds. On
Apple Silicon and Linux, the same command installs bottles.

## Quick start
```sh
./install.sh   # check / install Elixir (asks before installing)
./run.sh       # run it
```
There is no `build.sh` (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `elixir --version`. If it is missing, offers `brew install elixir` (macOS), the `apt` commands of the install page (Ubuntu), or prints the `choco install elixir` command (Windows) [2], and runs an install only if you answer `y`. | Elixir code needs the Elixir command and Erlang/OTP to run. The Homebrew formula installs both. |
| `run.sh` | Runs `elixir hello.exs`. `--verify` does the same (a CLI program ends by itself). | `elixir` followed by a file name runs that file as a script: the usage line printed by `elixir --help` is `elixir [options] [.exs file] [data]`. |

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks / installs Elixir
├── run.sh        runs elixir hello.exs
└── hello.exs     the program (one function call, teaching comments)
```
- One `.exs` file is a complete program. The Elixir guide says that
  "`.ex` files are meant to be compiled while `.exs` files are used for
  scripting", and that Elixir "treats both files exactly the same way, the
  only difference is in intention" [5].
- Nothing is written to disk, so nothing needs to be ignored by Git.

## Step-by-step walkthrough
Open [`hello.exs`](hello.exs) next to this list.

1. **Comments** start with `#` and run to the end of the line, as in
   Python and Ruby.
2. **`IO.puts("Hello, World!")`** is the whole program. `IO` is a *module*,
   a named group of functions, and `puts` is a function in it. The dot
   selects the function from the module. Elixir has no objects here:
   `IO.puts` is a plain function call. It writes its argument to the
   standard output and adds a newline.
3. **The string** `"Hello, World!"` is in double quotes. In Elixir, "A
   string is a UTF-8 encoded binary" [6].
4. **Parentheses** on a call with arguments are optional in Elixir, so
   `IO.puts "Hello, World!"` is valid too [7]. Parentheses are required
   for calls with no arguments [7].
5. **No `main`.** The file runs from top to bottom, like a Python script.
   Compare the [Haskell](../../haskell/cli/) version, where `main` is a
   named value, and the [C](../../c/cli/) version, where `main` is the
   function the runtime calls.
6. **The BEAM.** The `elixir` command starts the Erlang virtual machine,
   compiles the script into bytecode in memory, and runs it. The bytecode
   that `elixirc` writes to disk is stored in `.beam` files [5].

**Try it** (from this folder, any shell):
```sh
elixir -e '"Hello, World!" |> String.upcase() |> IO.puts()'
elixir -e 'IO.puts(:binary.first("Hello"))'
```
The first line uses the pipe operator `|>`. Its documentation says that it
"introduces the expression on the left-hand side as the first argument to
the function call on the right-hand side" [8]: it prints `HELLO, WORLD!`.
The second line calls an Erlang module, `:binary`, from Elixir. An Erlang
module name is an atom, so it starts with a colon [9]. It prints `72`, the
byte value of `H`.

### Why there is no build step
The Elixir guide shows a script run with `elixir` and explains: "Because
we used `elixir` instead of `elixirc`, the module was compiled and loaded
into memory, but no `.beam` file was written to disk" [5]. `elixirc` is
the command that compiles files into `.beam` files. The [web](../web/)
version is a Mix project: Mix compiles it and keeps the result in
`_build/`.

## Why this toolchain
- **The `elixir` command** is the way the Elixir team documents for
  running a script [5]. It ships with the language, and needs nothing but
  Erlang/OTP [2].
- **Homebrew** is the package manager this repository uses on macOS. Its
  `elixir` formula was at 1.20.5 on 2026-11-04 [3], the version that the
  GitHub releases page lists as the latest (2026-10-29) [10]. The install
  page of the Elixir team lists `brew install elixir` for macOS [2].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Elixir 1.20.5 on Erlang/OTP 29.1.2 from Homebrew, built from source (no Intel bottle) [3][4]. |
| macOS Apple Silicon | ⚠️ not verified | `brew install elixir` installs pre-built bottles [3][4]. Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` does not use apt, because Ubuntu's package has Elixir 1.18 and `mix.exs` needs 1.20 or newer. If `elixir` is missing, it downloads the official install script from elixir-lang.org, checks its SHA-256 checksum, and runs it. The script puts Elixir 1.20.5 and Erlang/OTP 29.1 into `~/.elixir-install/installs` without sudo [2]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. If `elixir` is missing, `install.sh` runs the official install script from elixir-lang.org after checking its SHA-256 checksum, as on Linux [2]. Git Bash has no `unzip`, so `install.sh` puts a small `unzip` on PATH for itself that calls 7-Zip. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: elixir compiles hello.exs in memory, runs it on the BEAM, and exits
         when the script ends.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`. To see the exact bytes:
```text
$ elixir hello.exs | od -c
0000000    H   e   l   l   o   ,       W   o   r   l   d   !  \n
0000016
```

## Sources
1. Elixir v1.0 released. José Valim, elixir-lang.org, 2014-09-18. <https://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/> (accessed 2026-11-04)
2. Install Elixir. The Elixir team, elixir-lang.org. <https://elixir-lang.org/install/> (accessed 2026-11-04)
3. `elixir` formula. Homebrew. <https://formulae.brew.sh/formula/elixir> (accessed 2026-11-04)
4. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (accessed 2026-11-04)
5. Modules and functions (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/1.18.1/modules-and-functions.html> (accessed 2026-11-04)
6. Binaries, strings, and charlists (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/binaries-strings-and-charlists.html> (accessed 2026-11-04)
7. Syntax reference. Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/syntax-reference.html> (accessed 2026-11-04)
8. `Kernel.|>/2`. Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Kernel.html#%7C%3E/2> (accessed 2026-11-04)
9. Erlang libraries (Getting started). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/erlang-libraries.html> (accessed 2026-11-04)
10. Releases. elixir-lang/elixir, GitHub. <https://github.com/elixir-lang/elixir/releases> (accessed 2026-11-04)
