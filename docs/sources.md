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

Found a wrong fact or a dead link? Please report it; see
[CONTRIBUTING.md](../CONTRIBUTING.md).
