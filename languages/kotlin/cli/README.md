# Kotlin · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Kotlin](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one top-level function, `main`, in the file `hello.kt`. Like the
[Java cli](../../java/cli/), it must be **compiled** before it can run, so
this folder has a `build.sh`. The Kotlin compiler produces bytecode for the
Java Virtual Machine (JVM) [1][2], so the result runs with the same `java`
launcher as a Java program.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (Java Development Kit) 21 or newer | Eclipse Temurin 21.0.8 | the compiler `kotlinc` runs on the JVM, and `java -jar` runs the program |
| `kotlinc`, the Kotlin compiler | 2.4.21 (released 2026-10-08 [3]) | compiles `hello.kt` into a jar file |
| curl, `unzip` | system versions | only for `./install.sh`, which downloads and unpacks the compiler |

The official command-line guide says to download "the latest version
(`kotlin-compiler-2.4.21.zip`) from GitHub Releases" and to unzip "the
standalone compiler into a directory" [2]. `./install.sh` does exactly that,
into `~/.local/kotlinc-2.4.21`.

## Quick start
```sh
./install.sh   # check / install the JDK and the Kotlin compiler (asks before installing)
./build.sh     # compile into build/hello.jar
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks that `java` is version 21 or newer. 2. Checks that `kotlinc` is on `PATH`. If one is missing, it shows the install command and runs it only if you answer `y`. For `kotlinc` it downloads the official zip, checks its SHA-256 checksum and unpacks it into `~/.local/kotlinc-2.4.21`. | The compiler is a separate program from the JDK. A checksum proves that the downloaded file is the file that was published. No administrator password is needed. |
| `kotlinc-env.sh` | Not run, only sourced by the other scripts: it sets the version, the checksum and the install folder, and puts the compiler's `bin` folder on `PATH`. | `install.sh` and `build.sh` must agree on where the compiler is. |
| `build.sh` | Runs `kotlinc hello.kt -include-runtime -d build/hello.jar`. | `-d` "indicates the output path for generated class files, which may be either a directory or a .jar file", and `-include-runtime` "makes the resulting .jar file self-contained and runnable by including the Kotlin runtime library in it" [2]. |
| `run.sh` | Runs `java -jar build/hello.jar`. `--verify` does the same, because a cli program already ends by itself. | The JVM loads the bytecode from the jar and calls `main` [2]. |

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / installs the JDK and the Kotlin compiler
├── kotlinc-env.sh   compiler version, checksum and folder (sourced, not run)
├── build.sh         compiles hello.kt into build/hello.jar
├── run.sh           runs the jar
├── hello.kt         the whole program
├── .gitignore       keeps build/ out of the repository
└── build/           created by build.sh; not committed
    └── hello.jar
```
A single file needs no project layout. The other Kotlin folders use the
build tool Gradle instead: see [../desktop](../desktop/) and [../web](../web/).

## Step-by-step walkthrough
Open [`hello.kt`](hello.kt) next to this list. The official command-line
guide shows the same program: `fun main() { println("Hello, World!") }` [2].

1. **`fun main()`** declares a function (`fun`) named `main`. Kotlin starts
   the program at a top-level function with this name. There is no class
   around it, no `public` and no `static`. The compiler puts the function
   into a class named `HelloKt`, after the file name, and writes that class
   into the jar. [Java](../../java/cli/README.md#step-by-step-walkthrough)
   needs a class, `public static void main(String[] args)`, and a file named
   after the class.
2. **No return type and no parameter.** A function that returns nothing
   needs no return type in Kotlin, and the parameter that holds the
   command-line arguments may be left out when the program does not read
   them.
3. **`println("Hello, World!")`** prints the text and a line break. It is a
   function of the Kotlin standard library, so it needs no import and no
   `System.out`. Compare Python's `print` in the
   [Python cli](../../python/cli/).
4. **No semicolon.** A line break ends the statement. This differs from
   Java, C, C++ and C#.
5. **`build.sh`** is a compile step, as in Java, Pascal and C. With
   `-include-runtime`, `kotlinc` also copies the Kotlin runtime library into
   the jar, so that the jar runs alone [2].

## Why this toolchain
- **`kotlinc` is the reference compiler** from JetBrains, the company that
  develops Kotlin [1]. The official command-line guide uses it for this exact
  program [2].
- **Version 2.4.21** is the newest release listed on the Kotlin releases
  page (2026-10-08) [3].
- **The same JDK 21** as the [Java folders](../../java/README.md), so a
  reader needs one Java installation for both languages.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Temurin 21.0.8, `kotlinc` 2.4.21 (JRE 21.0.8). The compiler zip is downloaded once and cached in `~/.cache/hello-world-kotlin`. |
| macOS Apple Silicon | ⚠️ not verified | Same commands; the compiler and the jar are pure Java bytecode. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `openjdk-21-jdk` with apt when no Java 21 is found. If `kotlinc` is missing, it downloads the official Kotlin compiler zip, checks its SHA-256 checksum, and unpacks it into `~/.local/kotlinc-2.4.21` [2]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` puts the JDK from `JAVA_HOME_21_X64` on PATH when that variable is set. It does not install a JDK: if Java 21 is missing it prints the `winget` Temurin 21 command and stops. If `kotlinc` is missing, it downloads the same zip, checks its SHA-256 checksum, and unpacks it with 7-Zip when Git Bash has no `unzip` [2]. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` and `./run.sh --verify` print:
```text
==> Run the program
    WHY: 'java -jar' starts the JVM and runs the main function in the jar.
Hello, World!
```
The last line is the program's output.

## Sources
1. Kotlin FAQ. JetBrains. <https://kotlinlang.org/docs/faq.html> (accessed 2026-11-04)
2. Kotlin command-line compiler. JetBrains. <https://kotlinlang.org/docs/command-line.html> (accessed 2026-11-04)
3. Kotlin releases. JetBrains. <https://kotlinlang.org/docs/releases.html> (accessed 2026-11-04)
