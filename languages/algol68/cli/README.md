# ALGOL 68 · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [ALGOL 68](../README.md)

## What this is
A command-line program, written in ALGOL 68, that prints one line:
`Hello, World!`. The interpreter Algol 68 Genie (the command `a68g`) reads
`hello.a68`, checks it, and runs it in one step [1]. There is no separate
compile step, so this folder has no `build.sh`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Algol 68 Genie (`a68g`) | 3.13.4, built from the project's source archive | runs `hello.a68` |
| C compiler (Apple clang) and `make` | from the Command Line Tools | `install.sh` builds `a68g` from source [1] |
| `curl` | the one shipped with macOS | `install.sh` downloads the source archive |

The project publishes releases as source archives on its own site [2]. It
publishes no checksum or signature for them. `algol68-env.sh` pins the
SHA-256 digest of `algol68g-3.13.4.tar.gz`,
`625746ccb08e6fbfea1f526400cf21068ab2af34f6b64756ccc20e37e4d2d4f8`, which
two downloads from `https://algol68genie.nl/algol68g-3.13.4.tar.gz` gave on
2026-11-12. The digest shows that you build the same file that was tested
here. It does not prove that the author of the project signed it. The
license is the GNU General Public License [2]; the `COPYING` file in the
archive is version 3, and the source files say "either version 3 of the
License, or (at your option) any later version".

## Quick start
```sh
./install.sh   # check a68g; if missing, offer to build it into ~/.local/algol68g-3.13.4
./run.sh       # run hello.a68
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `a68g` is installed. If not, and only if you answer "y", downloads the pinned source archive into a temporary folder, checks its SHA-256, and runs `./configure --prefix=... --disable-readline`, `make`, and `make install` | `a68g` is the ALGOL 68 implementation. No `sudo` is used: the prefix is a folder in your home directory |
| `algol68-env.sh` | Sourced by the other scripts. Pins the version, URL, SHA-256, and install folder (`A68G_DIR`, default `~/.local/algol68g-3.13.4`) and puts its `bin` folder on `PATH` | The scripts find `a68g` without your shell setup |
| `run.sh` | Runs `a68g hello.a68`. `--verify` runs the same command and exits by itself | `verify-all.sh` needs a command that prints `Hello, World!` and exits |

There is no `build.sh`: `a68g` is an interpreter, so it runs the source
file directly [1][2].

`--disable-readline` turns off the optional GNU readline library, which
only adds line editing for terminal input [1]. On the development
machine (macOS Intel, Command Line Tools), `configure` accepted the system
`readline` (the SDK ships it as Apple's `editline` library) and the 3.13.4
source then failed to compile with `use of undeclared identifier
'RL_VERSION_MAJOR'`. With `--disable-readline` it builds. Hello World reads
no input, so nothing is lost.

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / builds Algol 68 Genie (no sudo)
├── algol68-env.sh   pinned version, URL, SHA-256, install folder (sourced)
├── run.sh           runs hello.a68 with a68g
└── hello.a68        the program (one statement)
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).
`a68g` opens a file with the name you give it, and also tries the extensions
`.a68`, `.a68g`, and `.algol68` [1].

## Step-by-step walkthrough
1. **Comments** start with `#` and end with the next `#`. `CO ... CO` and
   `COMMENT ... COMMENT` do the same. Because the opening and closing symbols
   are equal, comments cannot nest [1] (section 4.11). A `#` inside a comment
   ends it, so `hello.a68` never writes the symbol in running text.
2. **The program has one statement.** A particular program is an enclosed
   clause that runs in the standard environment [1] (section 8.7). The Genie
   manual gives `(print ("Hello world!"))` as a complete program [1]. There is
   no `main` function.
3. **`print`** is a procedure of the standard prelude. It takes a row of
   values to write, declared as `PROC print = ([] SIMPLOUT) VOID` [1]. This is
   why `hello.a68` writes two pairs of parentheses: the inner pair builds the
   row, and the outer pair calls `print`.
4. **`new line`** is a value of the standard prelude that moves to the next
   line [1]. It sits in the row after the string, so the output ends with a
   newline. Without it, the shell prompt would follow the text.
5. **A string** is written between double quotes [1].
6. Compare [C](../../c/README.md) and [Pascal](../../pascal/README.md): no
   braces, no `main`, no include line. For the history of the language, see the
   [language overview](../README.md).

## Why this toolchain
- Algol 68 Genie describes itself as a new implementation written from
  scratch that "implements practically full Algol 68 as defined by the
  Revised Report" [1]. The Revised Report is the final definition of the
  language [3].
- Its home page calls it one of the most complete implementations of the
  language, "an interpreter like Python", and lists version 3 revisions from
  2022 onward [2].
- GCC 16 includes an experimental ALGOL 68 front end, `ga68` [4]. It is a
  compiler, and a compiler would need a `build.sh`. This folder uses the
  interpreter, which does not.
- The project's downloads page lists version 3.14.0 as its current release
  (9 November 2026) [2]. This folder pins 3.13.4, the version tested here; its
  archive is still served at the URL in `algol68-env.sh`.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-12) | Algol 68 Genie 3.13.4 built with Apple clang; `install.sh` (check, and a clean build into an empty prefix, about 1 minute 15 seconds), `run.sh`, and `run.sh --verify` run |
| macOS Apple Silicon | ⚠️ not verified | the scripts were not run there |
| Linux (Debian/Ubuntu) | ⚠️ not verified | the project says it develops Algol 68 Genie 3 on Debian GNU/Linux [2]; these scripts were not run there |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` stops on Windows. The project offers a prebuilt WIN64 binary for Windows 11 in a zip archive [2]; it was not tried |

## Expected output
Run this command in this folder:
```sh
./run.sh
```
`./run.sh` prints one line after its step messages and exits with status 0:
```text
==> Run the program
    WHY: a68g reads hello.a68 and runs it directly (no build step).
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. van der Veer, Marcel (ed.). *Learning Algol 68 Genie* (Algol 68 Genie 3.14, edition of November 2026): sections 4.11 (comments), 7.3 (`print`), 8.7 (particular program), 10.5 (generic installation, with the `configure` options, `enable-readline` among them), and the preface. Includes the Revised Report. <https://algol68genie.nl/learning-algol-68-genie.pdf> (accessed 2026-11-12)
2. van der Veer, Marcel. "The Algol 68 Genie project", downloads, license, and version history. algol68genie.nl. <https://algol68genie.nl/en/algol-68-genie/> (accessed 2026-11-12)
3. van Wijngaarden, A. et al. *Revised Report on the Algorithmic Language ALGOL 68*. IFIP Working Group 2.1; edition with errata to 1978. Software Preservation Group. <https://www.softwarepreservation.org/projects/ALGOL/report/Algol68_revised_report-AB-600dpi.pdf> (accessed 2026-11-12)
4. GCC 16 Release Series: Changes, New Features, and Fixes. GNU Project. <https://gcc.gnu.org/gcc-16/changes.html> (accessed 2026-11-12)
