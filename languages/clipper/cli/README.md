# Clipper · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Clipper](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.prg`](hello.prg), written in **Clipper 5** syntax. CA-Clipper
itself is a discontinued, proprietary MS-DOS product, so the program is
compiled with **Harbour 3.2.0**, "the free software implementation of a
multi-platform, multi-threading, object-oriented, scriptable programming
language, backward compatible with Clipper/xBase" [1].

Like the [COBOL cli](../../cobol/cli/), the compiler goes through C: Harbour
turns `hello.prg` into C, and a C compiler makes the native executable
`bin/hello-cli`. Unlike COBOL and C, Clipper is **dynamically typed**:
there are no type declarations, and a variable takes the type of the
value stored in it.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Harbour (`harbour`, `hbmk2`) | 3.2.0 (r2607071000), built by `install.sh` into `~/.local/harbour-3.2.0` | compiles `.prg` to C and drives the build |
| A C compiler (`cc`) and `make` | Apple clang 21.0.0 (Command Line Tools) | build Harbour itself, then compile the C that Harbour generates |
| `curl`, `tar`, `shasum` | come with macOS | download and check the Harbour source release |

## Quick start
```sh
./install.sh   # check / build Harbour 3.2.0 (asks first; about 3 minutes)
./build.sh     # hbmk2: Clipper -> C -> bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Looks for `hbmk2` (on PATH or in `~/.local/harbour-3.2.0/bin`). If it is missing on macOS or Linux, offers to download `harbour-3.2.0.src.tar.gz` from the Harbour GitHub release, check its SHA-256, and run `make install HB_INSTALL_PREFIX=~/.local/harbour-3.2.0 HB_BUILD_CONTRIBS=no`. On Windows it prints the download for the prebuilt package. | No package manager has a current Harbour (see [Why this toolchain](#why-this-toolchain)), so it is built from the official source release. No `sudo`. |
| `harbour-env.sh` | Sourced by `install.sh` and `build.sh`: sets the version, checksum and install folder and puts its `bin/` on PATH. | Keeps the version in one place. |
| `build.sh` | Runs `hbmk2 -q0 -w3 -es2 -gtcgi hello.prg -obin/hello-cli` and prints it (`set -x`). Extra options go to `hbmk2`, e.g. `./build.sh -trace`. | Turns the source into machine code. The flags are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a cli program ends by itself). | The executable is machine code, so the operating system runs it directly. |

**The flags, one by one** (from `hbmk2 -help` and `harbour` without arguments, Harbour 3.2.0):
- `-q0`: "quiet and don't display program header" (the Harbour banner).
- `-w3`: "set warning level number (0..3, default 1)"; 3 is the strictest.
- `-es2`: "set exit severity"; level 2 makes warnings stop the build, like
  `-Werror` in gcc/clang.
- `-gtcgi`: "link with GT<name> GT driver". A **GT** ("general terminal")
  is Harbour's screen driver. Clipper programs owned the whole MS-DOS
  screen, so Harbour's default driver on macOS and Linux, GTTRM, also
  controls the terminal: on the development machine it added escape codes around
  the text, even when the output went to a pipe. GTCGI writes plain text
  to standard output, which is what a cli program should do.
- `-obin/hello-cli`: "output file name". Note that there is no space after
  `-o`.

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / builds Harbour
├── harbour-env.sh   Harbour version, checksum and install folder
├── build.sh         compiles hello.prg
├── run.sh           runs bin/hello-cli
├── hello.prg        the program
└── bin/             created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- Clipper has no standard project layout. A one-program project is a
  `.prg` file; bigger Harbour projects add an `.hbp` project file for
  `hbmk2` [1]. One file needs none.
- `bin/` is ignored by the root `.gitignore`: build output is never
  committed. `hbmk2` deletes its temporary C and object files itself.

## Step-by-step walkthrough
Open [`hello.prg`](hello.prg) next to this list.

1. **Comments.** `/* ... */` and `//` work as in C. Clipper also accepts
   dBASE's `*` at the start of a line and `&&` after a statement.
2. **`PROCEDURE Main()`.** Code lives in procedures (no return value) and
   functions. Harbour starts the program at `Main()` if there is one,
   otherwise at the first procedure in the file (tested on the development
   machine). There is no type declaration: Clipper is dynamically typed,
   like Python.
3. **`?? "Hello, World!"` then `?`.** `?` and `??` are the classic
   output commands. They are not built into the compiler: the
   preprocessor turns them into function calls. Harbour's `std.ch` has
   `#command ?  [<explist,...>] => QOut( <explist> )` and
   `#command ?? [<explist,...>] => QQOut( <explist> )`. `QOut()` starts a
   new line *before* it writes; `QQOut()` writes where the cursor is. So
   the familiar `? "Hello, World!"` prints an empty line first. Try it
   (step 6).
4. **`RETURN`** ends the procedure; returning from `Main()` ends the
   program with exit status 0.
5. **Clipper becomes C.** Run `harbour -q0 -gc2 hello.prg -o/tmp/` (with
   `~/.local/harbour-3.2.0/bin` on PATH; `-gc2` is the "verbose" C output)
   and open `/tmp/hello.c`: it holds an array of **pcode**, the
   instructions of Harbour's virtual machine, such as
   `HB_P_PUSHFUNCSYM, 2, 0, /* QQOUT */`, and the call
   `hb_vmExecute( pcode, symbols );` that runs them. `hbmk2` compiles that C file and links it with the virtual machine and runtime library, so
   `bin/hello-cli` needs no Harbour at run time (`otool -L bin/hello-cli`
   shows only `libSystem`).
6. **Try it:** replace the two output lines with `? "Hello, World!"`, run
   `./build.sh` and `./bin/hello-cli | od -c`. The output now starts with `\n`.
   Then rebuild without `-gtcgi` (`hbmk2 -q0 hello.prg -obin/hello-cli`)
   and look at `./bin/hello-cli | od -c`: the GTTRM escape codes appear.
   Run `./build.sh` again to restore the normal build.

## Why this toolchain
- **Clipper itself cannot be used.** Clipper was a commercial MS-DOS
  compiler (Nantucket, later Computer Associates); see the
  [language README](../README.md#history). It stopped evolving in the
  1990s: CA announced 5.3 as "the last significant release" (Clipper FAQ,
  1998 [5]). It made MS-DOS programs, which macOS and Linux do not run
  natively. For old languages this repository uses the
  best option from that period, or its maintained successor.
- **Harbour is the maintained, Clipper-compatible successor.** Its own
  description is "backward compatible with Clipper/xBase" [1]. It is free
  software (GPL with a linking exception, see `LICENSE.txt` [1]) and runs
  on macOS, Linux and Windows. **Harbour 3.2.0** was released on
  2026-07-07, "the first official stable release since 3.0.0 (2011)" [2].
- **Why a source build (and no Docker).** Homebrew's `harbour` formula is
  still version 3.0.0, deprecated (reason in its JSON data: "uses
  deprecated libxdiff"), to be disabled on 2027-01-05; for Intel Macs it
  has a ready-made package (bottle) only for macOS Sonoma [3], so on the
  development machine (macOS 26) Homebrew would build it from source
  anyway. Debian's source archive lists only a `0.44-1` Harbour package, in
  the old "sarge" release [4]. The Harbour release publishes source code and
  a Windows package [2], and its README documents `make install` on macOS
  ("Darwin") and Linux hosts, with Xcode or the Command Line Tools as the
  only macOS prerequisite [1]. On the development machine the build took about
  3 minutes (179 s, 2026-11-01). A native build was possible, so no
  Docker fallback was needed.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | Harbour 3.2.0 built from source by `install.sh` with Apple clang 21. |
| macOS Apple Silicon | ⚠️ not verified | Same script. Harbour's CI includes macOS [1], but this project did not test arm64. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Same source build. Install a C compiler and make first: `sudo apt-get install -y build-essential`. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Download `harbour-3.2.0-win-mingw64.7z` from the release [2], add its `bin` folder to PATH and install a MinGW-w64 C compiler (e.g. via MSYS2). Name the output `bin/hello-cli.exe`. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Harbour README (description, build instructions for Darwin and Linux, hbmk2). Harbour project, file `README.md` in the 3.2.0 release and at <https://github.com/harbour/core> (accessed 2026-11-01)
2. Release v3.2.0 (2026-07-07; assets and SHA-256 digests). Harbour project, GitHub. <https://github.com/harbour/core/releases/tag/v3.2.0> (accessed 2026-11-01)
3. harbour formula (web page and JSON data <https://formulae.brew.sh/api/formula/harbour.json>). Homebrew. <https://formulae.brew.sh/formula/harbour> (accessed 2026-11-01)
4. Debian sources: harbour. Debian. <https://sources.debian.org/src/harbour/> (accessed 2026-11-01)
5. Clipper FAQ, part 3: "About Clipper and Visual Objects" (as of March 1998). The Oasis archive, hosted by the Harbour project. <https://harbour.github.io/the-oasis/docs/clipper-3.html> (accessed 2026-11-01)
