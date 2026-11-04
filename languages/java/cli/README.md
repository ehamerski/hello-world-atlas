# Java · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Java](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
the classic Java version: one class, `Hello`, with a `main` method. Unlike
the [Python cli](../../python/cli/), it must be **compiled** before it can
run, so this folder has a `build.sh`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (Java Development Kit) 21 or newer | Eclipse Temurin 21.0.8 | `javac` compiles the code to bytecode, `java` runs it on the JVM |
| Apache Maven | 3.9.16 | the build tool: reads `pom.xml`, calls `javac`, packs the `.jar` |

A JRE (runtime only) is not enough: it has no `javac`. Maven needs "a Java
Development Kit (JDK) installed" [5]. Maven 3.10.0 is the newest Maven
release (2026) [5]; 3.9.16 is the version installed on the verification machine, and it
builds this project in the same way.

## Quick start
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile into target/hello-cli.jar
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Runs `javac -version` and checks that the version is 21 or newer. 2. Checks that `mvn` is on `PATH`. If one is missing, it shows the install command (Homebrew, apt or winget) and runs it only if you answer `y`. | Java is compiled: the JDK holds the compiler and the JVM, and Maven drives the build. On macOS `/usr/bin/javac` always exists, but it only works when a JDK is installed, so the script runs it instead of only checking that the file exists. |
| `build.sh` | Runs `mvn --batch-mode --quiet package`. | Maven's phases "are executed sequentially": `validate`, `compile`, `test`, then `package`, which takes "the compiled code and package[s] it in its distributable format, such as a JAR" [2]. The JVM runs bytecode, never `.java` files [8]. |
| `run.sh` | Runs `java -jar target/hello-cli.jar`. `--verify` does the same (a cli program ends by itself). | `java` starts the JVM, which reads the manifest of the JAR file to find the main class (`com.example.hello.Hello`) [4]. |

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / installs the JDK and Maven
├── build.sh         compiles and packages with Maven
├── run.sh           runs the jar
├── pom.xml          the Maven project file (name, Java version, plugins)
├── src/main/java/com/example/hello/
│   └── Hello.java   the program
└── target/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli.jar
```
- This is Maven's **Standard Directory Layout**: `src/main/java` holds
  "Application/Library sources", and "the target directory is used to house
  all output of the build" [1].
- The folders below `src/main/java` follow the **package** name:
  `com.example.hello` → `com/example/hello/`. The Java Language Specification suggests
  forming "a unique package name" from "an Internet domain name", reversed [9]; `example.com` is reserved for
  examples [10], so it belongs to nobody.
- `pom.xml` sets `maven.compiler.release` to 21: code is "compiled following
  the rules of the programming language of the specified release" and the
  classes target that release [3].
- `maven-jar-plugin` writes `Main-Class` into the manifest of the JAR file. Maven's docs
  say that "if you want to create an executable jar file ... You need to
  tell it which main class to use", which is done with `<mainClass>` [4].
- `<finalName>hello-cli</finalName>` names the JAR file `hello-cli.jar` instead of
  `hello-cli-1.0.0.jar`, so `run.sh` does not depend on the version.

## Step-by-step walkthrough
Open [`Hello.java`](src/main/java/com/example/hello/Hello.java) next to this
list.

1. **`package com.example.hello;`** puts the class in a namespace. Python
   and JavaScript files have no such line; in Java the package must also
   match the folder.
2. **`public class Hello { ... }`**: in Java every method lives inside a
   class. A public class must be in a file with the same name, `Hello.java`.
   Java is "class-based, object-oriented" [11]. This program creates no
   objects, but it still needs the class.
3. **`public static void main(String[] args)`** is the entry point the
   `java` launcher looks for. `static` means it runs without creating a
   `Hello` object; `args` holds the command-line arguments. C, C++ and C#
   also start at a `main`; Python runs the file from top to bottom.
4. **`System.out.println("Hello, World!");`** writes the text and a line
   break to standard output. The statement ends with `;`, as in C.
5. **Compile, then run.** `javac` (through Maven) turns `Hello.java` into
   `Hello.class`. That file "does not contain code that is native to your
   processor; it instead contains bytecodes — the machine language of the
   Java Virtual Machine" [8]. `java` then runs it. You can do both steps by
   hand, without Maven:
   ```sh
   javac -d out src/main/java/com/example/hello/Hello.java
   java -cp out com.example.hello.Hello
   ```

**Newer Java is shorter.** Java 25 made "compact source files" final
(JEP 512) [12]. With it, a whole program can be
`void main() { IO.println("Hello, World!"); }`, with no class and no `static`.
The JEP's goal is to let "beginners ... write their first programs without
needing to understand" features meant for large programs [12]. In Java 21,
which this repository uses, the feature was only a preview (JEP 445) [13], so the classic
form is used here.

## Why this toolchain
- **Java 21** is a long-term support (LTS) release. Oracle lists "Java SE 8,
  11, 17, 21, and 25" as LTS releases, with Premier Support for 21 until
  September 2028 [14]. This repository uses Java 21 LTS for all four Java
  implementations. Newer versions also build this code.
- **Eclipse Temurin** is the JDK that `install.sh` suggests: "Prebuilt
  OpenJDK Binaries for Free!" from the Eclipse Adoptium project [20].
  Adoptium recommends installing it "through a package manager" [6].
- **Maven** gives every Java project the same layout and the same commands
  (`mvn package`) [1][2]. Spring Boot's own tutorial uses Maven too [15], so
  the [web](../web/) version builds the same way. All four Java folders use
  Maven so they look alike.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Temurin 21.0.8, Maven 3.9.16. The Homebrew `maven` formula depends on Homebrew's `openjdk` [7]; on the verification machine, its `mvn` wrapper script uses `JAVA_HOME` when it is set and that `openjdk` otherwise (check with `mvn -v`). |
| macOS Apple Silicon | ⚠️ not verified | Same commands. `brew install --cask temurin@21` installs the arm64 JDK [16]. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `sudo apt-get install openjdk-21-jdk maven`. `openjdk-21-jdk` is in Debian 13 "trixie" and Ubuntu 24.04 "noble" [17][18], but not in Debian 12, which only ships Java 17; use Temurin from Adoptium there [6]. |
| Windows (Git Bash / WSL) | ⚠️ not verified | JDK: `winget install --id EclipseAdoptium.Temurin.21.JDK -e` [19]. Maven: unzip the binary archive and add its `bin` folder to PATH [5]. Native commands (PowerShell): `mvn package`, then `java -jar target\hello-cli.jar`. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: 'java -jar target/hello-cli.jar' starts the JVM, which runs Hello.main().
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (accessed 2026-10-31)
2. Introduction to the Build Lifecycle. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html> (accessed 2026-10-31)
3. Setting the --release of the Java Compiler. Apache Maven Compiler Plugin. <https://maven.apache.org/plugins/maven-compiler-plugin/examples/set-compiler-release.html> (accessed 2026-10-31)
4. Set Up The Classpath (executable jar, `mainClass`). Apache Maven Archiver. <https://maven.apache.org/shared/maven-archiver/examples/classpath.html> (accessed 2026-10-31)
5. Installing Apache Maven. Apache Maven. <https://maven.apache.org/install.html> (accessed 2026-10-31)
6. Install Eclipse Temurin. Eclipse Adoptium. <https://adoptium.net/installation/> (accessed 2026-10-31)
7. maven (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/maven> (accessed 2026-10-31)
8. About the Java Technology (The Java Tutorials). Oracle. <https://docs.oracle.com/javase/tutorial/getStarted/intro/definition.html> (accessed 2026-10-31)
9. The Java Language Specification, Java SE 21, §6.1 Declarations (package naming). Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-6.html#jls-6.1> (accessed 2026-10-31)
10. RFC 2606: Reserved Top Level DNS Names. IETF. <https://www.rfc-editor.org/rfc/rfc2606> (accessed 2026-10-31)
11. The Java Language Specification, Java SE 21, Chapter 1. Introduction. Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-1.html> (accessed 2026-10-31)
12. JEP 512: Compact Source Files and Instance Main Methods. OpenJDK. <https://openjdk.org/jeps/512> (accessed 2026-10-31)
13. JEP 445: Unnamed Classes and Instance Main Methods (Preview). OpenJDK. <https://openjdk.org/jeps/445> (accessed 2026-10-31)
14. Oracle Java SE Support Roadmap. Oracle. <https://www.oracle.com/java/technologies/java-se-support-roadmap.html> (accessed 2026-10-31)
15. Developing Your First Spring Boot Application. Spring. <https://docs.spring.io/spring-boot/tutorial/first-application/index.html> (accessed 2026-10-31)
16. `temurin@21` (cask). Homebrew Formulae. <https://formulae.brew.sh/cask/temurin@21> (accessed 2026-10-31)
17. `openjdk-21-jdk` in Debian (`madison`). Debian. <https://qa.debian.org/madison.php?package=openjdk-21-jdk> (accessed 2026-10-31)
18. Package `openjdk-21-jdk` in noble. Ubuntu. <https://packages.ubuntu.com/noble/openjdk-21-jdk> (accessed 2026-10-31)
19. `EclipseAdoptium.Temurin.21.JDK` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/e/EclipseAdoptium/Temurin/21/JDK> (accessed 2026-10-31)
20. Eclipse Temurin. Eclipse Adoptium. <https://adoptium.net/temurin/> (accessed 2026-10-31)
