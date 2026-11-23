# Kotlin · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Kotlin](../README.md)

## What this is
A small web server written with **Ktor**. When a browser asks for
`http://localhost:8080/`, the server answers with the HTML
`<p>Hello, World!</p>`, which the browser shows as the text **Hello, World!**.
The server sends the HTML itself; there is no separate front end. Ktor is
"built from the ground up using Kotlin and Coroutines" and is brought to
you "by JetBrains, creators of IntelliJ IDEA, Kotlin, and more" [1]. For the
same task in Java, see [Spring Boot](../../java/web/).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (Java Development Kit) 21 or newer | Eclipse Temurin 21.0.8 | Gradle and the server run on the JVM |
| Gradle | 9.8.0 | the build tool: downloads the dependencies, compiles, and packs the jar |
| Kotlin Gradle plugin | 2.4.21 (pinned in `build.gradle.kts`) | compiles the Kotlin code; downloaded by Gradle |
| Ktor | 3.6.1 (pinned in `build.gradle.kts`) | the web framework; **not installed by hand**: Gradle downloads it during `./build.sh` |
| Netty | 4.2.17.Final (chosen by Ktor) | the engine inside Ktor that handles the network connections |
| Logback | 1.6.7 | prints Ktor's log messages |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

Ktor 3.6.1 is the "Latest release" on the Ktor home page and the version
that the Ktor documentation shows [1][6], and Maven Central lists it as the
newest `ktor-server-core` [2]. The same Kotlin 2.4.21 as in the other Kotlin
folders compiles it. Gradle 9.8.0 is newer than the 9.7.0 that Kotlin
Gradle plugin 2.4.21 supports fully; newer versions may print deprecation
warnings [3].

## Quick start
```sh
./install.sh   # check / install the JDK and Gradle (asks before installing)
./build.sh     # compile into the executable jar build/libs/hello-web-all.jar
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks that `java` is version 21 or newer. 2. Checks that `gradle` is on `PATH`. If one is missing, it shows the install command (on macOS `brew install gradle` [4]) and runs it only if you answer `y`. | Same toolchain as [../desktop](../desktop/README.md#scripts-explained). Ktor needs no separate install. |
| `build.sh` | Runs `gradle --no-daemon --console=plain buildFatJar`. | The Ktor Gradle plugin's `buildFatJar` task "builds a combined JAR of a project and runtime dependencies" [5]: one executable jar with Ktor, Netty and Logback inside. The first build downloads the Gradle plugins and libraries named in the build files into Gradle's cache (`~/.gradle`); later builds reuse them. |
| `run.sh` | Runs `java -jar build/libs/hello-web-all.jar`. `--verify` starts it in the background, waits for the page with `curl`, prints it, then stops the server. | The fat jar starts the JVM and calls `main`, which starts Ktor with the Netty engine. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

## Folder structure
```text
web/
├── README.md                    this file
├── install.sh                   checks / installs the JDK and Gradle
├── build.sh                     compiles and packages the executable jar
├── run.sh                       starts the server
├── screenshot.png               the page in a browser, for "Expected output" below
├── settings.gradle.kts          project name and where Gradle finds plugins and libraries
├── build.gradle.kts             plugins, dependencies, main class and jar name
├── .gitignore                   keeps build/, .gradle/ and .kotlin/ out of the repository
├── src/main/kotlin/
│   └── Main.kt                  the whole server
├── src/main/resources/
│   └── logback.xml              log level (INFO) and where messages go
├── build/                       created by Gradle; not committed
│   └── libs/hello-web-all.jar
├── .gradle/                     created by Gradle; not committed
└── .kotlin/                     created by the Kotlin plugin; not committed
```
- `build.gradle.kts` applies the Ktor Gradle plugin and sets
  `application { mainClass = "MainKt" }`, as the Ktor documentation shows for
  fat jars [5]. `ktor { fatJar { archiveFileName.set("hello-web-all.jar") } }`
  fixes the name of the jar [5].
- The two Ktor dependencies are `ktor-server-core` and `ktor-server-netty`.
  The Ktor documentation lists Netty, Jetty, Tomcat and CIO (Coroutine-based
  I/O) as server engines for the JVM and names the dependency of each [6].
  Netty is used here because it is the engine of the first example on the Ktor
  home page [1].
- `logback.xml` sets the log level to INFO. Without it, Logback prints
  Netty's internal debug messages.

## Step-by-step walkthrough
Open [`Main.kt`](src/main/kotlin/Main.kt) next to this list. It follows the
`embeddedServer` example of the Ktor documentation [6].

1. **Imports.** The last three, `respondText`, `get` and `routing`, are
   *extension functions*: functions that Ktor adds to existing classes from
   outside, so that `call.respondText(...)` reads like a method. Java has no
   such feature. [Spring Boot](../../java/web/README.md#step-by-step-walkthrough)
   uses annotations (`@GetMapping`) for the same job, and Flask in the
   [Python web](../../python/web/app.py) version uses decorators.
2. **`val port = System.getenv("PORT")?.toInt() ?: 8080`.** The server uses
   the `PORT` environment variable, or 8080. `?.` calls `toInt()` only when
   the left side is not null, and `?:` (the "Elvis operator") takes the right
   side when the left one is null.
3. **`embeddedServer(Netty, port = port, host = "127.0.0.1") { ... }`** creates
   a server inside the program: "`embeddedServer()` ... accepts an engine
   factory used to create an engine of a specific type" [6]. `127.0.0.1`
   means that only this computer can reach it. The block in braces, a
   trailing lambda, configures the application.
4. **`routing { get("/") { ... } }`** says that `GET` requests for `/` run
   the inner block, as in the Ktor example [1].
5. **`call.respondText("<p>Hello, World!</p>", ContentType.Text.Html)`**
   sends the text as the response. The content type `text/html` makes the
   browser render the `<p>` tag. Ktor adds `charset=UTF-8` by itself (see the
   `curl` output below). `respondText` is a suspend function: it may pause
   its coroutine while the data is sent, and the thread serves other
   requests meanwhile.
6. **`.start(wait = true)`** opens the port and keeps `main` waiting, so the
   server keeps running until you stop it. Without `wait`, `main` would
   return. The [cli](../cli/) version ran `main` and ended.

## Why this toolchain
- **Ktor is the framework of JetBrains**, the company that develops
  Kotlin [1][7]. It is "built from the ground up using Kotlin and
  Coroutines" [1], so the code in this folder uses no Java annotations.
- **Usage figures do not decide this choice.** The web frameworks table of
  the Stack Overflow Developer Survey 2026 (10,281 respondents) does not list
  Ktor [8], so this folder makes no claim about how many people use it. It
  is used because it is Kotlin's own, small enough for one file, and
  documented by JetBrains.
- **Netty** is one of the four JVM engines in the Ktor documentation [6] and
  the engine of its first example [1].
- **Ktor 3.6.1** is the current release (see Prerequisites) [1][2].
- **Port 8080** is the convention of this repository for every web
  implementation, and the port of the Ktor documentation's examples [6].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | macOS 26, Temurin 21.0.8, Gradle 9.8.0, Kotlin 2.4.21, Ktor 3.6.1, Netty 4.2.17.Final. `./build.sh` took about 1 minute with a cold dependency cache. The server starts in under 1 s. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. The fat jar is pure Java bytecode, so it runs on any JVM for Java 21 or newer. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `openjdk-21-jdk` with apt when no Java 21 is found. It does not install Gradle: if it is missing it prints how to get a current one [4] and stops. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` puts the JDK from `JAVA_HOME_21_X64` on PATH when that variable is set. It does not install a JDK: if Java 21 is missing it prints the `winget` Temurin 21 command and stops. It does not install Gradle either: if it is missing it prints `winget install --id Gradle.Gradle -e` [4] and stops. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: Ktor starts the Netty engine on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
13:11:27.093 INFO  i.k.s.Application - Application started in 0.493 seconds.
13:11:27.415 INFO  i.k.s.Application - Responding at http://127.0.0.1:8080
```
In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html; charset=UTF-8

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Ktor: Build Asynchronous Servers and Clients in Kotlin. JetBrains. <https://ktor.io/> (accessed 2026-11-04)
2. `ktor-server-core`, `maven-metadata.xml`. Maven Central. <https://repo1.maven.org/maven2/io/ktor/ktor-server-core/maven-metadata.xml> (accessed 2026-11-04)
3. Configure a Gradle project (Kotlin Gradle plugin compatibility). JetBrains. <https://kotlinlang.org/docs/gradle-configure-project.html> (accessed 2026-11-04)
4. Installing Gradle. Gradle. <https://docs.gradle.org/current/userguide/installation.html> (accessed 2026-11-04)
5. Creating fat JARs using the Ktor Gradle plugin. JetBrains. <https://ktor.io/docs/server-fatjar.html> (accessed 2026-11-04)
6. Server engines (`embeddedServer`, engine list). JetBrains. <https://ktor.io/docs/server-engines.html> (accessed 2026-11-04)
7. Kotlin FAQ. JetBrains. <https://kotlinlang.org/docs/faq.html> (accessed 2026-11-04)
8. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
