# Python · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Python](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and a newline,
then exits. The whole program is one line of Python: `print("Hello, World!")`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Python 3 (`python3.14` on macOS, `python3` elsewhere) | 3.14.10 (Homebrew `python@3.14`) | the interpreter that runs `hello.py` |

Any supported Python 3 version works, because this program uses only
`print()`.
The supported versions are listed on the Python Developer's Guide [3].

On macOS the scripts call `python3.14`, not `python3`. Homebrew's
`python@3.14` puts only versioned names on PATH; "Unversioned names such as
`python` ... are installed into `$(brew --prefix python)/libexec/bin`" [10],
and a plain `python3` on macOS is often Apple's older `/usr/bin/python3`.
The python.org installer provides `python3.14` too. Set `PYTHON=python3` (or
any other command) to override this.

## Quick start
```sh
./install.sh   # check / install Python 3 (asks before installing)
./run.sh       # run it
```
There is no `build.sh`. Python is an interpreted language, so you run the
source file directly (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that the interpreter (`python3.14` on macOS, `python3` elsewhere) is on your PATH. If it is missing, it shows the install command for your OS (Homebrew, apt, or the Windows Python install manager) and runs it only if you answer `y`. | The program cannot run without the interpreter. |
| `run.sh` | Runs `python3.14 hello.py` (macOS) or `python3 hello.py`. `--verify` does the same thing, because a cli program ends on its own. | One command to run the program, with an explanation of what happens. |

Both scripts accept `PYTHON=<command>` to use another interpreter, for example
`PYTHON=python ./run.sh` on Windows.

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Python 3
├── run.sh         runs the program
└── hello.py       the program (one line of code plus teaching comments)
```
A single `.py` file is a complete Python program: "the most common use
case is, of course, a simple invocation of a script: `python myscript.py`"
[9]. A project needs more structure
(a `pyproject.toml` and a package folder) only when it is packaged and
distributed, as the Python Packaging User Guide shows [6]. A Hello World
program is not distributed, so it needs none of that.

## Step-by-step walkthrough
Open [`hello.py`](hello.py) next to this list.

1. **Comments.** Lines starting with `#` are comments. The interpreter skips
   them. C, Java, and Go use `//` instead.
2. **No entry point.** Python runs a file from top to bottom. The first line
   of code is where the program starts. C, Java, C#, and Go need a function
   called `main` instead (in Java and C#, it lives inside a class).
3. **No import.** `print` is a built-in function, always available [4]. In
   C you first write `#include <stdio.h>` to use `printf`.
4. **The call.** `print("Hello, World!")` writes the string to standard
   output, then the default line ending `"\n"` [4]. Strings can use
   double or single quotes in Python: `'Hello, World!'` works the same.
5. **No semicolon, no braces.** A line ends the statement. Blocks (which
   this program does not need) are marked by indentation, not `{ }`.

For the other Python versions, see [../README.md](../README.md#comparing-the-categories).

### Why there is no build step
Python is "an interpreted, interactive, object-oriented programming
language" [1]. The Python glossary states that "source files can be run directly without
explicitly creating an executable" [7]. CPython still compiles the source
to *bytecode* first, but it does that automatically every time it runs a
file [7]. A compiled language like C needs a separate `build.sh` that turns
the source into an executable before `run.sh` can start it.

## Why this toolchain
- **CPython** is "the canonical implementation of the Python programming
  language, as distributed on python.org" [7]. It is the interpreter that
  the Homebrew formula and the Windows install manager install [2][8].
- **Python 3.14** is a supported release in "bugfix" status, with end of
  life planned for 2030-10 (Python Developer's Guide, checked 2026-10-30)
  [3]. Python 3.15 was released on 2026-10-09 and is also supported [3].
  This repository is verified with 3.14, the version installed on the dev
  machine. The file `hello.py` runs unchanged on both versions.
- **Homebrew** (macOS) and the **Python install manager** (Windows) are the
  install methods from the official docs [2][8].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Homebrew `python@3.14` 3.14.10. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel (`brew install python@3.14`). |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `sudo apt-get install -y python3`. Most distributions already include it [5]. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Install the Python install manager [8]: `winget install 9NQ7512CXL7T -e --accept-package-agreements --disable-interactivity`, then `py install 3.14`. In Git Bash run `PYTHON=python ./run.sh`. Native (PowerShell / `cmd`): `py hello.py`. WSL behaves like Linux. |

## Expected output
```text
$ python3 hello.py
Hello, World!
```
`./run.sh` prints its explanation first (lines starting with `==>` and
`WHY:`), then the same line.

## Sources
1. General Python FAQ. Python Software Foundation. <https://docs.python.org/3/faq/general.html> (accessed 2026-10-30)
2. python@3.14 formula. Homebrew. <https://formulae.brew.sh/formula/python@3.14> (accessed 2026-10-30)
3. Status of Python versions. Python Developer's Guide. <https://devguide.python.org/versions/> (accessed 2026-10-30)
4. Built-in Functions: print(). Python Software Foundation. <https://docs.python.org/3/library/functions.html#print> (accessed 2026-10-30)
5. Using Python on Unix platforms. Python Software Foundation. <https://docs.python.org/3/using/unix.html> (accessed 2026-10-30)
6. Packaging Python Projects. Python Packaging Authority. <https://packaging.python.org/en/latest/tutorials/packaging-projects/> (accessed 2026-10-30)
7. Glossary: bytecode, interpreted. Python Software Foundation. <https://docs.python.org/3/glossary.html> (accessed 2026-10-30)
8. Using Python on Windows. Python Software Foundation. <https://docs.python.org/3/using/windows.html> (accessed 2026-10-30)
9. Command line and environment. Python Software Foundation. <https://docs.python.org/3/using/cmdline.html> (accessed 2026-10-30)
10. Language Runtimes and Packages. Homebrew. <https://docs.brew.sh/Language-Runtimes-and-Packages> (accessed 2026-10-31)
