# Perl · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Perl](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and a newline,
then exits. The program is one statement of Perl, plus the two "safety net"
lines that Perl's own tutorial recommends at the top of every program [1].

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Perl 5 (`perl`) | 5.34.1 (the `/usr/bin/perl` that comes with macOS) | the interpreter that runs `hello.pl` |

The program uses only `print` and two pragmas, so any Perl 5 should run
it (verified here only with 5.34.1). The perl.org download page says: "Mac OS X
already has Perl installed", and for other Unix-like systems "You may
already have perl installed" [2]. Windows "does not have Perl installed by
default" [2].

## Quick start
```sh
./install.sh   # check / install Perl (asks before installing)
./run.sh       # run it
```
There is no `build.sh`. Perl is run straight from the source file (see
[Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `perl` is on your PATH and prints its version. If it is missing, it shows the install command for your OS (Homebrew, apt, or Strawberry Perl on Windows) and runs it only if you answer `y`. | The program cannot run without the interpreter. On macOS there is normally nothing to install [2]. |
| `run.sh` | Runs `perl hello.pl`. `--verify` does the same thing, because a cli program ends on its own. | One command to run the program, with an explanation of what happens. |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs the Perl interpreter
├── run.sh         runs the program
└── hello.pl       the program
```
A Perl program is a plain text file, usually with the extension `.pl`. The
tutorial shows how to run it: `perl progname.pl` [1]. A single script needs no
other layout. Programs with dependencies use a project-local library folder,
as in [../web](../web/README.md).

## Step-by-step walkthrough
Open [`hello.pl`](hello.pl) next to this list.

1. **`use strict;`** switches on a restriction: it "disables certain Perl
   expressions that could behave unexpectedly or are difficult to debug,
   turning them into errors" [3].
2. **`use warnings;`** asks Perl to print a message when code looks like a
   mistake. The tutorial says "Perl by default is very forgiving", and
   recommends starting "every program" with both lines, because "they check
   different things so you need both" [1][4].
3. **`print "Hello, World!\n";`** writes the text to standard output. `print`
   "prints a string or a list of strings" [5]. It adds a newline only if
   the special variable `$\` is set, and by default it is not [5], so the
   program writes `\n` itself, as C's `printf` does. Python's `print()` and
   Ruby's `puts` add the newline for you.
4. **The semicolon** ends the statement, as in C and Java. Perl has no
   `main` function: the statements of the file run in order. Compare with
   the other languages in [../../../docs/comparisons.md](../../../docs/comparisons.md).

### Why there is no build step
`perl` reads the source and runs it. Perl does "compile the entire program
to an internal form" first, and if there are compilation errors, "execution
of the program is not attempted" [6]. That happens inside every run, in
memory, so you never run a separate compile command. A compiled language
like C needs a separate `build.sh` that produces an executable before
`run.sh` can start it.

## Why this toolchain
- **The `perl` that is already on your computer.** The macOS system Perl
  (5.34.1 on the development machine) needs no installation [2]. This keeps the
  first program free of extra downloads. The [web](../web/README.md) version
  also runs on it.
- **Homebrew** (`brew install perl`) installs a current Perl (5.44.0 in the
  formula checked on 2026-11-04) [7] and **apt** (`sudo apt-get install perl`) installs
  Debian's (5.40.1 in Debian 13 "trixie") [8]. perl.org recommends **Strawberry
  Perl** for Windows [2].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | The system `/usr/bin/perl`, version 5.34.1 (`perl -v`). |
| macOS Apple Silicon | ⚠️ not verified | Same: macOS includes Perl [2]. `brew install perl` for a newer one [7]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `perl` with apt when it is missing [8]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. Git Bash comes with a Perl, so `install.sh` finds it. If `perl` is missing, it prints the Strawberry Perl steps [2] and stops. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ perl hello.pl
Hello, World!
```
`./run.sh` prints its explanation first (lines starting with `==>` and
`WHY:`), then the same line.

## Sources
1. perlintro: a brief introduction and overview of Perl. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlintro> (accessed 2026-11-04)
2. Perl Download. perl.org. <https://www.perl.org/get.html> (accessed 2026-11-04)
3. strict: Perl pragma to restrict unsafe constructs. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/strict> (accessed 2026-11-04)
4. warnings: Perl pragma to control optional warnings. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/warnings> (accessed 2026-11-04)
5. print. Perl 5 porters, perldoc.perl.org (perlfunc). <https://perldoc.perl.org/functions/print> (accessed 2026-11-04)
6. perlrun: how to execute the Perl interpreter. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlrun> (accessed 2026-11-04)
7. perl formula. Homebrew. <https://formulae.brew.sh/formula/perl> (accessed 2026-11-04)
8. Package perl (trixie). Debian. <https://packages.debian.org/stable/perl> (accessed 2026-11-04)
