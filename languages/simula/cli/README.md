# Simula · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Simula](../README.md)

## What this is
A command-line program, written in Simula 67, that prints one line:
`Hello, World!`. GNU Cim compiles it to C, and the C compiler makes a
native program (`build/hello`). Simula 67 is the version of Simula that
introduced classes and inheritance (see the [language overview](../README.md)).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| GNU Cim (Simula 67 compiler) | 5.1 (tarball from ftp.gnu.org, SHA-256 checked) | compiles `hello.sim` to C |
| C compiler (`cc`, `gcc` or clang) | Apple clang from the Command Line Tools | `cim` calls it to make the program |
| `make` | from the Command Line Tools | builds GNU Cim once |
| `curl`, `shasum` | macOS system tools | download and check the GNU Cim tarball |

## Quick start
```sh
./install.sh   # check / install GNU Cim 5.1 (asks before building it)
./build.sh     # compile hello.sim to build/hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for `cim` in `$CIM_PREFIX`. If it is missing, downloads GNU Cim 5.1, checks its SHA-256 digest, then runs `./configure`, `make` and `make install` (no sudo) | Simula needs a compiler; this one is the GNU project's own, built from its official source |
| `build.sh` | Copies `hello.sim` into `build/` and runs `cim -o hello hello.sim` there | `cim` writes `hello.c` and `hello.o` next to its input, so the work happens in `build/` and the source folder stays clean |
| `run.sh` | Runs `build/hello`. `--verify` runs the same check and exits by itself (the program ends after one line) | `verify-all.sh` needs a command that prints `Hello, World!` and exits |
| `cim-env.sh` | Sets the version, the SHA-256 digest, the URL and the install folder (sourced, not run) | the same settings are shared by `install.sh` and `build.sh` |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / builds GNU Cim 5.1 into $CIM_PREFIX
├── cim-env.sh     version, SHA-256 digest, install folder (sourced)
├── build.sh       compiles hello.sim with `cim` (in build/)
├── run.sh         runs build/hello
├── hello.sim      the program (Simula 67, GNU Cim dialect)
└── build/         generated files, ignored by git
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).

## Step-by-step walkthrough
`hello.sim` has three parts:

1. **A comment.** `comment ... ;` runs to the next semicolon, so the header
   text must not contain one. The Simula 67 Common Base defines this
   convention (report NR 743, section "Comment conventions").
2. **A block.** `begin ... end;` encloses the statements, as in ALGOL 60
   (the language Simula was built on). There is no `main` function; the
   block itself is the program.
3. **Two output procedures.** `outtext("Hello, World!")` writes the text
   without ending the line; `outimage` ends the line. Both come from the
   Simula 67 Common Base (report NR 743, procedure `outtext`).

Differences from other languages in this repository: there is no `print`
or `printf`; output goes through the procedures of the Common Base, and
statements are separated by semicolons.

## Why this toolchain
- **GNU Cim** is the GNU project's Simula compiler (project page:
  https://www.gnu.org/software/cim/cim.html). Its source is GPL-2.0 licensed
  and published on the GNU server, which is why `install.sh` downloads it
  from there and checks the digest.
- **Portable Simula Revisited** is a Java-based alternative. Its release
  R21 (Simula-2.0, for Java 21 through 25) was tested on 2026-11-02 and works with `-noexec`,
  `-output <absolute path>` and `-SPORT:noConsole`, but without
  `-SPORT:noConsole` it opens its own Swing console window. The project
  publishes no license (checked on 2026-11-02), so this folder does not use
  it. On 2026-11-20 the project page offers a newer release that needs
  Java 25 or later. You can read about it at
  https://portablesimula.github.io/github.io/.
- **Why a C compiler is needed:** Cim writes C code, which the C compiler
  turns into the program. `build.sh` output shows the `gcc` command it runs.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | `install.sh`, `build.sh`, `run.sh --verify` (install run once from a fresh prefix) |
| macOS Apple Silicon | ⚠️ not verified | the build flags in `install.sh` were tested only on Intel |
| Linux (Debian/Ubuntu) | ⚠️ not verified | the same recipe should apply; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | not run; the scripts target POSIX sh |

## Expected output
`./run.sh` (after `./build.sh`) prints one line and exits with status 0:
```text
==> Run the program
    WHY: build/hello is the native program that build.sh made from hello.sim.
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. GNU Cim, project page. GNU Project. <https://www.gnu.org/software/cim/cim.html> (accessed 2026-11-10; archived copy: <https://web.archive.org/web/20261005162711/http://www.gnu.org/software/cim/cim.html>, accessed 2026-11-22)
2. GNU Cim 5.1 source tarball and manual (`cim.info`). GNU Project. <https://ftp.gnu.org/gnu/cim/> (accessed 2026-11-10)
3. Dahl, Ole-Johan, Myhrhaug, B. and Nygaard, K. *Simula 67 Common Base Language*. Norwegian Computing Center, report NR 743, 1968 (revised 1970, 1982, 1984). <https://www.softwarepreservation.org/projects/ALGOL/manual/NR_report_743_Dahl_Myhrhaug_Nygaard_Simula-67-Common-Base-Language.pdf> (accessed 2026-11-10)
4. Portable Simula Revisited. <https://portablesimula.github.io/github.io/> (accessed 2026-11-20)
