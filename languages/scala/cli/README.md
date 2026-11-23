# Scala · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Scala](../README.md)

## What this is
A console program, written in Scala 3, that prints one line: `Hello, World!`.
The Scala compiler, `scalac`, translates it into Java Virtual Machine (JVM)
bytecode, and the `scala` command runs it on the JVM [1][7].

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (`java`) | Eclipse Temurin 21.0.8 | Scala 3.8 and newer need JDK 17 or newer [3] |
| Scala 3 (`scalac`, `scala`) | 3.10.1, unpacked into `~/.local/scala3-3.10.1-x86_64-apple-darwin` | compiles and runs the program [4][5] |
| `curl`, `shasum`, `tar` | macOS system tools | download, check, and unpack the Scala archive (only if Scala is missing) |

## Quick start
```sh
./install.sh   # check the JDK and Scala (asks before installing)
./build.sh     # compile hello.scala into build/
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for JDK 17 or newer. Checks for `scalac`. If Scala is missing, downloads the official archive, checks its SHA-256 checksum, and unpacks it into `~/.local`. It asks before each download or install and never uses `sudo` itself. If no JDK is found, it shows the Homebrew command for Temurin 21 and asks first | Scala runs on the JVM and needs a compiler |
| `scala-env.sh` | Sets the Scala version, the archive checksum, and the install folder, and puts `scalac` and `scala` on `PATH` (sourced, not run) | shared by all three scripts, so they find Scala without your shell `PATH` |
| `build.sh` | Creates `build/` and runs `scalac -d build hello.scala` | the JVM runs bytecode, not Scala source |
| `run.sh` | Runs `scala run --main-class hello --classpath build`. `--verify` runs the same command and exits | `verify-all.sh` needs a command that prints `Hello, World!` and exits |

## Folder structure
```text
cli/
├── README.md       this file
├── install.sh      checks the JDK, checks or installs Scala
├── scala-env.sh    version, checksum, install folder, PATH (sourced)
├── build.sh        scalac -d build hello.scala
├── run.sh          scala run --main-class hello --classpath build
├── hello.scala     the program
├── build/          class files written by build.sh, ignored by git
└── .gitignore      ignores build/, .bsp/, and .scala-build/
```
`scala run` creates `.bsp/` and `.scala-build/` in the current folder. Git
ignores both.

## Step-by-step walkthrough
`hello.scala` in order:

1. **`@main`** is a Scala 3 annotation. It turns the method that follows
   into the entry point of the program [2].
2. **`def hello(): Unit =`** defines a method named `hello`. `Unit` is the
   return type that means "no useful value", like `void` in Java. The `=`
   starts the method body.
3. **`println("Hello, World!")`** prints the text and a line break. It needs
   no import and no `System.out`.
4. The body is the indented line. Scala 3 reads the indentation, so the
   program needs no braces and no semicolon.

Differences from other languages in this repository:

- In Scala 2, the entry point was an `object` with a `main` method, or an
  `object` that extended `App`. Scala 3 replaces the `App` approach with
  `@main` [2]. This program is a top-level method and has no class or object.
- The annotated method needs no class around it. The compiler writes a class
  named `hello` for it, and `run.sh` uses that name in `--main-class hello`.

See the comparison of languages in [docs/comparisons.md](../../../docs/comparisons.md).

## Why this toolchain
- Scala 3.10.1 is a release of Scala 3 that the Scala project published on
  2026-11-11 [5]. Scala code runs on the JVM [7].
- The Scala documentation recommends the Coursier installer (`cs setup`) for
  a full setup [4]. This folder uses the official release archive instead.
  It is a plain file, needs no installer, and has a checksum that GitHub
  shows next to the download [5].
- `scalac` is the compiler and `scala` is the runner [4]. The `scala`
  command is Scala CLI, which runs compiled classes with `run` [6].
- The `-d` option sets the output folder [8]. With Scala 3.10.1, the folder
  must exist: without `build/`, `scalac` prints that it "does not exist or
  is not a directory or .jar file". `build.sh` creates it.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-20) | Scala 3.10.1, Eclipse Temurin 21.0.8; `install.sh`, `build.sh`, `run.sh`, and `run.sh --verify` run from a clean shell |
| macOS Apple Silicon | ⚠️ not verified | `scala-env.sh` lists the `aarch64-apple-darwin` archive and its digest from the release page [5]; not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `scala-env.sh` lists the Linux archives and their digests [5]; `install.sh` shows `sudo apt-get install -y openjdk-21-jdk` and asks first; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | the release has a Windows archive, and the Scala documentation offers an installer for Windows [4]; not run |

## Expected output
Run `./run.sh` after `./build.sh`. The program prints one line and exits with
status 0:

```text
Hello, World!
```
`./run.sh` also prints its own step lines before the program output.

## Sources
1. Hello, World! Scala 3 Book. Scala project. <https://docs.scala-lang.org/scala3/book/taste-hello-world.html> (accessed 2026-11-11)
2. Main methods in Scala 3. Scala 3 Book. Scala project. <https://docs.scala-lang.org/scala3/book/methods-main-methods.html> (accessed 2026-11-11)
3. JDK compatibility. Scala documentation. Scala project. <https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html> (accessed 2026-11-11)
4. Getting started with Scala 3. Scala documentation. Scala project. <https://docs.scala-lang.org/getting-started/install-scala.html> (accessed 2026-11-11)
5. Release 3.10.1. scala/scala3. GitHub. <https://github.com/scala/scala3/releases/tag/3.10.1> (accessed 2026-11-20)
6. `run` command. Scala CLI documentation. VirtusLab. <https://scala-cli.virtuslab.org/docs/commands/run/> (accessed 2026-11-11)
7. Scala 3 Book, "Scala features". Scala project. <https://docs.scala-lang.org/scala3/book/scala-features.html> (accessed 2026-11-11)
8. Compiler options. Scala 3 migration guide. Scala project. <https://docs.scala-lang.org/scala3/guides/migration/compiler-options.html> (accessed 2026-11-11)
