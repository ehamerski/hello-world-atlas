# About the sources

Every page in this repository states facts: dates, names, versions,
rankings, percentages, and how compilers and libraries behave. Each fact
must be **real, reliable and accessible**: a reader has to be able to open
the source and check it. This page explains which sources are used, how
they are cited, and how they are checked.

## 1. Which sources are accepted
In order of preference:

1. **Official documentation** of the language, compiler, framework or
   vendor (e.g. python.org, go.dev, learn.microsoft.com, the GNU manuals).
2. **Standards bodies** that publish the language standard: ISO/IEC,
   ANSI, ECMA International, IEEE.
3. **Original papers and books** by the language authors.
4. **Recognized industry surveys and indexes**, for market usage:
   - Stack Overflow Developer Survey: https://survey.stackoverflow.co/
   - TIOBE Index: https://www.tiobe.com/tiobe-index/
   - IEEE Spectrum Top Programming Languages: https://spectrum.ieee.org/
   - GitHub Octoverse: https://octoverse.github.com/
5. **Wikipedia only together with a primary source** from 1–3 that
   supports the same claim. Wikipedia alone is not enough.

Not accepted: blogs, forums, AI-generated text, or content farms as the
only source of a fact. They may be linked as "further reading" only.

Some facts need kinds of source that the list above does not name. They are
accepted in these forms:
- **Vendor documentation for platforms and toolchains**, for the `mobile`
  category and for toolchains with no standard: for example the Android
  SDK and Android Gradle plugin documentation (developer.android.com),
  Apple's Xcode and SwiftUI documentation (developer.apple.com), and
  Flutter's installation guide (docs.flutter.dev). A version number or a
  requirement ("needs Gradle 9.6 or newer") cites the page of the vendor
  that states it, and the README gives the version it actually ran.
- **History papers and talks by a language's authors**, such as the HOPL
  papers (History of Programming Languages conference, ACM SIGPLAN) and
  doctoral theses. They are the best source for "why was this language
  made". An author's own copy is cited when the publisher's page blocks
  automated reading (see section 5).
- **Source archives of the tool itself**, when a language has no website
  of its own: for example the QCL source archive (the README inside it is
  the source for what QCL says about itself) and the GNU Cim manual for
  Simula. The archive and its version are named.
- **Archives that preserve old standards and reports**, for languages from
  before the web, such as the Simula 67 Common Base Language report held by
  the Software Preservation Group.
- **Package registries and release pages** for "the current version is":
  the registry or the project's releases page, with the access date.

## 2. Rules for every claim
- **Every factual claim has a citation**: dates, names, versions,
  "first", "most used", rankings, percentages.
- **Every number states its year and its source**, e.g. "TIOBE Index,
  October 2026: …". Market figures change every year, so they are never
  presented as timeless.
- **Unverifiable means removed.** If a claim cannot be confirmed in an
  accessible source, it is dropped, not softened.
- **No invented APIs or tool behavior.** Commands, flags and library calls
  are checked against the official docs or by actually running them.
- **Quotes** (e.g. teachers' critical views in `pseudocode/`) are copied
  word for word, with author, publication and year.

### Facts about ideas, not only about tools
[Paradigms](paradigms.md) and [the AI essay](ai-new-paradigm.md) state
claims about ideas: what the actor model is, where object orientation came
from, what a contract in Eiffel promises. For those pages:
- The claim is a **quote** or a close paraphrase of a primary source: the
  paper that proposed the idea (for example Hewitt, Bishop and Steiger for
  actors, 1973), the language's own documentation, or its author's account.
- A **link between two ideas or languages** ("Objective-C's additions to C
  are mostly based on Smalltalk") needs a source that says so. If no source
  states the link, the page may still compare the two, and then it says
  that the comparison is this repository's own, not a historical claim.
- A **side remark** about a tool, such as "Qiskit is an open-source SDK",
  cites the tool's own documentation and says no more than that page says.
  Rankings and usage figures need a dated survey from section 1.

## 3. Rules for links
- **HTTPS only.** Links must be publicly accessible, with no login or
  paywall. If a standard is paywalled (e.g. ISO), cite its catalog page
  and an accessible description from the publisher.
- Each entry in a **Sources** section uses this format:
  `<Title>. <Publisher/Author>. <https://...> (accessed YYYY-MM-DD)`
- In the text, cite with a numbered reference `[n]` pointing to the list.

## 4. Security of installers
Trustworthy sources also matter for the software a reader installs:
- Toolchains are installed only from the **official installer** or an
  established **package manager** (Homebrew, apt, winget).
- `install.sh` never runs `sudo` or downloads code silently: it shows the
  command and asks first (see `scripts/common.sh`, `install_pkg`).
- No `curl … | sh` pipelines unless that is the vendor's documented
  official installer (e.g. GHCup, rustup), and then the README says so and
  links to the vendor page.

## 5. How sources are checked
- Every new or changed page is reviewed against its sources before it is
  published.
- Before each release, every link is opened and checked. Some sites
  (e.g. iso.org) refuse automated requests; those are checked by hand.
  Broken links are fixed, and claims without an accessible source are
  removed.
- `scripts/check-links.sh` checks every relative link and `#anchor`
  between the repository's own Markdown files.
- The sources a language cites for its year, designers and paradigm live in
  its `meta.yml` (`sources`). `scripts/gen-readme.py` and the site generator
  read that file, so the **Sources** page of the website lists the same
  sources as the language README, grouped by language, and
  `scripts/check-language.sh` fails when the file is incomplete.
- A paper may be a PDF that a tool cannot read in the browser. Its quotes
  are checked against the text of the PDF, extracted on the maintainer's
  machine (for example with `pdftotext`), never from a summary of it.

Found a wrong fact or a dead link? Please report it; see
[CONTRIBUTING.md](../CONTRIBUTING.md).
