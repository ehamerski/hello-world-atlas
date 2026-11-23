# Pascal · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Pascal](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.pas`](hello.pas), written in **ISO 7185 Standard
Pascal**, the standardized form of the language Niklaus Wirth defined in
1970 [1], and compiled by **Free Pascal** (FPC), "a mature, versatile, open
source Pascal compiler" [2].

Like the [C cli](../../c/cli/), the program is compiled ahead of time into
a native executable, `bin/hello-cli`. The script `build.sh` calls the
compiler with a flag that selects one dialect (`-Miso` here, `-std=c89` in
C).
Compare the [desktop version](../desktop/), which uses Object Pascal, the
extended dialect of Lazarus and Delphi.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Free Pascal (`fpc`) | 3.2.2, official macOS release, unpacked into `~/.local/fpc-3.2.2` by `install.sh` | compiles and links `hello.pas` |
| Apple's linker | Command Line Tools (Apple clang 21.0.0) | FPC calls the system linker on macOS |

Free Pascal 3.2.2 is the latest stable release; version 3.2.4 exists only
as a release candidate [2][3].

**Why not `brew install fpc` on macOS?** Homebrew's `fpc` formula has
ready-made packages (bottles) for Apple Silicon and Linux only [4], so on
Intel Macs Homebrew builds FPC from source. On the dev machine that build
failed (2026-11-01): Apple's current assembler rejects code that FPC 3.2.2
generates for one of its own library units:
```text
rtl-objpas/units/x86_64-darwin/rtti.s:12:1: error: non-private labels cannot
appear between .cfi_startproc / .cfi_endproc pairs
```
FPC's official macOS release is already compiled, so it does not hit this.
The Lazarus team also notes that its own 4.8 release "was built with FPC
3.2.2, and FPC 3.2.4RC1 for macOS" [5]. `install.sh` therefore downloads
the official release (`fpc-3.2.2.intelarm64-macosx.dmg`, one file for Intel
and Apple Silicon) [6], checks its SHA-256 checksum, and unpacks the files
its installer would copy to `/usr/local` into `~/.local/fpc-3.2.2`
instead. No `sudo` is needed; delete that folder to uninstall. On the dev machine this
took about 40 seconds with the file already downloaded (2026-11-01).

## Quick start
```sh
./install.sh   # check / install Free Pascal (asks before installing)
./build.sh     # compile hello.pas as ISO 7185 Pascal into bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `fpc-env.sh` | Sourced by `install.sh` and `build.sh`: sets `FPC_VERSION`, `FPC_DMG_SHA256`, `FPC_DIR` (default `~/.local/fpc-3.2.2`) and puts `$FPC_DIR/bin` first on `PATH` if FPC is installed there. | One place for the version, checksum and folder. |
| `install.sh` | Runs `fpc -iV`. If `fpc` is missing: on macOS it installs the official release as described above (it uses only `curl`, `shasum`, `hdiutil` and `pkgutil`, which come with macOS); on Debian/Ubuntu it offers `sudo apt-get install -y fpc`; on Windows it prints where to get the installer. Everything runs only if you answer `y`. | Pascal is compiled, so a Pascal compiler is the only tool needed. |
| `build.sh` | Runs `fpc -Miso -FEbin -FUbin -ohello-cli hello.pas` and prints that command (`set -x`). `FPC=/path/to/fpc ./build.sh` selects another compiler. | Turns the source into machine code. The flags are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a cli program ends by itself). | The executable is machine code, so the operating system runs it directly. |

**The flags, one by one** (descriptions from `fpc -h`, the compiler's own
help [7]):
- `-Miso`: "ISO 7185 mode". The User's Guide adds: "In this mode, the
  compiler complies with the requirements of level 0 of ISO/IEC 7185" [8].
  Without `-M`, FPC uses its own dialect: `-Mfpc` "Free Pascal dialect
  (default)" [7].
- `-FEbin`: "Set exe/unit output path to bin" [7], so the executable goes
  into `bin/`.
- `-FUbin`: "Set unit output path to bin" [7]: the object file `hello.o`
  also goes into `bin/`, so the source folder stays clean.
- `-ohello-cli`: "Change the name of the executable produced" [7]; without
  it the file would be `hello`, named after the source file.
- FPC compiles **and links** in one call. It shows warnings by default:
  its configuration file `fpc.cfg` contains `-viwn` ("Display Info,
  Warnings and Notes").

## Folder structure
```text
cli/
├── README.md     this file
├── fpc-env.sh    Free Pascal version, checksum and folder (sourced)
├── install.sh    checks / installs Free Pascal
├── build.sh      compiles hello.pas as ISO 7185 Pascal
├── run.sh        runs bin/hello-cli
├── hello.pas     the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    ├── hello-cli
    └── hello.o
```
- A one-file Pascal program needs no project file: `fpc hello.pas` is
  enough. Larger Free Pascal projects are usually Lazarus projects (`.lpi`
  file, see [../desktop](../desktop/)) or use FPC's `fpmake`.
- `bin/` and compiled units (`*.ppu`) are ignored by the root
  `.gitignore`.

## Step-by-step walkthrough
Open [`hello.pas`](hello.pas) next to this list.

1. **Comments** are written `{ ... }` or `(* ... *)`. FPC's Reference
   Guide calls `(* *)` "an older form of comment notation" and `{ }` "the
   standard notation". The `//` form found in much Pascal code "was
   introduced by Borland in the Delphi Pascal compiler" [9], so it is not
   Standard Pascal.
2. **`program hello(output);`** is the program header. In Standard Pascal
   it lists the files the program uses; `output` is the terminal. Free
   Pascal's own dialects do not need it: "The program header is not
   required. If present, it will be used by the compiler to name the
   program" [9].
3. **`begin ... end.`** is the program's body, its entry point. There is
   no `main` function as in C, Java or Go. Note the full stop after the
   last `end`.
4. **`writeln('Hello, World!')`** writes the text and a line break to
   standard output. FPC's documentation: "If the parameter F is omitted,
   standard output is assumed" [10]. Strings use single quotes.
5. **No semicolon after `writeln(...)`.** In Pascal the semicolon
   *separates* statements; it does not end them as in C. With one
   statement there is nothing to separate. **Try it:** add a `;` after
   the `)`, run `./build.sh`: it still compiles (Pascal allows an *empty
   statement* before `end`). Now remove the `;` and the closing quote of
   the string and run `./build.sh` again: FPC stops with
   `hello.pas(33,11) Fatal: String exceeds line`. Then undo your changes.
6. **Case does not matter.** `WriteLn`, `WRITELN` and `writeln` are the
   same word, as in Fortran and COBOL, and unlike C or Java.
7. **What the executable needs.** `otool -L bin/hello-cli` lists only
   `/usr/lib/libSystem.B.dylib`, the macOS system library: Free Pascal
   copies its own runtime library into the executable. Compare the
   [Fortran cli](../../fortran/cli/), which loads `libgfortran` at
   runtime.

## Why this toolchain
- **Era context.** Pascal's first compiler ran on CDC 6000 computers
  [1]. On personal computers, the best-known Pascal compilers were
  Borland's Turbo Pascal (1983) and its successor Delphi (1995) [11][12];
  both are commercial products.
- **Free Pascal is the maintained, free compiler on every platform of this
  project.** The Lazarus project describes it as "a GPL'ed compiler that
  runs on Linux, Windows, macOS, FreeBSD and others" [16]. It supports several
  dialects through `-M`: ISO 7185, ISO 10206 Extended Pascal, Turbo Pascal,
  Delphi, and its own [7][8]. So one
  compiler can build both the 1970s-style program here and the Object
  Pascal in [../desktop](../desktop/).
- **ISO mode on purpose.** It shows the language as standardized, without
  the Turbo Pascal and Delphi extensions that the desktop version uses.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | FPC 3.2.2 official release in `~/.local/fpc-3.2.2` (Homebrew's source build fails, see Prerequisites). Linking prints two harmless warnings from Apple's newer linker: `-macosx_version_min has been renamed to -macos_version_min` and `ld: warning: -multiply_defined is obsolete`. |
| macOS Apple Silicon | ⚠️ not verified | The same `install.sh` path: the release file covers Intel and Apple Silicon [6]. `brew install fpc` also has a bottle there [4]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `fpc` with apt when missing [13]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs Chocolatey and installs Lazarus 4.0.0, which includes Free Pascal 3.2.2 [15], with `choco install lazarus --version=4.0.0` when `fpc` is missing. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
         Free Pascal's runtime library is inside the executable.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Niklaus Wirth, *The Programming Language Pascal*, ETH Zürich, November 1970 (second edition July 1971). ETH Research Collection, DOI 10.3929/ethz-a-004150844. <https://www.research-collection.ethz.ch/server/api/core/bitstreams/8bd8f312-3c90-4bc5-9081-63943ff3902a/content> (accessed 2026-11-01)
2. Free Pascal (home page: description, latest stable version 3.2.2). <https://www.freepascal.org/> (accessed 2026-11-01)
3. FPC source repository tags (`release_3_2_2`, `release_3_2_4_rc2`). Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/source/-/tags> (accessed 2026-11-01)
4. `fpc` formula (versions and bottles). Homebrew Formulae. <https://formulae.brew.sh/formula/fpc> (accessed 2026-11-01)
5. Lazarus home page (news: "Lazarus Bugfix Release 4.8 - June 11, 2026"). Lazarus. <https://www.lazarus-ide.org/> (accessed 2026-11-01)
6. Free Pascal 3.2.2 for macOS (release files and checksums). SourceForge. <https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/3.2.2/> (accessed 2026-11-01)
7. `fpc -h`, the command-line help of Free Pascal 3.2.2 (run on the dev machine, 2026-11-01).
8. Free Pascal User's Guide, compiler modes (`-M`) section, LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (accessed 2026-11-01)
9. Free Pascal Reference Guide, sections "Comments" and "Programs", LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/ref.tex> (accessed 2026-11-01)
10. WriteLn. Free Pascal Run-Time Library reference. <https://www.freepascal.org/docs-html/rtl/system/writeln.html> (accessed 2026-11-01)
11. Turbo Pascal turns 40. Embarcadero blog. <https://blogs.embarcadero.com/turbo-pascal-turns-40/> (accessed 2026-11-01)
12. The long and winding road to today's Delphi: happy 29th birthday. Embarcadero blog. <https://blogs.embarcadero.com/the-long-and-winding-road-to-todays-delphi-happy-29th-birthday/> (accessed 2026-11-01)
13. `fpc` in Debian stable (3.2.2+dfsg-46). Debian archive (`madison`). <https://api.ftp-master.debian.org/madison?package=fpc&s=stable> (accessed 2026-11-01)
14. Free Pascal 3.2.2 for Windows (release files). SourceForge. <https://sourceforge.net/projects/freepascal/files/Win32/3.2.2/> (accessed 2026-11-01)
15. Lazarus downloads ("Lazarus 4.8 which is accompanied by FPC 3.2.2"). Lazarus. <https://www.lazarus-ide.org/index.php?page=downloads> (accessed 2026-11-01)
16. About Lazarus. Lazarus. <https://www.lazarus-ide.org/index.php?page=about> (accessed 2026-11-01)
