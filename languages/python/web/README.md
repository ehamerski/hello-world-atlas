# Python · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Python](../README.md)

## What this is
A small web server written with Flask. When a browser asks for
`http://localhost:8080/`, the server answers with the HTML
`<p>Hello, World!</p>`, which the browser shows as the text **Hello, World!**.
The server sends the HTML itself; there is no separate front end.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Python 3 (`python3.14` on macOS, `python3` elsewhere) | 3.14.10 (Homebrew `python@3.14`) | runs Flask and `app.py` |
| Flask | 3.1.3 (pinned in `requirements.txt`) | the web framework; `install.sh` installs it into `.venv/` |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

Flask 3.1 "supports Python 3.9 and newer" [2].

On macOS the scripts call `python3.14`, not `python3`. Homebrew's
`python@3.14` puts only versioned names on PATH; "Unversioned names such as
`python` ... are installed into `$(brew --prefix python)/libexec/bin`" [15],
and a plain `python3` on macOS is often Apple's older `/usr/bin/python3`.
The python.org installer provides `python3.14` too. Set `PYTHON=python3` (or
any other command) to override this.

## Quick start
```sh
./install.sh   # check Python, create .venv/, install Flask (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks the interpreter (`python3.14` on macOS, `python3` elsewhere) and shows how to install it. 2. Creates the virtual environment `.venv/` with `python3.14 -m venv .venv`. 3. Installs Flask with `.venv/bin/python -m pip install -r requirements.txt`. Steps 2 and 3 ask first. | Flask is a third-party package. The Flask docs say to "use a virtual environment to manage the dependencies for your project" [2]. A venv has "its own independent set of Python packages" [3], so nothing is installed into your system Python. |
| `run.sh` | Starts `.venv/bin/flask --app app run --port 8080`. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | `flask run` starts Flask's development server [4]. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`, because Python is interpreted, as in the
[cli](../cli/README.md#why-there-is-no-build-step).

## Folder structure
```text
web/
├── README.md         this file
├── install.sh        checks Python, creates .venv/, installs Flask
├── run.sh            starts the server
├── app.py            the web application (Flask's minimal app)
├── requirements.txt  the packages to install, with pinned versions
└── .venv/            created by install.sh; not committed (see ../../../.gitignore)
```
- `app.py` is the module name `flask` looks for first: "If `--app` is not
  set, the command will try to import 'app' or 'wsgi'" [5]. `run.sh` still
  passes `--app app` so the command says what it runs.
- `requirements.txt` is the file format `pip install -r` reads [6].
- `.venv` is the folder name the Flask installation guide uses [2].
- A bigger Flask app would become a package folder with `templates/` and
  `static/`, as in the Flask tutorial [7]. A single page needs neither.

## Step-by-step walkthrough
Open [`app.py`](app.py) next to this list.

1. **`from flask import Flask`** loads the `Flask` class from the installed
   package. Unlike the [cli](../cli/hello.py), which uses only the built-in
   `print`, this program depends on a library from PyPI.
2. **`app = Flask(__name__)`** creates the application. The first argument
   is "the name of the application's module or package", and Flask needs it
   "so that Flask knows where to look for resources such as templates and
   static files" [1].
3. **`@app.route("/")`** is a decorator. It tells Flask "what URL should
   trigger our function" [1]. Other frameworks in this repository register
   routes in their own way: Express uses `app.get("/", ...)`, Spring Boot
   uses `@GetMapping("/")`, and Go uses `http.HandleFunc("/", ...)`.
4. **`return "<p>Hello, World!</p>"`**: when a view returns a string, Flask
   converts it into a response "with the string as response body, a 200 OK
   status code and a text/html mimetype" [1]. You can see this in the
   `curl -i` output below.
5. **No `main`, no loop.** The file only defines the app. The `flask run`
   command imports it and runs the server loop that waits for requests.
   This is the biggest difference from the cli version, which runs once and
   exits.

## Why this toolchain
- **Flask** describes itself as "a lightweight WSGI web application
  framework", "designed to make getting started quick and easy" [8]. A Hello
  World page takes 5 lines of code, which suits the aim of this repository
  to keep each program as simple and direct as possible.
- Flask is among the most used Python web frameworks. In the Python
  Developers Survey 2024 (PSF and JetBrains, responses from October and
  November 2024), FastAPI was used by 38%, Django by 35%, and Flask by 34%
  of respondents [9]. In the Stack Overflow Developer Survey 2026, 12.5% of all
  respondents to the web frameworks question used Flask [10].
- This page does not use the other two. A Django project starts with
  `django-admin startproject`, which generates a `manage.py` and a settings
  package (`settings.py`, `urls.py`, `asgi.py`, `wsgi.py`) [12]. FastAPI is
  "a web framework for building APIs" [13]. Flask serves an HTML string
  from one file, which is the smallest setup for an HTML Hello World.
- **Port 8080** instead of Flask's usual 5000: "macOS Monterey and later
  automatically starts a service that uses port 5000" (AirPlay Receiver)
  [4]. Port 8080 is also the convention of this repository for every web
  implementation.
- **Development server only.** Flask warns: "Do not use the development
  server when deploying to production" [4]. A production deployment needs a
  WSGI server, which is out of scope for a Hello World program.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Python 3.14.10 (Homebrew), Flask 3.1.3. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `python3` and `python3-venv` with apt when missing [14]. It creates `.venv` and installs Flask from `requirements.txt` with pip. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install Python: if the interpreter (`PYTHON`, default `python3`) is missing it prints the `winget` and `py install 3.14` steps and stops. [11] It creates `.venv` (it finds `.venv/Scripts/` automatically) and installs Flask from `requirements.txt` with pip. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'flask --app app run' imports app.py and serves it on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:8080
Press CTRL+C to quit
```
In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Server: Werkzeug/3.1.9 Python/3.14.10
Date: Fri, 30 Oct 2026 18:29:54 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 20
Connection: close

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Quickstart. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/quickstart/> (accessed 2026-10-30)
2. Installation. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/installation/> (accessed 2026-10-30)
3. venv: Creation of virtual environments. Python Software Foundation. <https://docs.python.org/3/library/venv.html> (accessed 2026-10-30)
4. Development Server. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/server/> (accessed 2026-10-30)
5. Command Line Interface. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/cli/> (accessed 2026-10-30)
6. Requirements File Format. pip documentation. <https://pip.pypa.io/en/stable/reference/requirements-file-format/> (accessed 2026-10-30)
7. Project Layout (Tutorial). Flask (Pallets). <https://flask.palletsprojects.com/en/stable/tutorial/layout/> (accessed 2026-10-30)
8. Welcome to Flask. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/> (accessed 2026-10-30)
9. Python Developers Survey 2024 Results. Python Software Foundation and JetBrains. <https://lp.jetbrains.com/python-developers-survey-2024/> (accessed 2026-10-30)
10. 2026 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2026/technology> (accessed 2026-10-30)
11. Using Python on Windows. Python Software Foundation. <https://docs.python.org/3/using/windows.html> (accessed 2026-10-30)
12. Writing your first Django app, part 1. Django Software Foundation. <https://docs.djangoproject.com/en/stable/intro/tutorial01/> (accessed 2026-10-30)
13. FastAPI. FastAPI documentation. <https://fastapi.tiangolo.com/> (accessed 2026-10-30)
14. python3-venv package (Debian stable). Debian. <https://packages.debian.org/stable/python3-venv> (accessed 2026-10-30)
15. Language Runtimes and Packages. Homebrew. <https://docs.brew.sh/Language-Runtimes-and-Packages> (accessed 2026-10-31)
