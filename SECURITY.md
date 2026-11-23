# Security policy

## Supported versions

Only the latest release gets security fixes. The releases are listed in
[CHANGELOG.md](CHANGELOG.md). A fix goes into a new patch version; older
versions are not updated.

## What to report

Report a problem in the files of this repository, for example:

- a script (`install.sh`, `build.sh`, `run.sh` or a helper in `scripts/`)
  that runs a download without asking, or without checking what it
  downloaded;
- a library version pinned in a lockfile (`package-lock.json`,
  `Cargo.lock`, `Gemfile.lock`, `go.sum`, `mix.lock`, `pubspec.lock`,
  `requirements.txt`) that has a published advisory;
- a page of the website that runs code it should not, such as a script
  injected through a README or `meta.yml`;
- a password, key or token committed by mistake.

A problem in a compiler, interpreter, framework or library itself belongs
to that project. Report it there; open a report here only if this
repository needs to change because of it.

## How to report

Use GitHub private vulnerability reporting: open
[Report a vulnerability](https://github.com/ehamerski/hello-world-atlas/security/advisories/new)
on the repository's **Security** tab. Only you and the maintainer can read
the report. GitHub describes the steps in
[Privately reporting a security vulnerability](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately).

Do not open a public issue or pull request for a vulnerability before it
is fixed.

Say which file and which release or commit, what can happen, and the
steps that show it.

## What to expect

- The maintainer replies in the advisory and says whether the report is
  accepted.
- An accepted report is fixed in a new patch release. The fix is listed
  under **Security** in [CHANGELOG.md](CHANGELOG.md), and the advisory is
  published when the release is out.
- You are credited in the advisory unless you ask not to be.
