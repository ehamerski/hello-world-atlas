# Contributing

Thank you for helping. This repository is a teaching resource, so every
change must keep three promises: the programs run, every fact has a
source, and the explanations are clear to a reader who meets them for the
first time.

## Ways to help
- **Report a wrong fact or a dead link.** Open an issue with the page,
  the sentence, and a source that shows the correct fact (see
  [About the sources](docs/sources.md)).
- **Report a platform result.** Most implementations are verified only on
  macOS Intel (see [Platform support](docs/platform-support.md)). If you
  ran one on Linux, Windows or Apple Silicon, open an issue with the
  folder, your OS and version, the commands you ran and their output.
- **Fix or improve an implementation**, or **add a new one**, following
  the conventions below, through a pull request.

Pull requests are reviewed by the maintainer. An accepted change is
published with the next release.

## Repository layout
```text
README.md                    short intro + language table (generated part)
CONTRIBUTING.md              this file
CHANGELOG.md                 what changed in each release
LICENSE                      MIT License, for code
LICENSE-docs                 CC BY 4.0, for prose and images
NOTICE                       third-party files and their licenses
SECURITY.md                  how to report a security problem
CITATION.cff                 how to cite this repository
.gitignore .gitattributes    files git ignores; line endings per file type
.vale.ini  .vale/            prose style rules, read by scripts/check-prose.sh
.github/workflows/           GitHub Actions workflows (CI, iOS, site, release)
.github/dependabot.yml       automatic dependency update requests
ci/skip.yml                  folders verify-all.sh skips on one OS, with the reason
ci/timeouts.yml              folders that need a longer step timeout, with the reason
docs/start-here.md           where a new reader should begin
docs/about.md                purpose, audience, licenses and maintainer
docs/paradigms.md            the four core paradigms, plus concurrency and quantum
docs/comparisons.md          comparisons between languages
docs/ai-new-paradigm.md      closing essay
docs/off-the-record.md       light remarks and jokes about each language
docs/sources.md              which sources are accepted and how they are cited
docs/platform-support.md     where the programs are verified
docs/templates/              templates for READMEs and scripts
docs/contributing/           style guide, glossary of terms, translation guide
i18n/<locale>/               translations of the published pages
site/                        the website project (no content of its own)
scripts/approved.py          checks the folders, the site, the ZIPs and the export against languages/APPROVED.txt
scripts/build-site.sh        builds the website from languages/ and docs/
scripts/check-category-status.py   checks that each status in meta.yml is verified or explained in ci/skip.yml
scripts/check-downloads.sh   checks that every ZIP holds the files its scripts source
scripts/check-impl-table.py  checks that each language README table matches meta.yml
scripts/check-language.sh    checks that a language folder is complete
scripts/check-links.sh       checks every relative link in the READMEs
scripts/check-missing-categories.py   checks that a language README explains each missing category
scripts/check-product.sh     checks that published files hold no maintenance notes
scripts/check-prose.sh       checks the prose against the style guide (Vale)
scripts/check-sources.sh     requests every external URL (needs the network)
scripts/check-translations.sh  lists which translated pages are current, outdated or missing
scripts/common.sh            shared shell helpers
scripts/export-public.sh     copies the published files of a release into a folder
scripts/gen-readme.py        writes the generated tables from every meta.yml
scripts/package-downloads.sh packs one download ZIP per implementation
scripts/public-paths.txt     the paths that are published
scripts/stop-all.sh          stops processes left running (all or per language)
scripts/test-check-language.sh   checks that check-language.sh fails on broken input
scripts/use-runner-jdk.sh    picks JDK 21 on Windows (sourced by Java, Clojure, Kotlin)
scripts/verify-all.sh        runs every implementation (local CI)
languages/APPROVED.txt       the approved list: every language and its category folders
languages/README.md          every implementation (generated) + meta.yml schema
languages/<language>/README.md     language overview
languages/<language>/meta.yml      facts about the language, read by gen-readme.py
languages/<language>/<category>/   one implementation
languages/<language>/*.sh          Windows helpers that several categories source:
                                   msys2-env.sh and use-msys2-*.sh put MSYS2's
                                   tools first on PATH
languages/ruby/msys2-bin/          a bundle wrapper, so Git Bash can start
                                   MSYS2's Bundler on Windows
```
- `<language>` is any folder name under `languages/`. The current list is
  the generated table in
  [`languages/README.md`](languages/README.md#all-implementations).
- `<category>` is `cli`, `desktop`, `web`, `web-<front end>` (a web app
  with a separate front end, for example `web-react` or `web-rails`) or
  `mobile-<platform>` (for example `mobile-android` or `mobile-ios`). The
  same table lists every category folder in use. In `web`, the server
  sends the HTML itself.
- A second version of the same category gets a suffix:
  `<category>-<variant>` (for example `java/desktop-swing`). Pseudocode has
  no categories, so its folders are named after the dialect
  (`pseudocode/portugol`, `pseudocode/pseint`, `pseudocode/clrs`).
- A **documented-only** folder (for example `pseudocode/clrs`, which has
  no interpreter) has a README but no scripts. `scripts/verify-all.sh`
  lists it as skipped, and the root README marks it 📄.
- In the docs, `<language>/<category>` (for example `python/cli`) is short
  for `languages/<language>/<category>`. `scripts/verify-all.sh` accepts
  both forms.
- Each implementation is self-contained. It never imports from another
  implementation's folder. The only shared file it uses is `scripts/common.sh`.

## Starting a new implementation
Adding (or removing) a language or a category starts with
[`languages/APPROVED.txt`](languages/APPROVED.txt): add the language line,
or the category folder to its line. The checks compare every folder with
this list, so a folder that is not in it fails, and so does a listed
folder that is missing.
```sh
mkdir -p languages/python/cli
cp docs/templates/impl/README.md docs/templates/impl/*.sh languages/python/cli/
rm languages/python/cli/build.sh   # interpreted languages have no build step
# then fill every TODO(template) and every <placeholder>, and delete the
# TEMPLATE paragraph / comment at the top of each file
grep -rn 'TODO(template)\|TEMPLATE' languages/python/cli   # must print nothing
```
For a new language, also copy `docs/templates/language/README.md` to
`languages/<language>/README.md` and write `languages/<language>/meta.yml`
(schema: [`languages/README.md`](languages/README.md#metayml-schema)).
Every new implementation gets an entry under `categories:` in its
language's `meta.yml`. Then regenerate the tables:
```sh
python3 scripts/gen-readme.py           # rewrites the generated parts
python3 scripts/gen-readme.py --check   # exit 1 if they are out of date
```

## Script contract
Every implementation has `install.sh` and `run.sh`, plus `build.sh` when the
language is compiled. Each script:
- is POSIX `sh`, starts with `set -eu`, `cd`s to its own folder and sources
  `../../../scripts/common.sh`;
- has a header block with **WHAT**, **WHY**, **HOW** and **Platforms**;
- announces each step with `step` and says why it is needed with `explain`,
  so the student reads the reasons while the script runs;
- never runs `sudo` or installs anything without asking (`install_pkg`).

Settings that several scripts of one implementation share (a toolchain
version, its checksum, its install folder) go in a `<tool>-env.sh` file in
the same folder, for example `languages/pascal/cli/fpc-env.sh`. It is **sourced, not
run**: it starts with `# shellcheck shell=sh`, has a WHAT/WHY header, only
sets variables (and `PATH`), and is not executable (`chmod 644`).

`run.sh --verify` is the self-check used by `scripts/verify-all.sh`. It must
exit by itself and print `Hello, World!` to stdout:

| Category | `./run.sh` | `./run.sh --verify` |
|---|---|---|
| cli | prints `Hello, World!` | same |
| web | serves on `http://localhost:$PORT` until Ctrl+C | starts the server, prints the `curl` response, stops the server |
| desktop | opens a window showing `Hello, World!` | starts the app with `TF_VERIFY=1`: the app prints `Hello, World!` and closes its window after about 2 seconds |

Web servers use `PORT` (default `8080`, documented in the README).

`scripts/verify-all.sh` gives each step (`install.sh`, `build.sh`,
`run.sh --verify`) 300 seconds (`TF_VERIFY_TIMEOUT`). A folder whose cold
step is measured to take longer gets its own limit in `ci/timeouts.yml`, with
the reason. Add an entry only for a measured cold time plus a margin: the
limit still fails a step that hangs, so it must never be raised to hide one.

Check everything with:
```sh
scripts/verify-all.sh                 # all implementations
scripts/verify-all.sh python/cli      # one implementation (languages/ is optional)
scripts/check-links.sh                # every relative link and #anchor
scripts/check-sources.sh              # every external URL answers (network; run before a release)
python3 scripts/gen-readme.py --check # generated tables match every meta.yml
scripts/check-language.sh python      # one language is complete (no argument: all)
scripts/check-downloads.sh            # every download ZIP holds the files its scripts source
```

`scripts/check-sources.sh` collects every `http(s)` URL from the Markdown,
YAML, shell and site files, requests each one with `curl`, and prints a
summary. A URL passes when it answers 2xx after redirects. A failing URL is
retried once with a browser User-Agent. Status 429 is listed as "retry
later" and does not fail the run; sites that refuse robots (401, 403, 999)
are listed for a manual check. Any other failure is printed with the files
that cite it and the exit code is 1.

The script needs the network and takes a few minutes, so
`scripts/check-links.sh` does not run it. Pass paths to check only some
files, for example `scripts/check-sources.sh languages/dart`.

When a source moves, replace it with the publisher's new page or with an
Internet Archive copy (`web.archive.org/web/<timestamp>/<original URL>`) that
you opened. If no page can support a claim any more, change or remove the
claim.

Stop what is left running (a web server started by hand, an interrupted
verify run):
```sh
scripts/stop-all.sh --list            # only show what would be stopped
scripts/stop-all.sh                   # everything (asks first)
scripts/stop-all.sh java csharp/web   # only these folders
```

## Checklist for a pull request

**Each implementation** (`languages/<language>/<category>/`)
- [ ] Minimal source. A cli program prints exactly `Hello, World!`, a
      desktop program opens a window showing it, a web program serves it
      on a documented localhost port.
- [ ] Teaching comments in the source. They also point out differences
      from other languages.
- [ ] `install.sh`, `build.sh` (if compiled) and `run.sh` follow the
      script contract above.
- [ ] A README with all the sections of
      [`docs/templates/impl/README.md`](docs/templates/impl/README.md):
      What this is, Prerequisites, Quick start, Scripts explained, Folder
      structure, Step-by-step walkthrough, Why this toolchain, Platform
      notes, Expected output, Sources.
      For web, desktop and mobile, Expected output shows
      `screenshot.png` (the page, the window or the app screen) and says
      how it was taken. A folder without one says why under Expected
      output, in a sentence that contains "no screenshot" (for example,
      a page that is plain text, shown as text).
- [ ] From a clean shell, `install.sh → build.sh → run.sh` succeeds on
      your machine. Paste the commands and their output (or a
      screenshot for web and desktop) in the pull request, with your OS.
- [ ] `scripts/verify-all.sh <language>/<category>` passes.
- [ ] An entry in the language's `meta.yml`, the tables regenerated
      (`python3 scripts/gen-readme.py --check` passes), and
      `scripts/check-links.sh` reports no broken link.
- [ ] A new or changed external source passes
      `scripts/check-sources.sh <path>`, and you opened it and read the
      sentence that supports your text.

**All text**
- [ ] Written according to the [style guide](docs/contributing/style-guide.md),
      with the terms of the [glossary](docs/contributing/glossary.yml).
- [ ] `scripts/check-prose.sh` reports no alert.

**Each language** (`languages/<language>/README.md` and `meta.yml`)

A language is done when `scripts/check-language.sh <language>` passes. It
checks `meta.yml` (`humor.line` included), each category folder with its
README and `run.sh`, the site's tables for its main source files, the
generated README tables, the measured facts in `site/data/facts.json`, and
the prose. The script cannot check the items below that need a reader.
- [ ] `scripts/check-language.sh <language>` passes.
- [ ] History, dated milestones, market usage today (year and source),
      importance then and now, paradigm.
- [ ] Categories table linking to each implementation, comparison between
      its categories, and why any category is missing.
- [ ] Every factual claim is cited according to
      [About the sources](docs/sources.md). This includes `year` and
      `designers` in `meta.yml`, whose `sources` must be the same sources
      the README cites for them.
- [ ] `humor.line` in `meta.yml` (required): one light remark about the
      language for the [Off the record](docs/off-the-record.md) page,
      within the tone rule stated there. An entry for the Improbable
      Dictionary of Programming (`humor.dictionary`) is welcome
      (schema: [`languages/README.md`](languages/README.md#humor-keys)).

## Platforms
The maintainer verifies on **macOS Intel**. Linux (Ubuntu) and Windows
(Git Bash) can be verified in CI by
[`.github/workflows/ci-matrix.yml`](.github/workflows/ci-matrix.yml), which
is started by hand; its last passing run was on 2026-11-06. An
implementation's Linux and Windows rows say **verified in CI (date)** only
after a run of that workflow passed for it, with the date of that run.
Otherwise they say **not verified**. macOS Apple Silicon and WSL stay
**not verified** until someone runs them (see
[Platform support](docs/platform-support.md)). On Windows the scripts run
in Git Bash or WSL, and the README also lists the native Windows commands.
If you verify a platform, update its row in "Platform notes" with the date
and the versions you used.

## Commits and pull requests
- Work on a branch of your fork and open the pull request against the
  default branch.
- Commit messages follow
  [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
  with the scope `<language>/<category>`, `<language>`, or `scripts`,
  `docs`, `site`, `repo` for shared files:
  `feat(java/web): add Spring Boot hello world`,
  `docs(cobol): add history and milestones`,
  `fix(rust/desktop): pin eframe version`.
- Never commit secrets, `.env` files, build output or IDE files. The root
  [`.gitignore`](.gitignore) covers every toolchain. An implementation may
  add its own `.gitignore`.
- By contributing, you agree that your code is released under the MIT
  License ([LICENSE](LICENSE)) and your prose and images under CC BY 4.0
  ([LICENSE-docs](LICENSE-docs)).

## Versions and the public interface
Releases follow [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html),
and every release is described in [CHANGELOG.md](CHANGELOG.md). The
version number protects what a reader, a script or a link may rely on:
- **the script contract**: the names `install.sh`, `build.sh` and `run.sh`,
  `run.sh --verify` printing `Hello, World!` and exiting on its own, and
  the `PORT` variable of web servers (see
  [Script contract](#script-contract));
- **the folder layout**: `languages/<language>/<category>/`, and the
  `scripts/` commands named in the README;
- **the website addresses**: a page per language at
  `languages/<language>/` and per implementation at
  `languages/<language>/<category>/`, the same under each translation.

Removing or renaming any of these needs a new major version. A new
language, implementation or page needs a new minor version; a fix that
keeps them as they are needs a new patch version. Wording, sources and
toolchain versions inside an implementation are not part of the
interface.
