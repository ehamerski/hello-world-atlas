# Java · desktop-swing: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Java](../README.md) ·
> JavaFX version of the same program: [../desktop](../desktop/)

## What this is
A desktop program that opens a native window titled "Hello, World!" with
the text **Hello, World!** in the middle. The window is drawn by
**Swing**, the GUI toolkit that comes with the JDK. The program keeps
running until you close the window.

It is the same program as [../desktop](../desktop/), which uses JavaFX.
Putting the two side by side shows how Java's two desktop toolkits
differ. See [Swing or JavaFX?](#swing-or-javafx) below.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (Java Development Kit) 21 or newer | Eclipse Temurin 21.0.8 | `javac` compiles the code, `java` runs it. **Swing is inside the JDK.** |
| Apache Maven | 3.9.16 | builds the project (no dependencies to download) |

Nothing else is needed. The JDK's `java.desktop` module "Defines the AWT
and Swing user interface toolkits, plus APIs for accessibility, audio,
imaging, printing, and JavaBeans" [8]. Compare [../desktop](../desktop/),
where Maven has to download JavaFX.

## Quick start
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile into target/hello-swing.jar
./run.sh       # open the window (close it to end the program)
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Runs `javac -version` and checks that the version is 21 or newer. 2. Checks that `mvn` is on `PATH`. If one is missing, it shows the install command and runs it only if you answer `y`. | Same toolchain as [../cli](../cli/README.md#scripts-explained). Swing needs no separate install. |
| `build.sh` | Runs `mvn --batch-mode --quiet package`. This compiles `HelloSwing.java` into `target/hello-swing.jar`. | The JVM runs bytecode, so the code must be compiled first. There is no `target/lib/`, because there are no libraries to copy. |
| `run.sh` | Runs `java -jar target/hello-swing.jar`. With `--verify`, sets `TF_VERIFY=1`: the app prints `Hello, World!` once the window is shown and closes after about 2 s. | `java -jar` starts the class named in the manifest of the JAR file (`Main-Class`, set in `pom.xml`). No `--module-path` is needed because Swing is in the JDK. The self-check lets `scripts/verify-all.sh` test the window without waiting for you. |

## Folder structure
```text
desktop-swing/
├── README.md          this file
├── install.sh         checks / installs the JDK and Maven
├── build.sh           compiles target/hello-swing.jar
├── run.sh             opens the window
├── screenshot.png     the window, for "Expected output" below
├── pom.xml            Maven project: Java 21, no dependencies, Main-Class
├── src/main/java/com/example/hello/
│   └── HelloSwing.java  the program
└── target/            created by build.sh; not committed
    └── hello-swing.jar
```
- Maven's Standard Directory Layout, as in [../cli](../cli/README.md#folder-structure) [15].
- The folder is named `desktop-swing`, following the
  `<category>-<variant>` naming of this repository (like [../web-react](../web-react/)). The
  plain `desktop` folder holds the JavaFX version.
- `pom.xml` is the [../cli](../cli/) `pom.xml` with a different name and
  main class. The `<dependencies>` section is missing because the program needs no
  library outside the JDK.

## Step-by-step walkthrough
Open [`HelloSwing.java`](src/main/java/com/example/hello/HelloSwing.java)
next to this list.

1. **`import javax.swing...;`** brings in the Swing classes. Swing class
   names start with `J` (`JFrame`, `JLabel`). The older AWT toolkit, which
   Swing builds on, has `Frame` and `Label`. The `javax.swing` package
   "Provides a set of 'lightweight' (all-Java language) components that,
   to the maximum degree possible, work the same on all platforms" [3].
2. **`public class HelloSwing`** extends nothing. In JavaFX the program
   *is* an `Application` subclass ([../desktop](../desktop/README.md#step-by-step-walkthrough)).
   Swing is a plain library: `main` creates the objects itself.
3. **`main` calls `SwingUtilities.invokeLater(...)` and does not build the
   window itself.** This is the most important rule in Swing:
   - Oracle's tutorial lists three kinds of threads in a Swing program:
     *initial threads* "that execute initial application code", the
     *event dispatch thread* (EDT) "where all event-handling code is
     executed", and *worker threads* for "time-consuming background tasks"
     [16].
   - It asks "Why does not the initial thread simply create the GUI
     itself? Because almost all code that creates or interacts with Swing
     components must run on the event dispatch thread" [1].
   - The reason is that "most Swing object methods are not 'thread safe':
     invoking them from multiple threads risks thread interference or
     memory consistency errors" [2]. "Programs that ignore this rule may
     function correctly most of the time, but are subject to unpredictable
     errors that are difficult to reproduce" [2]. The Java 21 API says the
     same: "In general Swing is not thread safe" and "The preferred way to
     transfer control and begin working with Swing is to use
     `invokeLater`" [3].
   - `invokeLater` "Causes doRun.run() to be executed asynchronously on
     the AWT event dispatching thread" [4]. The tutorial compares it with
     `invokeAndWait`: "`invokeLater` simply schedules the task and returns;
     `invokeAndWait` waits for the task to finish before returning" [1].
   - `HelloSwing::createAndShowWindow` is a **method reference** (Java 8
     and later). It passes the method as the task to run.
   - Note: the Java Tutorials carry the banner "The Java Tutorials have
     been written for JDK 8" [1]. The threading rule has not changed. The
     Java 21 API documentation quoted above states it too [3].
4. **`createAndShowWindow()` runs on the EDT.** `new JFrame("Hello,
   World!")` creates a window with that title. Closing a JFrame by default
   only hides it: "The default behavior is to simply hide the JFrame when
   the user closes the window" [6]. `setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)`
   makes the close button end the program instead.
5. **`new JLabel("Hello, World!", SwingConstants.CENTER)`** is the text,
   centered. An empty border of 40 pixels plays the role of JavaFX's
   `setPadding(new Insets(40))`. `frame.pack()` "Causes this Window to be
   sized to fit the preferred size and layouts of its subcomponents" [7],
   `setLocationRelativeTo(null)` centers the window on the screen, and
   `setVisible(true)` shows it.
6. **The self-check.** With `TF_VERIFY=1`, the app checks
   `frame.isShowing()`, prints the label's text and starts a
   `javax.swing.Timer`. A `Timer` "Fires one or more `ActionEvent`s at
   specified intervals", and its "action event handlers ... execute on
   ... the event-dispatching thread", so they "can safely perform
   operations on Swing components" [5]. `setRepeats(false)` makes it fire
   once [5]. The handler sends a `WINDOW_CLOSING` event, the same event as
   a click on the close button, so `EXIT_ON_CLOSE` ends the program.
   `event -> ...` is a **lambda** (Java 8 and later).
7. **No explicit loop.** `main` returns at once, but the program keeps
   running: the EDT waits for events until the window is closed. JavaFX
   ([../desktop](../desktop/)), Python's tkinter `mainloop()` and a web
   server's request loop work the same way.

## Swing or JavaFX?
### History
| Year | Event | Source |
|---|---|---|
| 1995 | AWT, Java's first GUI toolkit, ships with Java SE at launch | [9] |
| 1998 | Swing, first "a separate library", becomes part of "J2SE 1.2" | [9] |
| 2005 | Development of JavaFX starts | [9] |
| 2011 | Oracle open-sources JavaFX through the OpenJFX project in OpenJDK | [9] |
| 2018 | JDK 11 (GA on 2018-09-25) removes JavaFX: "JavaFX is no longer included in the JDK. It is now available as a separate download from openjfx.io" | [10][17] |
| 2020 | Oracle's Java Client Roadmap: "Swing and AWT remain core Java SE technologies to Oracle across all Java SE releases and support timelines" | [9] |
| 2026 | Oracle: "JDK 8 includes JavaFX until March 2028, for newer JDK releases, Oracle offers JavaFX as separate library" | [11] |

Oracle's roadmap says of AWT: "AWT has been an integral part of Java SE
since its launch in 1995. Swing was introduced shortly thereafter as a
separate library and finally incorporated into 'J2SE 1.2' in 1998. Both
toolkits are part of the Java SE Specification" [9]. It also says
"Oracle will continue developing Swing and AWT across all supported
releases as a core Java SE technology" [9]. On the JavaFX side, "Oracle
completed the re-architecture and transition of JavaFX to OpenJFX as a
stand-alone module as of Java SE 11" [9]. The JDK 11 release notes add
that the JavaFX modules "were included in earlier releases of the Oracle
JDK, but not in the OpenJDK releases" [10].

(The roadmap was first published in May 2020, as its URL shows. The copy
read on 2026-11-02 is "Version 1.01" and marks itself "out of date and
remains for historical tracking purposes only" [9]. The facts quoted here
are historical, so they still hold.)

### Packaging and running
| | Swing (this folder) | JavaFX ([../desktop](../desktop/)) |
|---|---|---|
| Where the toolkit comes from | the JDK (`java.desktop` module) [8] | Maven Central (OpenJFX), since JDK 11 [10] |
| `pom.xml` dependencies | none | `org.openjfx:javafx-controls` |
| Build output | `target/hello-swing.jar` (about 4 KB) | `target/hello-desktop.jar` + `target/lib/` (JavaFX JAR files) |
| Native code | in the JDK | in the JavaFX JAR files, one variant per OS and CPU (see [../desktop](../desktop/README.md#folder-structure)) |
| Run command | `java -jar target/hello-swing.jar` | `java --module-path target/lib --add-modules javafx.controls -cp ... HelloApp` |
| Program shape | `main` calls `invokeLater`, the code builds the window | subclass of `Application`; JavaFX calls `start(Stage)` |
| GUI thread | event dispatch thread (EDT) [2] | JavaFX Application Thread |

The size of the JAR file was measured with `ls -l` on the verification
machine (2026-11-02).
To ship either program to users without a separate Java install, the
JDK's `jpackage` tool (JEP 392, final in JDK 16) can package
"self-contained Java applications" [13]. Oracle's roadmap points desktop
developers to "jlink, jpackage and/or third party packaging and
deployment solutions" [9].

### When to choose which
This is guidance drawn from the facts above, not a rule from Oracle:

- **Swing** when you want zero dependencies, or you maintain an existing
  Swing application. It is part of the Java SE specification and
  Oracle says it will keep developing it [9]. Any full JDK can build and
  run it, on every operating system the JDK supports. Its tutorial material is old,
  though: the Swing trail was "written for JDK 8" [1].
- **JavaFX** for new applications that want a more modern toolkit.
  OpenJFX describes JavaFX as "an open source, next generation client
  application platform for desktop, mobile and embedded systems built on
  Java" [12]. The cost is an extra dependency, and the JavaFX version
  must match your JDK (see [../desktop](../desktop/README.md#why-this-toolchain)).
- **Both:** JavaFX's `JFXPanel` "is a component to embed JavaFX content
  into Swing applications" [14], so a Swing application can move to
  JavaFX one screen at a time.

## Why this toolchain
- **A second toolkit for comparison.** The main Java desktop version uses
  JavaFX ([../desktop](../desktop/)). This Swing version exists so that
  the two toolkits can be compared.
- **Java 21 and Maven**, like every Java folder in this repository. Swing
  itself needs no version choice: it is the one in your JDK.
- **No GUI builder, no extra layout library.** One `JLabel` in a `JFrame`
  is the smallest complete Swing window.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-02) | Temurin 21.0.8, Maven 3.9.16. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. Use an arm64 JDK (the `temurin@21` cask installs one on Apple Silicon). |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Install as in [../cli](../cli/README.md#platform-notes). Needs a graphical desktop session; a server without a display cannot open the window. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Install as in [../cli](../cli/README.md#platform-notes). Native PowerShell: `mvn package`, then `java -jar target\hello-swing.jar`. |

## Expected output
`./run.sh` opens a small window titled "Hello, World!" with the text
"Hello, World!" in the middle:

![The Swing window titled "Hello, World!" showing the text "Hello, World!"](screenshot.png)

(Taken on 2026-11-02 on macOS Intel with `screencapture -x -o -l <window-id> screenshot.png`,
which captures only that window. On the verification machine, it looks almost
the same as the [JavaFX window](../desktop/README.md#expected-output).)

`./run.sh --verify` prints:
```text
==> Open the Hello World window
    WHY: Swing (part of the JDK) draws the window; 'java -jar' starts it.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Sources
1. Initial Threads (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/initial.html> (accessed 2026-11-02)
2. The Event Dispatch Thread (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/dispatch.html> (accessed 2026-11-02)
3. Package javax.swing (Java SE 21 API), including "Swing's Threading Policy". Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/package-summary.html> (accessed 2026-11-02)
4. SwingUtilities.invokeLater (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/SwingUtilities.html#invokeLater(java.lang.Runnable)> (accessed 2026-11-02)
5. Timer (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/Timer.html> (accessed 2026-11-02)
6. JFrame (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JFrame.html> (accessed 2026-11-02)
7. Window.pack() (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/Window.html#pack()> (accessed 2026-11-02)
8. Module java.desktop (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/module-summary.html> (accessed 2026-11-02)
9. Java Client Roadmap Update (first published May 2020; copy read is Version 1.01). Oracle. <https://www.oracle.com/technetwork/java/javase/javaclientroadmapupdatev2020may-6548840.pdf> (accessed 2026-11-02)
10. JDK 11 Release Notes ("JavaFX is no longer included in the JDK"; "Removal of JavaFX from the Oracle JDK"). Oracle. <https://www.oracle.com/java/technologies/javase/11-relnote-issues.html> (accessed 2026-11-02)
11. JavaFX. Oracle. <https://www.oracle.com/java/technologies/javase/javafx-overview.html> (accessed 2026-11-02)
12. JavaFX (OpenJFX home page). Gluon / OpenJFX. <https://openjfx.io/> (accessed 2026-11-02)
13. JEP 392: Packaging Tool. OpenJDK. <https://openjdk.org/jeps/392> (accessed 2026-11-02)
14. JFXPanel (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.swing/javafx/embed/swing/JFXPanel.html> (accessed 2026-11-02)
15. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (accessed 2026-11-02)
16. Lesson: Concurrency in Swing (The Java Tutorials). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/index.html> (accessed 2026-11-02)
17. JDK 11. OpenJDK. <https://openjdk.org/projects/jdk/11/> (accessed 2026-11-02)
