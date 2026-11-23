# Delphi · desktop: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Delphi](../README.md)

> 🔶 The source is the Delphi dialect of Object Pascal, compiled by Free Pascal
> 3.2.2 (`{$mode delphi}`) with the Lazarus 4.8 component library (LCL); Embarcadero
> Delphi itself is not used.

## What this is
A desktop program, written in the Delphi dialect, that opens one window titled
`Hello, World!` with the same text in its center. The window is a form, a class
that inherits from `TForm`, and the text is a `TLabel` component.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Free Pascal (`fpc`) | 3.2.2 (official macOS installer, SHA-256 checked) | compiles the program; Lazarus calls it |
| Lazarus `lazbuild` | 4.8 (source archive, SHA-256 checked, `make lazbuild`) | reads `hello.lpi` and builds the LCL and the program |
| Apple command-line tools | from macOS | the linker and assembler that `fpc` calls |

## Quick start
```sh
./install.sh   # check / install Free Pascal 3.2.2 and lazbuild 4.8 (asks before each install)
./build.sh     # build hello.lpi into build/hello (the first build also compiles the LCL)
./run.sh       # open the window; close it to end the program
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `fpc`, then `lazbuild`. On macOS it installs Free Pascal from the official installer and builds `lazbuild` from the Lazarus 4.8 source archive (`make lazbuild`). Both downloads are checked with SHA-256 | the project is built by Lazarus's own builder |
| `build.sh` | Runs `lazbuild --lazarusdir=… --pcp=… --bm=Default hello.lpi` | `lazbuild` reads the project file, so the units, packages and widget set are not typed by hand |
| `run.sh` | Runs `build/hello`. `--verify` sets `TF_VERIFY=1`: the program prints `Hello, World!` and closes its window after about 2 seconds | `verify-all.sh` must be able to finish by itself |
| `lazarus-env.sh` | Sets the Free Pascal and Lazarus versions, digests, folders and the `lazbuild` options (sourced, not run) | shared by all three scripts |

## Folder structure
```text
desktop/
├── README.md          this file
├── install.sh         checks / installs fpc and lazbuild
├── lazarus-env.sh     versions, SHA-256 digests, folders (sourced)
├── build.sh           runs lazbuild on hello.lpi
├── run.sh             runs build/hello (--verify = TF_VERIFY=1)
├── hello.lpi          the Lazarus project (LCL, Cocoa widget set, build mode Default)
├── hello.lpr          the program (Delphi dialect, one form class)
├── screenshot.png     the window on macOS (used below)
└── build/             generated files, ignored by git
```
Project format reference: the example projects in the Lazarus 4.8 source archive
(`examples/pen_brush/project1.lpi`).

## Step-by-step walkthrough
`hello.lpr` in order:

1. **`program hello;`** and **`{$mode delphi}{$H+}`**. The mode selects the Delphi
   dialect; `{$H+}` makes `String` a long string.
2. **`uses Interfaces, ...`**. `Interfaces` must be the first unit: it connects the
   LCL to the Cocoa widget set on macOS. The other units are the LCL's forms,
   controls, graphics, standard controls and the `SysUtils` helpers.
3. **`TMainForm = class(TForm)`** declares the window. Its fields hold the label
   and a timer, and `CloseTimerFired` is an event handler (a method).
4. **`constructor TMainForm.Create`** calls `inherited Create` first, sets the
   title and size, and creates a `TLabel` with `Parent := Self` (a child component
   belongs to its parent form).
5. **`GetEnvironmentVariable('TF_VERIFY') = '1'`**: in verify mode the program
   prints the line and starts a `TTimer` that calls `Close` after 2 seconds.
6. **`Application.CreateForm(TMainForm, MainForm)`** creates the form, and
   **`Application.Run`** runs the event loop until the main form closes.

Differences from other languages in this repository: the window is a class
with event methods (not a function), and the project file (`hello.lpi`) is
separate from the source. Compare [Pascal desktop](../../pascal/desktop/README.md),
which uses the same LCL.

## Why this toolchain
- **Lazarus** is a free IDE and component library (LCL) for Free Pascal [1][2].
- **Free Pascal 3.2.2** compiles the program [3]; Lazarus 4.8 is released with it [2].
- **Delphi** (Embarcadero; paid editions and a free Community Edition [4]) is
  what the dialect is named after. It is not used here [4].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | `build.sh`, `run.sh --verify`, and the window screenshot below. `install.sh` ran on the fast path (lazbuild present) |
| macOS Apple Silicon | ⚠️ not verified | the same steps; not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` installs `fpc`, `lazarus` and `libgtk2.0-dev` with `apt-get`. The project file selects Cocoa, so `hello.lpi` must be changed to `gtk2` first (not tested) |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` stops and links to the Free Pascal and Lazarus download pages. Not run |

## Expected output
`./run.sh` opens this window (the title bar and the text are both `Hello, World!`):

![The Lazarus LCL window titled "Hello, World!" with the text "Hello, World!" centered in it](screenshot.png)

The screenshot was taken on 2026-11-10 on macOS Intel with
`screencapture -x -o -l <window-id> screenshot.png`, which captures only that window
(the window id was found with a small Swift script that reads the window list).

`./run.sh --verify` prints the line and exits after about 2 seconds:
```text
Hello, World!
```

## Sources
1. Lazarus home page (LCL, Lazarus 4.8). Lazarus. <https://www.lazarus-ide.org/> (accessed 2026-11-10)
2. Lazarus downloads (the source archive used by install.sh, "Lazarus 4.8 which is accompanied by FPC 3.2.2"). Lazarus. <https://www.lazarus-ide.org/index.php?page=downloads> (accessed 2026-11-10)
3. Free Pascal home page and User's Guide (compiler modes, Delphi mode). Free Pascal. <https://www.freepascal.org/> and <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (accessed 2026-11-10)
4. Embarcadero Delphi product page. Embarcadero Technologies. <https://www.embarcadero.com/products/delphi> (accessed 2026-11-20)
