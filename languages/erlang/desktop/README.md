# Erlang · desktop: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Erlang](../README.md)

## What this is
A desktop program that opens a small window titled "Hello, World!" with
the text **Hello, World!** in the middle. The window is drawn by **wx**,
which the Erlang documentation describes this way: "The wx application is
an erlang binding of `wxWidgets`" [1]. `wxWidgets` is a C++ library that
"gives you a single, easy-to-use API for writing GUI applications on
multiple platforms" [2]. On macOS, it delivers "Cocoa-based applications"
[2], so the window is a native one.

wx is part of Erlang/OTP: nothing is downloaded, unlike the Flask library
of the [Python web](../../python/web/) version. The program is a compiled
**module**: `erlc` turns `hello_wx.erl` into `ebin/hello_wx.beam`, and
`erl` runs it. Compare the [cli](../cli/) version, which is an escript that
needs no build.

Erlang has no `mainloop()` call as in the [Python desktop](../../python/desktop/)
version. The program is its own event loop: a process that receives
messages, one of which says that the user closed the window.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Erlang/OTP (`erl`, `erlc`) | 29.1.2 (Homebrew `erlang` 29.1.2), as in [../cli](../cli/README.md#prerequisites) | compiles the module and runs it on the BEAM |
| `wx` application | 2.7, part of Erlang/OTP 29.1.2 | the binding to `wxWidgets` |
| `wxWidgets` | 3.2.12 (Homebrew `wxwidgets@3.2`, installed as a dependency of `erlang`) | the C++ toolkit that draws the window |
| A graphical session | macOS desktop | a window cannot open over a plain SSH connection or in a job without a display |

On Intel Macs, Homebrew has no pre-built package (bottle) for `erlang`
[3]. So `brew install erlang` builds Erlang and its dependency
`wxwidgets@3.2` from source. On the test machine (2026-11-01), Erlang took
about 15 minutes, plus about 7 minutes for `wxWidgets`. The `wx` application
is included in the Homebrew package. On Debian, it is a separate package,
`erlang-wx` [4].

## Quick start
```sh
./install.sh   # check / install Erlang/OTP and wx (asks before installing)
./build.sh     # erlc: hello_wx.erl -> ebin/hello_wx.beam
./run.sh       # open the window; close it to end the program
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `erl`, `erlc`, and the `wx` application (`code:lib_dir(wx)` fails when it is absent). If something is missing, offers `brew install erlang` (macOS), `apt-get install erlang erlang-wx` (Debian), or explains how to get the Windows installer [4][5], and runs an install only if you answer `y`. | Building needs the compiler, and running needs `wx`. |
| `build.sh` | Runs `erlc -Wall -o ebin hello_wx.erl`. | The BEAM runs bytecode, not source code. For a `.erl` file, `erlc` "generates a `.beam` file" [6]. `-o` is "The directory where the compiler is to place the output files" [6]. `-Wall` enables all warnings (see `erlc -h`). |
| `run.sh` | Runs `erl +Bd -noshell -pa ebin -s hello_wx main -s init stop`. With `--verify` it sets `TF_VERIFY=1`: the app prints `Hello, World!` once the window is shown and closes itself after about 2 seconds. | `--verify` lets `scripts/verify-all.sh` check a GUI program without a person. |

The options of `erl` in `run.sh` [7]:

- `-noshell`: "Starts an Erlang runtime system with no shell", so the
  terminal stays free.
- `-pa ebin`: "Adds the specified directories to the beginning of the code
  path", so `erl` finds `hello_wx.beam`.
- `-s hello_wx main`: "Makes `init` call the specified function": here,
  `hello_wx:main()`.
- `-s init stop`: when `main/0` returns, `init:stop()` ends the virtual
  machine.
- `+Bd`: "disables the break handler", so Ctrl+C is not caught by the
  emulator's break menu.

## Folder structure
```text
desktop/
├── README.md        this file
├── install.sh       checks / installs Erlang/OTP and wx
├── build.sh         erlc -> ebin/hello_wx.beam
├── run.sh           runs hello_wx:main()
├── hello_wx.erl     the program (teaching comments)
├── screenshot.png   the window on macOS (used below)
├── .gitignore       keeps ebin/ and *.beam out of Git
└── ebin/            created by build.sh; not committed
    └── hello_wx.beam
```
- `ebin/` is the folder for compiled code in the layout that Erlang/OTP
  documents for an application: "`ebin` - Required. Contains the Erlang
  object code, the `.beam` files" [8].

## Step-by-step walkthrough
Open [`hello_wx.erl`](hello_wx.erl) next to this list.

1. **`-module(hello_wx).`** names the module. The name must be the file
   name without `.erl`. `-export([main/0]).` makes `main/0` callable from
   outside, which `run.sh` needs.
2. **`-include_lib("wx/include/wx.hrl").`** reads a header file with the
   constants and records of `wx`, such as `?wxID_ANY` and the `#wx{}`
   record. `?` marks a macro. `-include_lib` finds the file inside the
   installed `wx` application, like `#include <...>` in C.
3. **`Wx = wx:new(),`** starts `wx` and returns a reference to it. `Wx`
   starts with an uppercase letter, so it is a variable, and "a variable
   can only be bound once" [9]. The comma ends an expression and starts
   the next one.
4. **`wxFrame:new(Wx, ?wxID_ANY, "Hello, World!")`** creates the top-level
   window with its title. `?wxID_ANY` means that the program does not care
   about the window's identifier. The original `wxWidgets` "is an
   object-oriented (C++) API and that is reflected in the erlang mapping"
   [1]: `wxFrame` is the C++ class, and the module has a function for each
   of its methods. A double-quoted string is a list of characters [10].
5. **`wxStaticText:new(Frame, ?wxID_ANY, "Hello, World!")`** creates a
   label, text that the user cannot edit.
6. **The sizer.** A sizer lays out the widgets of a window. A vertical box
   sizer stacks them. One stretch spacer above and one below the label put
   it in the middle, and the flag `?wxALIGN_CENTER_HORIZONTAL` centers it
   from side to side. The options are a list of `{Key, Value}` tuples.
   Tuples use curly braces and lists use square brackets [10].
   `wxWindow:setSizer/2` gives the sizer to the window, and
   `wxWindow:setClientSize/3` sets the size of the inner area to 320 by 120
   pixels.
7. **`wxFrame:connect(Frame, close_window)`** asks for the close event.
   The documentation says: "The callback fun is optional, if not supplied
   the event will be sent to the process that called connect/2" [1]. Here
   there is no callback, so the event arrives as a message in the mailbox
   of the process that runs `main/0`. `connect/2` closes nothing by itself.
8. **`wxFrame:show(Frame)`** makes the window visible.
9. **The self-check.** `os:getenv("TF_VERIFY")` returns the text of the
   variable, or `false` when it is not set. A `case` expression picks by
   pattern: "The expression `Expr` is evaluated and the patterns `Pattern`
   are sequentially matched against the result" [9]. With `"1"`, the
   program prints `Hello, World!` and sends itself the atom `verify_done`
   after 2000 ms with `erlang:send_after/3`. Otherwise it does nothing. An
   atom is "a literal, a constant with a name" [10].
10. **`loop(Frame)`** is the event loop. `receive` waits for a message:
    "The `receive` expression searches for a message in the message queue
    that matches one of the patterns" [9]. There are three patterns:
    - `#wx{event = #wxClose{}}` matches a wx event record that holds a
      close event. It destroys the window and the function returns.
    - `verify_done` also destroys the window.
    - `_Other` matches anything else, and the function calls itself.
      Erlang has no `while` loop: a function repeats by calling itself.
      Each process has its own queue of messages [11], and `receive` takes
      the first message that matches.
11. **`wx:destroy()`** stops the `wx` server after the loop, and `main/0`
    returns. `run.sh` then calls `init:stop()`.

**Try it:** change the text in both strings and the numbers in
`setClientSize`, run `./build.sh && ./run.sh`.

## Comparing with the cli
| | [cli](../cli/) | desktop |
|---|---|---|
| Source | an escript, `hello.erl` | a module, `hello_wx.erl`, with `-module` and `-export` |
| Build | none: `escript` compiles in memory [12] | `erlc` writes `ebin/hello_wx.beam` |
| Run with | `escript hello.erl` | `erl -noshell -pa ebin -s hello_wx main -s init stop` |
| Libraries | `io` from the standard library | `wx`, the `wxWidgets` binding |
| Output | a line on the terminal | a label in a native window |
| Ends | after the last expression | when the close message arrives |

## Why this toolchain
- **wx ships with Erlang/OTP.** It is the GUI toolkit of the Erlang
  distribution, so the version needs no download [1].
- **It uses native windows.** `wxWidgets` uses "the native platform's
  controls and utilities" [2], so the window looks like other windows of
  the operating system.
- **A module and `erlc`** show how Erlang code is normally built, which
  the [cli](../cli/) escript hides.
- **The cost: the first install.** On an Intel Mac, `wxwidgets@3.2` is built
  from source with Erlang (see [Prerequisites](#prerequisites)).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Erlang/OTP 29.1.2, `wx` 2.7, `wxWidgets` 3.2.12 from Homebrew. The window title bar is gray in the screenshot because the window was not the active one. |
| macOS Apple Silicon | ⚠️ not verified | `brew install erlang` installs a bottle [3]. Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `erlang` and `erlang-wx` with apt when `erl`, `erlc` or the `wx` application is missing [4]. The window opens on a virtual X display (Xvfb). |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` unpacks the official 64-bit Erlang/OTP zip into `~/.local/otp-29.1.2` when it is missing, as in [../cli](../cli/README.md#platform-notes). The zip includes `wx` [5]. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` opens this window:

![The wx window titled "Hello, World!" showing the text "Hello, World!" in the middle](screenshot.png)

(Taken on 2026-11-04 on macOS Intel, capturing only the window.)

`./run.sh --verify` prints:
```text
==> Open the Hello World window
    WHY: wx asks `wxWidgets` for a native window; the program then waits for its close message.
Hello, World!
```
The window closes by itself after about 2 seconds.

## Sources
1. wx (chapter). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/wx/chapter.html> (accessed 2026-11-04)
2. About `wxWidgets`. `wxWidgets`. <https://www.wxwidgets.org/about/> (accessed 2026-11-04)
3. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (accessed 2026-11-04)
4. `erlang-wx` package in Debian stable. Debian. <https://packages.debian.org/stable/erlang-wx> (accessed 2026-11-04)
5. Downloads. Ericsson AB, erlang.org. <https://www.erlang.org/downloads> (accessed 2026-11-04)
6. erlc. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erlc_cmd.html> (accessed 2026-11-04)
7. `erl` (`-noshell`, `-pa`, `-s`, `+B`). Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erl_cmd.html> (accessed 2026-11-04)
8. Applications (directory structure, `ebin`). Erlang/OTP documentation, Design Principles. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/applications.html> (accessed 2026-11-04)
9. Expressions (variables, `case`, `receive`). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (accessed 2026-11-04)
10. Data types (atom, tuple, list, string). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/data_types.html> (accessed 2026-11-04)
11. Conc prog (processes and message passing). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (accessed 2026-11-04)
12. escript. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/escript_cmd.html> (accessed 2026-11-04)
