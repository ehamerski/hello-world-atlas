# Eiffel · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Eiffel](../README.md)

## What this is
A command-line program, written in Eiffel, that prints one line:
`Hello, World!`. Gobo's compiler `gec` checks the program and turns it into a
native program (`build/hello`). The program also shows **Design by Contract**:
the routine `say` states what it requires from its caller (`require`), and the
query `greeting` states what it promises back (`ensure`).
This build (`gec hello.e`, no ECF file) does not check these contracts at run
time: a test version of `greeting` that returned an empty string ran and printed
an empty line, with no assertion violation.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Gobo Eiffel compiler (`gec`) | 26.03 (Homebrew formula `gobo`, bottle) | compiles `hello.e` to a native program |
| C compiler (Apple clang) | from the Command Line Tools | `gec` calls it to make the executable |
| Homebrew | any recent version | installs `gobo` (only if `gec` is missing) |

## Quick start
```sh
./install.sh   # check / install gec (asks before running brew install gobo)
./build.sh     # compile hello.e to build/hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `gec` is on PATH. If not, offers `brew install gobo` | Eiffel needs a compiler; the Homebrew bottle is ready-built |
| `build.sh` | Runs `gec ../hello.e` inside `build/` | `gec` names the program after the root class (`hello`) and writes its own files in the current folder, so the work stays in `build/` |
| `run.sh` | Runs `build/hello`. `--verify` runs the same check and exits by itself | `verify-all.sh` needs a command that prints `Hello, World!` and exits |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs gec (Homebrew formula gobo)
├── build.sh       compiles hello.e (in build/)
├── run.sh         runs build/hello
├── hello.e        the program (one class, HELLO)
└── build/         generated files, ignored by git
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).
By convention the file is named after the class in lower case (`hello.e` for `class HELLO`).

## Step-by-step walkthrough
1. **`class HELLO`** and **`create make`**. A class is the unit of Eiffel. The
   `create` clause names the creation routine `make`, which runs first.
2. **`make`** calls `say (greeting)`. A routine's body sits between `do` and
   `end`; Eiffel has no braces.
3. **`greeting: STRING`** is a query (a routine that returns `Result`). Its
   `ensure` clause comes **after** `do`. `not_empty: not Result.is_empty` is a
   labeled postcondition: it must be true when the routine returns.
4. **`say (a_text: STRING)`** has a `require` clause before `do`:
   `text_attached: a_text /= Void` is a precondition. It says that the caller
   must give a real string (not `Void`), so the routine does not have to check
   for it.
5. **`io.put_string`** and **`io.put_new_line`** write the text. `io` is a
   standard object that the Gobo kernel defines as `io: STD_FILES` (installed
   file `library/free_elks/src/elks/kernel/any.e`, line 284 in Gobo 26.03).

Design by Contract, in one sentence: a routine's **precondition** binds the
caller, its **postcondition** binds the routine, and a class **invariant** must
hold for every object from outside (ECMA-367, section 8.9). Gobo's compiler
checks the types of the arguments at compile time (`attached` types).
Differences from other languages: no `main` function, no braces, and `:=` for
assignment. Compare [Java](../../java/README.md) and
[Python](../../python/README.md).

## Why this toolchain
- The language is defined by the standard ECMA-367 (ECMA International, 2nd
  edition, June 2006) [1]. `gec` compiles it: the program here was built and
  run with it.
- **Gobo** is MIT-licensed, distributed as a Homebrew bottle, and version 26.03
  is the one used here (`brew info gobo`) [2][3]. Homebrew ships 26.03; the
  Gobo project has released newer versions (26.10 on 2026-10-19 [5]), which this
  folder has not tested.
- **EiffelStudio** is the IDE from Eiffel Software [1][4]. It is not needed for
  this command-line program; the language is the same.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | `install.sh` (gec already present), `build.sh`, `run.sh --verify` |
| macOS Apple Silicon | ⚠️ not verified | the Gobo bottle exists for other systems; not run here |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` stops and points to gobosoft.com |
| Windows (Git Bash / WSL) | ⚠️ not verified | not run; the scripts target POSIX sh |

## Expected output
`./run.sh` (after `./build.sh`) prints one line and exits with status 0:
```text
==> Run the program
    WHY: build/hello is the native program that build.sh made from hello.e.
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. ECMA-367, *Eiffel: Analysis, Design and Programming Language*, 2nd edition, June 2006. ECMA International. <https://www.ecma-international.org/wp-content/uploads/ECMA-367_2nd_edition_june_2006.pdf> (accessed 2026-11-10)
2. Gobo Eiffel 26.03, documentation and license files (installed by Homebrew). Gobo Eiffel project. <https://www.gobosoft.com/> (accessed 2026-11-10)
3. Homebrew formula `gobo` (version, license MIT). <https://formulae.brew.sh/formula/gobo> (accessed 2026-11-10)
4. Eiffel Software, EiffelStudio. <https://www.eiffel.org/> (accessed 2026-11-10)
5. Gobo Eiffel 26.10, GitHub release, published 2026-10-19. Gobo Eiffel project. <https://github.com/gobo-eiffel/gobo/releases/tag/gobo-26.10> (accessed 2026-11-20)
