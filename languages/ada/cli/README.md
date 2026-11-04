# Ada · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Ada](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. The
program is one Ada procedure, [`src/hello.adb`](src/hello.adb), compiled as
**Ada 2022** (ISO/IEC 8652:2023 [1]) by **GNAT**, the Ada compiler of GCC
[2]. The folder is an **Alire crate**: Alire is "a source-based package
manager for the Ada and SPARK programming languages" [3]. It downloads the
compiler and builds the program, much like Cargo does in
[Rust](../../rust/cli/).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Alire (`alr`) | 2.1.1 (official release archive, in `~/.local/bin`) | installs the toolchain and builds the crate |
| GNAT (`gnat_native`, installed by Alire) | 16.2.0 | the Ada compiler |
| GPRbuild (`gprbuild`, installed by Alire) | 26.0.1 | the build tool that reads `hello.gpr` |
| curl and unzip | macOS system tools | only to download Alire the first time |

Alire keeps the toolchain in its own folder (`~/.local/share/alire`; about
700 MB on the development machine), not in system folders, so nothing needs `sudo`.
The compiler is not on PATH: `alr` calls it. `alr exec -- gnat --version`
shows it.

## Quick start
```sh
./install.sh   # check / install Alire and the GNAT toolchain (asks first)
./build.sh     # alr build: compile, bind and link into bin/hello
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. If `alr` is missing, shows the `curl` and `unzip` commands that put the official Alire 2.1.1 release in `~/.local/bin` and runs them only if you answer `y` (Windows: links the official installer). 2. If `alr toolchain` shows no default `gnat_native`, offers `alr -n toolchain --select`, which downloads GNAT and GPRbuild. | Alire's docs: "Once the archive is extracted you have to add `alr` in the environment `PATH`" [3]. ada-lang.io: "By far the easiest way to get hold of an Ada toolchain is to use the Ada package manager Alire" [4]. |
| `build.sh` | Runs `alr -n build` (`-n`: non-interactive, take default answers). | Alire regenerates `config/` from `alire.toml`, then GPRbuild compiles, binds and links. |
| `run.sh` | Runs `./bin/hello`. `--verify` does the same (a cli program ends by itself). | The executable is machine code, so the operating system runs it directly. |

`alr run` would build and run in one step: "This will build and then
launch the resulting executable" [3]. `run.sh` runs the file instead, to
show that it needs nothing else.

## Folder structure
```text
cli/
├── README.md       this file
├── install.sh      checks / installs Alire and GNAT
├── build.sh        alr build
├── run.sh          runs bin/hello
├── alire.toml      Alire manifest: crate name, executable, Ada 2022
├── hello.gpr       GNAT project file: sources, main, output folders
├── .gitignore      generated folders (made by alr init)
├── src/
│   └── hello.adb   the program
└── (generated, not committed)
    ├── config/     settings generated from alire.toml on each build
    ├── obj/        compiled units: hello.o, hello.ali
    ├── alire/      Alire's local state for this crate
    └── bin/hello   the executable
```
- This is the layout that `alr init --bin hello` creates, as the Alire
  documentation describes it [3]. The folder was made with
  `alr init --in-place --bin hello`. Then `alire.toml` was trimmed and every
  file was commented.
- `hello.gpr` is a GNAT project file: "A text file expressed in an Ada-like
  syntax, generally with the .gpr extension", which "defines build-related
  characteristics of an application" [5].
- GNAT's file naming: "The file extension is .ads for a spec and .adb for a
  body", and the file name is the unit name "using lowercase for all
  letters" [6]. So `procedure Hello` lives in `hello.adb`.

## Step-by-step walkthrough
Open [`src/hello.adb`](src/hello.adb) next to this list.

1. **Comments** start with `--` and run to the end of the line. Ada has no
   block comment.
2. **`with Ada.Text_IO;`** is a context clause: "with is used to reference
   external modules that are needed in the procedure" [7]. `Ada.Text_IO` is
   the standard text input/output package. Compare C's `#include
   <stdio.h>`, which pastes text, and Go's `import "fmt"`.
3. **`procedure Hello is ... begin ... end Hello;`** is the main program.
   The standard says "an implementation is required to support all main
   subprograms that are public parameterless library procedures" [8]. There
   is no fixed name like C's `main`: `hello.gpr` says `for Main use
   ("hello.adb");`. Declarations would go between `is` and `begin`.
   `end Hello` repeats the name, so the compiler checks that the right block
   is closed.
4. **`Ada.Text_IO.Put_Line ("Hello, World!");`** "Calls the procedure Put
   for the given string, and then the procedure New_Line with a spacing of
   one" [9]: it writes the text and a line break, like Python's `print`.
   The full name says which package `Put_Line` comes from. A `use
   Ada.Text_IO;` clause would allow the short name.
5. **Build: compile, bind, link.** `alr build` shows three phases:
   `Compile` (GNAT turns `hello.adb` into `hello.o` and `hello.ali`, a file
   with the unit's dependency information), `Bind` and `Link`. The binder,
   `gnatbind`, "Checks that a program is consistent, in accordance with the
   rules in Chapter 10 of the Ada Reference Manual" and "Generates a main
   program incorporating the given elaboration order" [12]. The bind step
   is special to Ada; C, Fortran and COBOL go straight from compile to
   link.
6. **Look at the result.** `otool -L bin/hello` shows only
   `/usr/lib/libSystem.B.dylib`: GNAT's Ada runtime is linked into the
   executable (408,808 bytes on the development machine), so it does not need the
   compiler's libraries to run. Compare [COBOL](../../cobol/cli/), which
   loads `libcob` at run time.
7. **Try it:** in `src/hello.adb` change `Put_Line` to `Put_Lin` and run
   `./build.sh`. GNAT stops with `"Put_Lin" not declared in "Text_IO"` and
   even suggests `possible misspelling of "Put_Line"`. Restore it and build
   again.

**The compiler switches.** `alire.toml` asks for `ada_version = "Ada2022"`,
which becomes the GNAT switch `-gnat2022` in the generated
`config/hello_config.gpr`. Alire's default development profile also adds
all warnings (`-gnatwa`), validity checks (`-gnatVa`) and style checks
(`-gnaty...`: indentation of 3, casing of keywords, ...). That is why
`hello.adb` is indented by 3 spaces: indent `Put_Line` by 2 and the build
prints `(style) bad indentation` (a warning; the build still succeeds).

## Why this toolchain
- **GNAT is the maintained, free Ada compiler.** It is part of GCC: "The
  GNU Compiler Collection includes front ends for C, C++, Objective-C,
  Objective-C++, Fortran, Ada, Go, D, Modula-2" [2]. AdaCore, which
  maintains it, "was born following a 16-year gestation at New York
  University" [10].
- **Alire is the recommended way to get it.** The community site
  ada-lang.io says Alire is "by far the easiest way to get hold of an Ada
  toolchain" [4], and its getting-started guide uses `alr toolchain
  --select` to pick `gnat_native` and `gprbuild` [4]. Homebrew has no Alire
  formula (checked 2026-11-01), so the official release archive is used [11].
- **Ada 2022, the current edition.** This repository targets Ada 2012/2022.
  The current standard "was published as ISO/IEC 8652:2023 in May 2023"
  and "replaces the edition of 2012" [1]. Nothing in a Hello World differs
  between the two editions. It is *not* valid Ada 83, though: compiled
  with `-gnat83`, GNAT reports `(Ada 83) child units not allowed` for
  `Ada.Text_IO`. In Ada 83 the package was named `Text_IO`. The current
  standard still accepts the old name through a renaming, `package Text_IO
  renames Ada.Text_IO;`, listed in Annex J, "Obsolescent Features" [13].
- **Era context.** Ada was designed for the US Department of Defense in
  the late 1970s (see the [language README](../README.md#history)).
  GNAT is a maintained compiler that still accepts the old editions (GNAT
  has `-gnat83`, `-gnat95`, `-gnat2005`, `-gnat2012` and `-gnat2022` modes
  [12]).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | Alire 2.1.1 (`alr-2.1.1-bin-x86_64-macos.zip`), GNAT 16.2.0, GPRbuild 26.0.1. Linking uses Apple's Command Line Tools. |
| macOS Apple Silicon | ⚠️ not verified | `install.sh` picks `alr-2.1.1-bin-aarch64-macos.zip` [11]. Same commands. |
| Linux (x86_64 / aarch64) | ⚠️ not verified | `install.sh` picks `alr-2.1.1-bin-x86_64-linux.zip` or `-aarch64-linux.zip`; an AppImage is also published [11]. `~/.local/bin` must be on PATH. |
| Windows (Git Bash / WSL) | ⚠️ not verified | "On Windows an installer is provided" [3]: `alr-2.1.1-installer-x86_64-windows.exe` [11]. Then `alr toolchain --select`, `alr build`, and run `bin\hello.exe`. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello is machine code; the operating system runs it directly.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Ada Reference Manual, 2022 Edition: Foreword. Ada Resource Association / ISO/IEC JTC1/SC22/WG9. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-0-1.html> (accessed 2026-11-01)
2. GCC, the GNU Compiler Collection (home page). Free Software Foundation. <https://gcc.gnu.org/> (accessed 2026-11-01)
3. Alire documentation (installation, getting started, toolchains). Alire project. <https://alire.ada.dev/docs/> (accessed 2026-11-01)
4. Getting started: Installation. ada-lang.io. <https://ada-lang.io/docs/learn/getting-started/installation> (accessed 2026-11-01)
5. GPRbuild and GPR Companion Tools User's Guide: GNAT Project Manager. AdaCore. <https://docs.adacore.com/gprbuild-docs/html/gprbuild_ug/gnat_project_manager.html> (accessed 2026-11-01)
6. GNAT User's Guide: The GNAT Compilation Model (File Naming Rules). AdaCore. <https://docs.adacore.com/gnat_ugn-docs/html/gnat_ugn/gnat_ugn/the_gnat_compilation_model.html> (accessed 2026-11-01)
7. Introduction to Ada: Imperative Language. AdaCore (learn.adacore.com). <https://learn.adacore.com/courses/intro-to-ada/chapters/imperative_language.html> (accessed 2026-11-01)
8. Ada Reference Manual, 2022 Edition: 10.2 Program Execution. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-10-2.html> (accessed 2026-11-01)
9. Ada Reference Manual, 2022 Edition: A.10.7 Input-Output of Characters and Strings. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-A-10-7.html> (accessed 2026-11-01)
10. 20 Years On... AdaCore blog. <https://www.adacore.com/blog/20-years-on> (accessed 2026-11-01)
11. Alire releases, v2.1.1 (2026-05-29). GitHub, `alire-project/alire`. <https://github.com/alire-project/alire/releases/tag/v2.1.1> (accessed 2026-11-01)
12. GNAT User's Guide: Building Executable Programs with GNAT (compiler switches -gnat83 ... -gnat2022; Binding with `gnatbind`). AdaCore. <https://docs.adacore.com/gnat_ugn-docs/html/gnat_ugn/gnat_ugn/building_executable_programs_with_gnat.html> (accessed 2026-11-01)
13. Ada Reference Manual, 2022 Edition: Annex J Obsolescent Features, "J.1 Renamings of Library Units". <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-J-1.html> (accessed 2026-11-01)
