# Java · web-react: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Java](../README.md)

## What this is
A web application split into **two separate programs**, as many web
applications are built in practice:

- **`backend/`**: a Spring Boot API in Java. It sends no HTML. It answers
  `GET /api/hello` with the JSON `{"message":"Hello, World!"}`.
- **`frontend/`**: a React application in JavaScript, built and served by
  Vite. The browser loads it; then React calls `/api/hello` and shows the
  message as **Hello, World!**

Compare [../web](../web/), where the Java server builds the HTML itself.
Here the page is built **in the browser**, and Java only provides the
data. The two parts talk over HTTP.

```text
 browser ──GET /──────────► Vite (frontend, :4173) ── sends index.html + React code
 browser ──GET /api/hello─► Vite (frontend, :4173) ──proxy──► Spring Boot (backend, :8080)
                                                    ◄── {"message":"Hello, World!"}
 React draws <p>Hello, World!</p>
```

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (Java Development Kit) 21 or newer | Eclipse Temurin 21.0.8 | compiles and runs the back end |
| Apache Maven | 3.9.16 | builds the back end and downloads Spring Boot |
| Spring Boot | 4.1.2 (pinned in `backend/pom.xml`) | the back-end framework; downloaded by Maven |
| Node.js (20.19+ or 22.12+) with npm | Node.js 26.8.2, npm 12.2.1 | runs Vite; npm installs the front end's packages |
| React / Vite | React 19.3.1, Vite 8.3.5 (`frontend/package-lock.json`) | the UI library and the front-end build tool; installed by `install.sh` with `npm ci` |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |
| Google Chrome or Chromium | optional | `./run.sh --verify` uses it, if present, to check the page React draws |

"Vite requires Node.js version 20.19+, 22.12+" [7]. Spring Boot 4.1.2
"requires at least Java 17" [1].

## Quick start
```sh
./install.sh   # check JDK, Maven, Node.js; install the front end's packages (asks first)
./build.sh     # build backend/target/hello-api.jar and frontend/dist/
./run.sh       # start both: API on :8080, front end on http://localhost:4173
```
Open <http://localhost:4173/> in a browser. Ctrl+C stops both servers.
Other ports: `PORT=9000 FE_PORT=5000 ./run.sh` (`PORT` is the API,
`FE_PORT` the front end).

**While developing the front end**, you can use Vite's dev server instead of
the build. It reloads the page as soon as you save a file in `frontend/src`:
```sh
java -jar backend/target/hello-api.jar &       # the API, in the background
cd frontend && npm run dev                      # front end on http://localhost:5173
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks for a JDK 21+ (`javac -version`). 2. Checks for Maven. 3. Checks for Node.js 20.19+ / 22.12+ and npm. 4. Runs `npm ci` in `frontend/` if `node_modules` is missing. Anything missing is offered with its install command and runs only if you answer `y`. | Each part has its own toolchain. `npm ci` installs exactly the versions in `package-lock.json`: "If dependencies in the package lock do not match those in package.json, npm ci will exit with an error, instead of updating the package lock" [11]. |
| `build.sh` | 1. `mvn package` in `backend/` → `backend/target/hello-api.jar`. 2. `npm run build` (that is, `vite build`) in `frontend/` → `frontend/dist/`. | The JVM runs bytecode, so the Java is compiled first, as in [../web](../web/README.md#scripts-explained). Browsers cannot read JSX (the HTML-like `<p>` in `App.jsx`), so Vite translates it to plain JavaScript and bundles it into one file. |
| `run.sh` | Starts the API with `java -jar`, waits until `/api/hello` answers, then starts `vite preview` for the front end. `--verify`: calls `/api/hello` **through the front end's port** with `curl`, loads the page in headless Chrome if installed and prints what React drew, then stops both. | The two parts are separate programs, so both must run. `vite preview` serves the build; Vite says it is meant to "Locally preview the production build. Do not use this as a production server" [9]. A `trap` stops the API when the script ends or you press Ctrl+C. |

## Folder structure
```text
web-react/
├── README.md         this file
├── install.sh        checks JDK, Maven, Node.js; runs npm ci
├── build.sh          builds both parts
├── run.sh            starts both parts
├── screenshot.png    the page in a browser, for "Expected output" below
├── backend/                         the Spring Boot API (a Maven project)
│   ├── pom.xml
│   ├── src/main/java/com/example/hello/HelloApiApplication.java
│   ├── src/main/resources/application.properties
│   └── target/hello-api.jar         created by build.sh; not committed
└── frontend/                        the React app (an npm project)
    ├── package.json                 dependencies and the dev/build/preview commands
    ├── package-lock.json            exact versions of every package
    ├── vite.config.js               React plugin and the /api proxy
    ├── index.html                   the page; React fills <div id="root">
    ├── src/main.jsx                 starts React
    ├── src/App.jsx                  the component that calls the API
    ├── node_modules/                created by install.sh; not committed
    └── dist/                        created by build.sh; not committed
```
- **Two top-level folders, one per program.** Each keeps its own tool's
  standard layout, so either could move to its own repository. `backend/`
  is a normal Maven project, laid out like [../web](../web/README.md#folder-structure) [2].
  `frontend/` is the layout `npm create vite@latest` produces with the
  `react` template [7], trimmed to the files a Hello World needs (the
  template's CSS, images and linter config were removed).
- `package-lock.json` is committed: npm says "This file is intended to be
  committed into source repositories" [12]. `node_modules/` and `dist/`
  are build output and are ignored by the root `.gitignore`.
- The scripts live at the top, so the reader runs one `install.sh`,
  `build.sh` and `run.sh` for the whole application, as in every other folder.

## Step-by-step walkthrough
**Back end:** open
[`HelloApiApplication.java`](backend/src/main/java/com/example/hello/HelloApiApplication.java).

1. The class has the same two annotations as [../web](../web/README.md#step-by-step-walkthrough):
   `@SpringBootApplication` starts Spring, and `@RestController` sends
   whatever a method returns directly back to the caller [3].
2. **`record Greeting(String message) {}`** declares a small data class.
   Records are classes "that act as transparent carriers for immutable
   data" [13]; the compiler writes the constructor, the accessor
   `message()`, `equals`, `hashCode` and `toString` for you. Records became
   a standard feature in Java 16 (JEP 395) [13].
3. **`@GetMapping("/api/hello") Greeting hello()`** returns an object, not a
   string. Spring converts it to JSON, `{"message":"Hello, World!"}`, with
   `Content-Type: application/json` (see the `curl -i` output below).
   The `/api` prefix keeps API paths apart from the front end's pages.

**Front end:** open [`vite.config.js`](frontend/vite.config.js),
[`main.jsx`](frontend/src/main.jsx) and [`App.jsx`](frontend/src/App.jsx).

4. **The proxy** in `vite.config.js`: `server.proxy` configures "custom proxy
   rules for the dev server" [8], and `preview.proxy` uses the same rules by
   default (its default is `server.proxy`) [10]. Every request to
   `/api/...` is forwarded to Spring Boot. The browser only ever talks to
   one origin, so the back end needs no CORS settings. Without the proxy
   the browser would block the call: "For security reasons, browsers
   prohibit AJAX calls to resources outside the current origin", and the
   back end would need `@CrossOrigin` [14].
5. **`index.html`** has an empty `<div id="root">`. `main.jsx` calls
   `createRoot`, which "lets you create a root to display React components
   inside a browser DOM node" [4], and renders `<App />` there. `StrictMode`
   adds extra checks while developing; they "are development-only and do
   not impact the production build" [6].
6. **`App` is a function component.** `useState` "lets you add a state
   variable to your component" [5]: `message` starts as `Loading...`.
7. **`useEffect(() => { fetch('/api/hello')... }, [])`** runs once after the
   component is shown and calls the API. `useEffect` "lets you synchronize
   a component with an external system" [15]; here the external system is
   the Spring Boot API. When the JSON arrives, `setMessage(data.message)`
   updates the state and React redraws `<p>Hello, World!</p>`.
   React's docs show a longer version with an `ignore` flag, so that
   responses arriving in the wrong order are dropped [15]. With a single
   request, responses cannot arrive out of order, so the flag is left out
   here.
8. **JSX**: `return <p>{message}</p>` looks like HTML, but it is
   JavaScript. Vite's React plugin translates it during `npm run build`.
   In [../web](../web/) the same `<p>` was a Java string built on the
   server.

## Why this toolchain
- **React** is the most used front-end library in the Stack Overflow
  Developer Survey 2026: 41.5% of the 10,281 respondents to the web
  frameworks question used it, second only to Node.js (46.4%), which is a
  runtime, not a UI library [16]. This repository pairs Java with React.
- **Vite**: React's own docs list Vite as a build tool for starting "a
  React app from scratch", the path they suggest when "you just want to
  learn the basics of a React app" [17]. React's first suggestion is a
  framework such as Next.js, which it describes as enabling "full-stack
  React apps" [17]. Such a framework brings its own server, but in this
  application the server is Spring Boot, so a plain Vite setup is enough.
- **A proxy instead of CORS** keeps the back end identical to a normal
  same-origin API and the front-end code free of hard-coded server
  addresses. Deploying `dist/` to production is out of scope here; Vite's
  guide covers it [22].
- **Spring Boot** for the API: see [../web](../web/README.md#why-this-toolchain).
- **Ports:** 8080 is Spring Boot's default [18]. 4173 is the default port of
  `vite preview`, and 5173 the default of the dev server [10][8].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Temurin 21.0.8, Maven 3.9.16, Spring Boot 4.1.2, Node.js 26.8.2, npm 12.2.1, Vite 8.3.5, React 19.3.1. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. `brew install node` for Node.js [19]. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Java and Maven as in [../cli](../cli/README.md#platform-notes). The distribution's own `nodejs` package may be older than Vite needs; install a current LTS from <https://nodejs.org/en/download> [20]. `run.sh --verify` looks for `google-chrome` or `chromium` on `PATH` and skips the browser check if neither is found. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Java and Maven as in [../cli](../cli/README.md#platform-notes); Node.js with `winget install --id OpenJS.NodeJS.LTS -e` [21]. Native PowerShell, in two terminals: `cd backend; mvn package; java -jar target\hello-api.jar` and `cd frontend; npm ci; npm run build; npx vite preview`. |

## Expected output
`./run.sh --verify` (the log lines of the back end are shortened):
```text
==> 1/2 Start the backend (Spring Boot API) on http://localhost:8080
    WHY: the API must be up before the front end can ask it for the message.
 :: Spring Boot ::                (v4.1.2)
... INFO ... : Started HelloApiApplication in 2.688 seconds (process running for 3.685)
{"message":"Hello, World!"}

==> 2/2 Start the front end (Vite serving the React build) on http://localhost:4173
    WHY: Vite serves frontend/dist and forwards /api/* to the backend (see vite.config.js).
    Check 1: GET /api/hello on the FRONT END's port, which Vite forwards to Spring Boot:
  ➜  Local:   http://localhost:4173/
  ➜  Network: use --host to expose
{"message":"Hello, World!"}
    Check 2: load the page in headless Chrome and show what React drew:
<div id="root"><p>Hello, World!</p></div>
```
By hand, with `./run.sh` running:
```text
$ curl -i http://localhost:8080/api/hello        # the backend directly
HTTP/1.1 200 
Content-Type: application/json
Content-Length: 27

{"message":"Hello, World!"}

$ curl -i http://localhost:4173/api/hello        # the same call through the front end
HTTP/1.1 200 OK
content-type: application/json
content-length: 27

{"message":"Hello, World!"}
```
`curl http://localhost:4173/` returns only `index.html` with an empty
`<div id="root"></div>`: the text appears only after the browser runs
React. The browser shows: **Hello, World!**

![The page at http://localhost:4173/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --virtual-time-budget=10000 --screenshot=screenshot.png http://localhost:4173/`.)

## Sources
1. System Requirements. Spring Boot. <https://docs.spring.io/spring-boot/system-requirements.html> (accessed 2026-10-31)
2. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (accessed 2026-10-31)
3. Developing Your First Spring Boot Application. Spring Boot. <https://docs.spring.io/spring-boot/tutorial/first-application/index.html> (accessed 2026-10-31)
4. `createRoot`. React. <https://react.dev/reference/react-dom/client/createRoot> (accessed 2026-10-31)
5. `useState`. React. <https://react.dev/reference/react/useState> (accessed 2026-10-31)
6. StrictMode. React. <https://react.dev/reference/react/StrictMode> (accessed 2026-10-31)
7. Getting Started. Vite. <https://vite.dev/guide/> (accessed 2026-10-31)
8. Server Options. Vite. <https://vite.dev/config/server-options> (accessed 2026-10-31)
9. Command Line Interface. Vite. <https://vite.dev/guide/cli> (accessed 2026-10-31)
10. Preview Options. Vite. <https://vite.dev/config/preview-options> (accessed 2026-10-31)
11. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (accessed 2026-10-31)
12. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (accessed 2026-10-31)
13. JEP 395: Records. OpenJDK. <https://openjdk.org/jeps/395> (accessed 2026-10-31)
14. CORS. Spring Framework. <https://docs.spring.io/spring-framework/reference/web/webmvc-cors.html> (accessed 2026-10-31)
15. `useEffect`. React. <https://react.dev/reference/react/useEffect> (accessed 2026-10-31)
16. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
17. Creating a React App / Build a React app from Scratch. React. <https://react.dev/learn/creating-a-react-app>, <https://react.dev/learn/build-a-react-app-from-scratch> (accessed 2026-10-31)
18. Common Application Properties (server.port). Spring Boot. <https://docs.spring.io/spring-boot/appendix/application-properties/index.html> (accessed 2026-10-31)
19. node (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/node> (accessed 2026-10-31)
20. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (accessed 2026-10-31)
21. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (accessed 2026-10-31)
22. Deploying a Static Site. Vite. <https://vite.dev/guide/static-deploy> (accessed 2026-10-31)
