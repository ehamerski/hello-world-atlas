# Racket · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Racket](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and a newline,
then exits. The program has two lines: the language line `#lang racket/base`
and one expression, `(displayln "Hello, World!")`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Racket (`racket`), Minimal Racket, CS variant | 9.3 | the program that compiles and runs `hello.rkt` [1][8] |
| `curl` and `shasum` | the versions that come with macOS | `install.sh` downloads the Racket tarball and checks its SHA-256 digest |

Minimal Racket "includes just enough of Racket that you can use raco pkg to
install more" [1]. It is enough for this program.

## Quick start
```sh
./install.sh   # check / install Racket under ~/.local/racket-9.3 (asks before downloading)
./run.sh       # run it
```
There is no `build.sh`. Racket compiles a module in memory when it runs it
(see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `racket-env.sh` | Sourced by the other scripts. It pins the version, the download URL, the SHA-256 digest, and the install folder, and puts the Racket `bin` folder on `PATH` for the running script only. | One place holds the version and the digest. Your shell `PATH` stays unchanged. |
| `install.sh` | Looks for `racket` in `~/.local/racket-9.3/racket/bin`. If it is missing, it asks, downloads the official tarball with `curl`, checks the SHA-256 digest with `shasum -a 256`, and unpacks it. It never uses `sudo`. | The program cannot run without Racket. The digest check proves that the file is the one the project lists. |
| `run.sh` | Runs `racket hello.rkt`. `--verify` does the same, because a cli program ends on its own. | One command for students, with an explanation of what happens. |

The Racket project publishes the SHA-256 digest of each file on its release
page [1]. `install.sh` checks the downloaded tarball against it, and the check
printed `OK` in the run below. The project publishes no separate signature
file for the tarball on that page, so the digest is the only check.
`install.sh` unpacks into `~/.local/racket-9.3/racket/`, because the tarball
holds one folder named `racket`.

## Folder structure
```text
cli/
├── README.md       this file
├── install.sh      checks / installs Racket
├── racket-env.sh   version, URL, digest, and install folder (sourced, not run)
├── run.sh          runs the program
└── hello.rkt       the program (two lines plus teaching comments)
```
A single `.rkt` file with a `#lang` line is a complete Racket program. A
larger project puts several modules in one folder and loads them with
`require` [4].

## Step-by-step walkthrough
Open [`hello.rkt`](hello.rkt) next to this list.

1. **Comments.** A line that starts with `;` is a comment. Scheme and Lisp
   use the same symbol. Python and Ruby use `#`, and C, Java, and Go use
   `//`.
2. **`#lang racket/base`** names the language of the module. Every Racket
   file is a module, and the first line says which language it uses [3]. The
   language `racket` is the full variant. The Racket Guide calls
   `racket/base` "the smaller" one [3]. A Hello World needs only that one.
3. **No `main`, no import.** Racket runs the module from top to bottom, as
   Python and Ruby run a file. C, Java, C#, and Go need a `main` function.
4. **A call is a list in parentheses.** `(displayln "Hello, World!")` puts
   the function name first and then the arguments. Most languages write
   `function(argument)`. Racket moves the function inside the parentheses.
5. **`displayln`** is "the same as `(display datum out)` followed by
   `(newline out)`" [2], so it prints the text and a newline to standard
   output. The reference says: "For a closer analog to println in other
   languages, use displayln" [2]. Unlike C's `printf`, it needs no `\n`.
6. **The string** is printed without its quotation marks, because `display`
   shows the text itself. `write` keeps the quotation marks [2].

Compare with the other categories in [../README.md](../README.md#comparing-the-categories).

### Why there is no build step
`racket hello.rkt` runs the file: when the first command-line argument is
not a flag, Racket adds the `-u` flag, which requires the file as a script
[7]. The Racket Guide says that `racket sort.rkt` "runs the "sort.rkt"
program and automatically loads and compiles required modules" [4]. The
compiled code stays in memory. A compiled language such as C needs a
`build.sh` that makes an executable before `run.sh` can start it.

Racket also has an ahead-of-time step. `raco make hello.rkt` compiles the
module and its dependencies to files in a `compiled` folder, and
`racket hello.rkt` then uses those files when they are present [4][5]. The
Guide recommends it when compilation from source takes too long, which is
not the case for this program [4]. This implementation does not use it, so
it has no `build.sh`.

Minimal Racket does not include the `raco make` command. In the fresh
Minimal Racket 9.3 installation used here, `raco help` lists only `link`,
`pkg`, and `setup`, and `raco make hello.rkt` prints
`raco: Unrecognized command: make`. After the package `compiler-lib` was
installed with `raco pkg install compiler-lib` [6], `raco make hello.rkt`
created `compiled/hello_rkt.zo` and `compiled/hello_rkt.dep`, and
`raco help` then also listed `make` and `exe`.

## Why this toolchain
- **The `racket` program** is the reference implementation, from the Racket
  project (racket-lang.org). The download page lists the release, 9.3
  (August 2026), and one SHA-256 digest per file [1].
- **Minimal Racket** "includes just enough of Racket that you can use
  `raco pkg` to install more" [1], while the full distribution includes
  DrRacket [1][9]. This program needs neither. What Minimal Racket lacks: the
  GUI toolkit `racket/gui/base` belongs to the package `gui-lib` [10], and
  in the Minimal Racket 9.3 installation used here
  `racket -l racket/gui/base -e '(void)'` fails with
  `cannot open module file`. That is why this language has a `cli`
  implementation only.
- **The CS variant** is the default implementation as of Racket 8.0. It
  "uses Chez Scheme as its core compiler and runtime system" [8]. The
  installer file name ends in `-cs`, and `racket --version` prints
  `Welcome to Racket v9.3 [cs].`
- **A tarball in your home folder** needs no package manager and no `sudo`.
  The `x86_64-macosx` file runs on macOS Intel [1].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-12) | Racket 9.3 [cs], Minimal Racket, tarball `racket-minimal-9.3-x86_64-macosx-cs.tgz`, downloaded and checked with the SHA-256 digest from the release page [1]. Run from a clean shell with `env -i`, and installed into an empty folder. The Racket project reported in October 2026 that macOS binaries of versions 8.12 to 9.3 signed with a possibly compromised certificate would stop working once Apple revokes it, and advises installing the current binaries from the download page [11]. `install.sh` downloads the current file. |
| macOS Apple Silicon | ⚠️ not verified | The release page lists a separate `aarch64-macosx` tarball [1]. `install.sh` stops and names the download page. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` stops and names the download page. The command `racket hello.rkt` is the same. |
| Windows (Git Bash / WSL) | ⚠️ not verified | The release page lists a Windows installer [1]. The command `racket hello.rkt` is the same in a terminal. |

## Expected output
Run this command in this folder (output from a run on 2026-11-12; `./run.sh
--verify` prints the same lines and exits with status 0):
```sh
./run.sh
```
The script prints its explanation first (lines starting with `==>` and
indented `WHY:` lines), then the output of the program:
```text
==> Run the program
    WHY: 'racket hello.rkt' starts Racket, which compiles the module in memory and runs it.
Hello, World!
```
The command `racket hello.rkt` alone prints only the last line.

## Sources
1. Racket 9.3 download page (Minimal Racket, installers, and SHA-256 digests). Racket project. <https://download.racket-lang.org/releases/9.3/> (accessed 2026-11-12)
2. Racket Reference, section 13.5 "Writing" (`display`, `displayln`, `write`). Racket project. <https://docs.racket-lang.org/reference/Writing.html> (accessed 2026-11-12)
3. The Racket Guide, chapter 1 "Welcome to Racket" (`#lang`, `racket/base`). Racket project. <https://docs.racket-lang.org/guide/intro.html> (accessed 2026-11-12)
4. The Racket Guide, section 6.1 "Module Basics" (`racket sort.rkt`, `raco make`, `require`). Racket project. <https://docs.racket-lang.org/guide/module-basics.html> (accessed 2026-11-12)
5. raco make: Compiling Source to Bytecode. Racket project. <https://docs.racket-lang.org/raco/make.html> (accessed 2026-11-12)
6. raco pkg: Racket Package Manager, section "raco pkg install". Racket project. <https://docs.racket-lang.org/pkg/cmdline.html> (accessed 2026-11-12)
7. Racket Reference, chapter 18 "Running Racket" (command-line flags). Racket project. <https://docs.racket-lang.org/reference/running-sa.html> (accessed 2026-11-12)
8. Racket Reference, section 1.5 "Implementations" (CS and BC). Racket project. <https://docs.racket-lang.org/reference/implementations.html> (accessed 2026-11-12)
9. Racket, the programming language (home page). Racket project. <https://racket-lang.org/> (accessed 2026-11-12)
10. The Racket Graphical Interface Toolkit (package `gui-lib`). Racket project. <https://docs.racket-lang.org/gui/> (accessed 2026-11-12)
11. Security incident and signing keys (racket-lang blog, October 2026). Racket project. <https://blog.racket-lang.org/2026/10/infrastructure-compromise.html> (accessed 2026-11-12)
