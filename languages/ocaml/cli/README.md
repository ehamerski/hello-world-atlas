# OCaml · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [OCaml](../README.md)

## What this is
A command-line program, written in OCaml, that prints one line:
`Hello, World!`. The compiler `ocamlopt` turns `hello.ml` into a native
executable, `build/hello`. OCaml has two other commands that look similar. The
`ocaml` command is the toplevel, an interactive loop that can also run a
script [1]. The `ocamlc` command compiles to bytecode instead of native code
[2]. This folder uses `ocamlopt` because it links a standalone native executable [2].

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| OCaml (`ocamlopt`) | 5.5.2 (Homebrew formula `ocaml`, built from source) | compiles `hello.ml` to a native program |
| C compiler (Apple clang) | from the Command Line Tools | `ocamlopt` calls it to assemble and link |
| Homebrew | any recent version | installs `ocaml` (only if `ocamlopt` is missing) |

Homebrew checks the SHA-256 of the source archive before it builds. For
version 5.5.2 the formula lists
`5503e1baad8b625da35f1fe71d47558014fa36253ae5f1a22cc3a18fab041e0d` for
`ocaml-5.5.2.tar.xz` [3]. The formula lists no bottle for macOS Intel, so
`brew install ocaml` compiles OCaml on your machine [3].

## Quick start
```sh
./install.sh   # check / install ocamlopt (asks before running brew install ocaml)
./build.sh     # compile hello.ml to build/hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `ocamlopt` is installed and is version 5.5.2. If not, offers `brew install ocaml` | OCaml needs a compiler. `ocaml-env.sh` pins the version and finds Homebrew's folder, so no shell setup is needed |
| `build.sh` | Copies `hello.ml` into `build/` and runs `ocamlopt -o hello hello.ml` there | `ocamlopt` writes `hello.cmi`, `hello.cmx`, and `hello.o` next to the source file; the copy keeps the source folder clean |
| `run.sh` | Runs `build/hello`. `--verify` runs the same check and exits by itself | `verify-all.sh` needs a command that prints `Hello, World!` and exits |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs ocamlopt (Homebrew formula ocaml)
├── ocaml-env.sh   pinned version, source SHA-256, Homebrew path (sourced)
├── build.sh       compiles hello.ml (in build/)
├── run.sh         runs build/hello
├── hello.ml       the program (one phrase)
└── build/         generated files, ignored by git
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).
A source file with the extension `.ml` is an OCaml implementation file [2].

## Step-by-step walkthrough
1. **Comments** start with the two characters `(` and `*` and end with `*` and
   `)`. They can nest [8].
2. **`let () = ...`** is a phrase. A `.ml` file is a sequence of phrases that
   OCaml evaluates in order, so the program needs no `main` function [4]. The
   left side, `()`, is the value of type `unit`, the type of an expression that
   returns no useful result: the manual shows `- : unit = ()` as the result of
   such a call [4].
3. **`print_endline "Hello, World!"`** calls a function from the standard
   library, which OCaml opens for every program. Its documentation reads: "Print
   a string, followed by a newline character, on standard output and flush
   standard output" [5]. This is why `hello.ml` uses `print_endline`:
   `print_string` prints a string with no newline [5], so the output would lack
   the final newline.
4. **No semicolon, no braces, no `main`.** Compare [C](../../c/README.md) and
   [Java](../../java/README.md).

The difference between the three commands:

| Command | What it does | Source |
|---|---|---|
| `ocaml` | toplevel: reads phrases, evaluates them, prints the result; can also run a script file | [1] |
| `ocamlc` | batch compiler to bytecode | [2] |
| `ocamlopt` | batch compiler to native code, faster at run time, slower to compile | [2] |

## Why this toolchain
- `ocamlopt` is the OCaml native-code compiler. It is part of the OCaml
  distribution [2]. Its output is an executable, so the scripts follow the same
  `build.sh`, `run.sh` pattern as the other compiled languages.
- The Homebrew formula `ocaml` packages version 5.5.2 (license LGPL-2.1-only
  with the OCaml linking exception) [3]. The OCaml project lists 5.5.2 as released on
  2026-10-23 [6].
- OCaml.org describes other ways to install OCaml [7]. This folder uses Homebrew
  because Homebrew checks the SHA-256 of the source archive [3].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-11) | OCaml 5.5.2 from the Homebrew formula; `install.sh`, `build.sh`, `run.sh`, and `run.sh --verify` run from a clean shell (`env -i`) |
| macOS Apple Silicon | ⚠️ not verified | Homebrew lists a bottle for Apple Silicon [3]; the scripts were not run there |
| Linux (Debian/Ubuntu) | ⚠️ not verified | the scripts use Homebrew on Linux; not run there |
| Windows (Git Bash / WSL) | ⚠️ not verified | not run; see the OCaml install page [7] |

## Expected output
Run these commands in this folder:
```sh
./build.sh
./run.sh
```
`./run.sh` prints one line after its step messages and exits with status 0:
```text
==> Run the program
    WHY: build/hello is the native program that build.sh made from hello.ml.
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. The toplevel system or REPL (`ocaml`), chapter 14 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/toplevel.html> (accessed 2026-11-11)
2. Native-code compilation (ocamlopt), chapter 16 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/native.html> (accessed 2026-11-11)
3. Homebrew formula `ocaml` (version 5.5.2, source SHA-256, bottles). Homebrew. <https://formulae.brew.sh/formula/ocaml> (accessed 2026-11-11)
4. The core language, chapter 1 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/coreexamples.html> (accessed 2026-11-11)
5. The OCaml library, module `Stdlib`, release 5.5. Inria. <https://ocaml.org/manual/5.5/api/Stdlib.html> (accessed 2026-11-11)
6. OCaml 5.5.2 release notes. OCaml.org. <https://ocaml.org/releases/5.5.2> (accessed 2026-11-11)
7. Install OCaml. OCaml.org. <https://ocaml.org/install> (accessed 2026-11-11)
8. Lexical conventions, chapter 11 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/lex.html> (accessed 2026-11-11)
