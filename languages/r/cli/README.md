# R · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [R](../README.md)

## What this is
A command-line program, written in R, that prints one line: `Hello, World!`.
R is interpreted [1]: there is no compile step. The command `Rscript` reads
`hello.R`, evaluates it, and exits [2]. It differs from the `R` command, which
starts an interactive session with a prompt [3]. The interactive `R` also
prints a version banner when it starts; `Rscript` prints none, so the output
is exactly one line.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| R (`Rscript`) | 4.6.2 (Homebrew formula `r`, built from source) | runs `hello.R` |
| Homebrew | any recent version | installs `r` (only if `Rscript` is missing) |

Homebrew checks the SHA-256 of the source archive before it builds. For
version 4.6.2 the formula lists
`c297040f6392b1dac6e5c0eb398422cfdaedf540ae2205edb9ad0d10cb10ee00` for
`R-4.6.2.tar.gz` [4]. The formula lists no bottle for macOS Intel, so
`brew install r` compiles R on your machine and also installs the formula's
dependencies, which include the GNU compiler collection [4]. The build takes
several minutes.

## Quick start
```sh
./install.sh   # check / install Rscript (asks before running brew install r)
./run.sh       # run it
```
R has no build step, so there is no `build.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `Rscript` is installed and is version 4.6.2. If not, offers `brew install r` | R needs its interpreter. `r-env.sh` pins the version and finds Homebrew's folder, so no shell setup is needed |
| `run.sh` | Runs `Rscript hello.R`. `--verify` runs the same check and exits by itself | `Rscript` runs a file non-interactively [2]; `verify-all.sh` needs a command that prints `Hello, World!` and exits |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Rscript (Homebrew formula r)
├── r-env.sh       pinned version, source SHA-256, Homebrew path (sourced)
├── run.sh         runs hello.R
└── hello.R        the program (one expression)
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).
R scripts are plain text files that `Rscript` runs [2].

## Step-by-step walkthrough
1. **Comments** start with `#` and run to the end of the line.
2. **No `main` function.** `Rscript` evaluates the expressions of the file from
   top to bottom [2].
3. **`writeLines("Hello, World!")`** writes the elements of a character vector
   to standard output. By default it writes the separator `"\n"` after each
   line of text [5]. The one string passed here is one line, so the program
   prints the text and a newline.
4. **Other ways to print.** `cat("Hello, World!\n")` writes the text as given
   [6], so you add the newline yourself. `print("Hello, World!")` shows the
   value as the console does, with the quotes and a `[1]` prefix, as running
   `Rscript -e 'print("Hello, World!")'` shows.

Differences from other languages: no `main`, no semicolons, no compile step.
Compare [Python](../../python/README.md) and [Ruby](../../ruby/README.md), the
other interpreted languages here.

The difference between the two commands:

| Command | What it does | Source |
|---|---|---|
| `R` | starts an interactive session and issues a prompt | [3] |
| `Rscript` | a front end for scripts: runs a file non-interactively and exits | [2] |

## Why this toolchain
- The R manual describes `Rscript` as an alternative front end to
  `R CMD BATCH` for running a file with arguments. `Rscript` writes R output to
  standard output and standard error, so the shell can redirect it [2]. That
  suits a program that prints one line.
- The Homebrew formula `r` packages version 4.6.2 (license
  GPL-2.0-or-later) [4]. The R manuals for 4.6.2 are dated 2026-10-29 [7].
- CRAN also offers an installer for Windows [8]. This folder uses
  Homebrew because it checks the SHA-256 of the source archive [4].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-11) | R 4.6.2 from the Homebrew formula; `install.sh` and `run.sh --verify` run from a clean shell (`env -i`) |
| macOS Apple Silicon | ⚠️ not verified | Homebrew lists a bottle for Apple Silicon [4]; the scripts were not run there |
| Linux (Debian/Ubuntu) | ⚠️ not verified | the scripts use Homebrew on Linux; not run there |
| Windows (Git Bash / WSL) | ⚠️ not verified | not run; CRAN provides a Windows installer [8] |

## Expected output
Run this command in this folder:
```sh
./run.sh
```
It prints one line after its step messages and exits with status 0:
```text
==> Run the program
    WHY: 'Rscript hello.R' starts R without a session and evaluates the file.
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. R FAQ, section 2.1 "What is R?". Kurt Hornik and the R Core Team. CRAN. <https://cran.r-project.org/doc/FAQ/R-FAQ.html> (accessed 2026-11-11)
2. An Introduction to R, appendix B, section B.4 "Scripting with R". R Core Team. CRAN. <https://cran.r-project.org/doc/manuals/r-release/R-intro.html> (accessed 2026-11-11)
3. An Introduction to R, section 1.5 "Using R interactively". R Core Team. CRAN. <https://cran.r-project.org/doc/manuals/r-release/R-intro.html> (accessed 2026-11-11)
4. Homebrew formula `r` (version 4.6.2, source SHA-256, bottles, dependencies). Homebrew. <https://formulae.brew.sh/formula/r> (accessed 2026-11-11)
5. `writeLines`: Write Lines to a Connection. R documentation, package base. R Core Team. <https://stat.ethz.ch/R-manual/R-patched/library/base/html/writeLines.html> (accessed 2026-11-11)
6. `cat`: Concatenate and Print. R documentation, package base. R Core Team. <https://stat.ethz.ch/R-manual/R-patched/library/base/html/cat.html> (accessed 2026-11-11)
7. R Installation and Administration, for R 4.6.2 (2026-10-29). R Core Team. CRAN. <https://cran.r-project.org/doc/manuals/r-release/R-admin.html> (accessed 2026-11-11)
8. Download R-4.6.2 for Windows. CRAN. <https://cran.r-project.org/bin/windows/base/> (accessed 2026-11-11)
