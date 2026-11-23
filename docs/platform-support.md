# Platform support

This page says where the programs in this repository are known to work,
how that is checked, and what is not checked.

## Summary
| Platform | Status |
|---|---|
| macOS on Intel (x86-64) | ✅ verified on the development machine (each README's Platform notes give the date) |
| macOS on Apple Silicon | ⚠️ not verified, except the [Swift iOS app](../languages/swift/mobile-ios/README.md) on a CI runner |
| Linux (Ubuntu, x86-64) | ✅ verified in CI on 2026-11-06: the 67 implementations in that run. ⚠️ Not verified in CI: the implementations added after it |
| Windows (Git Bash) | ✅ verified in CI on 2026-11-06: the 66 implementations in that run (the [Lua desktop app](../languages/lua/desktop/README.md) was skipped). ⚠️ Not verified in CI: the implementations added after it |
| Windows (WSL) | ⚠️ not verified |

**Verified** means that the implementation was installed, built and run
on that platform and printed or showed `Hello, World!`. **Verified in CI**
means the same check ran on a GitHub-hosted virtual machine, on the date
given (see [Linux and Windows in CI](#linux-and-windows-in-ci)). **Not verified**
means the README gives the commands for that platform, taken from the
toolchain's official documentation, but nobody has run them there yet.
Every implementation README has a **Platform notes** table with the exact
status, date and commands for each platform.

## How an implementation is checked
`scripts/verify-all.sh` runs every implementation folder the way a reader
would, and passes it only when every step exits with status 0 and the
output contains `Hello, World!`:
1. `install.sh`, which checks the toolchain (and asks before installing
   anything);
2. `build.sh`, for compiled languages;
3. `run.sh --verify`, a self-check that ends by itself:

| Category | What `run.sh --verify` does |
|---|---|
| cli | runs the program; it prints `Hello, World!` |
| desktop | opens the window; the program prints `Hello, World!` and closes the window after about 2 seconds |
| web | starts the server, fetches the page with `curl`, prints the answer and stops the server |

You can run it yourself, for every folder or for one:
```sh
scripts/verify-all.sh
scripts/verify-all.sh python/cli
```

Web implementations run on their own free ports (from 18000, so a server
you started on 8080 does not interfere), and `verify-all.sh` stops whatever
each folder leaves running, also when you press Ctrl+C.

## Last full check
The last full check ran on 2026-11-02 on macOS 26.7.2, Intel x86-64. It
started from a fresh `git clone` of tag `v1.0.0-rc.1`, the release
candidate of `v1.0.0`; the final `v1.0.0` changed only documentation
files, no code or scripts. In each folder,
`install.sh` was answered "yes" to every question, then
`scripts/verify-all.sh` ran all folders:

```text
Summary: 46 passed, 0 failed, 1 documented only
```

The one **documented only** folder is
[CLRS pseudocode](../languages/pseudocode/clrs/README.md): it is a
textbook notation with no interpreter, so there is nothing to run. Each
implementation's current status is in the table of
[all implementations](../languages/README.md#all-implementations).

## Linux and Windows in CI
The workflow [`.github/workflows/ci-matrix.yml`](../.github/workflows/ci-matrix.yml)
runs the same check on GitHub Actions, one job per language and per
system:

```sh
scripts/verify-all.sh --install languages/<language>
```

`--install` lets `install.sh` install what is missing without asking,
because each runner is a fresh virtual machine that is thrown away after
the job. On Linux, desktop programs draw into a virtual X display (Xvfb).
Some toolchains are already on the runner images (for example Go,
.NET, Node.js, PHP, Python and Rust). For those, `install.sh` only checks
the version it finds; on a machine without them it prints the install
steps and stops, as each README's Platform notes say.
Folders that cannot run on one system are listed, with the reason and a
source, in [`ci/skip.yml`](../ci/skip.yml), and `verify-all.sh` prints
them as skipped. There is one: the Lua desktop app on Windows. The
runner has no GPU, and LÖVE needs OpenGL 2.1 or later.

The last run that passed was on 2026-11-06, on the `develop` branch; it
ran every implementation that existed on that day. The later runs stopped
before any implementation ran, so they verify nothing:

| Runner label | Image | Result |
|---|---|---|
| `ubuntu-latest` | Ubuntu 26.04, x86-64 | 67 passed, 0 failed, 1 documented only |
| `windows-latest` | Windows Server 2025, Git Bash | 66 passed, 0 failed, 1 skipped, 1 documented only |

The implementations added after that day (for example the Dart, Swift,
Objective-C and Smalltalk folders) are **not verified in CI**: their
Linux and Windows rows say **not verified**, and their macOS Intel row
gives the result on the development machine. An implementation that
passed on 2026-11-06 may have changed since; its macOS Intel row gives
the date of its latest check. Each README's Platform notes table says
which case applies.

The runner labels and the software on each image are listed in the
[GitHub Actions runner images](https://github.com/actions/runner-images)
repository. On Windows, `bash` in a workflow is the Git Bash that comes
with the image
([workflow syntax: `defaults.run.shell`](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#defaultsrunshell)).

## Known limits
- **Three verified platforms.** macOS on Intel is verified on the
  development machine; Linux (Ubuntu on x86-64) and Windows (Git Bash)
  were verified in CI on 2026-11-06, for the implementations that existed
  then. macOS on Apple Silicon, other Linux distributions,
  Linux on ARM and WSL are documented, not tested.
- **The machine already had the toolchains.** The clean clone ran on a
  computer that already had the compilers installed. `install.sh` did
  install every per-project dependency (npm, Maven, Cargo, NuGet and
  others) into the fresh clone, and it suggests the system install for
  anything that is missing. A machine with no toolchains at all has not
  been tested.
- **Desktop windows are checked by the program itself.**
  `run.sh --verify` opens and closes the window automatically. The
  screenshots in the desktop READMEs were taken and checked by eye.
- **Market figures age.** The TIOBE and Stack Overflow numbers in the
  language pages are dated ("October 2026", "2026"), and each source has
  its access date, as [About the sources](sources.md) requires.

If you run an implementation on a platform marked **not verified**,
please report the result; see [CONTRIBUTING.md](../CONTRIBUTING.md).
