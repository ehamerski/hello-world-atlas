# Platform support

This page says where the programs in this repository are known to work,
how that is checked, and what is not checked.

## Summary
| Platform | Status |
|---|---|
| macOS on Intel (x86-64) | ✅ verified: every runnable implementation |
| macOS on Apple Silicon | ⚠️ not verified |
| Linux (Debian/Ubuntu) | ⚠️ not verified |
| Windows (Git Bash or WSL) | ⚠️ not verified |

**Verified** means that the implementation was installed, built and run
on that platform and printed or showed `Hello, World!`. **Not verified**
means the README gives the commands for that platform, taken from the
toolchain's official documentation, but nobody has run them there yet.
Every implementation README has a **Platform notes** table with the exact
status, date and commands for each platform.

## How an implementation is checked
`scripts/verify-all.sh` runs every implementation folder the way a student
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

## Known limits
- **One verified platform.** Only macOS on Intel is verified. The other
  platforms are documented, not tested.
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
