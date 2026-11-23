# Node.js · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Node.js](../README.md)

## What this is
A small web server written with **Express**, the "fast, unopinionated,
minimalist web framework for Node.js" [1]. When a browser asks for
`http://localhost:8080/`, the server answers with the HTML
`<p>Hello, World!</p>`, which the browser shows as the text
**Hello, World!**. The server sends the HTML itself; there is no separate
front end.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Node.js 18 or newer, with npm | Node.js 26.8.2, npm 12.2.1 (nvm) | runs `app.js`; npm downloads Express |
| Express | 5.3.0 (locked in `package-lock.json`) | the web framework; `install.sh` installs it into `node_modules/` |
| `curl` | system `curl` | only for `./run.sh --verify` and for testing by hand |

Express 5 needs Node.js 18 or higher: "Before you begin, make sure you have
Node.js 18 or higher installed" [2]. npm comes with Node.js.

## Quick start
```sh
./install.sh   # check Node.js and npm, install Express into node_modules/ (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.
`npm start` also works: it runs the `start` script of `package.json`,
`node app.js`, on port 8080.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks for Node.js 18+ and npm, and shows how to install them if missing. 2. Runs `npm ci`, which installs the exact versions listed in `package-lock.json` into `node_modules/`. Step 2 asks first. | Express is a package from the npm registry, not part of Node.js. `npm ci` is "meant to be used in automated environments ... or any situation where you want to make sure you're doing a clean install of your dependencies" [8]. |
| `run.sh` | Runs `node app.js`. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`: Node.js runs JavaScript directly, as in
[../cli](../cli/README.md#why-there-is-no-build-step).

## Folder structure
```text
web/
├── README.md          this file
├── install.sh         checks Node.js and npm, installs Express
├── run.sh             starts the server
├── app.js             the web application (Express's hello world, port 8080)
├── package.json       the project: name, module type, start script, dependencies
├── package-lock.json  the exact version of every installed package (written by npm)
├── screenshot.png     the page, for "Expected output" below
└── node_modules/      created by install.sh; not committed (see ../../../.gitignore)
```
- **`app.js`** is the file name the Express hello world example uses [3].
- **`package.json`** is the npm project file. `"dependencies"` lists
  Express; with `"private": true`, "npm will refuse to publish it" [9]. `"type": "commonjs"` says that `.js` files use
  `require()` [9][10]. `"scripts"` defines `npm start`.
- **`package-lock.json`** records the exact version of Express and of the
  64 packages Express itself needs. npm says this file "is intended to be
  committed into source repositories" [11], so every student gets the
  same code. `npm ci` refuses to run without it [8].
- **`node_modules/`** holds the downloaded packages, inside this folder
  (Python keeps them in `.venv/`, Go in one shared cache). It can always
  be recreated from the lock file, so it is not committed.

## Step-by-step walkthrough
Open [`app.js`](app.js) next to this list.

1. **`const express = require("express")`** loads Express from
   `node_modules/`. Unlike the [cli](../cli/hello.js), which uses only the
   global `console`, this program depends on a library from the npm
   registry. This is the CommonJS syntax of the Express docs [3]; the
   ES module syntax is `import express from "express"` [10].
2. **`const app = express()`** creates the application.
3. **`process.env.PORT || 8080`** reads the `PORT` environment variable,
   or uses 8080 if it is not set. `||` returns its right side when the
   left side is falsy (for example `undefined`).
4. **`app.get("/", (req, res) => { ... })`** registers a route: GET
   requests for `/` call the arrow function. The Express example does the
   same and notes that "for every other path, it will respond with a
   **404 Not Found**" [3]. Compare Flask's `@app.route("/")`, Go's
   `http.HandleFunc("/", ...)`, and Spring Boot's `@GetMapping("/")`.
5. **`res.send("<p>Hello, World!</p>")`**: "When the parameter is a
   `String`, the method sets the `Content-Type` to "text/html"" [4]. You
   can see this header in the `curl -i` output below.
6. **`app.listen(port, "127.0.0.1", callback)`** starts the server. It
   "binds and listens for connections on the specified host and port" and
   "is identical to Node's http.Server.listen()" [5]. The host
   `"127.0.0.1"` keeps the server private to this computer. Without it,
   "the server will accept connections on the unspecified IPv6 address
   (`::`) when IPv6 is available, or the unspecified IPv4 address
   (`0.0.0.0`) otherwise" [12], that is, from other machines too. The callback runs once
   the server is ready; Express 5 passes it an error if listening failed,
   for example when the port is already taken.
7. **No loop to write.** `app.listen()` returns at once, and the file
   ends, but the program keeps running: Node.js only "exits the event loop
   when there are no more callbacks to perform" [13], and an open server
   keeps waiting for requests. The [cli](../cli/) version had nothing to
   wait for, so it ended.

The Express example on expressjs.com uses port 3000 and sends
`Hello World!` [3]. This version uses port 8080 (the convention of every
web implementation in this repository) and sends the same `<p>` paragraph as the
other web versions.

## Why this toolchain
- **Express:** in the Stack Overflow Developer Survey 2026, 15.6% of the
  respondents to the web frameworks and technologies question used it
  (1,604 of 10,281) [6]. It is an
  "Impact Project" of the OpenJS Foundation, the same foundation that
  hosts Node.js [7].
- **Express 5:** version 5.0.0 was released on 2024-09-09 but "we didn't
  make it the `latest` release on npm" until 5.1.0 on 2025-03-31 [14].
  Express 5 "drops support for Node.js versions before v18" [15]. 5.3.0
  was published on the npm registry on 2026-10-09 and was the `latest`
  version there when this page was verified [16].
- **Why not only Node's `http` module?** Node.js can serve a page without
  any package: the "About Node.js" page shows a server built with
  `createServer` from `node:http` [13]. Express adds routing (which URL
  calls which function), so that a 404 is returned for every other path,
  and a `Content-Type` chosen for you [3][4]. The survey above shows that many respondents use Express.
- **CommonJS (`require`)** instead of ES modules (`import`): the Express
  hello world uses `require` [3], and so does the Electron tutorial used by
  [../desktop](../desktop/). Both forms are standard in Node.js; ES
  modules are the ECMAScript standard's own module system [10].
- **Port 8080** is the convention of this repository for every web implementation.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Node.js 26.8.2 (nvm), npm 12.2.1, Express 5.3.0. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel. Express is pure JavaScript: the same `node_modules/` works on every CPU. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` does not install Node.js: if version 18 or newer is missing it prints the nodejs.org steps [17] and stops. It runs `npm ci` when Express is not installed. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install Node.js: if version 18 or newer is missing it prints `winget install --id OpenJS.NodeJS.LTS -e` [18] and stops. It runs `npm ci` when Express is not installed. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'node app.js' listens on 127.0.0.1 (this computer only) and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/ (Ctrl+C to stop)
```
In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 20
ETag: W/"14-UEgmxq84YB3jUrvPtCv95CaXyYs"
Date: Sat, 31 Oct 2026 17:23:58 GMT
Connection: keep-alive
Keep-Alive: timeout=5

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 with headless Google Chrome:
`chrome --headless=new --window-size=640,320 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Express: Node.js web application framework (home page). OpenJS Foundation and Express.js contributors. <https://expressjs.com/> (accessed 2026-10-31)
2. Installing. Express.js. <https://expressjs.com/en/starter/installing.html> (accessed 2026-10-31)
3. Hello world example. Express.js. <https://expressjs.com/en/starter/hello-world.html> (accessed 2026-10-31)
4. Response (res.send). Express.js 5.x API. <https://expressjs.com/en/5x/api/response> (accessed 2026-10-31)
5. Application (app.listen). Express.js 5.x API. <https://expressjs.com/en/5x/api/application> (accessed 2026-10-31)
6. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
7. Projects. OpenJS Foundation. <https://openjsf.org/projects> (accessed 2026-10-31)
8. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (accessed 2026-10-31)
9. package.json ("private", "dependencies", "scripts"). npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-json> (accessed 2026-10-31)
10. Modules: Packages ("type" field) and ECMAScript modules. Node.js v26 Documentation. <https://nodejs.org/api/packages.html> and <https://nodejs.org/api/esm.html> (accessed 2026-10-31)
11. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (accessed 2026-10-31)
12. Net: server.listen(). Node.js v26 Documentation. <https://nodejs.org/api/net.html> (accessed 2026-10-31)
13. About Node.js. OpenJS Foundation. <https://nodejs.org/en/about> (accessed 2026-10-31)
14. Express@5.1.0: Now the Default on npm with LTS Timeline. Express Technical Committee, 2025-03-31. <https://expressjs.com/en/blog/2025-03-31-v5-1-latest-release> (accessed 2026-10-31)
15. Introducing Express v5: A New Era for the Node.js Framework. Wes Todd, 2024-10-15. <https://expressjs.com/en/blog/2024-10-15-v5-release> (accessed 2026-10-31)
16. express (package metadata: dist-tags and publish times). npm registry. <https://registry.npmjs.org/express> (accessed 2026-10-31)
17. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (accessed 2026-10-31)
18. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (accessed 2026-10-31)
