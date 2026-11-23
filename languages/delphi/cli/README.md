# Delphi · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Delphi](../README.md)

> 🔶 The source is the Delphi dialect of Object Pascal, compiled by Free Pascal
> 3.2.2 (`{$mode delphi}`); Embarcadero Delphi itself is not used.

## What this is
A command-line program, written in the Delphi dialect, that prints one line:
`Hello, World!`. Free Pascal compiles it to a native program (`build/hello`).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Free Pascal (`fpc`) | 3.2.2 (official macOS installer, SHA-256 checked) | compiles `hello.pas` in Delphi mode |
| Apple command-line tools | from macOS | the linker and assembler that `fpc` calls |

## Quick start
```sh
./install.sh   # check / install Free Pascal 3.2.2 (asks before installing)
./build.sh     # compile hello.pas to build/hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `fpc`. If it is missing, downloads the official Free Pascal 3.2.2 macOS installer, checks its SHA-256 digest and unpacks it into `~/.local/fpc-3.2.2` (no sudo) | Free Pascal is the compiler that stands in for Delphi |
| `build.sh` | Runs `fpc -Mdelphi -FEbuild -FUbuild -obuild/hello hello.pas` | `-Mdelphi` selects the Delphi dialect, `-FE`/`-FU` keep the output in `build/` |
| `run.sh` | Runs `build/hello`. `--verify` runs the same check and exits | `verify-all.sh` needs a command that prints `Hello, World!` and exits |
| `delphi-env.sh` | Sets the version, the digest, the install folder and `PATH` (sourced, not run) | shared by `install.sh` and `build.sh` |

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / installs Free Pascal 3.2.2
├── delphi-env.sh    version, SHA-256 digest, install folder (sourced)
├── build.sh         compiles hello.pas in Delphi mode
├── run.sh           runs build/hello
├── hello.pas        the program (Delphi dialect)
└── build/           generated files, ignored by git
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).

## Step-by-step walkthrough
1. **`(* ... *)` comments.** Pascal comments use braces `{ }` or `(* *)`. This
   file uses `(* *)` because its text contains `{$mode delphi}`, and a brace
   comment would end early.
2. **`program hello;`** names the program. The name matches the file.
3. **`{$mode delphi}`** is a compiler directive (it starts with `{$`). It selects
   Delphi's rules, for example Delphi's class and exception behavior.
4. **`begin ... end.`** is the main block. The final `.` ends the program.
5. **`WriteLn('Hello, World!');`** writes the text and a line end. The text uses
   single quotes: in Delphi a double-quoted string is not a Pascal string.

Difference from the other repository languages: a program is a `program` block
with `begin ... end.`, not a function called `main`.

## Why this toolchain
- **Free Pascal** is a free compiler for Pascal and Object Pascal, and its
  Delphi mode accepts Delphi-style code [1][2].
- **Delphi** (Embarcadero; paid editions and a free Community Edition [3]) is
  what the dialect is named after. It is not verified here, so it is not used [3].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | `install.sh` (Free Pascal already present), `build.sh`, `run.sh --verify` |
| macOS Apple Silicon | ⚠️ not verified | the same installer covers both Macs (the file name says `intelarm64`); not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` uses `apt-get install fpc`; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` stops and links to the Free Pascal download page; not run. Delphi itself is not verified |

## Expected output
`./run.sh` (after `./build.sh`) prints one line and exits with status 0:
```text
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. Free Pascal User's Guide, compiler modes and command-line options (`-M`, `-FE`, `-FU`, `-o`). Free Pascal. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (accessed 2026-11-10)
2. Free Pascal home page (version 3.2.2). Free Pascal. <https://www.freepascal.org/> (accessed 2026-11-10)
3. Embarcadero Delphi product page. Embarcadero Technologies. <https://www.embarcadero.com/products/delphi> (accessed 2026-11-20)
