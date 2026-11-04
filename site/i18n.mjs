// site/i18n.mjs - the site's locales and the strings of its own components.
// Used by astro.config.mjs, scripts/generate.mjs and the custom pages.
//
// English is the source of truth. A translation lives in the mirror tree
// i18n/<tag>/ at the repository root (see i18n/README.md); this file only
// says which locales the site builds and where their URLs go.
//
// To add a locale: add one entry to LOCALES and create the folder
// i18n/<tag>/. Until a page is translated, Starlight shows the English page
// with a notice: https://starlight.astro.build/guides/i18n/#fallback-content
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import YAML from 'yaml';

const SITE = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.dirname(SITE);

// tag:   BCP 47 language tag (https://www.rfc-editor.org/info/bcp47); it is
//        the folder name under i18n/ and the <html lang> value.
// dir:   URL folder; '' is the root locale (English, URLs without a prefix).
// label: the name shown in the language picker, in that language.
export const LOCALES = [
  { tag: 'en', dir: '', label: 'English' },
  { tag: 'pt-BR', dir: 'pt-br', label: 'Português (Brasil)' },
];
export const ROOT_LOCALE = LOCALES[0];

// The English strings; their translations are i18n/<tag>/site-ui.yml.
export const UI_SOURCE = 'site/site-ui.yml';

// Translated files carry two bookkeeping keys that are not content.
const BOOKKEEPING = ['source', 'source_sha'];

// The `locales` option of Starlight: the root locale is called "root".
// https://starlight.astro.build/reference/configuration/#locales
export function starlightLocales() {
  return Object.fromEntries(LOCALES.map((l) => [l.dir || 'root', { label: l.label, lang: l.tag }]));
}

function readYaml(file) {
  const full = path.join(ROOT, file);
  return fs.existsSync(full) ? YAML.parse(fs.readFileSync(full, 'utf8')) : null;
}

// uiStrings(tag) -> { strings, translated }. Every English key is present;
// a translated key replaces it. `translated` is false when the locale has
// no site-ui.yml yet (the English strings are used).
export function uiStrings(tag) {
  const english = readYaml(UI_SOURCE);
  if (tag === ROOT_LOCALE.tag) return { strings: english, translated: true };
  const local = readYaml(`i18n/${tag}/site-ui.yml`) || {};
  for (const key of BOOKKEEPING) delete local[key];
  return { strings: { ...english, ...local }, translated: Object.keys(local).length > 0 };
}

// "{name} …" placeholders in a string are replaced by values[name].
export function format(text, values = {}) {
  return text.replace(/\{(\w+)\}/g, (all, name) => (name in values ? String(values[name]) : all));
}

// A Starlight label with its translations, for sidebar items and the title.
// https://starlight.astro.build/guides/i18n/#translate-the-site-title
export function translatedLabel(key) {
  const translations = {};
  for (const l of LOCALES.slice(1)) {
    const { strings, translated } = uiStrings(l.tag);
    if (translated) translations[l.tag] = strings[key];
  }
  return { label: uiStrings(ROOT_LOCALE.tag).strings[key], translations };
}
