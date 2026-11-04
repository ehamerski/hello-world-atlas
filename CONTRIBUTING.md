# Contributing

Thank you for helping. This repository is a teaching resource, so every
change must keep three promises: the programs run, every fact has a
source, and the explanations are clear to a student who reads them for
the first time.

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
LICENSE                      MIT for code, CC BY 4.0 for prose
CITATION.cff                 how to cite this repository
docs/start-here.md           where a new reader should begin
docs/paradigms.md            the 4 paradigms and their languages
docs/comparisons.md          comparisons between languages
docs/ai-new-paradigm.md      closing essay
docs/sources.md              which sources are accepted and how they are cited
docs/platform-support.md     where the programs are verified
docs/templates/              templates for READMEs and scripts
docs/contributing/           style guide and glossary of terms
scripts/common.sh            shared shell helpers
scripts/verify-all.sh        runs every implementation (local CI)
scripts/check-links.sh       checks every relative link in the READMEs
scripts/check-prose.sh       checks the prose against the style guide (Vale)
scripts/gen-readme.py        writes the generated tables from every meta.yml
scripts/build-site.sh        builds the website from languages/ and docs/
site/                        the website project (no content of its own)
languages/README.md          every implementation (generated) + meta.yml schema
languages/<language>/README.md     language overview
languages/<language>/meta.yml      facts about the language, read by gen-readme.py
languages/<language>/<category>/   one implementation
```
- `<language>` is one of: `pseudocode`, `c`, `cpp`, `java`, `csharp`, `go`,
  `python`, `node`, `rust`, `php`, `haskell`, `lisp`, `prolog`, `pascal`,
  `cobol`, `clipper`, `basic`, `fortran`, `ada`, `assembly`.
- `<category>` is one of: `cli`, `desktop`, `web`, `web-react`,
  `web-angular`, `web-vue`. Only the `web-<fe>` folders have a separate
  front end. In `web`, the server sends the HTML itself.
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

Check everything with:
```sh
scripts/verify-all.sh                 # all implementations
scripts/verify-all.sh python/cli      # one implementation (languages/ is optional)
scripts/check-links.sh                # every relative link and #anchor
python3 scripts/gen-readme.py --check # generated tables match every meta.yml
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
      For web and desktop, Expected output shows `screenshot.png` (the
      page or the window) and says how it was taken.
- [ ] From a clean shell, `install.sh → build.sh → run.sh` succeeds on
      your machine. Paste the commands and their output (or a
      screenshot for web and desktop) in the pull request, with your OS.
- [ ] `scripts/verify-all.sh <language>/<category>` passes.
- [ ] An entry in the language's `meta.yml`, the tables regenerated
      (`python3 scripts/gen-readme.py --check` passes), and
      `scripts/check-links.sh` reports no broken link.

**All text**
- [ ] Written according to the [style guide](docs/contributing/style-guide.md),
      with the terms of the [glossary](docs/contributing/glossary.yml).
- [ ] `scripts/check-prose.sh` reports no alert.

**Each language** (`languages/<language>/README.md` and `meta.yml`)
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
The maintainer verifies on **macOS Intel**. macOS Apple Silicon, Linux and
Windows are documented in every README's "Platform notes" and marked
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
  License and your prose under CC BY 4.0, as described in
  [LICENSE](LICENSE).
