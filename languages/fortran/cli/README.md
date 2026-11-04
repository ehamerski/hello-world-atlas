# Fortran · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Fortran](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.f90`](hello.f90), written in modern **free-form
Fortran** and compiled as **Fortran 2008** (ISO/IEC 1539:2010 [1]) by
**GFortran** (the `gfortran` command), the Fortran compiler of GCC [2].

Like the [C `cli`](../../c/cli/) version, the program is compiled ahead of time into
a native executable, `bin/hello-cli`, and `build.sh` calls the compiler
directly with a flag that enforces one standard (`-std=f2008` here,
`-std=c89` in C).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| GFortran (`gfortran`) | 16.2.0 (Homebrew `gcc` 16.2.0) | compiles and links `hello.f90` |
| Apple's linker | Command Line Tools (Apple clang 21.0.0) | `gfortran` uses the system linker on macOS |

On macOS, GFortran comes inside Homebrew's `gcc` formula ("Also known as:
gcc@16, gfortran" [3]); Apple's own tools have no Fortran compiler. On
Intel Macs, Homebrew has no pre-built `gcc` package (bottle) for current
macOS versions [3], so `brew install gcc` compiles GCC from source. On the
test machine (macOS Intel), that took about 4.5 hours (2026-11-01). Apple
Silicon Macs and Linux get a pre-built package.

## Quick start
```sh
./install.sh   # check / install gfortran (asks before installing)
./build.sh     # compile hello.f90 as Fortran 2008 into bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `gfortran --version`. If `gfortran` is missing, offers `brew install gcc` (macOS; warns that Intel Macs build from source) or `sudo apt-get install -y gfortran` (Debian/Ubuntu), or prints the MSYS2 commands (Windows), and runs a command only if you answer `y`. | Fortran is compiled, so a Fortran compiler is the only tool needed. The Fortran-lang website gives the same commands [4]. |
| `build.sh` | Runs `gfortran -std=f2008 -Wall -Wextra -o bin/hello-cli hello.f90` and prints that command (`set -x`). `FC=gfortran-16 ./build.sh` picks another compiler command. | Turns the source into machine code. The flags are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a cli program ends by itself). | The executable is machine code, so the operating system runs it directly. |

**The flags, one by one:**
- `-std=f2008`: "Specify the standard to which the program is expected to
  conform, which may be one of 'f95', 'f2003', 'f2008', 'f2018', 'f2023',
  'gnu', or 'legacy'. The default value for std is 'gnu', which specifies a
  superset of the latest Fortran standard" [5]. Without this flag, the
  compiler accepts GNU extensions without a warning.
- `-Wall -Wextra`: extra warnings about suspicious code (the same flags as
  in C).
- `-o bin/hello-cli`: names the output; without it, the file is `a.out`.
- No flag chooses the source form: "Source files with .f90, .f95, .f03,
  .f08, .F90, .F95, .F03 and .F08 extensions are treated as free form",
  while `.f`, `.for` and similar "are treated as fixed form" [6].

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks / installs gfortran
├── build.sh      compiles hello.f90 as Fortran 2008
├── run.sh        runs bin/hello-cli
├── hello.f90     the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- A one-file Fortran program needs no project file. Larger projects use a
  `Makefile`, CMake, or the Fortran Package Manager (`fpm`, with a
  `fpm.toml` and `app/` and `src/` folders) [7]; for one file, `build.sh`
  shows the compiler line instead.
- `bin/` and Fortran module files (`*.mod`) are ignored by the root
  `.gitignore`.

## Step-by-step walkthrough
Open [`hello.f90`](hello.f90) next to this list.

1. **Comments** start with `!` and run to the end of the line, like `//`
   in C99, Java, or Go.
2. **`program hello` ... `end program hello`** is the main program. The
   name is only a label: there is no function called `main` as in C.
   Fortran ignores case, so `PROGRAM HELLO` is the same.
3. **`implicit none`** switches off an old rule. Without it, "the default
   ... is default integer if the letter is I, J, ..., or N and default
   real otherwise" [8]: an undeclared name such as `count` would silently
   become a real number. "An IMPLICIT NONE statement can indicate that no
   implicit typing rules are to apply" [8]. This program has no variables,
   but the line belongs in every program.
4. **`print '(a)', "Hello, World!"`** writes the text and a line break to
   standard output. The first item is the *format*: `(a)` means "one
   character string, as it is".
5. **Why not `print *`?** The common textbook line is
   `print *, "Hello, World!"`. The `*` "indicates list-directed
   formatting" [8], where the compiler chooses the layout, and in
   list-directed output "each output record begins with a blank
   character" [8]. That program prints ` Hello, World!` with a leading
   space, which is not exactly `Hello, World!`. **Try it:** change the line
   to `print *, "Hello, World!"`, run `./build.sh && ./run.sh | od -c |
   head -n 1` and look for the space before `H`. Change it back.
6. **Compile and link.** `build.sh` does both in one call. `otool -L
   bin/hello-cli` shows that the program loads `libgfortran.5.dylib`
   (plus `libquadmath` and `libgcc_s`) from Homebrew's `gcc` at run time:
   the Fortran runtime library does the actual output.

## Why this toolchain
- **Era context.** FORTRAN began in 1957 as IBM's compiler for the IBM
  704 [9]. That machine and its compiler are long gone, but code from the
  fixed-form era (`.f` files [6]) is still compiled by today's compilers.
- **GFortran is free, maintained, and available on every platform of
  this repository.** The Fortran-lang website states: "GNU Fortran Compiler (gfortran) is a mature
  compiler, part of the GNU Compiler Collection" [10]. It "implements the
  Fortran 77, 90 and 95 standards completely" [11] and "supports almost all
  of ISO/IEC 1539-1:2004 (Fortran 2003) and ISO/IEC 1539-1:2010 (Fortran
  2008)" [12], so it compiles old and new code. Other current compilers
  include Intel's `ifx` and LFortran [10].
- **Fortran 2008 and free form on purpose.** This repository targets
  Fortran 2008 or later. Fortran 2008 is the newest standard that GFortran
  supports almost completely [12]; the current standard is Fortran 2023 [1]. Free form is the modern
  layout, and the [COBOL `cli`](../../cobol/cli/) version already shows the
  punched-card fixed format.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | GFortran 16.2.0 from Homebrew `gcc` 16.2.0, built from source (no Intel bottle) [3]. |
| macOS Apple Silicon | ⚠️ not verified | `brew install gcc` installs a pre-built bottle [3]. Same commands. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `sudo apt-get install -y gfortran` [13][4]. Same commands. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Install MSYS2, then in the "MSYS2 UCRT64" shell `pacman -S mingw-w64-ucrt-x86_64-gcc-fortran` [14], and add `C:\msys64\ucrt64\bin` to `PATH`. Name the output `bin/hello-cli.exe`. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly
         and loads libgfortran, the Fortran runtime library.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Fortran Standards: Fortran 2008 / Fortran 2023. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2008.html>, <https://wg5-fortran.org/f2023.html> (accessed 2026-11-01)
2. GCC, the GNU Compiler Collection (home page). Free Software Foundation. <https://gcc.gnu.org/> (accessed 2026-11-01)
3. `gcc` formula. Homebrew. <https://formulae.brew.sh/formula/gcc> (accessed 2026-11-01)
4. Installing GFortran. Fortran-lang. <https://fortran-lang.org/learn/os_setup/install_gfortran/> (accessed 2026-11-01)
5. GNU Fortran: Options controlling Fortran dialect (-std). GCC. <https://gcc.gnu.org/onlinedocs/gfortran/Fortran-Dialect-Options.html> (accessed 2026-11-01)
6. GNU Fortran and GCC (source form by file extension). GCC. <https://gcc.gnu.org/onlinedocs/gfortran/GNU-Fortran-and-GCC.html> (accessed 2026-11-01)
7. Fortran Package Manager: First steps. Fortran-lang. <https://fpm.fortran-lang.org/tutorial/hello-fpm.html> (accessed 2026-11-01)
8. Fortran 2018 working draft J3/18-007r1 (8.7 IMPLICIT statement; 12.6.2 Format specification; 13.10.4 List-directed output). INCITS/Fortran (J3). <https://j3-fortran.org/doc/year/18/18-007r1.pdf> (accessed 2026-11-01)
9. Fortran. IBM Heritage. <https://www.ibm.com/history/fortran> (accessed 2026-11-01)
10. Compilers. Fortran-lang. <https://fortran-lang.org/compilers/> (accessed 2026-11-01)
11. About GNU Fortran. GCC. <https://gcc.gnu.org/onlinedocs/gfortran/About-GNU-Fortran.html> (accessed 2026-11-01)
12. GNU Fortran: Standards. GCC. <https://gcc.gnu.org/onlinedocs/gfortran/Standards.html> (accessed 2026-11-01)
13. Package `gfortran` (trixie). Debian. <https://packages.debian.org/stable/gfortran> (accessed 2026-11-01)
14. Package `mingw-w64-ucrt-x86_64-gcc-fortran`. MSYS2. <https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-gcc-fortran> (accessed 2026-11-01)
