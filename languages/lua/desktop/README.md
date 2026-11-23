# Lua · desktop: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Lua](../README.md)

## What this is
A desktop program that opens a small window titled "Hello, World!" with
the text **Hello, World!** in the middle. The window is drawn by LÖVE (also
written Love2D), which describes itself as "a framework you can use to make
2D games in Lua" [1]. Lua has no window toolkit of its own, so a program needs a host that provides one.

**This implementation is a compromise.** [`../cli`](../cli/README.md) and
[`../web`](../web/README.md) run on Lua 5.5, the current version [2]. LÖVE 11.5 embeds LuaJIT, a separate implementation of the language that is "fully
upwards-compatible with Lua 5.1" [3]. So `main.lua` runs in the Lua 5.1 dialect, not in Lua 5.5. The program prints its Lua version when it starts (see [Expected output](#expected-output)): `Lua 5.1` and a LuaJIT version. The Hello World code
is the same in both dialects: only the version differs. 

LÖVE works in a different style from [`../cli`](../cli/README.md). Your
program does not start the window and does not run a loop. LÖVE is the
program: it starts, reads `conf.lua`, creates the window, and then runs its
own main loop, which calls functions that you define with fixed names
(`love.load`, `love.update`, `love.draw`) [4]. This is the *callback*
model: you supply the functions, and the framework decides when to call
them.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| LÖVE (`love`) | 11.5, the official macOS zip [5] | runs `main.lua`; it contains LuaJIT and the code for windows and graphics |
| curl | system curl | only for `install.sh`, which downloads the zip |
| `shasum`, `unzip` | system tools | `install.sh` checks the checksum and unpacks the zip |

You do not need the `lua` program of [`../cli`](../cli/README.md): LÖVE has
its own copy of the language.

## Quick start
```sh
./install.sh   # check LÖVE; on macOS download it into vendor/ (asks first)
./run.sh       # open the window; close it to end the program
```
`./run.sh --verify` is a self-check: it opens the window, prints
`Hello, World!`, and closes the window after about 2 seconds.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `love-env.sh` | Sets the LÖVE version (11.5), the download address, the SHA-256 checksum of the zip, and the path of the `love` program. It is sourced by the other two scripts, not run. | `install.sh` and `run.sh` must agree on these values, so they live in one file. |
| `install.sh` | 1. Checks whether `love` can be run. 2. On macOS: asks, downloads `love-11.5-macos.zip` from the LÖVE releases on GitHub into `vendor/`, checks its checksum, and unpacks `love.app` there. On Debian and Ubuntu: runs `sudo apt-get install -y love` after asking. On Windows: shows where to download LÖVE. | LÖVE is not part of Lua, and each system packages it differently. The macOS download stays inside this folder: nothing goes into `/Applications`, and no `sudo` is needed. |
| `run.sh` | Runs `love .`, which starts LÖVE on this folder. With `--verify` it sets `TF_VERIFY=1` first. | LÖVE takes a folder with a `main.lua` as its argument. `main.lua` reads `TF_VERIFY` and, when it is `1`, prints the greeting and quits after about 2 seconds, so `scripts/verify-all.sh` does not wait for a person to close the window. |

There is no `build.sh`: LÖVE runs the Lua source directly, as in the
[cli](../cli/README.md#why-there-is-no-build-step).

The release page of LÖVE publishes no checksum for the zip. The checksum in
`love-env.sh` was computed from the download and compared with the one that
the Homebrew cask `love` lists for the same file [6].

## Folder structure
```text
desktop/
├── README.md        this file
├── install.sh       checks / downloads LÖVE
├── run.sh           opens the window
├── love-env.sh      version, address, and checksum of LÖVE (sourced)
├── main.lua         the program: love.load, love.update, love.draw
├── conf.lua         window settings: love.conf
├── screenshot.png   the window, for "Expected output" below
├── .gitignore       keeps vendor/ out of git
└── vendor/          created by install.sh (the zip and love.app); not committed
```
- A LÖVE program is a folder with a `main.lua` at its top level. LÖVE
  reports "No code to run" and the advice to "Make sure main.lua is at the
  top level" when it is missing [7].
- `conf.lua` is optional. When it exists, LÖVE loads it before it creates
  the window, so it can change the window settings [7].
- Larger games add folders for images, sounds, and Lua modules; a single
  window needs only these two files.

## Step-by-step walkthrough
Open [`main.lua`](main.lua) and [`conf.lua`](conf.lua) next to this list.

1. **`conf.lua`: `function love.conf(t) ... end`.** LÖVE runs this file
   first. It calls `love.conf` with a table `t` that holds the default
   settings, and the function changes only what it needs [7]. Here it sets
   the title and the size of the window (480 by 200 pixels). A *table* is
   the only data structure of Lua, and `t.window.title` reads a field of a
   field of it.
2. **`local verify = os.getenv("TF_VERIFY") == "1"`** reads an environment
   variable. It is `true` only in the self-check of `run.sh --verify`.
3. **`function love.load()`** is called once, after the window exists [4].
   It prints `_VERSION` and `jit.version`, which show the dialect of the
   compromise (the second value exists only in LuaJIT). Then it creates a
   32-pixel font and makes it the current font with
   `love.graphics.setFont`.
4. **`function love.update(dt)`** is called on every frame with `dt`, the
   seconds since the previous frame [4]. A game keeps its logic here. The
   greeting has none; the function only counts the seconds in verify mode
   and calls `love.event.quit()` after two of them.
5. **`function love.draw()`** is called on every frame after `love.update`
   [4]. LÖVE clears the window before each call, so the function draws
   everything again. `love.graphics.printf("Hello, World!", 0, y, width,
   "center")` draws the text in a box as wide as the window, centered, and
   `y` puts one line of text in the vertical middle.
6. **Why a function that runs 60 times a second draws one sentence.** A
   desktop toolkit such as tkinter ([Python](../../python/desktop/README.md))
   or Swing ([Java](../../java/desktop-swing/README.md)) builds a tree of
   widgets once and keeps it. A game loop keeps no widgets: it redraws the
   scene on every frame. This is also why the program has no
   `mainloop()` or `launch()` call: LÖVE owns the loop (see the `love.run`
   function in [4]).

## Why this toolchain
- **Lua has no standard window toolkit.** The standard libraries in the reference manual cover strings, tables, math, input and output, and the operating system, and none draws a window [2]. A Lua program that wants a window needs a host that provides one.
- **LÖVE is a Lua-first framework.** Its home page presents it as a
  framework for making 2D games in Lua, free and open source, for Windows,
  macOS, Linux, Android, and iOS, under the zlib/libpng license [1]. The Lua authors write that Lua "is one of the leading scripting languages in game development" [8], so a game framework fits a main use of the language.
- **Version 11.5** is the version that the LÖVE site offers for download on
  2026-11-04 [1].
- **The compromise.** LÖVE 11.5 runs LuaJIT, which implements Lua 5.1 [3]. This repository did not find a window library for Lua 5.5 that it could document as maintained and verify, so LÖVE was kept. The language [overview](../README.md#comparing-the-categories) states the difference.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | LÖVE 11.5 from the official zip, unpacked into `vendor/`.  `run.sh` starts the program inside the app bundle directly. |
| macOS Apple Silicon | ⚠️ not verified | The official zip is a universal app, so the same commands should apply. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `love` with apt when it is missing [9]. The window opens on a virtual X display (Xvfb). |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` downloads the official LÖVE 11.5 64-bit zip [5] into `vendor/` and checks its SHA-256 checksum. CI does not run it: the GitHub `windows-latest` runner has no GPU, and LÖVE needs OpenGL 2.1 or later [10]. WSL needs a graphical (WSLg) session. |

## Expected output
`./run.sh` opens this window:

![The LÖVE window titled "Hello, World!" showing the text "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 on macOS Intel with `screencapture -x -o -l <window-id> screenshot.png`,
which captures only that window. The window is 480 by 200 points, and the
image is 960 by 456 pixels because of the Retina display.)

`./run.sh --verify` prints:
```text
==> Open the Hello World window
    WHY: 'love .' starts LÖVE, which runs conf.lua and main.lua from this folder.
Lua 5.1	LuaJIT 2.1.1700008891
Hello, World!
```
The line with the versions is printed by `love.load`.

## Sources
1. LÖVE: free 2D game engine. LÖVE Development Team. <https://love2d.org/> (accessed 2026-11-04)
2. Lua 5.5 Reference Manual. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. <https://www.lua.org/manual/5.5/manual.html> (accessed 2026-11-04)
3. LuaJIT Extensions. Mike Pall. <https://luajit.org/extensions.html> (accessed 2026-11-04)
4. `src/modules/love/callbacks.lua`, tag 11.5 (function `love.run`). LÖVE. <https://github.com/love2d/love/blob/11.5/src/modules/love/callbacks.lua> (accessed 2026-11-04)
5. LÖVE 11.5 release. LÖVE (GitHub). <https://github.com/love2d/love/releases/tag/11.5> (accessed 2026-11-04)
6. love: Homebrew cask. Homebrew. <https://formulae.brew.sh/cask/love> (accessed 2026-11-04)
7. `src/modules/love/boot.lua`, tag 11.5. LÖVE. <https://github.com/love2d/love/blob/11.5/src/modules/love/boot.lua> (accessed 2026-11-04)
8. The Evolution of Lua. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. HOPL III, ACM, 2007. <https://www.lua.org/doc/hopl.pdf> (accessed 2026-11-04)
9. love: Debian package. Debian. <https://packages.debian.org/stable/love> (accessed 2026-11-04)
10. `readme.md`, tag 11.5 (Dependencies). LÖVE. <https://github.com/love2d/love/blob/11.5/readme.md> (accessed 2026-11-05)
