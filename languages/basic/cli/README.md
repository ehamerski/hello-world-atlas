# BASIC · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [BASIC](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.bas`](hello.bas), written in **QBasic / QuickBASIC 4.5**
BASIC, the dialect of Microsoft's MS-DOS BASICs, and compiled with
**QB64 Phoenix Edition** (QB64-PE) 4.7.0, "a modern extended BASIC+OpenGL
language that retains QB4.5/QBasic compatibility and compiles native
binaries for Windows (7 and up), Linux and macOS (Catalina and up)" [1].

The whole program is two statements, `PRINT` and `SYSTEM`, plus one
compiler instruction. Compare it with [C](../../c/cli/hello.c) or
[COBOL](../../cobol/cli/hello.cob): BASIC has no program header, no
`main`, no blocks, and no declarations. That simplicity was its point: it
was made at Dartmouth so that students could learn programming quickly
(see the [language README](../README.md#history)).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| QB64-PE (`qb64pe`) | 4.7.0-GLFW, built by `install.sh` into `~/.local/qb64pe-4.7.0` | translates BASIC to C++ and drives the build |
| A C++ compiler (`clang++`) and `make` | Apple clang 21.0.0 (Command Line Tools) | build QB64-PE itself, then compile the C++ it generates |
| `curl`, `tar`, `shasum` | come with macOS | download and check the QB64-PE release |

## Quick start
```sh
./install.sh   # check / build QB64-PE 4.7.0 (asks first; about 1 minute)
./build.sh     # qb64pe -x: BASIC -> C++ -> bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Looks for `qb64pe` (in `~/.local/qb64pe-4.7.0` or on PATH). If it is missing on macOS, offers to download `qb64pe_osx-4.7.0-GLFW.tar.gz` from the QB64-PE GitHub release, check its SHA-256, unpack it and run `make OS=osx BUILD_QB64=y -j3` there. On Linux and Windows it prints the download and the steps. | QB64-PE is in no package manager; its macOS release is compiled on your Mac [1]. No `sudo`. |
| `qb64pe-env.sh` | Sourced by `install.sh` and `build.sh`: sets the version, checksum and install folder, and picks the `qb64pe` command. | Keeps the version in one place. |
| `build.sh` | Runs `qb64pe -x -q -w hello.bas -o bin/hello-cli` and prints it (`set -x`). | Turns the source into machine code. The flags are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a cli program ends by itself). | The executable is machine code, so the operating system runs it directly. |

**The flags, one by one** (from `man ./qb64pe.1` in the QB64-PE folder):
- `-x`: "Compile instead of edit and output the result to the console".
  Without `-x` or `-c`, `qb64pe` opens its editor (IDE).
- `-q`: "Quiet mode (suppresses most output other than warnings and
  errors)".
- `-w`: "Show warnings when compiling".
- `-o bin/hello-cli`: "Write output executable to <output file>". QB64-PE
  also writes `bin/hello-cli_start.command`, a launcher you can
  double-click in Finder; this project does not use it.

**Why `install.sh` calls `make` instead of `setup_osx.command`:** the
QB64-PE README says "Run `./setup_osx.command` to compile QB64-PE for your
OS version" [1]. That script runs `make OS=osx clean` and
`make OS=osx BUILD_QB64=y -j3`, and then launches the editor and waits for
a key. `install.sh` runs the same build command without the interactive
parts, so it also works unattended (`TF_ASSUME_YES=1`).

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / builds QB64-PE
├── qb64pe-env.sh    QB64-PE version, checksum and install folder
├── build.sh         compiles hello.bas
├── run.sh           runs bin/hello-cli
├── hello.bas        the program
└── bin/             created by build.sh; not committed (see ../../../.gitignore)
    ├── hello-cli
    └── hello-cli_start.command
```
- BASIC has no project layout or build file. A QBasic program is one
  `.bas` file.
- `bin/` is ignored by the root `.gitignore`: build output is never
  committed.

## Step-by-step walkthrough
Open [`hello.bas`](hello.bas) next to this list.

1. **Comments** start with an apostrophe `'`, or with the keyword `REM`.
2. **`$CONSOLE:ONLY`** is a QB64 *metacommand*, an instruction for the
   compiler. A QB64 program normally opens its own graphics window, the
   way a QBasic program filled the MS-DOS screen. "The :ONLY option
   bypasses the graphical program window, allowing the program to run in a
   text-only console window" [2]; `PRINT` then writes to the terminal. The
   QB64 wiki adds: "QB64 Metacommands are not commented out with ' or REM,
   unlike QuickBASIC metacommands" [2]. This line is the only part of the
   file that QBasic would not understand.
3. **`PRINT "Hello, World!"`.** "The PRINT statement prints numeric or
   string expressions to the program screen" [3], followed by a line
   break unless the line ends with `;` or `,`. There is no `main`: the
   program runs from the first statement to the last.
4. **`SYSTEM`** "immediately closes a program and returns control to the
   operating system" [4]. Without it, or with `END`, QB64 pauses with a
   "Press any key to continue" message [5]. On the development machine, in
   console mode, the message was `Press enter to continue` and the
   program waited for input.
5. **BASIC becomes C++.** QB64-PE writes the translated C++ into its own
   folder, `~/.local/qb64pe-4.7.0/internal/temp/`, as `.txt` files that
   `main.txt` includes, and compiles it with `clang++`. After a build,
   `grep -n Hello ~/.local/qb64pe-4.7.0/internal/temp/main0.txt` shows the
   `PRINT` line turned into C++:
   `qbs_set(tqbs,qbs_new_txt_len("Hello, World!",13));`.
   `otool -L bin/hello-cli` shows that even this console program links macOS's graphics frameworks
   (Cocoa, OpenGL): QB64-PE's runtime library always includes its window
   code.
6. **Try it:** delete the `SYSTEM` line, run `./build.sh` and `./run.sh`:
   the program now waits for Enter. Then also delete `$CONSOLE:ONLY` and
   rebuild: `./bin/hello-cli` opens a QB64 window instead of printing in
   the terminal. Restore both lines afterwards.

## Why this toolchain
- **Which BASIC?** BASIC has many dialects (see the
  [language README](../README.md)). For an old language this
  repository uses the best option from that period, or its maintained
  successor. The BASIC most PC users met in the MS-DOS
  era was Microsoft's: QBasic shipped with MS-DOS 5.0 (Microsoft's own
  support article: "When EDIT.COM is executed in MS-DOS versions 5.0 and
  later, it invokes QBASIC.EXE with the /EDITOR switch" [6]). QBasic
  itself is an MS-DOS program, which macOS and Linux do not run natively.
- **QB64 Phoenix Edition** keeps that dialect alive: it "retains
  QB4.5/QBasic compatibility" and builds native programs for Windows,
  Linux and macOS [1]. It is maintained: version 4.7.0 was released on
  2026-09-26 [7]. It installs natively on macOS, so no Docker is needed.
- **Why not FreeBASIC**, the other candidate? FreeBASIC "is a
  free/open source (GPL), BASIC compiler for Microsoft Windows, DOS and
  Linux" [8]; macOS is not in its list, so on this project's development machine
  it would only run inside a Linux Docker container. It also supports
  QuickBASIC code, through its `-lang qb` dialect [9]. Its latest release,
  1.10.1, is from 2023-12-25 [10]. QB64-PE was chosen because it runs
  natively on every target platform and is more recently released.
- **Why not Visual Basic?** Visual Basic .NET is the BASIC with the most
  users today (see the [language README](../README.md#market-usage-today)),
  but it is an object-oriented .NET language closer to C#, which this
  project already covers in [csharp/](../../csharp/). Microsoft also
  wrote in 2020: "Going forward, we do not plan to evolve Visual Basic as
  a language" [11]. The classic, line-by-line BASIC shows the imperative
  paradigm more clearly.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | QB64-PE 4.7.0 built by `install.sh` with Apple clang 21 (57 s). |
| macOS Apple Silicon | ⚠️ not verified | Same macOS package and script; the package is compiled locally, so it targets the Mac's own CPU. |
| Linux | ⚠️ not verified | Download `qb64pe_lnx-x64-4.7.0-GLFW.tar.gz` [7] and run `./setup_lnx.sh`; "Dependencies should be automatically installed. Required packages include OpenGL, ALSA and the GNU C++ Compiler" [1]. It uses `sudo` for those packages, so `install.sh` does not run it for you. Then use `QB64PE=/path/to/qb64pe ./build.sh`. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Download `qb64pe_win-x64-4.7.0-GLFW.7z` [7] and "extract the package contents to a folder with full write permissions" [1]; add it to PATH. Name the output `bin/hello-cli.exe`. WSL behaves like Linux. |

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
1. QB64 Phoenix Edition README (description, installation, usage). QB64-PE project. <https://github.com/QB64-Phoenix-Edition/QB64pe> (accessed 2026-11-01)
2. $CONSOLE. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/$CONSOLE> (accessed 2026-11-01)
3. PRINT. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/PRINT> (accessed 2026-11-01)
4. SYSTEM. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/SYSTEM> (accessed 2026-11-01)
5. END. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/END> (accessed 2026-11-01)
6. `EDIT.COM` Cannot Find `QBASIC.EXE` (KB 63777). Microsoft Knowledge Base, archived copy. <https://ftp.zx.net.nz/pub/archive/ftp.microsoft.com/MISC/KB/en-us/63/777.HTM> (accessed 2026-11-01)
7. Release v4.7.0-GLFW (2026-09-26; assets and SHA-256 digests). QB64-PE project, GitHub. <https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v4.7.0-GLFW> (accessed 2026-11-01)
8. FreeBASIC home page. FreeBASIC project. <https://www.freebasic.net/> (accessed 2026-11-01)
9. Compiler option -lang. FreeBASIC Wiki. <https://www.freebasic.net/wiki/CompilerOptlang> (accessed 2026-11-01)
10. Release 1.10.1 (2023-12-25). FreeBASIC project, GitHub. <https://github.com/freebasic/fbc/releases/tag/1.10.1> (accessed 2026-11-01)
11. Visual Basic support planned for .NET 5.0 (2020-03-11). Microsoft .NET Blog. <https://devblogs.microsoft.com/vbteam/visual-basic-support-planned-for-net-5-0/> (accessed 2026-11-01)
