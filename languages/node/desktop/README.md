# Node.js · desktop: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Node.js](../README.md)

## What this is
A desktop program that opens a small window titled "Hello, World!" with the
heading **Hello, World!** inside. It is built with **Electron**, "a
framework for building desktop applications using JavaScript, HTML, and
CSS" [1]. Node.js has no window toolkit of its own, so the window comes
from Electron, an npm package that `install.sh` downloads.

The window's content is a web page ([`index.html`](index.html)). Electron
works "by embedding Chromium and Node.js into its binary" [1]: Chromium,
the open-source browser engine behind Google Chrome, draws the page, and Node.js runs
[`main.js`](main.js), which creates the window. Compare
[../../python/desktop](../../python/desktop/) (tkinter) and
[../../go/desktop](../../go/desktop/) (Fyne), which draw their widgets
without a browser engine.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Node.js 22.12 or newer, with npm | Node.js 26.8.2, npm 12.2.1 (nvm) | npm installs Electron; the `electron` package's `"engines"` field asks for `node >= 22.12.0` |
| Electron | 45.2.1 (locked in `package-lock.json`) | the desktop framework; `install.sh` installs it into `node_modules/` |
| macOS 13 (Ventura) or newer, or Windows 10 or newer | macOS 26.7.2 | Electron's binaries support "macOS (Ventura and up)" and "Windows (Windows 10 and up)" [2] |

Electron brings **its own** Node.js and Chromium. On the development machine,
`ELECTRON_RUN_AS_NODE=1 node_modules/.bin/electron -p process.versions`
reports Node.js 24.22.1 and Chromium 156.0.8078.75, while the `node`
command is 26.8.2. So `main.js` runs on Electron's Node.js 24, not on the
Node.js you installed; that one is only used by npm and to start Electron.

## Quick start
```sh
./install.sh   # check Node.js, install Electron (asks before each download)
./run.sh       # open the window; close it with Cmd+Q (macOS) or Ctrl+C here
```
`npm start` also works: it runs the `start` script of `package.json`,
`electron .`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks for Node.js 22.12+ and npm, and shows how to install them if missing. 2. Runs `npm ci`, which installs the exact versions in `package-lock.json` into `node_modules/`. 3. Runs `npx --no install-electron`, which downloads the Electron program (about 125 MB zipped, 270 MB unpacked on the development machine). Steps 2 and 3 ask first. | Since Electron 42, "`electron` no longer downloads itself via `postinstall` script"; instead, "Electron will now download itself dynamically the first time that its main `bin` script is run", or "you can now call the `install-electron` script, which contains the exact same code from the former `postinstall` script" [3]. Doing it in `install.sh` means `run.sh` never starts a large download on its own. |
| `run.sh` | Runs `node_modules/.bin/electron .`. `--verify` sets `TF_VERIFY=1`: once the page has loaded, the app prints the heading's text and quits after about 2 seconds. | `electron .` reads `package.json`, runs the file named in `"main"` and opens the window. There is no build step. |

There is no `build.sh`: Electron runs `main.js` and `index.html` as they
are. To give the app to other people you would package it with a tool
such as Electron Forge, "an all-in-one tool for packaging and distributing
Electron applications" [4]; a Hello World run from its folder does not
need it.

## Folder structure
```text
desktop/
├── README.md          this file
├── install.sh         checks Node.js, installs Electron
├── run.sh             opens the window
├── main.js            the main process: creates the window
├── index.html         the page shown inside the window
├── package.json       the project: entry point ("main"), start script, Electron as a dev dependency
├── package-lock.json  the exact version of every installed package (written by npm)
├── screenshot.png     the window, for "Expected output" below
└── node_modules/      created by install.sh; not committed (see ../../../.gitignore)
```
- **`main.js` + `index.html` + `package.json`** is the layout of
  Electron's own first-app tutorial, with `"main": "main.js"` and
  `"start": "electron ."` in `package.json` [5].
- **`"devDependencies"`**: Electron is listed there, as the Electron README
  recommends: "The preferred method is to install Electron as a
  development dependency in your app" [2].
- **`package-lock.json`** and **`node_modules/`** work as in
  [../web](../web/README.md#folder-structure). Here `node_modules/` is
  about 284 MB, almost all of it the Electron program in
  `node_modules/electron/dist/`. Compare 3.8 MB for Express.

## Step-by-step walkthrough
Open [`main.js`](main.js) and [`index.html`](index.html) next to this list.

1. **Two processes.** "The main process runs in a Node.js environment,
   meaning it has the ability to `require` modules and use all of Node.js
   APIs" [6]; that is `main.js`. "Each Electron app spawns a separate
   renderer process for each open `BrowserWindow`" [6]; that one shows
   `index.html`, and "the renderer has no direct access to `require` or
   other Node.js APIs" [6]. Electron uses this two-process design even for a Hello World.
2. **`const { app, BrowserWindow } = require("electron/main")`** loads two
   objects from Electron with *destructuring*. The tutorial shows
   `require('electron')` and also the `electron/main` form [5].
3. **`createWindow`** is an arrow function stored in a constant.
   `new BrowserWindow({ width: 320, height: 160 })` creates the window and
   `win.loadFile("index.html")` shows the page in it.
4. **`index.html`** is ordinary HTML. The window title comes from
   `<title>`, the text from `<h1 id="greeting">`. Its
   `Content-Security-Policy` line follows Electron's security checklist,
   item 7, "Define a Content Security Policy" [7]. Two other items of that
   checklist are already the defaults: Node.js integration is off for
   pages ("the default behavior in Electron since 5.0.0") and context
   isolation is on ("the default behavior in Electron since 12.0.0") [7].
5. **`app.whenReady().then(...)`** waits for Electron to start; windows
   cannot be created before that. `whenReady()` returns a *Promise*, a
   value that arrives later.
6. **`window-all-closed` and `activate`** are the platform conventions the
   tutorial adds: quit when the last window closes, except on macOS
   (`darwin`), and reopen a window when the Dock icon is clicked [5].
7. **The self-check** (only with `TF_VERIFY=1`, used by `./run.sh
   --verify`): on the `did-finish-load` event, `main.js` checks that the
   window is visible, asks the renderer for the heading's text with
   `executeJavaScript` (an `async`/`await` call), prints it and quits
   2 seconds later. 14 of the 32 lines of code in `main.js` are this check.

There is no loop to write: as with tkinter's `mainloop()` and Fyne's
`ShowAndRun()`, Electron runs the event loop and calls your functions
when events happen.

## Why this toolchain
Node.js has no desktop toolkit of its own, so this folder uses
**Electron**. The reasons, with their sources:

- **It is a Node.js desktop framework.** The app's own code runs in a
  Node.js environment [6], so this is still a Node.js program, with
  `require`, npm and `package.json`, like [../cli](../cli/) and
  [../web](../web/). Tauri, an alternative, is "built on Rust"
  [8]: its native side is written in Rust, which would make it a Rust
  program, not a Node.js one.
- **It is used by many applications.** Electron's home page lists, among
  others, 1Password, Discord, Figma, GitHub Desktop, Notion, Obsidian,
  Postman, Signal, Slack, Trello, and VS Code as "Apps users love, built
  with Electron" [9]. This is the Electron project's own list, not an independent
  survey. The 2026 Stack Overflow Developer Survey does not ask about
  desktop frameworks (neither Electron nor Tauri is in its web
  frameworks list) [10], so no market-share number is given here.
- **It is maintained under a foundation.** "Electron is an open-source
  project under the OpenJS Foundation" [9], which lists it as an "Impact
  Project" [11], next to Node.js itself. A new major version comes out
  every 8 weeks and "the latest three stable major versions are supported
  by the Electron team" [12].
- **Version 45** became stable on 2026-10-20 (Chromium M156, Node.js
  v24.22.0) [13]; 45.2.1 was the latest release on GitHub on 2026-10-31
  [14]. Electron 46 was still in alpha [13][14].
- **Costs.** Every Electron app ships its own Chromium and
  Node.js [1], so even this Hello World needs a download of about 125 MB and
  about 270 MB on disk. Tauri avoids that by using "the web view already
  available on every user's system" [8]. NW.js (previously node-webkit)
  is another Node.js option; it "lets you call all Node.js modules
  directly from DOM" [15]. For a repository that teaches Node.js, the size
  is accepted in exchange for writing the whole app in JavaScript and
  HTML with the framework of the Electron project.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Node.js 26.8.2 (nvm), npm 12.2.1, Electron 45.2.1 (`electron-v45.2.1-darwin-x64.zip`). |
| macOS Apple Silicon | ⚠️ not verified | Same commands. `install-electron` downloads the `arm64` build; Electron provides "64-bit Intel and Apple Silicon / ARM binaries for macOS" [2]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` does not install Node.js: if version 22.12 or newer is missing it prints the nodejs.org steps and stops. It runs `npm ci`, then `npx --no install-electron` to download the Electron program. Electron provides `x64` and `arm64` Linux binaries [2]. A window needs a graphical session. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install Node.js: if version 22.12 or newer is missing it prints `winget install --id OpenJS.NodeJS.LTS -e` and stops. It runs `npm ci`, then `npx --no install-electron` to download the Electron program. Electron needs Windows 10 or newer [2]. WSL not verified; it behaves like Linux, and a window needs WSLg or an X server. |

## Expected output
`./run.sh` opens this window:

![The Electron window titled "Hello, World!" showing the heading "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 on macOS Intel with `screencapture -x -o -l <window-id> screenshot.png`,
which captures only that window.)

`./run.sh --verify` prints:
```text
==> Open the Hello World window
    WHY: 'electron .' runs main.js in Electron's main process; main.js opens
         a window whose content (index.html) is drawn by Chromium.
Hello, World!
```

## Sources
1. Introduction. Electron Docs. <https://www.electronjs.org/docs/latest> (accessed 2026-10-31)
2. electron/electron (README: Installation, Platform support). GitHub. <https://github.com/electron/electron/blob/main/README.md> (accessed 2026-10-31)
3. Breaking Changes (42.0: `electron` no longer downloads itself via `postinstall` script). Electron Docs. <https://www.electronjs.org/docs/latest/breaking-changes> (accessed 2026-10-31)
4. Getting Started. Electron Forge. <https://www.electronforge.io/> (accessed 2026-10-31)
5. Building your First App. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/tutorial-first-app> (accessed 2026-10-31)
6. Process Model. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/process-model> (accessed 2026-10-31)
7. Security. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/security> (accessed 2026-10-31)
8. What is Tauri?. Tauri. <https://v2.tauri.app/start/> (accessed 2026-10-31)
9. Electron home page ("Apps users love, built with Electron"). Electron. <https://www.electronjs.org/> (accessed 2026-10-31)
10. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
11. Projects. OpenJS Foundation. <https://openjsf.org/projects> (accessed 2026-10-31)
12. Electron Releases. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/electron-timelines> (accessed 2026-10-31)
13. Schedule. Electron Releases. <https://releases.electronjs.org/schedule> (accessed 2026-10-31)
14. Releases. electron/electron (GitHub). <https://github.com/electron/electron/releases> (accessed 2026-10-31)
15. NW.js home page. NW.js. <https://nwjs.io/> (accessed 2026-10-31)
