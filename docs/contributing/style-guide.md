# Style guide

This guide defines how the prose in this repository is written: every
README, every page in `docs/`, the text fields of each `meta.yml`, the
comments in the source code and the messages that the scripts print. It
applies to new text and to every change to existing text.

The guide builds on two published style guides. Where they disagree with
each other, or with this page, this page decides.

- Google developer documentation style guide:
  <https://developers.google.com/style>
- Microsoft Writing Style Guide:
  <https://learn.microsoft.com/en-us/style-guide/welcome/>

The rules are checked automatically by [Vale](https://vale.sh/docs/), a
prose linter, as far as a linter can check them (see
[Checking the text](#9-checking-the-text)). The glossary of technical terms
is in [`glossary.yml`](glossary.yml).

## 1. Audience and register
<!-- The rules below quote the words they ban, so Vale skips them. -->
<!-- vale off -->
- **Readers** are computer science students. Assume they can open a
  terminal and read code in one language, but do not assume they know the
  language on the page.
- **Register:** formal, technical and scientific. Write as in a textbook
  or a paper, not as in a blog post or a chat.
- **Person:** address the reader as *you* in instructions ("Run
  `./run.sh`"). Elsewhere, describe the subject in the third person. Do
  not use *I* or *we*: the text has no narrator.
- **Voice and tense:** prefer the active voice and the present tense. Use
  the past tense only for history.
- **No filler or marketing words.** Avoid *simply*, *just*, *easy*,
  *easily*, *obviously*, *of course*, *basically*, *very*, *really*,
  *amazing*, *powerful*, *blazing*, *cutting-edge*, *seamless*. What is
  easy for the writer may not be easy for the reader, and a claim of
  quality needs evidence, not an adjective.
- **No humor in the main text.** Jokes have their own page.
- **No contractions** in formal prose (*does not*, not *doesn't*). Quoted
  text keeps its contractions.
- **Short sentences**, one idea each. Split a sentence longer than about
  30 words.

## 2. Spelling and grammar
- **US English** (*color*, *behavior*, *organize*, *catalog*, *program*,
  *license* as both noun and verb). Quoted text and proper names keep
  their original spelling (*Centre*, *Programme*).
- The reference dictionary is Merriam-Webster:
  <https://www.merriam-webster.com/>.
- **Serial (Oxford) comma** in lists of three or more: *install, build,
  and run*.
- Use *e.g.* and *i.e.* only inside parentheses: *(e.g. Homebrew)*. In
  running text, write *for example* and *that is*.
- **Headings** use sentence case: *Platform notes*, not *Platform Notes*.
  Proper names keep their capitals.
- **Lists:** introduce a list with a complete sentence or a phrase ending
  in a colon. Items that are full sentences end with a period; fragments
  do not.

<!-- vale on -->

## 3. Terminology
- Use the terms in [`glossary.yml`](glossary.yml), spelled as there.
  Examples: *Hello World* (the program; *`Hello, World!`* is its output),
  *command line*, *front end* (noun) and *front-end* (adjective), *web
  server*, *macOS*, *Node.js*, *JavaScript*, *GitHub*.
- Use one term for one concept. Once a page calls something a *toolchain*,
  it does not switch to *tool set*.
- Define an abbreviation at its first use on each page: *command-line
  interface (CLI)*. Common ones (*HTML*, *URL*, *HTTP*) need no definition.
- Product and language names follow their owners' spelling: *COBOL*,
  *Fortran*, *Ada*, *Common Lisp*, *C#*, *C++*, *Go*, *Rust*, *PHP*,
  *Haskell*, *Prolog*, *Pascal*, *Clipper*, *BASIC*.

## 4. Facts and citations
The source rules are in [About the sources](../sources.md). In short:

- Every factual claim (date, name, version, ranking, percentage, "first",
  "most used") has a citation. A claim that cannot be sourced is removed.
- Cite with a numbered reference `[n]` in the text, pointing to the
  *Sources* section of the same page.
- A source entry has this form:
  `<Title>. <Author or publisher>. <https://...> (accessed YYYY-MM-DD)`.
- Market figures state their year and source in the sentence: *"TIOBE
  Index, October 2026: …"*.
- **Quotations** are copied word for word, in double quotation marks,
  with the source cited. Do not correct spelling inside a quotation.
- Hedge only as much as the source does. Do not write *probably* or
  *it is believed* to cover a missing source; find the source or delete
  the claim.

## 5. Numbers, dates, and units
- Spell out zero to nine in prose; use numerals for 10 and above, and
  always for versions, measurements, counts in tables and code.
- **Dates** use ISO 8601: `2026-11-03`. A month alone is written
  *October 2026*; a year alone, *1991*. Decades: *the 1970s*.
- Versions are written as their project writes them: *Python 3.14*,
  *Java 25*, *C++20*, *GTK 4*.
- Units take a space: *2 s*, *8 MB*, *2.1 GB*. Use SI prefixes for decimal
  sizes and IEC prefixes (*MiB*, *GiB*) only when the exact binary size
  matters.
- Ranges use an en dash without spaces: *1970–1980*, *pages 4–7*.

## 6. Code, commands, and file names
- Use `code formatting` for file and folder names, commands, flags,
  environment variables, function and variable names, literal output, and
  key names in configuration files: `run.sh`, `--verify`, `PORT`,
  `printf`.
- Put commands that the reader types in a fenced code block with a
  language tag (`sh`, `text`, `python`, …). Do not include a shell prompt
  (`$`), so the block can be copied as it is.
- Show output in a separate `text` block.
- Name keys in words: *Ctrl+C*, *Enter*.
- **Code comments** are in English, follow this guide, and explain *why*
  as well as *what*. Keep them short: one line per idea.
- **Script messages** (`step`, `explain`, errors) are complete sentences
  in the imperative or the present tense: *"Installing Flask. It is the
  web framework this example uses."* An error message says what failed
  and what the reader can do.

## 7. Links
- Link text describes the target: *see [About the sources](../sources.md)*,
  not *click here*.
- External links use HTTPS and point to the most authoritative page
  available (see section 4).
- Relative links between files of this repository are checked by
  `scripts/check-links.sh`.

## 8. Inclusive language
<!-- vale off -->
Follow the inclusive-language guidance of the Google guide
(<https://developers.google.com/style/inclusive-documentation>).

- Use *they* for a person whose gender is unknown, including "the
  student" or "the user". Do not write *he or she* or *he/she*.
- Use neutral technical terms: *allowlist* and *denylist*, *primary* and
  *replica*, *main branch*, *placeholder*, *stop* or *end* (a process).
- Do not describe a language, a tool or its users with contempt. Critical
  views are presented as quotations with their source.
- Do not use idioms or cultural references that a non-native reader may
  not know. The text is also the source for translations.

<!-- vale on -->

## 9. Checking the text
Vale applies the checks that a program can make: spelling against the US
English dictionary plus the project vocabulary, banned filler words,
preferred terms, British spellings, and the markers of internal work
notes, which must never appear in a published file. Run it from the
repository root:

```sh
scripts/check-prose.sh                  # every published Markdown file
scripts/check-prose.sh docs/paradigms.md   # one file or folder
```

- The rules are in [`.vale.ini`](../../.vale.ini) and
  [`.vale/styles/`](../../.vale/styles/).
- Words that are correct but missing from the dictionary (names, tools,
  commands) are added to `.vale/styles/config/vocabularies/HelloWorld/accept.txt`.
- Vale does not check code blocks or inline code. Grammar, clarity and
  facts still need a human reviewer.
