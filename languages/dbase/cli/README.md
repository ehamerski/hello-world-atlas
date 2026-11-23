# dBASE · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [dBASE](../README.md)

> 🔶 **Compromise:** dBASE III Plus is proprietary DOS software, so it is **not run here**.
> The program is dBASE III-compatible code, compiled and run by **Harbour 3.2.0** (an
> open-source xBase compiler). Students who own a dBASE III Plus license can run the original in DOSBox (see the language overview).

## What this is
A command-line program, in dBASE III-compatible `.prg` syntax, that prints one line:
`Hello, World!`. Harbour compiles it through C into `build/hello`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Harbour (`hbmk2`, `harbour`) | 3.2.0 (official source release [4], SHA-256 checked, built with `make`) | compiles `hello.prg` |
| C compiler (Apple clang) and `make` | from the Command Line Tools | Harbour writes C and builds with them |
| `curl`, `shasum` | macOS system tools | download and check the Harbour source |

## Quick start
```sh
./install.sh   # check / install Harbour 3.2.0 (asks before building it)
./build.sh     # compile hello.prg to build/hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `hbmk2`. If it is missing, downloads Harbour 3.2.0, checks its SHA-256 digest, builds it with `make` and installs it into `~/.local/harbour-3.2.0` (no sudo) | Harbour is the open-source compiler that runs the dBASE-style code |
| `build.sh` | Runs `hbmk2 -obuild/hello -gtstd hello.prg` | `-obuild/hello` (attached, no space) sets the output; `-gtstd` links the standard console terminal driver |
| `run.sh` | Runs `build/hello`. `--verify` runs the same check and exits | `verify-all.sh` needs a command that prints `Hello, World!` and exits |
| `harbour-env.sh` | Sets the version, the digest and the install folder, and puts Harbour on `PATH` (sourced, not run) | shared by `install.sh` and `build.sh` |

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / builds Harbour 3.2.0
├── harbour-env.sh   version, SHA-256 digest, install folder (sourced)
├── build.sh         compiles hello.prg with hbmk2
├── run.sh           runs build/hello
├── hello.prg        the program (dBASE III-compatible)
└── build/           generated files, ignored by git
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).

## Step-by-step walkthrough
`hello.prg` in order:

1. **Lines that start with `*`** are comments in dBASE III. The header says what
   the program does and where the compromise is stated.
2. **`?? "Hello, World!"`** writes the text at the current position, with **no new
   line**. `?` (one question mark) starts a new line first, then writes [5].
3. **`?`** on its own writes the line end [5], so the output is exactly one line.
   This was checked: the output bytes are `Hello, World!` and a line feed.
4. **`RETURN`** ends the program. A `.prg` file is a list of commands that run from
   top to bottom, so no `main` function is needed.

Difference from other languages in this repository: output is a command (`?`), not
a function call (`print`).

## Why this toolchain
- **dBASE III Plus** (Ashton-Tate) is the dialect this folder targets. Ashton-Tate
  calls it the successor to dBASE III, which first shipped in June 1984 [1]. It is
  proprietary, so this repository does not run it.
- **Harbour** is an open-source compiler for the xBase language and its commands. It
  is compatible with Clipper compilers [2], and Clipper compiled dBASE III Plus
  programs into DOS programs [6]. Its license
  is in `LICENSE.txt` of the source archive.
- **DOSBox** runs DOS programs on other systems. A student who owns a dBASE III Plus
  license can install it in DOSBox to run the original. This repository does not test
  that route [3].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | `install.sh` (Harbour already present), `build.sh`, `run.sh --verify` |
| macOS Apple Silicon | ⚠️ not verified | the source build should be the same; not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` builds from source with `make` and `build-essential`; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` stops and points to the official Harbour Windows build; the original dBASE III Plus is DOS software |

## Expected output
`./run.sh` (after `./build.sh`) prints one line and exits with status 0:
```text
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. Ashton-Tate. "dBASE III PLUS Product Background", press background, 1986-07-01. Computer History Museum, catalog number 102762813. <https://archive.computerhistory.org/resources/access/text/2017/01/102762813-05-01-acc.pdf> (accessed 2026-11-20)
2. Harbour project home page (xBase compiler; compatibility with Clipper compilers). Harbour project. <https://harbour.github.io/> (accessed 2026-11-20)
3. DOSBox, an x86 emulator with DOS. DOSBox project. <https://www.dosbox.com/> (archived copy of 2026-11-16: <https://web.archive.org/web/20261116214648/https://www.dosbox.com/>) (accessed 2026-11-20)
4. Harbour 3.2.0 source release (build instructions, `hbmk2` options). Harbour project, GitHub. <https://github.com/harbour/core/releases/tag/v3.2.0> (accessed 2026-11-10)
5. Harbour Reference Guide: Clipper 5.3 (`?` and `??`). Harbour project. <https://harbour.github.io/doc/clc53.html> (accessed 2026-11-20)
6. Martel, J.-P. "A personal History of dBASE". The dBASE Developers Bulletin, `dbase.com`. <https://www.dbase.com/Knowledgebase/dbulletin/bu03hist.htm> (accessed 2026-11-20)
