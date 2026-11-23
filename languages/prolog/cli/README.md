# Prolog · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Prolog](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.pl`](hello.pl), with one directive and one rule, run by
**SWI-Prolog**, a free Prolog system [1] whose "syntax and set of built-in
predicates is based on the ISO standard" [2].

Prolog is a **logic** language. The file does not list commands to run in
order. It states a rule, and running the program means asking Prolog to
*prove* a goal from that rule. The text appears as a side effect of that
proof. As in the [Python `cli` version](../../python/cli/), there is no
`build.sh`:
`swipl` reads the source file each time it starts.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| SWI-Prolog (`swipl`) | 10.0.2 (Homebrew `swi-prolog` 10.0.2) | loads `hello.pl` and proves the goal `main` |

The program uses only the built-in `format/1` and the `initialization/2`
directive, so any current SWI-Prolog version should work. Only 10.0.2 was
tested.

On Intel Macs, Homebrew has no pre-built package (bottle) for `swi-prolog`;
the formula page lists bottles only for macOS on Apple Silicon and for
Linux [3]. So `brew install swi-prolog` compiles it from source, which
also needs `cmake` and `pkgconf` [3]. The official site also offers a
macOS disk image with "universal (fat) binaries that run natively on Intel
(x86_64) and Apple Silicon" [4].

## Quick start
```sh
./install.sh   # check / install SWI-Prolog (asks before installing)
./run.sh       # run it
```
There is no `build.sh` (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `swipl --version`. If it is missing, offers `brew install swi-prolog` (macOS), `sudo apt-get install -y swi-prolog-nox` (Debian/Ubuntu), or prints the Windows download link and `winget` command, and runs an install only if you answer `y`. | Prolog code needs a Prolog system to run it. Nothing else is needed. |
| `run.sh` | Runs `swipl hello.pl`. `--verify` does the same (a CLI program ends by itself). | Starting `swipl` with file names is "the normal way to start Prolog": the files "are loaded" [5]. The directive in the file then runs `main`. |

Both scripts accept `SWIPL=<command>` to use another `swipl`, for example
`SWIPL=/Applications/SWI-Prolog.app/Contents/MacOS/swipl ./run.sh` for the
disk image (its "commandline tools" are "in the Contents/MacOS directory"
[4]).

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks / installs SWI-Prolog
├── run.sh        runs swipl hello.pl
└── hello.pl      the program (one directive, one rule, teaching comments)
```
- One `.pl` file is a complete program. SWI-Prolog loads files that have the extension `.pl` or `.prolog` and
  are given on the command line [5]. A "traditional
  Prolog source file contains Prolog clauses and directives, but no module
  declaration" [6]; `hello.pl` is such a file.
- Nothing is written to disk, so nothing needs to be ignored by Git.

## Step-by-step walkthrough
Open [`hello.pl`](hello.pl) next to this list.

1. **Comments** start with `%` and run to the end of the line, like `//`
   in C99, Java, or Go. `/* ... */` also works.
2. **Clauses.** A Prolog file is a list of *clauses*. The SWI-Prolog
   glossary calls a clause the "'Sentence' of a Prolog program", made of a
   *head* and a *body* "separated by the neck operator (`:-`)" [7]. Read
   `:-` as "if". Each clause ends with a full stop `.`.
3. **Facts and rules.** A *fact* is a "Clause without a body", so
   "interpreted as logic, there is no condition to be satisfied" [7]. The
   glossary's example is `person(john).` ("john is a person"). A clause
   with a body is a *rule*: the head is true if the body is true.
   `hello.pl` has no facts and one rule.
4. **The directive `:- initialization(main, main).`** A clause with no
   head, only `:-` and a goal, is a *directive*: "an instruction to the
   compiler", run while the file loads [6]. This one tells SWI-Prolog what
   to do after loading: "the last goal registered using
   `initialization(Goal, main)` is executed as main goal". If it succeeds,
   the program halts "with status 0"; "If Goal fails or raises an
   exception, the process terminates with non-zero exit code" [8]. Without
   the directive, `swipl hello.pl` would load the file and then wait at
   the interactive `?-` prompt for your questions.
5. **The rule `main :- format("Hello, World!~n").`** reads "`main` is true
   if `format("Hello, World!~n")` is true". `main` is a *predicate*: a
   "Collection of clauses with the same functor (name/arity)" [7]. Its
   name is `main` and its arity (number of arguments) is 0, written
   `main/0`. Here the collection has one clause.
6. **The query.** The directive asks the question (the *goal*) `main`. A
   goal is a "Question stated to the Prolog engine"; it "either succeeds
   ... or it fails if Prolog fails to prove it" [7]. To prove `main`,
   Prolog finds the clause whose head matches `main` and proves its body.
   The body is `format/1`, a built-in predicate that will "Write formatted
   output to Output or `current_output`" [9]. `~n` means "Output a newline
   character" [9], like `\n` in C. Proving the goal prints the text; that
   side effect is the purpose of the program.
7. **Unification and backtracking** are the two other parts of Prolog's
   proof engine. This program is too small to need them, but they decide
   how every bigger program runs:
   - To *unify* is to "make two terms equal by assigning variables in one
     term to values at the corresponding location of the other term".
     "Unlike assignment (which does not exist in Prolog), unification is
     not directed" [7]. Matching the goal `main` with the head `main` is a
     (trivial) unification.
   - *Backtracking*: "If a predicate offers multiple clauses to solve a
     goal, they are tried one-by-one until one succeeds". If a later goal
     is not satisfied, Prolog may "reject the previously chosen clause and
     try the next one" [7]. `main/0` has one clause, so there is nothing
     to go back to.

**Try it** (from this folder, any shell):
```sh
swipl -g 'foo(a, B) = foo(A, b), print(A-B), nl' -t halt
swipl -g 'member(X, [red, green, blue]), format("~w~n", [X]), fail ; true' -t halt
```
The first line is the glossary's unification example [7]: it prints
`a-b`, because `=` makes both terms equal in both directions. In the
second, `member/2` is "True if Elem is a member of List" [10], so it has
three answers. `fail` will "Always fail" [11], which forces Prolog to
backtrack into `member/2` for the next answer, so it prints `red`,
`green`, and `blue` on three lines. The manual's way "to prevent the user
from entering interactive mode" is to "start the application with
`-g goal -t halt`" [5]: `-g` runs the goal and `-t halt` exits instead of
opening the `?-` prompt.

### Why there is no build step
SWI-Prolog does compile, but in memory, every time it loads a file. The
glossary says: "SWI-Prolog always compiles your program before executing
it", where compiling is the "Process where a Prolog program is translated
to a sequence of instructions" [7]. Like CPython's bytecode, this needs no
separate command and leaves no file on disk. (SWI-Prolog can also build a
stand-alone executable with `swipl -o output -c prolog-file` [5]; a Hello
World does not need it.)

## Why this toolchain
- **SWI-Prolog** "offers a comprehensive free Prolog environment" and "is
  widely used in research and education as well as commercial
  applications" [1]. Its manual says it "is traditionally strong in
  education because it is free and portable, but also because of its
  compatibility with textbooks and its easy-to-use environment" [2]. This
  suits a repository for learners. It is BSD-2-Clause licensed [3].
- **Standard Prolog.** The language is standardized as ISO/IEC
  13211-1:1995, *Prolog, Part 1: General core*, published 1995-06-01 [12].
  SWI-Prolog's built-in predicates are "based on the ISO standard" [2].
  One part of `hello.pl` is SWI-Prolog's own: the manual marks the
  one-argument `initialization/1` as ISO [6], but not
  `initialization/2` [8]. The `main` option is used anyway because it
  gives the simplest program that runs, prints, and exits.
- **Homebrew** is the package manager this repository uses on macOS. Its
  `swi-prolog` formula was at 10.0.2 on 2026-11-01 [3], the same version as
  the current stable download [4].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | SWI-Prolog 10.0.2 from Homebrew, built from source (no Intel bottle) [3]. |
| macOS Apple Silicon | ⚠️ not verified | `brew install swi-prolog` installs a pre-built bottle [3]. Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `swi-prolog-nox` with apt when `swipl` is missing [13]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs MSYS2 in `C:\msys64` and installs the UCRT64 packages `swi-prolog-core` and `swi-prolog-packages` with `pacman` when `swipl` is missing. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: swipl loads hello.pl and proves the goal 'main', which prints the
         greeting as a side effect; then the program stops.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`. To see the exact bytes:
```text
$ swipl hello.pl | od -c
0000000    H   e   l   l   o   ,       W   o   r   l   d   !  \n
0000016
```

## Sources
1. SWI-Prolog (home page). SWI-Prolog. <https://www.swi-prolog.org/> (accessed 2026-11-01)
2. SWI-Prolog Reference Manual: 1.1 Positioning SWI-Prolog. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=swiprolog> (accessed 2026-11-01)
3. `swi-prolog` formula. Homebrew. <https://formulae.brew.sh/formula/swi-prolog> (accessed 2026-11-01)
4. Download SWI-Prolog stable versions. SWI-Prolog. <https://www.swi-prolog.org/download/stable> (accessed 2026-11-01)
5. SWI-Prolog Reference Manual: 2.4 Command line options. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=cmdline> (accessed 2026-11-01)
6. SWI-Prolog Reference Manual: 4.3 Loading Prolog source files. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=consulting> (accessed 2026-11-01)
7. SWI-Prolog Reference Manual: Glossary of Terms. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=glossary> (accessed 2026-11-01)
8. SWI-Prolog Reference Manual: initialization/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=initialization/2> (accessed 2026-11-01)
9. SWI-Prolog Reference Manual: format/1, format/2, format/3. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=format/1> (accessed 2026-11-01)
10. SWI-Prolog Reference Manual: member/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=member/2> (accessed 2026-11-01)
11. SWI-Prolog Reference Manual: fail/0. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=fail/0> (accessed 2026-11-01)
12. ISO/IEC 13211-1:1995, Information technology - Programming languages - Prolog - Part 1: General core (catalog page). IEC Webstore (ISO/IEC JTC 1/SC 22). <https://webstore.iec.ch/publication/9731> (accessed 2026-11-01)
13. Package `swi-prolog-nox` (trixie). Debian. <https://packages.debian.org/stable/swi-prolog-nox> (accessed 2026-11-01)
14. Installing from PPA (Ubuntu Personal Package Archive). SWI-Prolog. <https://www.swi-prolog.org/build/PPA.html> (accessed 2026-11-01)
15. manifests/s/SWI-Prolog/SWI-Prolog. microsoft/winget-pkgs, GitHub. <https://github.com/microsoft/winget-pkgs/tree/master/manifests/s/SWI-Prolog/SWI-Prolog> (accessed 2026-11-01)
