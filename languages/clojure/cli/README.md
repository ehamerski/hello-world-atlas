# Clojure · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Clojure](../README.md)

## What this is
A command-line program that prints `Hello, World!` and ends. It is one
function, `-main`, in one namespace, `hello.core`. The Clojure CLI starts a
Java Virtual Machine (JVM), loads the namespace, compiles it to bytecode in
memory, and calls `-main`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Java runtime 21 or newer | Eclipse Temurin 21.0.8 | Clojure "is always compiled (on the JVM, to Java bytecode)" [1], so a JVM runs it. Clojure itself needs Java 8 or newer; this repository tests with Java 21 [2]. |
| Clojure CLI (`clojure`, `clj`) | 1.12.6.1673 | reads `deps.edn`, downloads libraries, builds the classpath, and starts the JVM [3] |
| Clojure (the language, a JAR file) | 1.12.6 | the compiler and the standard library; the CLI downloads it from Maven Central on first use [2][4] |

The Clojure CLI has a four-part version and the language a three-part
version. "The leading 3 parts of the CLI version indicate which version of
the Clojure language will be used by default" [4].

## Quick start
```sh
./install.sh   # check / install Java and the Clojure CLI (asks before installing)
./run.sh       # run it (there is no build.sh)
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks that `java` is version 21 or newer. 2. Checks that `clojure` is on `PATH`; if not, offers to install the Clojure CLI 1.12.6.1673 into `~/.local/clojure-1.12.6` with the official POSIX installer (no `sudo`). 3. Runs `clojure -P` after asking, unless `.cpcache/` already holds the classpath. | Java runs the bytecode and the CLI starts it. With `-P`, the CLI does "a full deps expansion, download deps, and cache the classpath, but not actually execute the function, tool, main, etc." [5]. `./run.sh` then starts without a download. |
| `run.sh` | Runs `clojure -M -m hello.core`. `--verify` does the same: a cli program has nothing else to check. | `-M` runs `clojure.main` and `-m` names a namespace "with a -main function" [5]. |
| `clojure-env.sh` | Sets the CLI version, the installer checksum and `CLOJURE_DIR`, and puts `$CLOJURE_DIR/bin` on `PATH`. `install.sh` and `run.sh` source it. | One place for the toolchain settings. It is identical in [../desktop](../desktop/) and [../web](../web/), so each folder stays independent. |

### Why there is no build.sh
The rule of this repository is that a language that is compiled gets a
`build.sh`. Clojure is compiled, but the compiler runs when the program
loads, not as a separate step:

- "Clojure compiles all code you load on-the-fly into JVM bytecode, but
  sometimes it is advantageous to compile ahead-of-time (AOT)" [6]. The
  Clojure reference lists the reasons for AOT: to deliver an application
  without source, to speed up startup, to generate named classes for Java,
  and to create an application that does not need runtime bytecode
  generation and custom class loaders [6]. A Hello World needs none of them.
- The author states that "there is no interpreter" and that Clojure is
  "always compiled" to Java bytecode on the JVM [1]. This is why the
  program runs straight from source with `clojure -M -m hello.core`: that
  command is the whole "build and run", and `.clj` files are the only
  input.
- The CLI covers the other job of a build tool, dependency download, with
  `clojure -P`, which `install.sh` runs. Packaging into one JAR file
  ("uberjar") with `tools.build` is the AOT route [6]. This repository does
  not take it, because it would add a library, a build alias, and a
  `build.sh` that produces output the program does not need to run.

The same choice applies to [../desktop](../desktop/) and
[../web](../web/). Compare [Java](../../java/cli/README.md), where `javac`
must run before `java`, and [Python](../../python/cli/README.md), which has
no `build.sh` either.

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / installs Java and the Clojure CLI
├── run.sh           runs the program
├── clojure-env.sh   toolchain settings, sourced by the scripts
├── deps.edn         project file: source folders and dependencies
├── .gitignore       ignores .cpcache/ (the CLI's classpath cache)
└── src/
    └── hello/
        └── core.clj   the program: namespace hello.core
```
- `deps.edn` is the project file of the Clojure CLI. It holds `:paths`, the
  folders with source code, and `:deps`, the libraries [3][7]. The file
  lists `:paths` explicitly, although `["src"]` is also the value in the
  CLI's own `deps.edn`.
- The namespace `hello.core` is the file `src/hello/core.clj`: dots in the
  name become folders. The CLI puts `src` on the classpath, so the loader
  finds the file there.
- `.cpcache/` is created by the CLI in the project folder and holds the
  computed classpath. It is not committed.

Layout reference: <https://clojure.org/reference/deps_and_cli>

## Step-by-step walkthrough
Open [`core.clj`](src/hello/core.clj) next to this list.

1. **`(ns hello.core)`** declares the namespace. Namespaces are Clojure's
   modules. In Java a package name must match a folder, and a class must
   match a file; here the file holds as many functions as you like. Common
   Lisp has packages, but they are not tied to files.
2. **Everything is a list.** `(defn -main ...)` is a list whose first item
   is the operator. This is the Lisp inheritance: Clojure "is a dialect of
   Lisp" [8], and in Lisps "code is data" [8], so the program is written in
   the same lists that it manipulates. Common Lisp writes the same thing as
   `(defun main () (format t "Hello, World!~%"))`.
3. **`defn`** defines a function: a name, a parameter vector in square
   brackets, and a body. `-main` is only a convention: the `-m` option looks
   for a function with that name [5].
4. **`& args`** collects the command-line arguments in a sequence. The
   program ignores them. Java's `main` makes you write `String[] args` and
   a class even when no argument is used.
5. **`(println "Hello, World!")`** prints the string and a newline. A
   function call has the form `(function argument ...)`: the parenthesis
   opens before the function name. There is no semicolon; in Clojure a
   `;` starts a comment, as in Common Lisp.
6. **The result.** Every expression has a value. The value of the last
   expression in a body is the value of the function; `println` returns
   `nil`.
7. **What runs.** `clojure -M -m hello.core` starts a JVM with `clojure.main`,
   which loads `hello.core`. The compiler turns each form into bytecode,
   "there is no interpreter" [1], and `-main` is called. When `-main`
   returns, the JVM ends, because no other thread is running.

See the [language overview](../README.md#comparing-the-categories) and
[docs/comparisons.md](../../../docs/comparisons.md) for this program next to
the other languages.

## Why this toolchain
- **The Clojure CLI is the official way to run Clojure.** The Getting
  Started guide of clojure.org installs it: the CLI "can download Clojure
  itself and other Clojure or JVM-based libraries" [4]. Leiningen, an older
  build tool, is not used here.
- **The official POSIX installer, with a checksum.** The guide documents
  `posix-install.sh` for Linux, BSD, and macOS, and its `--prefix` option
  [4]. `install.sh` runs the versioned installer from the
  `clojure/brew-install` release 1.12.6.1673 [9], checks its SHA-256 first,
  and installs into your home folder, so no `sudo` is needed. The installer
  then checks the checksum of the tools archive it downloads. The guide
  warns that on macOS this installer "will conflict with brew" [4]. If you
  already use Homebrew's `clojure/tools/clojure`, `install.sh` finds that
  `clojure` on `PATH` and installs nothing.
- **Java 21.** clojure.org lists Java 8 as the minimum and recommends the
  newest long-term support release; its Install guide says Clojure
  "officially supports Java LTS releases (currently Java 8, 11, 17, 21, and
  25)" [2][4]. Java 21 is the version used in the other JVM folders of this
  repository.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Temurin 21.0.8, Clojure CLI 1.12.6.1673 (Clojure 1.12.6), installed by the official POSIX installer into `~/.local/clojure-1.12.6`. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. The installer is a shell script and the libraries are JVM bytecode, so only the Java runtime is specific to the CPU. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `openjdk-21-jdk` with apt when no Java 21 is found. If `clojure` is missing, it downloads the official POSIX installer, checks its SHA-256 checksum, and installs the CLI into `~/.local/clojure-1.12.6` without sudo [4]. Then it runs `clojure -P`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` puts the JDK from `JAVA_HOME_21_X64` on PATH when that variable is set. It does not install a JDK: if Java 21 is missing it prints the `winget` Temurin 21 command and stops. If `clojure` is missing, it downloads the `clj-msi` installer, checks its SHA-256 checksum, and installs it silently into `~/.local/clojure-1.12.6` [4]. Then it runs `clojure -P`. WSL not verified; it behaves like Linux. |

Homebrew (`brew install clojure/tools/clojure`) is the documented macOS
alternative [4]. It was not run for this folder.

## Expected output
`./run.sh` prints:
```text
Hello, World!
```
`./run.sh --verify` (the same program) printed, on 2026-11-04:
```text
==> Run the program
    WHY: 'clojure -M -m hello.core' loads hello.core and calls its -main function.
Hello, World!
```

## Sources
1. A History of Clojure, section 3.5.10 "Implementation Benefits". Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, Article 71, 2020 (author's PDF, Internet Archive copy of download.clojure.org). <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (accessed 2026-11-04)
2. Clojure Downloads (stable release 1.12.6; "Recommended: Java 25 (LTS releases are supported)", "Minimum: Java 8"). clojure.org. <https://clojure.org/releases/downloads> (accessed 2026-11-04)
3. Clojure CLI Reference. clojure.org. <https://clojure.org/reference/clojure_cli> (accessed 2026-11-04)
4. Install Clojure. clojure.org. <https://clojure.org/guides/install_clojure> (accessed 2026-11-04)
5. Clojure CLI Reference, "Run a main namespace or script (-M)" and option -P. clojure.org. <https://clojure.org/reference/clojure_cli> (accessed 2026-11-04)
6. Ahead-of-time Compilation and Class Generation. clojure.org. <https://clojure.org/reference/compilation> (accessed 2026-11-04)
7. Deps and CLI Reference. clojure.org. <https://clojure.org/reference/deps_and_cli> (accessed 2026-11-04)
8. A History of Clojure, abstract and section 3.1 "Clojure, the Lisp". Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, 2020. <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (accessed 2026-11-04)
9. clojure/brew-install release 1.12.6.1673 (contains `posix-install.sh`). Clojure core team, GitHub. <https://github.com/clojure/brew-install/releases/tag/1.12.6.1673> (accessed 2026-11-04)
