# Common Lisp · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Common Lisp](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, [`hello.lisp`](hello.lisp), written in standard **ANSI Common
Lisp** (ANSI INCITS 226-1994 [1]) and built with **SBCL** (Steel Bank
Common Lisp), "a free and open-source ANSI Common Lisp implementation with
a high-performance native Compiler" [2].

The build works differently from the [C `cli` version](../../c/cli/) or
the [Fortran `cli` version](../../fortran/cli/). There is no compiler that turns a
source file into an executable. Instead, SBCL starts, loads `hello.lisp`
into its memory (compiling each function to machine code as it goes), and
then saves its whole memory, the *image*, as the executable
`bin/hello-cli`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| SBCL | 2.6.10 (Homebrew `sbcl`, `/usr/local/bin/sbcl`) | loads `hello.lisp` and saves the executable |

SBCL 2.6.10 was "released October 29, 2026" [3]. On macOS it comes from
Homebrew's `sbcl` formula [4]. Homebrew has pre-built packages (bottles)
for Apple Silicon Macs and Linux, but not for Intel Macs [4], so on an
Intel Mac `brew install sbcl` compiles SBCL from source. SBCL is written
in Lisp and "can be compiled from source code using another
ANSI-compliant Common Lisp implementation" [5], so Homebrew first
installs `ecl` (Embeddable Common Lisp) as a build dependency [4].

## Quick start
```sh
./install.sh   # check / install SBCL (asks before installing)
./build.sh     # load hello.lisp and save the image as bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `sbcl --version`. If it is missing, offers `brew install sbcl` (macOS), `sudo apt-get install -y sbcl` (Debian/Ubuntu), or points to the Windows installer on sbcl.org, and runs a command only if you answer `y`. `SBCL=/path/to/sbcl ./install.sh` checks another command. | SBCL is the only tool needed: the program uses nothing outside the Common Lisp standard. |
| `build.sh` | Runs `sbcl --non-interactive --no-sysinit --no-userinit --load hello.lisp --eval '(sb-ext:save-lisp-and-die "bin/hello-cli" :executable t :toplevel (function main))'` and prints that command (`set -x`). | Loads the program into a running Lisp and saves that Lisp as one executable file. The options are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a CLI program ends by itself). | The executable contains the SBCL runtime, so the operating system runs it directly. SBCL itself is not needed at this point. |

**The options, one by one:**
- `--non-interactive`: "Sets both --quit and --disable-debugger" (from
  `sbcl --help` [6]). `--quit` means "Exit with code 0 after option
  processing" [6]. Without it, SBCL would stop at its REPL prompt and wait
  for you to type. `--disable-debugger` makes an error "print a backtrace
  and exit with status 1" instead of opening the interactive debugger [2],
  so a broken `hello.lisp` makes `build.sh` fail.
- `--no-sysinit` / `--no-userinit`: "Don't load a system-wide
  initialization file" / "Don't load a user initialization file" [2]. Your
  own `~/.sbclrc` cannot change the build.
- `--load hello.lisp`: "equivalent to --eval '(load "<filename>")'" [2].
- `--eval '(...)'`: evaluates one Lisp form. "More than one --eval option
  can be used, and all will be read and executed, in the order they appear
  on the command line" [2].
- `sb-ext:save-lisp-and-die` saves "a 'core image', i.e. enough
  information to restart a Lisp process later in the same state" [2]. The
  name says what it does: save, then exit. It is an SBCL extension
  (package `sb-ext`), not part of the standard.
  - `:executable t`: "combine the SBCL runtime and the core image to
    create a standalone executable" [2].
  - `:toplevel (function main)`: "The function to run when the created
    core file is resumed" [2]. Without it, the executable would start the
    REPL. "This function returning is equivalent to (sb-ext:exit :code 0)
    being called" [2], so the program ends with exit code 0 when `main`
    returns.

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks / installs SBCL
├── build.sh      loads hello.lisp and saves bin/hello-cli
├── run.sh        runs bin/hello-cli
├── hello.lisp    the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- A one-file Lisp program needs no project file: `build.sh` shows the
  SBCL command instead.
- `bin/` and compiled Lisp files (`*.fasl`) are ignored by the root
  `.gitignore`.

## Step-by-step walkthrough
Open [`hello.lisp`](hello.lisp) next to this list.

1. **Comments** start with `;` and run to the end of the line. The number
   of semicolons is a style convention from the standard: `;;;;` for a
   "title for the code which follows", `;;;` "prior to a definition",
   `;;` inside code "aligned to the same level of indentation as a form",
   and `;` at the end of a line [7].
2. **Code is lists.** Everything in parentheses is a list. When Lisp
   evaluates a list whose first element is a symbol, "that symbol is the
   name of an operator" [8], and the other elements are the arguments. So
   `(format t "Hello, World!~%")` calls `format` with two arguments, and
   `(+ 1 2)` is `1 + 2`. Because a program is made of lists, Lisp code can
   read and build other Lisp code: a macro is "a function ... that
   implements macro expansion by producing a form to be evaluated in place
   of the original argument form" [9]. The [web version](../web/) uses one.
3. **`(defun main () ...)`** "Defines a new function named function-name
   in the global environment" [10]. `()` is the empty parameter list. The
   name `main` is a choice of this program: Common Lisp has no required entry point.
   `build.sh` makes `main` the start-up function with `:toplevel`.
4. **`(format t "Hello, World!~%")`** writes the text to standard output.
   - `t` is the destination: the standard output. With `nil` instead,
     `format` returns the text as a string and prints nothing [11].
   - `~%` is a directive: it "outputs a #\Newline character" [12]. In
     `format`, the tilde starts a directive, like `%` in C's `printf` [11].
   - `format` to `t` returns `nil` [11], so `main` returns `nil`. Every
     Lisp form has a value; here nobody uses it.
5. **Functional, but not pure.** Common Lisp is "a multi-paradigm
   programming language" [13], and this repository groups it with the
   functional languages. A function is "an object representing code" [14]:
   `(function main)` in `build.sh` hands the function `main` itself, as a
   value, to `save-lisp-and-die`. But `main` is not a mathematical
   function: its only job is a side effect, printing. The language does
   not stop you; see the [language overview](../README.md) for how this
   compares with Haskell.
6. **Loading is not running.** `sbcl --script hello.lisp` prints nothing:
   `--script` loads the file "instead of entering the read-eval-print-loop,
   and exit[s] afterwards" [2], and loading only *defines* `main`. **Try
   it** with the line from the top of the file, which loads the file and
   then calls `main`:
   `sbcl --noinform --eval '(load "hello.lisp")' --eval '(main)' --quit`.
7. **The image model.** The usual way to work in Lisp is the REPL
   (read-eval-print loop), "where you can interact with SBCL by typing
   expressions" [2]. **Try it:** run `sbcl`, type `(load "hello.lisp")`,
   then `(main)`; change the text in the file, load it again, call `(main)`
   again, and quit with `(quit)`. You changed a running program without
   restarting it. `build.sh` does the same steps without you typing and
   then saves that running Lisp to disk.
8. **What is inside the executable.** `bin/hello-cli` is 36,147,144 bytes
   on the test machine: it is a whole Lisp system (including the compiler
   and the debugger), not only `main`. `otool -L bin/hello-cli` shows two libraries:
   `libSystem.B.dylib` (macOS) and Homebrew's `libzstd.1.dylib`. Homebrew's
   SBCL depends on `zstd` [4], which SBCL uses for compressed core files
   [2], so the executable runs without SBCL but still needs the `zstd`
   package.

## Why this toolchain
- **SBCL is free, maintained, and fast.** It has "a high-performance native
  Compiler" [2] and had a release on 2026-10-29 [3]. It has binaries for
  Linux and Windows and is in Homebrew and Debian [3][4][15].
- **The standard has not changed since 1994.** The language standard is
  still ANSI INCITS 226-1994 [1]. The Common Lisp HyperSpec, the free
  online reference used as a source here, "is not the ANSI Common Lisp
  standard, but is based on that standard" [16]. `hello.lisp` uses only
  standard operators (`defun`, `format`); only `build.sh` uses an SBCL
  extension (`sb-ext:save-lisp-and-die`).
- **One executable, as in the other CLI versions.** Saving the image with
  `:executable t` gives a file that runs like the C or Go programs. The
  price is the size (about 36 MB here), because the whole Lisp system
  comes along.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | SBCL 2.6.10 from Homebrew, built from source (no Intel bottle; builds with `ecl`) [4]. |
| macOS Apple Silicon | ⚠️ not verified | `brew install sbcl` installs a pre-built bottle [4]. Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `sbcl` with apt when missing. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs MSYS2 in `C:\msys64` and installs the UCRT64 package `sbcl` with `pacman` when `sbcl` is missing. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is a saved Lisp image plus the SBCL runtime; the
         operating system runs it, and the image calls MAIN.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Common Lisp Documentation (the standard ANSI INCITS 226-1994). LispWorks. <https://www.lispworks.com/documentation/common-lisp.html> (accessed 2026-11-01)
2. SBCL 2.6.10 User Manual (1 Introduction; 3.3 Command-line Options; 3.6.1 Saving a Core Image; 5.3 Enabling and Disabling the Debugger). SBCL. <https://www.sbcl.org/manual/> (accessed 2026-11-01)
3. Download (platform table: "The most recent version of SBCL is 2.6.10, released October 29, 2026"). SBCL. <https://www.sbcl.org/platform-table.html> (accessed 2026-11-01)
4. `sbcl` formula. Homebrew. <https://formulae.brew.sh/formula/sbcl> (accessed 2026-11-01)
5. Getting Started. SBCL. <https://www.sbcl.org/getting.html> (accessed 2026-11-01)
6. `sbcl --help` (output of SBCL 2.6.10 on the test machine; the same help text is printed by every SBCL 2.6.10 installation). SBCL. <https://www.sbcl.org/> (accessed 2026-11-01)
7. Common Lisp HyperSpec, 2.4.4.2 Notes about Style for Semicolon (and 2.4.4.2.1 to 2.4.4.2.4). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/02_ddb.htm> (accessed 2026-11-01)
8. Common Lisp HyperSpec, 3.1.2.1.2 Conses as Forms. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/03_abab.htm> (accessed 2026-11-01)
9. Common Lisp HyperSpec, Glossary: M ("macro function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_m.htm> (accessed 2026-11-01)
10. Common Lisp HyperSpec, Macro DEFUN. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defun.htm> (accessed 2026-11-01)
11. Common Lisp HyperSpec, Function FORMAT. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_format.htm> (accessed 2026-11-01)
12. Common Lisp HyperSpec, 22.3.1.2 Tilde Percent: Newline. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/22_cab.htm> (accessed 2026-11-01)
13. Common-Lisp.net (home page: "What is Common Lisp?"). Common-Lisp.net. <https://common-lisp.net/> (accessed 2026-11-01)
14. Common Lisp HyperSpec, Glossary: F ("function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_f.htm> (accessed 2026-11-01)
15. Package `sbcl` (trixie). Debian. <https://packages.debian.org/stable/sbcl> (accessed 2026-11-01)
16. About the Common Lisp HyperSpec. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Front/Help.htm> (accessed 2026-11-01)
