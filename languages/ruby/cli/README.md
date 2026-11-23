# Ruby · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Ruby](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and a newline,
then exits. The program is one statement: `puts "Hello, World!"`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Ruby (`ruby`) | 4.0.7 (Homebrew `ruby`) | the interpreter that runs `hello.rb` |

This program uses only `puts`, so any Ruby version runs it. Set
`RUBY=/path/to/ruby` to use another interpreter, for example a second Ruby
version.

## Quick start
```sh
./install.sh   # check / install Ruby (asks before installing)
./run.sh       # run it
```
There is no `build.sh`. Ruby is an interpreted language, so you run the
source file directly (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `ruby` is on your `PATH` and prints its version. If it is missing, it shows the install command for your operating system (Homebrew, apt, or RubyInstaller on Windows) and runs it only if you answer `y`. | The program cannot run without the interpreter. |
| `run.sh` | Runs `ruby hello.rb`. `--verify` does the same thing, because a cli program ends on its own. | One command for students, with an explanation of what happens. |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Ruby
├── run.sh         runs the program
└── hello.rb       the program (one statement plus teaching comments)
```
A single `.rb` file is a complete Ruby program. A project needs a `Gemfile` only when it uses third-party libraries
(gems); this program uses none (the [web](../web/README.md) version does).

## Step-by-step walkthrough
Open [`hello.rb`](hello.rb) next to this list.

1. **Comments.** A line that starts with `#` is a comment. Python and Perl
   use the same symbol; C, Java, and Go use `//`.
2. **No entry point.** Ruby runs the file from top to bottom. C, Java, C#,
   and Go need a `main` function instead.
3. **`puts`** is a method that every Ruby object can call. `Kernel#puts`
   is documented as "Equivalent to `$stdout.puts(objects)`" [2], so it
   writes to standard output. `IO#puts` "Writes a newline after each that
   does not already end with a newline sequence" [3]. Unlike C's `printf`,
   the newline needs no `\n`; like Java's `println`, it is added for you.
4. **No import.** `puts` is always available, so nothing has to be loaded
   first. C needs `#include <stdio.h>` for `printf`.
5. **The string** `"Hello, World!"` is in double quotes.
6. **No parentheses and no semicolon.** "In many cases, parenthesis are
   not necessary when sending a message" [5], and a line break ends the
   statement. Python 3 requires parentheses for `print("...")`.

Compare with the other categories in [../README.md](../README.md#comparing-the-categories).

### Why there is no build step
`ruby hello.rb` reads the source and runs it. Internally, the reference
implementation still compiles the code to instructions for its virtual
machine: the `InstructionSequence` class "represents a compiled sequence of
instructions for the Virtual Machine used in MRI" [4]. This happens
automatically each time, so there is no separate compile step to run. A
compiled language like C needs a `build.sh` that makes an executable
before `run.sh` can start it.

## Why this toolchain
- **The `ruby` command** is the interpreter of the Ruby project
  (ruby-lang.org). The project's installation page says that "Ruby
  versions 2.0 and above are included by default in macOS releases since
  at least El Capitan (10.11)", and warns that "It is possible that major
  package managers will install older Ruby versions instead of the latest
  release" [1]. For that reason `install.sh` uses Homebrew, whose formula
  carries a current release [6].
- **Homebrew** (macOS) is the install method the Ruby installation page
  lists for macOS: `brew install ruby` [1]. Linux uses the distribution's
  packages [1]; Windows uses RubyInstaller [1].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Homebrew `ruby` 4.0.7. |
| macOS Apple Silicon | ⚠️ not verified | Same command as Intel (`brew install ruby`). |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `ruby-full` with apt when `ruby` is missing [1]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` uses the Ruby already on PATH. If `ruby` is missing, it installs the MSYS2 Ruby 4.0 package with `pacman` (MSYS2 is pre-installed in `C:\msys64`). WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ruby hello.rb
Hello, World!
```
`./run.sh` prints its explanation first (lines starting with `==>` and
indented `WHY:` lines), then the program's output:
```text
==> Run the program
    WHY: 'ruby hello.rb' starts the interpreter, which runs the file top to bottom.
Hello, World!
```

## Sources
1. Installing Ruby. Ruby community. <https://www.ruby-lang.org/en/documentation/installation/> (accessed 2026-11-04)
2. Kernel#puts. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/Kernel.html#method-i-puts> (accessed 2026-11-04)
3. IO#puts. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/IO.html#method-i-puts> (accessed 2026-11-04)
4. RubyVM::InstructionSequence. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/RubyVM/InstructionSequence.html> (accessed 2026-11-04)
5. Calling methods. Ruby documentation (master). <https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html> (accessed 2026-11-04)
6. ruby (Homebrew formula). Homebrew. <https://formulae.brew.sh/formula/ruby> (accessed 2026-11-04)
