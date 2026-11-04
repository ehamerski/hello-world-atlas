# Node.js · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Node.js](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and a newline,
then exits. The program is one line of JavaScript,
`console.log("Hello, World!");`, run by **Node.js**, "an open-source and
cross-platform JavaScript runtime environment" [3]. JavaScript was made
for web browsers; Node.js runs it on your computer like any other
command-line program.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Node.js (the `node` command) | 26.8.2 (installed with nvm) | the runtime that runs `hello.js` |

Any Node.js version works: this program uses only `console.log`. No npm
package is needed, so there is no `package.json` and no `node_modules/`.

On the test machine (macOS Intel), Node.js was installed with nvm, one of
the install methods listed on nodejs.org [6]. `install.sh` offers Homebrew
on macOS instead, because every other implementation in this repository
uses Homebrew. Its `node` formula was at version 26.13.0 on 2026-10-31 [5].

## Quick start
```sh
./install.sh   # check / install Node.js (asks before installing)
./run.sh       # run it
```
There is no `build.sh` (see [Why there is no build step](#why-there-is-no-build-step)).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks that `node` is on your `PATH` and prints its version. If it is missing, it shows the install command for your operating system (Homebrew on macOS, nodejs.org on Linux, `winget` on Windows) and runs it only if you answer `y`. | The program cannot run without the runtime. |
| `run.sh` | Runs `node hello.js`. `--verify` does the same thing, because a cli program ends on its own. | One command for students, with an explanation of what happens. |

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Node.js
├── run.sh         runs the program
└── hello.js       the program (one line of code plus teaching comments)
```
A single `.js` file is a complete Node.js program: the getting-started
page of nodejs.org runs its first example with `node server.js` [3]. A
`package.json` file is only needed when a project has npm dependencies or
scripts, as in [`../web`](../web/) and [`../desktop`](../desktop/).

## Step-by-step walkthrough
Open [`hello.js`](hello.js) next to this list.

1. **Comments.** Lines starting with `//` are comments, as in C, Java, and
   Go. JavaScript also has `/* ... */` block comments. Python uses `#`.
2. **No entry point.** Node.js runs the file from top to bottom, like
   Python. "Node.js simply enters the event loop after executing the input
   script" and "exits the event loop when there are no more callbacks to
   perform" [1]. This script schedules nothing, so Node.js exits right
   after the `console.log` line. C, Java, and Go need a `main` function.
3. **No import.** `console` is a global object, always available, the same
   object web browsers provide. `console.log` "prints to `stdout` with
   newline" [2], like Python's `print` and Java's `println`.
4. **The semicolon.** `;` ends the statement. The ECMAScript standard
   says that most statements "must be terminated with a semicolon", but
   "such semicolons may be omitted from the source text in certain
   situations" (automatic semicolon insertion) [8]. Writing them avoids
   having to learn those rules.
5. **Strings.** `"Hello, World!"` and `'Hello, World!'` are the same
   string in JavaScript, as in Python.

Compare with the other Node.js versions in [../README.md](../README.md#comparing-the-categories).

### Why there is no build step
You never compile JavaScript yourself: `node hello.js` reads the source
and runs it. Inside Node.js, the code is run by **V8**, "Google's open
source high-performance JavaScript and WebAssembly engine", which "is used
in Chrome and in Node.js" [7]. V8 compiles each function to "a concise
bytecode" for its Ignition interpreter; then "the compiled code is
analyzed during runtime and optionally re-compiled dynamically" to
machine code [7]. All of this happens in memory while the program runs.
This is why the `cli` versions of C, Go, and Java have a `build.sh` and
this one does not. Python works the same way from the student's point of
view (see [../../python/cli](../../python/cli/README.md#why-there-is-no-build-step)).

## Why this toolchain
- **Node.js** is a JavaScript runtime that runs outside the browser, on
  macOS, Linux, and Windows [3]. It was used by 46.4% of the respondents
  to the web frameworks and technologies question of the Stack Overflow
  Developer Survey 2026 (base 10,281) [9].
- **Version:** Node.js 26 has been the "Active LTS" line since 2026-10-28
  (codename Lithium) and is supported until 2029-04-30 [4]. "Production
  applications should only use _Active LTS_ or _Maintenance LTS_
  releases" [4]. The test machine has 26.8.2, released in the same line
  before it became LTS; `hello.js` runs unchanged on any version.
- **`console.log`** instead of `process.stdout.write("Hello, World!\n")`:
  both write to standard output [2], but `console.log` adds the newline
  for you, and it works the same way in a web browser.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Node.js 26.8.2 (nvm). |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel (`brew install node`). |
| Linux (Debian/Ubuntu) | ⚠️ not verified | The distribution's own `nodejs` package may be an old version. Install a current LTS as shown on nodejs.org [6]. |
| Windows (Git Bash / WSL) | ⚠️ not verified | `winget install --id OpenJS.NodeJS.LTS -e` [10], or the installer from nodejs.org [6]. Native (PowerShell / `cmd`): `node hello.js`. WSL behaves like Linux. |

## Expected output
```text
$ node hello.js
Hello, World!
```
`./run.sh` prints its explanation first (lines starting with `==>` and
`WHY:`), then the same line.

## Sources
1. About Node.js. OpenJS Foundation. <https://nodejs.org/en/about> (accessed 2026-10-31)
2. Console. Node.js v26 Documentation. <https://nodejs.org/api/console.html> (accessed 2026-10-31)
3. Introduction to Node.js. Node.js Learn. <https://nodejs.org/en/learn/getting-started/introduction-to-nodejs> (accessed 2026-10-31)
4. Node.js Releases. OpenJS Foundation. <https://nodejs.org/en/about/previous-releases> and Node.js Release Working Group schedule. <https://github.com/nodejs/Release> (accessed 2026-10-31)
5. node formula. Homebrew. <https://formulae.brew.sh/formula/node> (accessed 2026-10-31)
6. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (accessed 2026-10-31)
7. V8 JavaScript engine (home page). The V8 Project Authors. <https://v8.dev/> ; Firing up the Ignition interpreter. V8 blog. <https://v8.dev/blog/ignition-interpreter> ; Sparkplug, a non-optimizing JavaScript compiler. V8 blog. <https://v8.dev/blog/sparkplug> (accessed 2026-10-31)
8. ECMAScript 2026 Language Specification (ECMA-262, 17th edition), §12.10 Automatic Semicolon Insertion. Ecma International. <https://262.ecma-international.org/17.0/#sec-automatic-semicolon-insertion> (accessed 2026-10-31)
9. 2026 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2026/technology> (accessed 2026-10-31)
10. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (accessed 2026-10-31)
