# Translating the website

The website is written in English, and English is the source of truth for
every text. A translation is made from the English file, follows it when
it changes, and is never changed ahead of it. This page lists the steps
to add a new human language (a *locale*) and the rules for keeping it
current. The file layout and the bookkeeping of a translated file are
described in [`i18n/README.md`](../../i18n/README.md).

Source code, code comments, file names, commands, script output and the
download ZIPs are not translated: they are the same for every reader.

## Checklist for a new locale

1. **Propose the locale.** Open an issue that names:
   - its [BCP 47 language tag](https://www.rfc-editor.org/info/bcp47),
     for example `es` or `pt-BR`. A region code is added only when the
     written language differs by region;
   - a **native-speaker reviewer**, who reviews every tier before it is
     released. A translation is not released without this review.
2. **Configure the site.** Add one entry to `LOCALES` in `site/i18n.mjs`
   (tag, URL folder and the name of the language in that language), and
   create the folder `i18n/<tag>/`. The labels of the site framework
   (search box, page navigation, theme switch) come from
   [Starlight's built-in translations](https://starlight.astro.build/guides/i18n/#translate-starlights-ui).
   If the language has none, add them as described there.
3. **Add the glossary column.** In
   [`glossary.yml`](glossary.yml), add the tag under `translations` of
   every term. Terms marked `do_not_translate: true` repeat the English
   term. The reviewer approves every other entry before the first page is
   translated, and every page then uses these entries.
4. **Translate the site's own strings.** Copy `site/site-ui.yml` to
   `i18n/<tag>/site-ui.yml` and translate each value. Keep every key and
   every `{placeholder}`.
5. **Translate in tiers.** Each tier is reviewed and released as a whole:

   | Tier | Content |
   |---|---|
   | T1 | Home (`README.md`), every reader page in `docs/` and `site-ui.yml`. The *Languages*, *Timeline* and comparison pages are built from `site-ui.yml` and the T2 data. |
   | T2 | The language pages (`languages/<language>/README.md`) and their `meta.yml` overlays |
   | T3 | The implementation pages (`languages/<language>/<category>/README.md`), the implementations table (`languages/README.md`) and `CONTRIBUTING.md` |

   The `LOCALES` entry puts the locale in the language picker of the
   site, so it reaches a release only when T1 is 100% current. Until then
   it stays on the branch where the translation is made, and the locale
   is seen only on a local build.
6. **Review.** The native-speaker reviewer reads each tier on the built
   site (`scripts/build-site.sh --preview`) and approves it or returns a
   list of corrections. A tier is released only when
   `scripts/check-translations.sh <tag>` shows every file of that tier as
   *current* and none as *outdated*.
7. **Maintain.** When an English file changes, the check reports its
   translation as *outdated*, and the site keeps showing the old
   translation until it is redone. Redo the translation from the new
   English file, record the new `source_sha`, and ask the reviewer to
   check the changed passages.

## Rules for translators

- **Register:** formal, technical and scientific, with the vocabulary that
  IT courses and IT professionals use in that language. The rules of the
  [style guide](style-guide.md) apply in the target language: no first
  person, no filler or marketing words, no humor outside the humor page.
- **Terms:** use the glossary entry of every term, on every page. A
  missing or doubtful term is added to the glossary first.
- **Completeness:** translate the whole file. Do not shorten, summarize or
  add text, and do not add translator notes.
- **Code and names stay as they are:** code blocks, inline code, commands,
  paths, URLs, program output, product names, and the titles of cited
  works.
- **Quotations** keep their original language and are followed by a
  translation marked as such, so that the citation still matches the
  source.
- **Humor** may be adapted instead of translated, because a joke rarely
  survives a word-for-word translation. The rules of the humor page still
  apply: no mocking of people or communities.
- **Links** keep the targets of the English file. Only links to a heading
  of the same page change, to match the translated heading.
- **Markers** in HTML comments (`<!-- vale off -->`,
  `<!-- BEGIN SITE: ... -->`, `<!-- BEGIN GENERATED: ... -->`) are kept
  exactly, in the same places.

## Checking a translation

```sh
scripts/check-translations.sh <tag>      # current, outdated or missing, per tier
scripts/check-product.sh                 # no process material in published files
scripts/build-site.sh --preview          # read the pages on the local site
```

`check-translations.sh` reports problems as warnings and never fails a
build, so a change to an English page is never blocked by a translation
that is behind.
