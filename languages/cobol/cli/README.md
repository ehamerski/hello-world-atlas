# COBOL · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [COBOL](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.cob`](hello.cob), written in **COBOL-85** (ANSI
X3.23-1985, adopted by ISO as ISO 1989:1985 [1]) in the traditional
**fixed format**, the column layout of punched cards. It is compiled with
**GnuCOBOL** 3.2, a free COBOL compiler that "translates COBOL into C and
internally compiles the translated code using a native C compiler" [2].

Like the [C cli](../../c/cli/), the result is a native executable,
`bin/hello-cli`. Unlike C, the program has no `main` function and no
`#include`: it is organized in **divisions**, and `DISPLAY` is part of
the language itself, not of a library you include.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| GnuCOBOL (`cobc`) | 3.2.0 (Homebrew `gnucobol` 3.2) | translates COBOL to C and builds the executable |
| A C compiler (`cc`) | Apple clang 21.0.0 (Command Line Tools) | `cobc` calls it to compile the generated C |
| `libcob` | comes with GnuCOBOL | GnuCOBOL's runtime library: `DISPLAY`, `STOP RUN`, ... |

## Quick start
```sh
./install.sh   # check / install GnuCOBOL (asks before installing)
./build.sh     # cobc -x: COBOL -> C -> bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `cobc --version`. If it is missing, offers `brew install gnucobol` (macOS), `sudo apt-get install -y gnucobol` (Debian/Ubuntu) or prints the MSYS2 commands (Windows), and runs them only if you answer `y`. | COBOL is compiled; GnuCOBOL is the compiler, and it needs a C compiler too. |
| `build.sh` | Runs `cobc -x -std=cobol85 -Wall -o bin/hello-cli hello.cob` and prints that command (`set -x`). Extra options are passed to `cobc`, e.g. `./build.sh -save-temps`. | Turns the source into machine code. The flags are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a cli program ends by itself). | The executable is machine code, so the operating system runs it directly. |

**The flags, one by one** (from `cobc --help`, GnuCOBOL 3.2):
- `-x`: "build an executable program". The GnuCOBOL manual: "Include the
  main function in the output, creating an executable image" [3]. Without
  `-x`, `cobc` builds a module that other COBOL programs `CALL`.
- `-std=cobol85`: "warnings/features for a specific dialect". GnuCOBOL
  knows many dialects (`cobol85`, `cobol2002`, `cobol2014`, `ibm`, `mf`,
  ...); this one checks the program against the 1985 standard.
- `-Wall`: "enable most warnings".
- `-o bin/hello-cli`: "place the output into <file>".
- Fixed format is the default: `--fixed` is described as "use fixed source
  format (default)". `-free` switches to free format [3].

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks / installs GnuCOBOL
├── build.sh      compiles hello.cob
├── run.sh        runs bin/hello-cli
├── hello.cob     the program
├── .gitignore    ignores the C files made by ./build.sh -save-temps
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- COBOL has no standard project layout or build file. A one-program
  project is the source file; `.cob` (also `.cbl`) is the usual extension.
- `bin/` is ignored by the root `.gitignore`: build output is never
  committed.

## Step-by-step walkthrough
Open [`hello.cob`](hello.cob) next to this list.

1. **Columns matter (fixed format).** The GnuCOBOL manual describes it:
   "columns 1-6, the sequence number area; column 7, the indicator area;
   columns 8-72, the program-text area" [3]. Division, section and
   paragraph headers "must begin in Area A" (columns 8-11), and everything
   else goes in Area B (columns 12-72) [4]. So every line of code starts
   with 7 spaces, and statements with 11.
2. **Comments** are lines with `*` in column 7, the indicator area [4]:
   the whole line is a comment.
3. **`IDENTIFICATION DIVISION.` / `PROGRAM-ID. HELLO.`** name the program.
   Every header and every sentence ends with a period.
4. **No ENVIRONMENT or DATA DIVISION.** They describe the computer, the
   files and the variables. This program has none, so they are left out.
5. **`PROCEDURE DIVISION.`** holds the code. Execution starts at its first
   statement; there is no `main` function to declare.
6. **`DISPLAY "Hello, World!".`** writes the text and a line break to the
   standard output, like Python's `print` (C's `printf` needs `\n`).
7. **`STOP RUN.`** ends the program and returns to the operating system.
8. **COBOL becomes C.** Run `./build.sh -save-temps` and open the
   generated `hello.c`: the `DISPLAY` line becomes a call
   `cob_display (0, 1, 1, &c_1);` and `STOP RUN` becomes
   `cob_stop_run (0);`, functions of `libcob`. `otool -L bin/hello-cli`
   shows that the program loads `libcob.4.dylib` at run time. Delete the
   generated files afterwards (`rm hello.c hello.c.h hello.c.l.h hello.i`;
   Git ignores them anyway).
9. **Try it:** move `PROCEDURE DIVISION.` to column 1 and run `./build.sh`.
   GnuCOBOL stops with `invalid indicator 'U' at column 7`: it read the
   `U` of `PROCEDURE` as the indicator. Put the 7 spaces back.

## Why this toolchain
- **Era context.** COBOL was made for business computers of 1959-1960
  (see the [language README](../README.md#history)). Commercial
  mainframe compilers today, such as IBM Enterprise COBOL for z/OS [5], run on
  IBM's z/OS mainframe operating system, not on the macOS, Linux and
  Windows computers this project targets.
- **GnuCOBOL is the free, maintained successor for these platforms.**
  "GnuCOBOL (formerly OpenCOBOL) is a free, modern COBOL compiler" [2];
  Homebrew describes it as a "COBOL85-202x compiler supporting lots of
  dialect specific extensions" [6]. Version 3.2 was released on
  2023-07-28 [7]. It is packaged by Homebrew [6], Debian [8], and
  MSYS2 [9], so every platform of this project can install it.
- **COBOL-85 and fixed format on purpose.** For an old language this
  repository uses the best option still in use and supported from that
  period. COBOL-85 (ANSI X3.23-1985 / ISO 1989:1985 [1]) is the standard
  that came before ISO/IEC 1989:2002, which added objects (see the
  [milestones](../README.md#milestones)), and fixed format is its source
  layout [4]. `-std=cobol85` makes GnuCOBOL check the program against that standard,
  like `-std=c89` does for [ANSI C](../../c/cli/).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | GnuCOBOL 3.2.0 (Homebrew), Apple clang from the Command Line Tools. |
| macOS Apple Silicon | ⚠️ not verified | Same commands: `brew install gnucobol` [6]. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `sudo apt-get install -y gnucobol`; the `gnucobol` package is the "compiler package for default GnuCOBOL" and depends on `gnucobol3` [8]. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Install MSYS2, then in the "MSYS2 UCRT64" shell `pacman -S mingw-w64-ucrt-x86_64-gnucobol mingw-w64-ucrt-x86_64-gcc` [9], and add `C:\msys64\ucrt64\bin` to PATH. Name the output `bin/hello-cli.exe`. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly
         and loads libcob, the GnuCOBOL runtime library.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. FIPS PUB 21-2, COBOL (adopts ANSI X3.23-1985). National Institute of Standards and Technology. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub21-2.pdf> (accessed 2026-11-01)
2. GnuCOBOL (project page). SourceForge. <https://sourceforge.net/projects/gnucobol/> (accessed 2026-11-01)
3. GnuCOBOL manual (`cobc` options, source format). GnuCOBOL project. <https://gnucobol.sourceforge.io/doc/gnucobol.html> (accessed 2026-11-01); option texts also from `cobc --help`, GnuCOBOL 3.2.0
4. GnuCOBOL Programmer's Guide (fixed format, Area A/B, indicator column). Gary L. Cutler. <https://gnucobol.sourceforge.io/HTML/gnucobpg.html> (accessed 2026-11-01)
5. Enterprise COBOL for z/OS 6.4: Industry specifications. IBM. <https://www.ibm.com/docs/en/cobol-zos/6.4.0?topic=appendixes-industry-specifications> (accessed 2026-11-01)
6. `gnucobol` formula. Homebrew. <https://formulae.brew.sh/formula/gnucobol> (accessed 2026-11-01)
7. GnuCOBOL (home page, releases). GnuCOBOL project. <https://gnucobol.sourceforge.io/> (accessed 2026-11-01)
8. Package `gnucobol` (trixie). Debian. <https://packages.debian.org/stable/gnucobol> (accessed 2026-11-01)
9. Base package mingw-w64-gnucobol. MSYS2. <https://packages.msys2.org/base/mingw-w64-gnucobol> (accessed 2026-11-01)
