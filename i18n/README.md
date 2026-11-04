# Translations

English is the source of truth for every text in this repository. This
folder holds the translations of the website, one folder per language,
named by its [BCP 47 language tag](https://www.rfc-editor.org/info/bcp47)
(for example `pt-BR`). A translation is always made from the English file
and never changed ahead of it.

Source code, code comments, file names, script output and the download ZIPs
are not translated: they are the same for every reader.

## Layout

Each language folder mirrors the paths of the English files:

```text
languages/python/README.md                    English (the source)
languages/python/meta.yml                     English data
site/site-ui.yml                              English strings of the website's own components

i18n/pt-BR/languages/python/README.md         translation of languages/python/README.md
i18n/pt-BR/languages/python/meta.yml          translated fields of languages/python/meta.yml only
i18n/pt-BR/docs/start-here.md                 translation of docs/start-here.md
i18n/pt-BR/site-ui.yml                        translation of site/site-ui.yml
```

The website generator (`site/scripts/generate.mjs`) turns
`i18n/<tag>/<path>` into the page of `<path>` under the language's URL
folder, for example `/pt-br/start-here/`. A page that has no translation
yet shows the English page with a notice, so no link is ever broken. The
languages the website builds are listed in `site/i18n.mjs`.

## Rules for a translated file

1. **Record the English version.** A Markdown translation starts with this
   front matter; a `.yml` translation has the same two keys at the top:

   ```yaml
   ---
   source: docs/start-here.md
   source_sha: 428792575edcb39bda53c5039401e23c8693cbcd
   ---
   ```

   `source_sha` is the Git blob hash of the English file the translation was
   made from. Print it with `git hash-object docs/start-here.md`.
2. **Keep the links as they are in the English file.** The generator
   resolves them from the English file's folder and points them to pages in
   the same language. Only `#anchor` links into the same page change, to
   match its translated headings.
3. **`meta.yml`: only these fields are translated:** `year_note`, and per
   category (matched by `folder`) `label` and `run`. Names, years,
   designers, paradigms and sources are facts and stay as in English.
   `humor` is the exception: it may be **adapted** rather than translated,
   because a joke rarely survives a word-for-word translation. A `humor`
   in the translation replaces the English one whole, so it repeats `line`
   and every other key it keeps.
4. **`site-ui.yml`: keep every `{placeholder}`.** A key that is left out is
   shown in English.

## Checking the translations

```sh
scripts/check-translations.sh          # every language
scripts/check-translations.sh pt-BR    # one language
```

It lists each English file as **current** (the translation matches the
English file), **outdated** (the English file changed after the translation
was made) or **missing**, and prints the share of current files per
language. These are warnings: the check never fails a build.
