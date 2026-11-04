# Java · desktop: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Java](../README.md)

## What this is
A desktop program that opens a native window titled "Hello, World!" with
the text **Hello, World!** in the middle. The window is drawn by
**JavaFX**, a GUI toolkit for Java. The program keeps running until you
close the window.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (Java Development Kit) 21 or newer | Eclipse Temurin 21.0.8 | `javac` compiles the code, `java` runs it |
| Apache Maven | 3.9.16 | builds the project and downloads JavaFX |
| JavaFX (OpenJFX) | 21.0.13 (pinned in `pom.xml`) | the GUI toolkit; **not installed by hand**: Maven downloads it from Maven Central during `./build.sh` |

JavaFX is not part of the JDK. Oracle moved it out "as a stand-alone module
as of Java SE 11", into the OpenJFX project [10]. That is why it is a
Maven dependency here, unlike Python's tkinter, which comes with the
python.org installers. The openjfx.io guide makes the same point: with
Maven "you don't have to download the JavaFX SDK" [1].

## Quick start
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile; downloads JavaFX the first time
./run.sh       # open the window (close it to end the program)
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Runs `javac -version` and checks that the version is 21 or newer. 2. Checks that `mvn` is on `PATH`. If one is missing, it shows the install command and runs it only if you answer `y`. | Same toolchain as [../cli](../cli/README.md#scripts-explained). JavaFX needs no separate install. |
| `build.sh` | Runs `mvn --batch-mode --quiet package`. This compiles `HelloApp.java` into `target/hello-desktop.jar` and copies the JavaFX JAR files into `target/lib/`. | The JVM runs bytecode, so the code must be compiled first. `copy-dependencies` "copies the files for a project's dependencies from the repository to a directory" [6]; `run.sh` needs them in a known folder. |
| `run.sh` | Runs `java --module-path target/lib --add-modules javafx.controls -cp target/hello-desktop.jar com.example.hello.HelloApp`. With `--verify`, sets `TF_VERIFY=1`: the app prints `Hello, World!` once the window is shown and quits after about 2 s. | JavaFX is a set of Java **modules**. This is the command openjfx.io gives for running a JavaFX app from the command line: `java --module-path $PATH_TO_FX --add-modules javafx.controls HelloFX` [1]. The self-check lets `scripts/verify-all.sh` test the window without waiting for you. |

## Folder structure
```text
desktop/
├── README.md          this file
├── install.sh         checks / installs the JDK and Maven
├── build.sh           compiles and collects JavaFX into target/lib
├── run.sh             opens the window
├── screenshot.png     the window, for "Expected output" below
├── pom.xml            Maven project: Java 21, JavaFX dependency, plugins
├── src/main/java/com/example/hello/
│   └── HelloApp.java  the program
└── target/            created by build.sh; not committed
    ├── hello-desktop.jar
    └── lib/           javafx-base, javafx-graphics, javafx-controls jars
```
- Maven's Standard Directory Layout, as in [../cli](../cli/README.md#folder-structure) [2].
- `pom.xml` asks only for `javafx-controls`. Maven adds `javafx-graphics`
  and `javafx-base` because `javafx-controls` depends on them. openjfx.io
  notes that javafx.graphics "is transitively required by the
  javafx.controls module" [1].
- JavaFX contains native code, so each JAR file has an operating-system
  variant. JavaFX's Maven parent POM picks the "classifier" from your OS
  and CPU: `mac`, `mac-aarch64`, `linux`, `linux-aarch64`, `win` and
  others [7]. On the verification machine (an Intel Mac) `target/lib` holds
  `javafx-base-21.0.13-mac.jar` and so on.
- `target/lib` also holds JAR files without a classifier (for example
  `javafx-base-21.0.13.jar`). They are empty placeholders: their manifest
  only says `Automatic-Module-Name: javafx.baseEmpty` (checked with
  `unzip -p` on the verification machine). They do no harm on the module path.
- The `maven-dependency-plugin` execution is bound to the `package` phase.
  By default `copy-dependencies` runs in `process-sources` and copies to
  `target/dependency` [6]. `pom.xml` changes both, so the JAR files land in
  `target/lib` next to `hello-desktop.jar`.

## Step-by-step walkthrough
Open [`HelloApp.java`](src/main/java/com/example/hello/HelloApp.java) next to
this list.

1. **`import javafx...;`** brings in the JavaFX classes used below, as
   `from tkinter import ttk` does in [Python](../../python/desktop/hello.py).
2. **`public class HelloApp extends Application`**: a JavaFX program is a
   subclass of `Application`. This is object-oriented **inheritance**: the
   class gets JavaFX's whole life cycle and only fills in `start()`. The
   [cli](../cli/) version needed no inheritance.
3. **`main` calls `launch(args)`.** For each launch, the JavaFX runtime
   "Constructs an instance of the specified Application class; Calls the
   init() method; Calls the start(javafx.stage.Stage) method; Waits for the
   application to finish" and then calls `stop()` [3]. `launch` "does not
   return until the application has exited" [3].
4. **`start(Stage stage)`** "is called on the JavaFX Application Thread"
   [3]. A `Stage` is a window, and JavaFX creates the first one and passes it to `start()`.
5. **`new Label("Hello, World!")`** is the text. A `StackPane` centers it,
   `setPadding(new Insets(40))` adds 40 pixels of space around it, and a
   `Scene` holds everything drawn in the window. Then `setTitle` sets the
   title bar and `show()` puts the window on the screen.
6. **The self-check.** With `TF_VERIFY=1`, the app checks
   `stage.isShowing()`, prints the label's text and starts a
   `PauseTransition` of 2 s. A `PauseTransition` "executes an
   Animation.onFinished at the end of its duration" [4], and that handler
   calls `Platform.exit()`, which "Causes the JavaFX application to
   terminate" [5] and is "the preferred way to explicitly terminate a
   JavaFX Application" [3]. `event -> Platform.exit()` is a **lambda**, a
   short way to pass a function as a value (Java 8 and later).
7. **No explicit loop.** After `start()` returns, JavaFX keeps handling
   events until the last window closes. Python's tkinter does the same
   with `root.mainloop()`, and a web server does it while it waits for
   requests.

## Why this toolchain
- **JavaFX or Swing?** The JDK still ships an older GUI toolkit, Swing.
  Oracle says that "Swing and AWT remain core Java SE technologies" [10],
  so Swing is not deprecated. This repository uses JavaFX for the Java
  desktop version (and Swing in [desktop-swing](../desktop-swing/)).
  JavaFX is developed in the open as OpenJFX [10]. It still gets feature
  releases (JavaFX 21 came out in September 2023; 27 is the newest in
  October 2026), and it has long-term support (LTS) versions [9].
- **Why JavaFX 21 and not 27?** Each JavaFX release needs a minimum JDK.
  "JavaFX 21 requires JDK 17 or later" [8], but "JavaFX 24 requires JDK 22
  or later" [11], and the newest JavaFX, 27, needs JDK 25 [9]. This repository
  uses Java 21, so the newest JavaFX it can use is the 23 line, which "is
  compiled with `--release 21` and thus requires JDK 21 or later" [12].
  But 23 is not an LTS line; its last release on Maven Central is 23.0.2
  [13]. JavaFX 21 is an LTS line, and Gluon lists it as an active LTS release,
  with 21.0.13 published in October 2026 [9]. It matches Java 21 LTS.
- **Why not `mvn javafx:run`?** openjfx.io also documents the
  `javafx-maven-plugin`, which runs the app with `mvn javafx:run` [1]. Here
  `build.sh` and `run.sh` are kept separate, as in every compiled
  implementation of this repository: build once, then run with plain `java`.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Temurin 21.0.8, Maven 3.9.16, JavaFX 21.0.13 (`mac` JAR files). |
| macOS Apple Silicon | ⚠️ not verified | Same commands. Maven picks the `mac-aarch64` JavaFX JAR files [7]. Use an arm64 JDK (the `temurin@21` cask installs one on Apple Silicon). |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Install as in [../cli](../cli/README.md#platform-notes). Maven picks the `linux` JAR files [7]. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Install as in [../cli](../cli/README.md#platform-notes). Maven picks the `win` JAR files [7]. On Windows `--module-path` uses `;` between entries, but a single folder (`target/lib`) needs none. Native PowerShell: `mvn package`, then `java --module-path target\lib --add-modules javafx.controls -cp target\hello-desktop.jar com.example.hello.HelloApp`. |

## Expected output
`./run.sh` opens a small window titled "Hello, World!" with the text
"Hello, World!" in the middle:

![The JavaFX window titled "Hello, World!" showing the text "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 on macOS Intel with `screencapture -x -o -l <window-id> screenshot.png`,
which captures only that window. The title is cut short because the window
is narrow.)

`./run.sh --verify` prints:
```text
==> Open the Hello World window
    WHY: JavaFX draws the window. Its jars in target/lib are loaded as Java modules.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Sources
1. Getting Started with JavaFX. OpenJFX (Gluon). <https://openjfx.io/openjfx-docs/> (accessed 2026-10-31)
2. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (accessed 2026-10-31)
3. Application (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.graphics/javafx/application/Application.html> (accessed 2026-10-31)
4. PauseTransition (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.graphics/javafx/animation/PauseTransition.html> (accessed 2026-10-31)
5. Platform (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.graphics/javafx/application/Platform.html> (accessed 2026-10-31)
6. dependency:copy-dependencies. Apache Maven Dependency Plugin. <https://maven.apache.org/plugins/maven-dependency-plugin/copy-dependencies-mojo.html> (accessed 2026-10-31)
7. javafx-21.0.13.pom (OS profiles and `javafx.platform` classifiers). Maven Central. <https://repo.maven.apache.org/maven2/org/openjfx/javafx/21.0.13/javafx-21.0.13.pom> (accessed 2026-10-31)
8. Release Notes for JavaFX 21. OpenJDK (openjdk/jfx). <https://github.com/openjdk/jfx/blob/jfx21/doc-files/release-notes-21.md> (accessed 2026-10-31)
9. JavaFX (downloads and release table). Gluon. <https://gluonhq.com/products/javafx/> (accessed 2026-10-31)
10. Java Client Roadmap Update (May 2020). Oracle. <https://www.oracle.com/technetwork/java/javase/javaclientroadmapupdatev2020may-6548840.pdf> (accessed 2026-10-31)
11. Release Notes for JavaFX 24. OpenJDK (openjdk/jfx). <https://github.com/openjdk/jfx/blob/jfx24/doc-files/release-notes-24.md> (accessed 2026-10-31)
12. Release Notes for JavaFX 23. OpenJDK (openjdk/jfx). <https://github.com/openjdk/jfx/blob/jfx23/doc-files/release-notes-23.md> (accessed 2026-10-31)
13. org.openjfx:javafx-controls versions (maven-metadata.xml). Maven Central. <https://repo.maven.apache.org/maven2/org/openjfx/javafx-controls/maven-metadata.xml> (accessed 2026-10-31)
