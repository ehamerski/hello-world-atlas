# Smalltalk · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Smalltalk](../README.md)

## What this is

A command-line program that prints `Hello, World!` to standard output. It uses GNU Smalltalk (gst), the free Smalltalk implementation maintained by the GNU Project.

## Prerequisites

| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| GNU Smalltalk (gst) | 3.2.5 | The Smalltalk interpreter that runs hello.st |

## Quick start

```sh
./install.sh   # check / install GNU Smalltalk (asks before installing)
./run.sh       # run it
```

## Scripts explained

| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for the `gst` command; installs via Homebrew or APT if missing | The GNU Smalltalk interpreter is needed to run hello.st |
| `run.sh` | Runs `gst hello.st` (`--verify` does the same) | Interprets and executes the Smalltalk source |

## Folder structure

```text
cli/
├── README.md      this file
├── install.sh     checks / installs GNU Smalltalk
├── run.sh         runs the program
└── hello.st       the source code
```

Layout reference: [GNU Smalltalk manual](https://www.gnu.org/software/smalltalk/manual/) — a single `.st` file is a complete script.

## Step-by-step walkthrough

1. **`'Hello, World!' displayNl.`** — This single line does everything. In Smalltalk, every value is an object. `'Hello, World!'` is a String literal. `displayNl` is a message sent to the string object. It prints the string to standard output followed by a newline. The period (`.`) terminates the statement. Reference: [GNU Smalltalk manual](https://www.gnu.org/software/smalltalk/manual/).

2. **Comments** — In Smalltalk, double-quoted strings that are not assigned to a variable serve as comments. This is the traditional Smalltalk comment style, used since Smalltalk-80. Unlike most languages, Smalltalk does not have a special comment character; instead, an unassigned string expression is discarded. Reference: [Goldberg and Robson, Smalltalk-80](https://archive.org/details/smalltalk-80).

## Why this toolchain

GNU Smalltalk (gst) is the free implementation of the Smalltalk language, part of the GNU Project. It supports the standard Smalltalk dialect and can run scripts from the command line, making it suitable for cli programs. While commercial Smalltalk implementations (Pharo, VisualWorks, Dolphin) are more feature-rich, GNU Smalltalk is the most accessible option for learning and scripting. Reference: [GNU Smalltalk](https://www.gnu.org/software/smalltalk/).

## Platform notes

| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-06) | GNU Smalltalk 3.2.5, Homebrew `gnu-smalltalk` |
| macOS Apple Silicon | ⚠️ not verified | Homebrew `gnu-smalltalk` provides arm64 builds |
| Linux (Debian/Ubuntu) | ⚠️ not verified | APT package `gnu-smalltalk` |
| Windows (Git Bash / WSL) | ⚠️ not verified | Use WSL or build from source |

## Expected output

```text
Hello, World!
```

## Sources

1. GNU Smalltalk manual. GNU Project. <https://www.gnu.org/software/smalltalk/manual/> (accessed 2026-11-06; archived copy: <https://web.archive.org/web/20250123115149/https://www.gnu.org/software/smalltalk/manual/>, accessed 2026-11-22)
2. GNU Smalltalk. GNU Project. <https://www.gnu.org/software/smalltalk/> (accessed 2026-11-06; archived copy: <https://web.archive.org/web/20261103070437/http://www.gnu.org/software/smalltalk/>, accessed 2026-11-22)
3. Goldberg, A. and Robson, D. Smalltalk-80: The Language and Its Implementation. Addison-Wesley, 1983. <https://archive.org/details/smalltalk-80> (accessed 2026-11-06)
