# Go · web-vue: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Go](../README.md)

## What this is
A web app split into **two separate programs**, the way many real web apps
are built:

- **`backend/`**: a Go API built with the standard library only. It sends no
  HTML. It answers `GET /api/hello` with the JSON
  `{"message":"Hello, World!"}`.
- **`frontend/`**: a Vue app in JavaScript, built and served by Vite. The
  browser loads it, Vue calls `/api/hello`, and the page shows the message
  as **Hello, World!**

Compare [../web](../web/), where the Go server fills an HTML template
itself. Here the page is built **in the browser**, and Go only provides the
data. The two parts talk over HTTP. The same split, with Spring Boot and
React, is in [../../java/web-react](../../java/web-react/).

```text
 browser ──GET /──────────► Vite (frontend, :4173) ── sends index.html + Vue code
 browser ──GET /api/hello─► Vite (frontend, :4173) ──proxy──► Go API (backend, :8080)
                                                    ◄── {"message":"Hello, World!"}
 Vue draws <p>Hello, World!</p>
```

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Go 1.22 or newer | Go 1.27.3 (Homebrew) | compiles the back end; `net/http` and `encoding/json` come with it |
| Node.js (20.19+ or 22.12+) with npm | Node.js 26.8.2, npm 12.2.1 | runs Vite; npm installs the front end's packages |
| Vue / Vite | Vue 3.5.44, Vite 8.3.5, `@vitejs/plugin-vue` 6.0.10 (`frontend/package-lock.json`) | the UI framework, the front-end build tool, and its Vue plugin; installed by `install.sh` with `npm ci` |
| `curl` | system `curl` | only for `./run.sh --verify` and for testing by hand |
| Google Chrome or Chromium | optional | `./run.sh --verify` uses it, if present, to check the page Vue draws |

"Vite requires Node.js version 20.19+, 22.12+" [7]. Vue's own project
generator, `npm create vue@latest`, asks for a newer Node.js
(`^22.18.0 || >=24.12.0`) [2], but this app does not use the generator.

## Quick start
```sh
./install.sh   # check Go and Node.js; install the front end's packages (asks first)
./build.sh     # build backend/bin/hello-api and frontend/dist/
./run.sh       # start both: API on :8080, front end on http://localhost:4173
```
Open <http://localhost:4173/> in a browser. Ctrl+C stops both servers.
Other ports: `PORT=9000 FE_PORT=5000 ./run.sh` (`PORT` is the API,
`FE_PORT` the front end).

**While developing the front end**, you can use Vite's development server instead of
the build. It reloads the page as soon as you save a file in `frontend/src`:
```sh
./backend/bin/hello-api &                      # the API, in the background
cd frontend && npm run dev                      # front end on http://localhost:5173
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks for Go 1.22+ (`go env GOVERSION`). 2. Checks for Node.js 20.19+ / 22.12+ and npm. 3. Runs `npm ci` in `frontend/` if `node_modules` is missing. For anything missing, the script shows the install command and runs it only if you answer `y`. | Each part has its own toolchain. The back end downloads nothing. `npm ci` installs exactly the versions in `package-lock.json`: "If dependencies in the package lock do not match those in package.json, npm ci will exit with an error, instead of updating the package lock" [11]. |
| `build.sh` | 1. `go build -o bin/hello-api .` in `backend/` → `backend/bin/hello-api`. 2. `npm run build` (that is, `vite build`) in `frontend/` → `frontend/dist/`. | Go compiles to a native executable, as in [../cli](../cli/README.md#scripts-explained). Browsers cannot read `.vue` files, so Vite's Vue plugin compiles them to plain JavaScript and Vite bundles it into one file. |
| `run.sh` | Starts the API, waits until `/api/hello` answers, then starts `vite preview` for the front end. `--verify`: calls `/api/hello` **through the front end's port** with `curl`, loads the page in headless Chrome if it is installed, prints what Vue drew, and then stops both. | The two parts are separate programs, so both must run. `vite preview` serves the build; Vite says it is meant to "Locally preview the production build. Do not use this as a production server" [9]. A `trap` stops the API when the script ends or you press Ctrl+C. |

`npm ci` may print `npm warn install-scripts ... fsevents@2.3.3`.
`fsevents` is an optional, macOS-only package of Vite (`"optional": true,
"os": ["darwin"]` in `package-lock.json`) used for watching files. npm
did not run its install script; the build and `vite preview` work without it.

## Folder structure
```text
web-vue/
├── README.md         this file
├── install.sh        checks Go and Node.js; runs npm ci
├── build.sh          builds both parts
├── run.sh            starts both parts
├── screenshot.png    the page in a browser, for "Expected output" below
├── backend/                         the Go API (a Go module)
│   ├── go.mod                       module example.com/hello-api, go 1.22
│   ├── main.go                      the API
│   └── bin/hello-api                created by build.sh; not committed
└── frontend/                        the Vue app (an npm project)
    ├── package.json                 dependencies and the dev/build/preview commands
    ├── package-lock.json            exact versions of every package
    ├── vite.config.js               Vue plugin and the /api proxy
    ├── index.html                   the page; Vue fills <div id="app">
    ├── src/main.js                  creates the Vue app and mounts it
    ├── src/App.vue                  the component that calls the API
    ├── node_modules/                created by install.sh; not committed
    └── dist/                        created by build.sh; not committed
```
- **Two top-level folders, one per program**, as in
  [../../java/web-react](../../java/web-react/README.md#folder-structure).
  Each keeps its own tool's standard layout, so either could move to its
  own repository. `backend/` is a "basic command" Go module like
  [../web](../web/README.md#folder-structure) [12]. `frontend/` has the
  files a Vite + Vue project needs, written by hand and kept to the minimum
  (no CSS, images, or linter configuration). `npm create vue@latest`, "the official
  Vue project scaffolding tool", creates a similar Vite-based layout [2].
- `package-lock.json` is committed: npm says "This file is intended to be
  committed into source repositories" [13]. `node_modules/`, `dist/`, and
  `bin/` are build output and are ignored by the root `.gitignore`.
- The scripts live at the top, so the reader runs one `install.sh`,
  `build.sh`, and `run.sh` for the whole app, as in every other folder.

## Step-by-step walkthrough
**Back end:** open [`backend/main.go`](backend/main.go).

1. **``type Greeting struct { Message string `json:"message"` }``** declares
   the shape of the answer. A struct groups named fields, like a Java record
   or a Python dataclass. The text in backquotes is a **struct tag**: "The
   encoding of each struct field can be customized by the format string
   stored under the "json" key in the struct field's tag" [14]. Without it,
   the JSON key would be `Message`, the Go field name. The field must start
   with a capital letter, or `encoding/json` could not see it (exported
   names, see [../cli](../cli/README.md#step-by-step-walkthrough)).
2. **`w.Header().Set("Content-Type", "application/json")`** says what the
   body is. In [../web](../web/README.md#step-by-step-walkthrough) Go
   guessed `text/html` from the content; for JSON the handler says it.
3. **`json.NewEncoder(w).Encode(Greeting{Message: "Hello, World!"})`**
   writes the struct as JSON straight into the response. `Encode` writes
   the JSON "followed by a newline character" [14], which is why the
   response is 28 bytes, not 27.
4. **`http.HandleFunc("GET /api/hello", hello)`**: the same Go 1.22 method
   pattern as in [../web](../web/README.md#step-by-step-walkthrough) [15].
   The `/api` prefix keeps API paths apart from the front end's pages.

**Front end:** open [`vite.config.js`](frontend/vite.config.js),
[`main.js`](frontend/src/main.js), and [`App.vue`](frontend/src/App.vue).

5. **The proxy** in `vite.config.js`: `server.proxy` configures "custom proxy
   rules for the dev server", and "any requests whose request path starts
   with that key will be proxied to the specified target" [8].
   `preview.proxy` uses the same rules by default [10]. Every request to
   `/api/...` is forwarded to the Go API. The browser only ever talks to
   one origin, so the back end needs no cross-origin resource sharing
   (CORS) headers.
6. **`index.html`** has an empty `<div id="app">`. `main.js` calls
   `createApp(App).mount('#app')`: it creates the Vue application from the
   `App` component and draws it inside that element [20].
7. **`App.vue` is a Single-File Component.** "Vue Single-File Components
   (a.k.a. *.vue files, abbreviated as SFC) is a special file format" [3]
   that keeps a component's logic (`<script setup>`) and its HTML template
   (`<template>`) together. `<script setup>` "is a compile-time syntactic
   sugar for using Composition API inside Single-File Components" [4].
8. **`const message = ref('Loading...')`**: `ref` "takes an inner value and
   returns a reactive and mutable ref object, which has a single property
   .value that points to the inner value" [5]. Setting `message.value`
   makes Vue redraw every place that uses it. In the template you write
   `{{ message }}` without `.value`.
9. **`onMounted(async () => { ... })`** "registers a callback to be called
   after the component has been mounted" [6]: after the `<p>` is on the
   page, the callback calls `fetch('/api/hello')`, `await`s the JSON and sets
   `message.value = data.message`. Vue redraws `<p>Hello, World!</p>`.
10. **Vue compared with React** ([../../java/web-react](../../java/web-react/README.md#step-by-step-walkthrough)):
    the same app, two styles. React's component is a JavaScript function
    that returns JSX, and state changes go through `setMessage(...)`. Vue
    separates an HTML-like `<template>` from the script, and state is a
    `ref` that you assign to. `{{ message }}` in Vue's template plays the
    role of `{message}` in React's JSX.

## Why this toolchain
- **Vue** is "a JavaScript framework for building user interfaces" [1]. In
  the Stack Overflow Developer Survey 2026, 17.2% of the 10,281 respondents
  to the web frameworks question used Vue.js [16]. This repository
  pairs Go with Vue.
- **Vite**: Vue's quick start creates projects that use "a build setup based
  on Vite" [2], so it is the standard build tool for a new Vue app.
- **A proxy instead of CORS** keeps the back end a plain same-origin API and
  the front-end code free of hard-coded server addresses, the same choice as
  in [../../java/web-react](../../java/web-react/README.md#why-this-toolchain).
- **The Go standard library for the API**: `net/http` serves it and
  `encoding/json` writes the JSON [14][15], so the back end downloads
  nothing, like [../web](../web/README.md#why-this-toolchain).
- **Ports:** 8080 matches the other web folders in this repository. 4173 is
  the default port of `vite preview`, and 5173 the default of the development
  server [10][8].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Go 1.27.3, Node.js 26.8.2, npm 12.2.1, Vue 3.5.44, Vite 8.3.5. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. `brew install go node` [17][18]. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Go from the official archive, as in [../cli](../cli/README.md#platform-notes). The distribution's own `nodejs` package may be older than Vite needs; install a current LTS from <https://nodejs.org/en/download> [19]. `run.sh --verify` looks for `google-chrome` or `chromium` on `PATH` and skips the browser check if neither is found. |
| Windows (Git Bash / WSL) | ⚠️ not verified | `winget install --id GoLang.Go -e` and `winget install --id OpenJS.NodeJS.LTS -e`. Native PowerShell, in two terminals: `cd backend; go build -o bin\hello-api.exe .; .\bin\hello-api.exe` and `cd frontend; npm ci; npm run build; npx vite preview`. |

## Expected output
`./run.sh --verify`:
```text
==> 1/2 Start the backend (Go API) on http://localhost:8080
    WHY: the API must be up before the front end can ask it for the message.
2026/10/31 13:48:36 API listening on http://localhost:8080/api/hello
{"message":"Hello, World!"}


==> 2/2 Start the front end (Vite serving the Vue build) on http://localhost:4173
    WHY: Vite serves frontend/dist and forwards /api/* to the backend (see vite.config.js).
    Check 1: GET /api/hello on the FRONT END's port, which Vite forwards to the Go API:
  ➜  Local:   http://localhost:4173/
  ➜  Network: use --host to expose
{"message":"Hello, World!"}

    Check 2: load the page in headless Chrome and show what Vue drew:
<div id="app" data-v-app=""><p>Hello, World!</p></div>
```
(The empty lines come from the newline `Encode` adds after the JSON.
`data-v-app` is an attribute Vue adds to the element it mounted into.)

By hand, with `./run.sh` running:
```text
$ curl -i http://localhost:8080/api/hello        # the backend directly
HTTP/1.1 200 OK
Content-Type: application/json
Date: Sat, 31 Oct 2026 16:47:20 GMT
Content-Length: 28

{"message":"Hello, World!"}
```
`curl http://localhost:4173/` returns only `index.html` with an empty
`<div id="app"></div>`: the text appears only after the browser runs Vue.
The browser shows: **Hello, World!**

![The page at http://localhost:4173/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --virtual-time-budget=10000 --screenshot=screenshot.png http://localhost:4173/`.)

## Sources
1. Introduction. Vue.js. <https://vuejs.org/guide/introduction.html> (accessed 2026-10-31)
2. Quick Start. Vue.js. <https://vuejs.org/guide/quick-start.html> (accessed 2026-10-31)
3. Single-File Components. Vue.js. <https://vuejs.org/guide/scaling-up/sfc.html> (accessed 2026-10-31)
4. `<script setup>`. Vue.js. <https://vuejs.org/api/sfc-script-setup.html> (accessed 2026-10-31)
5. Reactivity API: Core (ref). Vue.js. <https://vuejs.org/api/reactivity-core.html#ref> (accessed 2026-10-31)
6. Composition API: Lifecycle Hooks (`onMounted`). Vue.js. <https://vuejs.org/api/composition-api-lifecycle.html#onmounted> (accessed 2026-10-31)
7. Getting Started. Vite. <https://vite.dev/guide/> (accessed 2026-10-31)
8. Server Options. Vite. <https://vite.dev/config/server-options> (accessed 2026-10-31)
9. Command Line Interface. Vite. <https://vite.dev/guide/cli> (accessed 2026-10-31)
10. Preview Options. Vite. <https://vite.dev/config/preview-options> (accessed 2026-10-31)
11. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (accessed 2026-10-31)
12. Organizing a Go module. The Go Authors. <https://go.dev/doc/modules/layout> (accessed 2026-10-31)
13. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (accessed 2026-10-31)
14. Package encoding/json. The Go Authors. <https://pkg.go.dev/encoding/json> (accessed 2026-10-31)
15. Package net/http (ServeMux patterns). The Go Authors. <https://pkg.go.dev/net/http> (accessed 2026-10-31)
16. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
17. go (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/go> (accessed 2026-10-31)
18. node (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/node> (accessed 2026-10-31)
19. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (accessed 2026-10-31)
20. Application API (`createApp`, `app.mount`).
 Vue.js. <https://vuejs.org/api/application.html> (accessed 2026-10-31)
