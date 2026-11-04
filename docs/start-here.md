# Start here

> Part of [Hello World in many languages](../README.md)

Every example in this repository is run the same way, on every operating
system: open a terminal in the example's folder and run its scripts. This
page shows how to get a terminal that can run them, and what the scripts do.

## 1. Get the code
- **One example:** on the website, open a language page and click
  **Download ZIP** next to the example. Unzip it. The ZIP keeps the paths of
  the repository, so the example is in `languages/<language>/<category>/`
  inside the unzipped folder, next to the shared `scripts/common.sh`.
- **Everything:** clone the repository with Git.

## 2. Open a terminal that runs `sh` scripts
The scripts are POSIX `sh` scripts ([CONTRIBUTING.md](../CONTRIBUTING.md#script-contract)).

| System | Terminal | Status |
|---|---|---|
| macOS (Intel) | Terminal (in Applications → Utilities) | verified: the development machine |
| macOS (Apple Silicon) | Terminal | documented, not verified |
| Linux | any terminal | documented, not verified |
| Windows | **Git Bash**, which comes with [Git for Windows](https://gitforwindows.org/), or a Linux shell in [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) | documented, not verified. Each README also lists the native Windows commands |

## 3. Run the three scripts
```sh
cd languages/<language>/<category>   # e.g. languages/python/cli
./install.sh                         # check the toolchain; asks before installing anything
./build.sh                           # compile (compiled languages only)
./run.sh                             # run it
```
- `install.sh` checks whether the toolchain is there. When something is
  missing, it shows the install command for your system (for example with
  [Homebrew](https://brew.sh/) on macOS or `apt` on Debian and Ubuntu) and
  asks before it runs it. If you say no, it only prints the command. It never
  runs `sudo` without showing it first.
- `build.sh` exists only where the language is compiled.
- `run.sh` prints `Hello, World!` (cli), opens a window (desktop), or starts
  a web server on `http://localhost:8080/` (web; change it with `PORT=...`).

Every script says what it does and why while it runs. Each example's README
explains the code step by step ("Step-by-step walkthrough") and has
"Platform notes" for each operating system.

## 4. Where to go next
- New to programming? Follow the
  [guided path through the walkthroughs](comparisons.md#a-guided-path-through-the-walkthroughs).
- Curious about the ideas behind the languages? Read the
  [paradigms](paradigms.md).
