# Clojure · desktop: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Clojure](../README.md) ·
> The same program in Java: [java/desktop-swing](../../java/desktop-swing/)

## What this is
A desktop program that opens a native window titled "Hello, World!" with
the text **Hello, World!** in the middle. The window is drawn by **Swing**,
the GUI toolkit that comes with the JDK. Clojure has no GUI toolkit of its
own: the program calls Swing through **Java interop**. It keeps running
until you close the window.

It is the same program as [java/desktop-swing](../../java/desktop-swing/),
written in Clojure. Putting the two side by side shows what Java interop
looks like.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Java runtime 21 or newer | Eclipse Temurin 21.0.8 | runs the bytecode. **Swing is inside the JDK.** |
| Clojure CLI | 1.12.6.1673 (Clojure 1.12.6) | starts the JVM and loads the program; see [../cli](../cli/README.md#prerequisites) |

Nothing else is needed. The JDK's `java.desktop` module "Defines the AWT
and Swing user interface toolkits, plus APIs for accessibility, audio,
imaging, printing, and JavaBeans" [1]. `deps.edn` has no dependency.

## Quick start
```sh
./install.sh   # check / install Java and the Clojure CLI (asks before installing)
./run.sh       # open the window (close it to end the program)
```
There is no `build.sh`: Clojure compiles the source when it loads it. The
reason is in [../cli](../cli/README.md#why-there-is-no-buildsh).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Same three steps as [../cli](../cli/README.md#scripts-explained): checks Java, checks or installs the Clojure CLI, and runs `clojure -P`. | Swing needs no separate install. |
| `run.sh` | Runs `clojure -M -m hello.core`. With `--verify`, sets `TF_VERIFY=1`: the app prints `Hello, World!` once the window is shown and closes after about 2 s. | The self-check lets `scripts/verify-all.sh` test the window without waiting for you. |
| `clojure-env.sh` | Sets the CLI version, the installer checksum and `CLOJURE_DIR`. | The same file as in [../cli](../cli/). |

## Folder structure
```text
desktop/
├── README.md        this file
├── install.sh       checks / installs Java and the Clojure CLI
├── run.sh           opens the window
├── clojure-env.sh   toolchain settings, sourced by the scripts
├── deps.edn         project file: source folder, no dependency
├── screenshot.png   the window, for "Expected output" below
├── .gitignore       ignores .cpcache/ (the CLI's classpath cache)
└── src/
    └── hello/
        └── core.clj   the program: namespace hello.core
```
The layout is the one of [../cli](../cli/README.md#folder-structure) [2].

## Step-by-step walkthrough
Open [`core.clj`](src/hello/core.clj) next to this list.

1. **`(:import ...)` in `ns`** is Clojure's version of Java's `import`. It
   lets the code write `JFrame` instead of `javax.swing.JFrame`. Swing class
   names start with `J` (`JFrame`, `JLabel`); the older AWT toolkit, which
   Swing builds on, has `Frame` and `Label`. The `javax.swing` package
   "Provides a set of 'lightweight' (all-Java language) components that, to
   the maximum degree possible, work the same on all platforms" [3].
2. **`-main` calls `SwingUtilities/invokeLater` and does not build the
   window itself.** This is the most important rule in Swing:
   - Oracle's tutorial asks "Why does not the initial thread simply create
     the GUI itself? Because almost all code that creates or interacts with
     Swing components must run on the event dispatch thread" (EDT) [4].
   - The reason is that "most Swing object methods are not 'thread safe':
     invoking them from multiple threads risks thread interference or
     memory consistency errors" [5].
   - `invokeLater` "Causes doRun.run() to be executed asynchronously on the
     AWT event dispatching thread" [6].
   - The method expects a `java.lang.Runnable`. Clojure's function interface,
     `clojure.lang.IFn`, extends `Runnable` [7], so the function
     `create-and-show-window` is passed as it is. Java needs a lambda or a
     method reference (see [java/desktop-swing](../../java/desktop-swing/README.md#step-by-step-walkthrough)).
   - The Java Tutorials carry the banner "The Java Tutorials have been
     written for JDK 8" [4]. The Java 21 API documentation states the same
     rule [3].
3. **Interop syntax.** Clojure reaches Java classes with a few forms [8]:

   | Java | Clojure | Meaning |
   |---|---|---|
   | `new JFrame("...")` | `(JFrame. "...")` | a trailing dot calls the constructor |
   | `frame.pack()` | `(.pack frame)` | a leading dot calls an instance method; the object comes first |
   | `SwingConstants.CENTER` | `SwingConstants/CENTER` | `Class/NAME` reads a static field |
   | `System.getenv("X")` | `(System/getenv "X")` | `Class/name` calls a static method |

   The call is still a list that starts with the operator, as in every
   Lisp, so Java code looks different in Clojure but means the same.
4. **`let`** binds `frame` and `label` for the code inside it. The names
   never change afterwards: Clojure values are immutable by default. The
   Swing objects themselves are mutable Java objects, which is why the
   code calls `setBorder`, `add`, and `setVisible` on them.
5. **`(.setDefaultCloseOperation frame JFrame/EXIT_ON_CLOSE)`.** Closing a
   JFrame by default only hides it: "The default behavior is to simply
   hide the JFrame when the user closes the window" [9]. `EXIT_ON_CLOSE`
   ends the program instead.
6. **The label and the window.** `(JLabel. "Hello, World!" SwingConstants/CENTER)`
   is the text, centered. An empty border of 40 pixels keeps the window from
   being tiny. `.pack` "Causes this Window to be sized to fit the preferred
   size and layouts of its subcomponents" [10], `(.setLocationRelativeTo frame nil)`
   centers the window on the screen (`nil` is Clojure's null), and
   `.setVisible` shows it.
7. **The self-check.** With `TF_VERIFY=1`, the app checks `.isShowing`,
   prints the label's text, and starts a `javax.swing.Timer`. A `Timer`
   "Fires one or more `ActionEvent`s at specified intervals", and its
   "action event handlers ... execute on ... the event-dispatching thread",
   so they "can safely perform operations on Swing components" [11].
   - `Timer` wants an `ActionListener`, a Java interface. "reify defines
     both an anonymous type and creates an instance of that type", for "a
     one-off implementation of one or more protocols or interfaces" [12]. It
     does the job of Java's lambda here.
   - `doto` calls several methods on the same object and returns it [8], so
     `(.setRepeats false)` and `(.start)` apply to the timer.
   - The action sends a `WINDOW_CLOSING` event, the same event as a click on
     the close button, so `EXIT_ON_CLOSE` ends the program.
8. **No explicit loop.** `-main` returns at once, but the program keeps
   running: the EDT waits for events until the window is closed. Python's
   tkinter `mainloop()` and a web server's request loop work the same
   way.

## Why this toolchain
- **Swing through interop shows the point of a hosted language.** The
  author wrote that Clojure programs "are Java libraries and bytecode when
  on the JVM" and that being hosted means there is "no overhead,
  conversion, friction, wrapping, declarations et al going to and from the
  larger ecosystem" [13]. A window needs no Clojure library at all.
- **Swing, not JavaFX.** Swing is part of every JDK [1], so the project has
  no dependency. JavaFX would need Maven artifacts and platform-specific
  native code, as in [java/desktop](../../java/desktop/). Clojure wrappers
  around Swing and JavaFX exist, but this folder uses none, so the code
  stays the same as the Java version.
- **The Clojure CLI**, as in [../cli](../cli/README.md#why-this-toolchain).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Temurin 21.0.8, Clojure CLI 1.12.6.1673 (Clojure 1.12.6). |
| macOS Apple Silicon | ⚠️ not verified | Same commands. Use an arm64 Java runtime. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` does the same as in [../cli](../cli/README.md#platform-notes). The window opens on a virtual X display (Xvfb). |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does the same as in [../cli](../cli/README.md#platform-notes). Swing is part of the JDK, so nothing else is installed. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` opens a small window titled "Hello, World!" with the text
"Hello, World!" in the middle:

![The Swing window titled "Hello, World!" showing the text "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 on macOS Intel with `screencapture -x -o -l <window-id> screenshot.png`,
which captures only that window. The window id was looked up for the
process of the program. The window was not in focus, so the title bar is
gray.)

`./run.sh --verify` printed, on 2026-11-04:
```text
==> Open the Hello World window
    WHY: Swing (part of the JDK) draws the window; 'clojure -M -m hello.core' starts it.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Sources
1. Module java.desktop (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/module-summary.html> (accessed 2026-11-04)
2. Deps and CLI Reference. clojure.org. <https://clojure.org/reference/deps_and_cli> (accessed 2026-11-04)
3. Package javax.swing (Java SE 21 API), including "Swing's Threading Policy". Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/package-summary.html> (accessed 2026-11-04)
4. Initial Threads (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/initial.html> (accessed 2026-11-04)
5. The Event Dispatch Thread (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/dispatch.html> (accessed 2026-11-04)
6. SwingUtilities.invokeLater (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/SwingUtilities.html#invokeLater(java.lang.Runnable)> (accessed 2026-11-04)
7. IFn.java, `public interface IFn extends Callable, Runnable` (tag clojure-1.12.6). Clojure core team, GitHub. <https://github.com/clojure/clojure/blob/clojure-1.12.6/src/jvm/clojure/lang/IFn.java> (accessed 2026-11-04)
8. Java Interop. clojure.org. <https://clojure.org/reference/java_interop> (accessed 2026-11-04)
9. JFrame (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JFrame.html> (accessed 2026-11-04)
10. Window.pack() (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/Window.html#pack()> (accessed 2026-11-04)
11. Timer (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/Timer.html> (accessed 2026-11-04)
12. Datatypes: deftype, defrecord, and reify. clojure.org. <https://clojure.org/reference/datatypes> (accessed 2026-11-04)
13. A History of Clojure, section 3.5 "Clojure and the Host". Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, 2020. <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (accessed 2026-11-04)
