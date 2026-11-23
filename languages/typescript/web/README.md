# TypeScript · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [TypeScript](../README.md)

## What this is
A small web server written in TypeScript with only the `http` module that
Node.js includes. When a browser asks for `http://localhost:8080/`, the
server answers `Hello, World!` as `text/html`. The TypeScript compiler,
`tsc`, checks the types in `src/server.ts` and writes `build/server.js`.
Node.js runs that JavaScript file. The server sends the page itself; there
is no separate front end.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Node.js 24 or newer, with npm | Node.js 26.8.2, npm 12.2.1 (nvm) | runs `tsc` and the server; npm downloads the compiler |
| TypeScript (`typescript` package) | 7.0.2 (locked in `package-lock.json`) | the compiler, `tsc` |
| `@types/node` | 26.6.6 (locked in `package-lock.json`) | type declarations for `node:http`, `process`, and `console` [1] |
| `curl` | system `curl` | only for `./run.sh --verify` and for testing by hand |

This example asks for Node.js 24 or newer because that is a current
long-term support line [2]. The `typescript` 7.0.2 package declares
`"engines": {"node": ">=16.20.0"}` [3].

## Quick start
```sh
./install.sh   # check Node.js and npm, install the compiler into node_modules/ (asks first)
./build.sh     # compile src/server.ts to build/server.js
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl -i http://localhost:8080/`. Use another port with
`PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks for Node.js 24+ and npm, and shows how to install them if missing. 2. Runs `npm ci`, which installs the exact versions in `package-lock.json` into `node_modules/`. Step 2 asks first. | `tsc` is a package from the npm registry, not part of Node.js. `npm ci` is meant for "any situation where you want to make sure you're doing a clean install of your dependencies" [4]. |
| `build.sh` | Runs `npx tsc -p .`. | The `-p` option compiles "the project given the path to its configuration file, or to a folder with a 'tsconfig.json'" [5]. The result is `build/server.js`. |
| `run.sh` | Runs `node build/server.js`. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | Node.js runs JavaScript, so it runs the compiled file. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |
| `typescript-env.sh` | Sourced by the three scripts. It sets the oldest accepted Node.js version and finds `node` and `npm` when they are not on `PATH`. | The scripts work from a shell with a short `PATH`. |

## Folder structure
```text
web/
├── README.md            this file
├── install.sh           checks Node.js and npm, installs the compiler
├── build.sh             compiles src/server.ts to build/server.js
├── run.sh               starts the server
├── typescript-env.sh    shared settings (sourced, not run)
├── package.json         the project: pinned compiler and type declarations
├── package-lock.json    the exact version and integrity value of every installed package
├── tsconfig.json        the compiler settings (strict mode, input and output folders)
├── screenshot.png       the page, for "Expected output" below
├── src/
│   └── server.ts        the program
├── build/               created by build.sh; not committed
└── node_modules/        created by install.sh; not committed
```
- **`package.json`** lists the compiler under `"devDependencies"`, for
  packages that the project needs only while it is developed [6]. The
  versions are exact (`7.0.2`, not `^7.0.2`).
- **`package-lock.json`** records an `integrity` value for every package:
  "A `sha512` or `sha1` Standard Subresource Integrity string for the
  artifact that was unpacked in this location" [7]. `npm ci` fails if the
  lock file does not match `package.json` [4].
- **`tsconfig.json`** is the file `tsc -p .` reads [5]. `"strict": true`
  turns on the whole family of strict type-checking options [8].
  `"types": ["node"]` is needed because "by default `types` is set to
  `[]`" since TypeScript 6.0 [8]. `"outDir": "build"` sends the `.js` files
  to `build/` [8]. `"module": "nodenext"` is the setting the TypeScript docs
  recommend "for modern Node.js projects" [8].

## Step-by-step walkthrough
Open [`src/server.ts`](src/server.ts) next to this list.

1. **`import { createServer } from "node:http"`** loads a function from the
   `http` module. The `node:` prefix names a module that is built into
   Node.js, so npm downloads nothing for it. Compare
   [Node.js web](../../node/web/README.md), which needs the Express package.
   The types for the module come from `@types/node` [1].
2. **`const port: number = Number(process.env.PORT ?? 8080)`** reads the
   `PORT` environment variable and falls back to 8080. `process.env`
   values are strings or `undefined`. `??` takes its right side when the
   left side is `undefined`, and `Number(...)` converts the text to a
   number. The `: number` annotation makes `tsc` reject any other type.
3. **`createServer((_request, response) => { ... })`** creates the server.
   The function runs once for every request. `http.createServer` takes an
   optional `requestListener` [9]. `tsc` infers the types of the two
   parameters from the declarations in `@types/node`, so they need no
   annotation.
4. **`response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" })`**
   sends the response header. "The status code is a 3-digit HTTP status
   code" [9]. The last argument holds the headers [9]; here it sets
   `Content-Type` to `text/html`, as the `curl -i` output below shows.
5. **`response.end("Hello, World!")`** sends the body. "The method,
   `response.end()`, MUST be called on each response" [9].
6. **`server.listen(port, "127.0.0.1", callback)`** starts the server.
   `http.Server` extends `net.Server` [9], and the host `"127.0.0.1"`
   keeps the server private to this computer. The callback runs when the
   server is ready.
7. **No loop to write.** `listen` returns at once, and the file ends, but
   the program keeps running because the open server keeps Node.js waiting
   for requests. The [cli](../cli/) version had nothing to wait for, so it
   ended.

## Why this toolchain
- **`node:http` and no framework:** the page needs one route, and the
  built-in module is enough. The Node.js
  [web](../../node/web/README.md) version uses Express, which adds routing;
  this version shows what Node.js offers without it.
- **`tsc` and Node.js:** TypeScript 7.0 is "a 10x faster native port of
  TypeScript", and `npm install -D typescript` gives you "the new `tsc`
  executable" [10]. Node.js can also run a `.ts` file directly. It
  "will replace TypeScript syntax with whitespace, and no type checking is
  performed" and "ignores `tsconfig.json` files" [11]. This example uses the
  compiler so that the types are checked and the strict mode applies. See
  [../cli](../cli/README.md#why-this-toolchain).
- **CommonJS output:** `package.json` has `"type": "commonjs"`, and the
  compiler writes a `require("node:http")` call for the `import` line, as
  `build/server.js` shows.
- **Port 8080** is the convention of this repository for every web
  implementation.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-11) | Node.js 26.8.2 (nvm), npm 12.2.1, TypeScript 7.0.2, `@types/node` 26.6.6. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel. The `typescript` package lists a separate native package for `darwin-arm64` [3]. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` does not install Node.js: if version 24 or newer is missing it prints the nodejs.org steps [12] and stops. |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` prints `winget install --id OpenJS.NodeJS.LTS -e` [13] and stops if Node.js is missing. |

On macOS, if Node.js is missing, `install.sh` offers `brew install node`
[14].

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'node build/server.js' listens on 127.0.0.1 (this computer only) and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/ (Ctrl+C to stop)
```
In a second terminal:
```sh
curl -i http://localhost:8080/
```
```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Date: Wed, 11 Nov 2026 19:19:23 GMT
Connection: keep-alive
Keep-Alive: timeout=5
Transfer-Encoding: chunked

Hello, World!
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-11 with headless Google Chrome 157:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. @types/node ("TypeScript definitions for node"). DefinitelyTyped, npm registry. <https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/node> (accessed 2026-11-11)
2. Node.js Releases. OpenJS Foundation. <https://nodejs.org/en/about/previous-releases> (accessed 2026-11-11)
3. typescript (package metadata: dist-tags, engines, license, platform packages). npm registry. <https://registry.npmjs.org/typescript> (accessed 2026-11-11)
4. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (accessed 2026-11-11)
5. TypeScript compiler options: CLI commands, `--project`. Microsoft. <https://www.typescriptlang.org/docs/handbook/compiler-options.html> (accessed 2026-11-11)
6. package.json (`devDependencies`). npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-json> (accessed 2026-11-11)
7. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (accessed 2026-11-11)
8. Reference for `tsconfig.json`: `strict`, `outDir`, `types`, `module`. Microsoft. <https://www.typescriptlang.org/tsconfig/> (accessed 2026-11-11)
9. HTTP: `http.createServer()`, `response.writeHead()`, `response.end()`, `http.Server`. Node.js v26 Documentation. <https://nodejs.org/api/http.html> (accessed 2026-11-11)
10. Announcing TypeScript 7.0. Microsoft, TypeScript blog, 2026-07-08. <https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/> (accessed 2026-11-11)
11. Modules: TypeScript. Node.js v26 Documentation. <https://nodejs.org/api/typescript.html> (accessed 2026-11-11)
12. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (accessed 2026-11-11)
13. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (accessed 2026-11-11)
14. node (Homebrew formula). Homebrew. <https://formulae.brew.sh/formula/node> (accessed 2026-11-11)
