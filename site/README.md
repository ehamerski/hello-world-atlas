# The website

This folder holds the website project. It has **no content of its own**. On every build, the pages are generated from the repository's [`languages/`](../languages/README.md) and [`docs/`](../docs/) folders, so the site and the READMEs cannot drift apart.

Generator: [Astro](https://docs.astro.build/) with the [Starlight](https://starlight.astro.build/) documentation theme. The exact versions are pinned in `package-lock.json`.

## Build and preview

From the repository root (Node.js 22.23.4 or later, an even major version;
the site is built and tested with the major version in `.nvmrc`, 26):

```sh
scripts/build-site.sh            # build into site/dist/
scripts/build-site.sh --preview  # build, then serve on http://localhost:4321/
cd site && npm run preview       # serve an existing build
```

`scripts/build-site.sh` explains every step it runs. It installs the packages with `npm ci` (exact lockfile versions), runs `scripts/generate.mjs`, packs the download ZIPs with `scripts/package-downloads.sh`, runs `astro build`, then checks every link of the built site with `scripts/check-links.mjs`.

## What is where

| Path | What it is | In git? |
|---|---|---|
| `astro.config.mjs` | site title, menu (information architecture), locales | yes |
| `i18n.mjs` | the languages the site is built in (English at the root URL, others under `/<tag>/`) | yes |
| `site-ui.yml` | English strings of the site's own components (menu, banner, cards, timeline) | yes |
| `scripts/generate.mjs` | turns the repository Markdown and `meta.yml` files, and their translations in [`../i18n/`](../i18n/README.md), into pages; `--check` only checks that every implementation's main file has a known comment syntax and Shiki id (`--check python ruby`: only these languages) | yes |
| `scripts/check-links.mjs` | checks the links of the built HTML | yes |
| `scripts/source-code.mjs` | finds the comment lines, entry point and greeting line of a source file (used by the Anatomy sections, the comparator and the facts) | yes |
| `scripts/test-source-code.mjs` | fixture tests for the language tables and for `generate.mjs --check` | yes |
| `scripts/measure-facts.mjs` | measures every implementation (lines, files, dependencies, build output, run time) into `data/facts.json`; run it by hand, it builds and runs every cli program; `--check` only checks that `data/facts.json` is up to date | yes |
| `data/facts.json` | the measured facts, with the method and the machine, shown on the Measured facts page | yes |
| `scripts/check-a11y.mjs` | checks the built site against WCAG 2.2 AA with axe-core in light and dark mode; `--screenshots <dir>` also saves PNGs | yes |
| `plugins/academic.mjs` | numbered table and figure captions, bibliography-style Sources lists | yes |
| `src/pages/[...locale]/compare/side-by-side.astro`, `facts.astro`, `genealogy.astro` | the comparator, Measured facts and Genealogy pages | yes |
| `src/components/Footer.astro` | Starlight's footer plus the "Off the record" link | yes |
| `src/pages/[...locale]/languages/index.astro` | the language cards, filtered by paradigm, era and category (one page per locale) | yes |
| `src/components/Hero.astro` | the Starlight Home banner plus the "not translated yet" notice | yes |
| `src/styles/theme.css` | the visual identity: fonts, colors for light and dark, captions, references, print | yes |
| `src/styles/site.css` | styles of the site's own components (cards, Anatomy, comparator, charts) | yes |
| `src/content/docs/`, `src/generated/`, `public/assets/` | generated pages, data and images | no (generated) |
| `public/downloads/` | one ZIP per implementation | no (generated) |
| `dist/`, `.astro/`, `node_modules/` | build output and packages | no |

To change a page, edit the Markdown it comes from (for example `languages/python/README.md`), not the generated file.

## A new programming language

The site reads each source file with three tables, all looked up by the
language folder (`languages/<lang>/`) first and the file extension second:
the Shiki language id (`LANG_BY_EXT` in `scripts/generate.mjs`), the
comment syntax (`COMMENT_SYNTAX` in `scripts/source-code.mjs`) and the
entry point (`ENTRY`, same file). An extension needs a language entry only
when two languages share it: `.pl` is Perl in `languages/perl/` and Prolog
in `languages/prolog/`.

After adding a language, run:

```sh
scripts/check-language.sh <lang>           # every check of a complete language, these included
node site/scripts/generate.mjs --check     # fails if a main file has no known comment syntax or Shiki id
node site/scripts/measure-facts.mjs --only <lang>   # measures it into data/facts.json
node site/scripts/test-source-code.mjs     # the fixture tests of the tables
```

## Languages of the site

English is the source of truth and is served at the root URL. Each other
language has its own URL folder (`/pt-br/` for Brazilian Portuguese) and a
language picker in the header. The list is in `i18n.mjs`. A page that is not
translated yet shows the English text with a notice. Starlight translates
its own interface (search, "On this page", the notice) by itself. How to
translate, and how `scripts/check-translations.sh` tracks outdated
translations, is in [`../i18n/README.md`](../i18n/README.md).

## Environment variables

- `SITE_BASE`: the URL path the site is served under. The default `/` works for a local preview. A GitHub Pages project site needs `/<repository name>/`, which `.github/workflows/pages.yml` sets.
- `SITE_URL`: the origin the site is published at (for GitHub Pages `https://<owner>.github.io`), used for canonical links and the sitemap. The default `http://localhost:4321` fits a local preview.
- `REPO_URL`: where links to non-page files (scripts, sources) point. The default is the GitHub repository on branch `develop`.
- `REPO_ROOT`: the repository `scripts/generate.mjs` reads. The default is the repository the script is in; the fixture tests point it to a temporary folder.
