# Haskell · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Haskell](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.hs`](hello.hs), compiled by **GHC**, the Glasgow Haskell
Compiler, into a native executable, `bin/hello-cli`. GHC and its tools are
installed with **GHCup**, "the main installer for the general purpose
language Haskell" [1].

The program is two lines of real code:

```haskell
main :: IO ()
main = putStrLn "Hello, World!"
```

Those two lines show the main idea of Haskell, a **purely functional**
language: printing is not something the code *does*; it is a value (an
`IO` action) that the code *describes*. The
[walkthrough](#step-by-step-walkthrough) explains this step by step.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| GHC | 9.10.3 (GHCup) | compiles and links `hello.hs` |
| GHCup | 0.2.6.2 | installs GHC (and Cabal, used by [../web](../web/)) into `~/.ghcup` |
| Apple's linker | Command Line Tools | GHC uses the system C toolchain to link on macOS |

GHC 9.10.3 was "released 10th September 2025" [2]. On the test machine,
`ghcup list` showed it with the tag `recommended` on 2026-11-01; GHCup
installs that version when no version is given [3].

GHCup puts its programs in `~/.ghcup/bin` [4], in your home folder, so no
`sudo` is needed. The scripts add that folder to `PATH` themselves (see
`ghcup-env.sh`); in your own terminal run `. ~/.ghcup/env` first.

## Quick start
```sh
./install.sh   # check / install GHC with GHCup (asks before installing)
./build.sh     # compile hello.hs into bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `ghc --version`. If GHC is missing, downloads GHCup's bootstrap script from `https://get-ghcup.haskell.org` [1] to a file and shows its path, then runs it only if you answer `y` (it asks before the download too), with `BOOTSTRAP_HASKELL_NONINTERACTIVE=1` (no questions, as in GHCup's guide [3]) and `BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1` (skip Stack, a build tool these examples do not use). On Windows it prints the PowerShell command instead [1]. | Haskell is compiled, so GHC is the only tool the cli needs. GHCup should be run "as **non-root/non-admin user**" [4]. |
| `build.sh` | Runs `ghc -O -outputdir build -o bin/hello-cli hello.hs` and prints that command (`set -x`). `GHC=ghc-9.10 ./build.sh` picks another compiler command. | Turns the source into machine code. The flags are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a cli program ends by itself). | The executable is machine code, so the operating system runs it directly. |
| `ghcup-env.sh` | Not run on its own: the other three scripts read it. It adds `~/.ghcup/bin` to `PATH` if it is not there yet. | `install.sh` does not edit your shell profile, so each script finds `ghc` this way. |

**The flags, one by one:**
- `-O`: optimize. The GHC User's Guide describes the default, with no
  `-O` flag, as "Please compile quickly; I'm not over-bothered about compiled-code quality" [5]. `-O1`
  (the same as `-O`) means "Generate good-quality code without taking too
  long about it" [5].
- `-outputdir build`: put the intermediate files in `build/` instead of
  next to `hello.hs`. It "is shorthand for the combination of" `-odir`,
  `-hidir` and the other output-folder flags [6]. In that folder the files
  are named after the *module*, not the file, so you get `build/Main.o`
  and `build/Main.hi` [6]. The `.hi` *interface* file "contains the
  information that GHC needs in order to compile further modules that
  depend on this module" [6].
- `-o bin/hello-cli` names the executable. Without it, the name is "based
  on the name of the file containing the module `Main`" [6], so here it
  would be `hello`.

## Folder structure
```text
cli/
├── README.md       this file
├── install.sh      checks / installs GHC with GHCup
├── build.sh        compiles hello.hs
├── run.sh          runs bin/hello-cli
├── ghcup-env.sh    adds ~/.ghcup/bin to PATH (read by the scripts)
├── hello.hs        the program
├── build/          created by build.sh: Main.o, Main.hi; not committed
└── bin/            created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- A one-file program with no libraries needs no project file and no build
  tool: `ghc` alone is enough. The [web](../web/) version uses libraries,
  so it has a `.cabal` file and is built with Cabal.
- `bin/`, `build/` and `*.hi` files are ignored by the root `.gitignore`.

## Step-by-step walkthrough
Open [`hello.hs`](hello.hs) next to this list.

1. **Comments.** "An ordinary comment begins with a sequence of two or
   more consecutive dashes (e.g. --) and extends to the following
   newline" [7], like `//` in C99, Java or Go. "A nested comment begins
   with "{-" and ends with "-}"" [7].
2. **`module Main (main) where`.** Every Haskell file is a module. A
   program needs a module that, "by convention, must be called Main and
   must export the value main" [8]. The line is optional: if a file has no
   header, "the header is assumed to be 'module Main(main) where'" [8].
3. **`main :: IO ()` is a type signature.** Read `::` as "has the type".
   `IO ()` is the type of an *I/O action*: "The IO type serves as a tag for
   operations (actions) that interact with the outside world" [9]. The `()`
   is the *unit* type, which "has one non-⊥ member, the nullary constructor
   ()" [9]: the action gives back nothing useful, like `void` in C. GHC
   could infer this type by itself, but writing it is the usual style.
4. **`main = putStrLn "Hello, World!"` is a definition, not a command.**
   `putStrLn` has the type `String -> IO ()` [10]: it is a function that
   takes a string and returns an action. Function application needs no
   parentheses: "Function application is written e1 e2" [11], so
   `putStrLn "Hello, World!"` is `putStrLn("Hello, World!")` in C style.
   The result of that application is the action "write this line". The
   `=` means *is equal to*, as in mathematics: `main` and that action are
   the same value.
5. **Who prints, then? The runtime system.** The Report says: "When the
   program is executed, the computation main is performed" [8]. So the
   Haskell code only *describes* the printing, and the runtime *performs*
   it once, when the program starts. haskell.org puts it this way: "Even
   side-effecting IO operations are but a description of what to do,
   produced by pure code" [12].
6. **Why this matters: pure functions.** "Every function in Haskell is a
   function in the mathematical sense (i.e., "pure")" [12]: same input,
   same result, nothing else happens. The type shows which values may
   touch the outside world. A function of type `String -> String` cannot
   print; about such a type haskell.org says "By the type it cannot do any
   side-effects whatsoever" [12]. Only values of type `IO ...`, run from
   `main`, can. **Try it:** add a pure function and use it from `main`:

   ```haskell
   greet :: String -> String
   greet name = "Hello, " ++ name ++ "!"

   main :: IO ()
   main = putStrLn (greet "World")
   ```

   Run `./build.sh && ./run.sh`: the output is the same. `greet` builds
   the text, and only the `IO` action prints it. Then change it back.
7. **Compile and link.** `build.sh` does both in one call. `otool -L
   bin/hello-cli` lists only macOS system libraries (`libSystem`,
   `libiconv`, `libffi`, `libcharset`): GHC links the Haskell libraries and
   the runtime system into the executable itself, so no Haskell tool is
   needed to run it. On the test machine, the file is 1,438,656 bytes.

## Why this toolchain
- **GHC is the standard compiler.** haskell.org calls GHC Haskell's
  "flagship compiler" [12]. It compiles ahead of time to a native
  executable, like the [C](../../c/cli/) and [Fortran](../../fortran/cli/)
  versions in this repository.
- **GHCup is the official installer.** It "makes it easy to install
  specific versions of GHC on GNU/Linux, macOS (aka Darwin), FreeBSD and
  Windows" [4], installs into your home folder, and also installs Cabal,
  which the [web](../web/) version needs.
- **Plain `ghc`, no Cabal or Stack here.** One file that uses no
  libraries needs no package description. The `ghc` command line shows every step; the
  [web](../web/) version shows the Cabal way.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | GHC 9.10.3, GHCup 0.2.6.2. GHC has an x86-64 macOS build [2]. |
| macOS Apple Silicon | ⚠️ not verified | Same commands; GHC has an AArch64 macOS build [2]. GHCup notes: "On Darwin M1 you might also need a working llvm installed (e.g. via brew) and have the toolchain exposed in PATH" [13]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` runs GHCup's bootstrap script from `get-ghcup.haskell.org` (non-interactive, without Stack) when `ghc` is missing. It installs GHC and Cabal into `~/.ghcup`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install GHC: if `ghc` is missing it prints GHCup's PowerShell command [4] and stops. WSL not verified; it behaves like Linux. |

**GHCup's bootstrap script is not digest-checked.** GHCup's install page
gives no checksum for it: it points to the script's source code, and offers
GPG checks only for a manual install of the binaries [4]. So `install.sh`
saves the script to `~/.cache/hello-world-haskell/bootstrap-haskell.sh` and
shows the path, so you can read it before you answer `y` to run it.

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code with the Haskell runtime inside;
         the operating system runs it directly.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. GHCup (home page: install commands). haskell.org. <https://www.haskell.org/ghcup/> (accessed 2026-11-01)
2. GHC 9.10.3 download page (release date, binary distributions). GHC developers, haskell.org. <https://www.haskell.org/ghc/download_ghc_9_10_3.html> (accessed 2026-11-01)
3. GHCup User Guide (tags such as `recommended`, non-interactive install). haskell.org. <https://www.haskell.org/ghcup/guide/> (accessed 2026-11-01)
4. GHCup: Installation. haskell.org. <https://www.haskell.org/ghcup/install/> (accessed 2026-11-19)
5. GHC 9.10.3 User's Guide: <!-- vale HelloWorld.British = NO -->Optimisation<!-- vale HelloWorld.British = YES --> (code improvement). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/using-optimisation.html> (accessed 2026-11-01)
6. GHC 9.10.3 User's Guide: Filenames and separate compilation (-o, -outputdir, interface files). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/separate_compilation.html> (accessed 2026-11-01)
7. Haskell 2010 Language Report, Chapter 2: Lexical Structure (2.3 Comments). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch2.html> (accessed 2026-11-01)
8. Haskell 2010 Language Report, Chapter 5: Modules. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch5.html> (accessed 2026-11-01)
9. Haskell 2010 Language Report, Chapter 6: Predefined Types and Classes (6.1.5 The Unit Datatype, 6.1.7 The IO and IOError Types). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch6.html> (accessed 2026-11-01)
10. Haskell 2010 Language Report, Chapter 7: Basic Input/Output. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch7.html> (accessed 2026-11-01)
11. Haskell 2010 Language Report, Chapter 3: Expressions (3.3 Curried Applications and Lambda Abstractions). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch3.html> (accessed 2026-11-01)
12. Haskell Language (home page: features). haskell.org. <https://www.haskell.org/> (accessed 2026-11-01)
13. GHCup: System requirements. haskell.org. <https://www.haskell.org/ghcup/install/reqs/> (accessed 2026-11-01)
