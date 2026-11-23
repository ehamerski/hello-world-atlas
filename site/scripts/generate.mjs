// site/scripts/generate.mjs - build the website content from the repository.
//
// WHAT: reads the Markdown and meta.yml files of the repository and writes
//   site/src/content/docs/**      one page per README / doc (Starlight pages)
//   site/src/content/i18n/*.json  Starlight's own UI strings (the 404 text)
//   site/src/generated/*.json     data for the custom pages (language cards)
//   site/public/assets/**         images the READMEs show (screenshots)
// Every output path is git-ignored and deleted at the start of each run, so
// nothing generated is ever committed.
//
// WHY: the repository Markdown is the single source of truth. Copying it
// into the site by hand would make two copies that drift apart. This script
// copies it at build time instead, and fixes
// the parts that differ between GitHub and a website:
//   - the first "# Title" line becomes the page title (Starlight renders it);
//   - relative links to other Markdown files become links to their pages;
//   - links to other files (scripts, sources) point to the repository.
//
// TRANSLATIONS: a file i18n/<tag>/<path> translates the English file <path>
// and becomes the page <locale dir>/<route> (site/i18n.mjs lists the
// locales). Its links are written exactly as in the English file; they are
// resolved from the English file's folder and point to pages of the same
// locale. A page with no translation is not written: Starlight then shows the
// English page with a notice. Code, file names and ZIPs stay in English.
//
// HOW: run by scripts/build-site.sh, or by hand from site/:
//   node scripts/generate.mjs
//   node scripts/generate.mjs --check   # write nothing; fail when an
//                                       # implementation's main file has no
//                                       # known comment syntax or Shiki id
//   node scripts/generate.mjs --check python ruby   # the same, for these
//                                       # language folders only
// Environment:
//   SITE_BASE  URL path the site is served under (default "/"); for
//              example "/hello-world/" for a GitHub Pages project site.
//   REPO_URL   where links to non-page files point (default: the public
//              GitHub repository, branch main).
//   REPO_ROOT  the repository to read (default: the one this script is in);
//              the fixture tests (test-source-code.mjs) point it elsewhere.
// Only files that git tracks (or new files that are not ignored) are read,
// the same rule as scripts/check-links.sh, so build output never leaks in.

import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import YAML from 'yaml';
import { LOCALES, ROOT_LOCALE, UI_SOURCE, format, uiStrings } from '../i18n.mjs';
import { GREETING, anatomy, classify, entryPoint, hasCommentSyntax, isScript, linesWith, lookup, mainFile as findMainFile } from './source-code.mjs';

const SITE = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const ROOT = process.env.REPO_ROOT ? path.resolve(process.env.REPO_ROOT) : path.dirname(SITE);
const OUT_DOCS = path.join(SITE, 'src', 'content', 'docs');
const OUT_I18N = path.join(SITE, 'src', 'content', 'i18n');
const OUT_DATA = path.join(SITE, 'src', 'generated');
const OUT_ASSETS = path.join(SITE, 'public', 'assets');

const BASE = withSlashes(process.env.SITE_BASE || '/');
const REPO_URL = (process.env.REPO_URL ||
  'https://github.com/ehamerski/hello-world-atlas/blob/main').replace(/\/$/, '');

const IMAGE_EXT = new Set(['.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp']);

// Every reader page in docs/ and its place in the site menu
// (astro.config.mjs). A docs/*.md file that is not listed here stops the
// build: docs/ is published, so a new page must be added on purpose.
const DOC_ROUTES = {
  'docs/home.md': '',
  'docs/start-here.md': 'start-here',
  'docs/comparisons.md': 'compare',
  'docs/paradigms.md': 'paradigms',
  'docs/ai-new-paradigm.md': 'ai-essay',
  'docs/sources.md': 'sources',
  'docs/platform-support.md': 'platform-support',
  'docs/about.md': 'about',
  'docs/off-the-record.md': 'off-the-record',
};

function withSlashes(p) {
  return ('/' + p + '/').replace(/\/+/g, '/');
}

// ------------------------------------------------------------ repository

const files = execFileSync('git',
  ['ls-files', '--cached', '--others', '--exclude-standard'],
  { cwd: ROOT, encoding: 'utf8' }).split('\n').filter(Boolean)
  .filter((f) => fs.existsSync(path.join(ROOT, f)));
const fileSet = new Set(files);
const read = (f) => fs.readFileSync(path.join(ROOT, f), 'utf8');

// languages/<lang>/meta.yml -> one object per language, sorted by name.
const languages = files
  .filter((f) => /^languages\/[^/]+\/meta\.yml$/.test(f))
  .map((f) => {
    const meta = YAML.parse(read(f));
    meta.slug = f.split('/')[1];
    return meta;
  })
  .sort((a, b) => a.name.localeCompare(b.name, 'en'));

// ---------------------------------------------------------- translations

// The translation of the English file `file` in locale `loc`, or null.
// Front matter: `source` and `source_sha` are bookkeeping for
// scripts/check-translations.sh and are removed here.
function translated(loc, file) {
  if (loc === ROOT_LOCALE) return read(file);
  const f = `i18n/${loc.tag}/${file}`;
  if (!fileSet.has(f)) return null;
  const m = read(f).match(/^---\n([\s\S]*?)\n---\n/);
  const fields = m ? YAML.parse(m[1]) || {} : {};
  if (fields.source !== file) console.warn(`warning: ${f} says "source: ${fields.source}", expected ${file}`);
  return m ? read(f).slice(m[0].length) : read(f);
}

// meta.yml overlay: i18n/<tag>/languages/<lang>/meta.yml may translate only
// year_note and, per category (matched by folder), label and run. Names,
// years, designers, paradigms and sources are facts and stay as in English.
// `humor` is adapted, not translated (a joke rarely survives a word-for-word
// translation): when the overlay has it, it replaces the English one whole.
function localizedLanguages(loc) {
  return languages.map((lang) => {
    const f = `i18n/${loc.tag}/languages/${lang.slug}/meta.yml`;
    if (loc === ROOT_LOCALE || !fileSet.has(f)) return lang;
    const overlay = YAML.parse(read(f)) || {};
    const byFolder = new Map((overlay.categories || []).map((c) => [c.folder, c]));
    return {
      ...lang,
      year_note: overlay.year_note ?? lang.year_note,
      humor: overlay.humor ?? lang.humor,
      categories: lang.categories.map((c) => ({
        ...c,
        label: byFolder.get(c.folder)?.label ?? c.label,
        run: byFolder.get(c.folder)?.run ?? c.run,
      })),
    };
  });
}

// A folder under i18n/ that is not a configured locale is never published.
for (const f of files.filter((f) => f.startsWith('i18n/') && f.split('/').length > 2)) {
  const tag = f.split('/')[1];
  if (!LOCALES.some((l) => l.tag === tag)) {
    console.warn(`warning: ${f}: "${tag}" is not in LOCALES (site/i18n.mjs); skipped`);
  }
}

// Map each Markdown file that becomes a page to its route (no slashes).
const routes = new Map();
// README.md is not a page of its own: links to it lead to the home page
// (docs/home.md), whose route is also ''.
routes.set('README.md', '');
routes.set('CONTRIBUTING.md', 'contributing');
routes.set('languages/README.md', 'implementations');
for (const f of files) {
  if (/^docs\/[^/]+\.md$/.test(f)) {
    if (!(f in DOC_ROUTES)) {
      throw new Error(`${f} has no route: add it to DOC_ROUTES in site/scripts/generate.mjs`);
    }
    routes.set(f, DOC_ROUTES[f]);
  }
}
for (const lang of languages) {
  routes.set(`languages/${lang.slug}/README.md`, `languages/${lang.slug}`);
  for (const cat of lang.categories) {
    routes.set(`languages/${lang.slug}/${cat.folder}/README.md`,
      `languages/${lang.slug}/${cat.folder}`);
  }
}
// The URL of a route in a locale (default: English, no prefix).
const url = (route, loc = ROOT_LOCALE) =>
  BASE + [loc.dir, route].filter(Boolean).map((p) => p + '/').join('');

// ------------------------------------------------------------- Markdown

// Split Markdown into fenced code blocks and the text between them, so
// links inside code examples are left alone (same rule as check-links.sh).
function mapOutsideFences(md, fn) {
  const out = [];
  let fence = null;
  let chunk = [];
  const flush = () => { if (chunk.length) out.push(fn(chunk.join('\n'))); chunk = []; };
  for (const line of md.split('\n')) {
    const m = line.match(/^\s*(`{3,}|~{3,})/);
    if (fence) {
      out.push(line);
      if (m && m[1][0] === fence[0] && m[1].length >= fence.length) fence = null;
    } else if (m) {
      flush();
      out.push(line);
      fence = m[1];
    } else {
      chunk.push(line);
    }
  }
  flush();
  return out.join('\n');
}

// The anchor ids of a Markdown file's headings, in order, as Starlight
// makes them with github-slugger (https://github.com/Flet/github-slugger):
// the heading text in lower case, punctuation removed, spaces as hyphens,
// "-1", "-2" … added to repeated ids.
function headingIds(md) {
  const ids = [];
  const seen = new Map();
  mapOutsideFences(md, (text) => {
    for (const [, heading] of text.matchAll(/^#{1,6}\s+(.+?)\s*#*\s*$/gm)) {
      const plain = heading.replace(/!?\[([^\]]*)\]\([^)]*\)/g, '$1').replace(/[`*_]/g, '');
      const base = plain.toLowerCase().replace(/[^\p{L}\p{M}\p{N}\p{Pc}\s-]/gu, '').replace(/\s/g, '-');
      const n = seen.get(base) || 0;
      seen.set(base, n + 1);
      ids.push(n ? `${base}-${n}` : base);
    }
    return text;
  });
  return ids;
}

// A link into another page keeps the English anchor, as in the English
// file. When that page is translated, its headings have other ids, so the
// anchor is replaced by the id of the heading in the same position. A
// translation has the same headings as its English file. When it does not,
// the translation is outdated (scripts/check-translations.sh reports it), the
// positions no longer match, and the link goes to the top of the page
// instead of to an anchor that does not exist.
const anchorMaps = new Map();
function localAnchor(file, anchor, loc) {
  if (loc === ROOT_LOCALE) return anchor;
  const key = `${loc.tag}:${file}`;
  if (!anchorMaps.has(key)) {
    const local = fileSet.has(`i18n/${loc.tag}/${file}`) && translated(loc, file);
    const en = headingIds(read(file));
    const tr = local ? headingIds(local) : [];
    anchorMaps.set(key, !local ? null : en.length === tr.length ? new Map(en.map((id, i) => [id, tr[i]])) : false);
  }
  const map = anchorMaps.get(key);
  if (map === false) return null;
  return map?.get(decodeURIComponent(anchor)) ?? anchor;
}

// Rewrite one link target found in the Markdown file `from`.
// `page` is set when the text is shown on a page other than its own (the
// "Quick start" of an implementation on the language page): an "#anchor"
// then points back to the implementation's page.
function rewriteTarget(target, from, page, loc) {
  if (page && target.startsWith('#')) return page + target;
  if (/^([a-z][a-z0-9+.-]*:|#|\/)/i.test(target)) return target; // external, anchor, absolute
  const [p, anchor] = target.split('#');
  const hash = anchor !== undefined ? '#' + anchor : '';
  let resolved = path.posix.normalize(path.posix.join(path.posix.dirname(from), decodeURI(p)));
  resolved = resolved.replace(/\/$/, '');
  const doc = [resolved, resolved + '/README.md'].find((f) => routes.has(f));
  // The site's home page is docs/home.md, not the repository README: a
  // link to a heading of the README goes to the README on GitHub.
  if (doc === 'README.md' && anchor) return `${REPO_URL}/README.md${hash}`;
  if (doc) {
    const local = anchor ? localAnchor(doc, anchor, loc) : null;
    return url(routes.get(doc), loc) + (anchor && local ? '#' + local : anchor ? '' : hash);
  }
  if (IMAGE_EXT.has(path.extname(resolved).toLowerCase()) && fileSet.has(resolved)) {
    const dest = path.join(OUT_ASSETS, resolved);
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.copyFileSync(path.join(ROOT, resolved), dest);
    return `${BASE}assets/${resolved}`;
  }
  // Any other file or folder: show it in the repository.
  return `${REPO_URL}/${resolved}${hash}`;
}

// `loc` is the locale of the page the text is shown on: links to other
// pages stay in that locale.
function rewriteLinks(md, from, page, loc = ROOT_LOCALE) {
  return mapOutsideFences(md, (text) => text
    // [text](target) and ![alt](target), with an optional "title"
    .replace(/(!?\[[^\]]*\]\()(<[^>]*>|[^)\s]+)((?:\s+"[^"]*")?\))/g,
      (all, open, target, close) => {
        const bare = target.replace(/^<|>$/g, '');
        return open + rewriteTarget(bare, from, page, loc) + close;
      })
    // reference definitions: [label]: target
    .replace(/^(\s{0,3}\[[^\]]+\]:\s+)(\S+)/gm,
      (all, open, target) => open + rewriteTarget(target, from, page, loc)));
}

// The README of a language or implementation opens with a "> Part of …"
// quote that links back up the repository on GitHub. The site shows a
// breadcrumb instead (src/components/PageTitle.astro), so the quote is left
// out: the first block quote, when nothing but blank lines comes before it.
const dropPartOf = (md) => md.replace(/^\s*(>.*\n)+/, '');

// The opening sentence of a language page: what the page covers, the year
// and the designers, from meta.yml (where they are cited).
function topicSentence(lang, ui) {
  const names = lang.designers;
  const designers = names.length > 1
    ? names.slice(0, -1).join(', ') + ui['list.and'] + names[names.length - 1]
    : names[0];
  if (lang.year != null) return format(ui['language.topic'], { name: lang.name, year: lang.year, designers });
  const undated = format(ui['language.topicUndated'], { name: lang.name, note: lang.year_note });
  return designers ? `${undated} ${format(ui['language.topicDesigners'], { designers })}` : undated;
}

// Remove the first "# Title" line and return [title, rest].
function splitTitle(md, fallback) {
  const m = md.match(/^# (.+)\n/m);
  if (!m) return [fallback, md];
  return [m[1].trim(), md.replace(m[0], '')];
}

// One "## Heading" section of a README (without the heading), or null.
function section(md, heading) {
  const lines = md.split('\n');
  const start = lines.findIndex((l) => l.trim() === `## ${heading}`);
  if (start < 0) return null;
  let end = lines.findIndex((l, i) => i > start && /^## /.test(l));
  if (end < 0) end = lines.length;
  return lines.slice(start + 1, end).join('\n').trim();
}

// The section of `file` in the locale `loc`. A translation keeps the
// headings of its English file in the same order, so the section is the one
// in the position of the English `heading`; English when there is none.
function localSection(file, heading, loc) {
  const en = read(file);
  const tr = translated(loc, file);
  const h2 = (md) => md.split('\n').filter((l) => /^## /.test(l)).map((l) => l.slice(3).trim());
  const i = h2(en).indexOf(heading);
  const local = tr ? h2(tr) : [];
  if (i >= 0 && local.length === h2(en).length) return section(tr, local[i]);
  return section(en, heading);
}

function frontmatter(fields) {
  // JSON strings are valid YAML, so JSON.stringify quotes titles safely.
  return '---\n' + Object.entries(fields)
    .map(([k, v]) => `${k}: ${typeof v === 'string' ? JSON.stringify(v) : JSON.stringify(v)}`)
    .join('\n') + '\n---\n\n';
}

function writePage(loc, route, fields, body) {
  const rel = [loc.dir, route].filter(Boolean).join('/');
  const file = path.join(OUT_DOCS, rel ? `${rel}/index.md` : 'index.md');
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, frontmatter(fields) + body.trim() + '\n');
}

// --------------------------------------------------------- source files

// Shiki language ids for the code blocks, looked up by language folder
// first and file extension second, like the tables in source-code.mjs.
// Every id is in the Shiki languages list (https://shiki.style/languages;
// the installed list is `bundledLanguagesInfo` of the shiki package).
// Languages Shiki does not know (QB64 BASIC, Portugol, PSeInt, Clipper,
// Simula, Eiffel, QCL, ALGOL 68) are
// listed as 'txt' on purpose, so `--check` knows they were not forgotten.
const LANG_BY_EXT = {
  byLanguage: {
    perl: { '.pl': 'perl' },
    prolog: { '.pl': 'prolog' },
    'objective-c': { '.h': 'objective-c' },
    bash: { '.sh': 'bash' },
  },
  byExt: {
    '.py': 'python', '.c': 'c', '.h': 'c', '.cpp': 'cpp', '.hpp': 'cpp',
    '.java': 'java', '.cs': 'csharp', '.csproj': 'xml', '.go': 'go',
    '.js': 'javascript', '.mjs': 'javascript', '.jsx': 'jsx', '.ts': 'typescript',
    '.html': 'html', '.css': 'css', '.json': 'json', '.rs': 'rust',
    '.toml': 'toml', '.php': 'php', '.hs': 'haskell', '.lisp': 'common-lisp',
    '.asd': 'common-lisp', '.pas': 'pascal', '.lpr': 'pascal',
    '.pp': 'pascal', '.cob': 'cobol', '.cbl': 'cobol', '.f90': 'fortran-free-form',
    '.adb': 'ada', '.ads': 'ada', '.gpr': 'ada', '.asm': 'asm', '.xml': 'xml',
    '.lpi': 'xml', '.yml': 'yaml', '.yaml': 'yaml', '.properties': 'properties',
    '.vue': 'vue', '.sh': 'sh', '.cabal': 'txt', '.mod': 'txt',
    '.rb': 'ruby', '.ru': 'ruby', '.erb': 'erb', '.pm': 'perl', '.lua': 'lua',
    '.kt': 'kotlin', '.kts': 'kotlin', '.gradle': 'groovy',
    '.clj': 'clojure', '.cljs': 'clojure', '.cljc': 'clojure', '.edn': 'clojure',
    '.erl': 'erlang', '.hrl': 'erlang', '.ex': 'elixir', '.exs': 'elixir',
    '.swift': 'swift', '.m': 'objective-c', '.dart': 'dart', '.st': 'smalltalk',
    '.dpr': 'pascal', '.vb': 'vb', '.vbproj': 'xml', '.fsproj': 'xml',
    '.tsx': 'tsx', '.scala': 'scala', '.sc': 'scala', '.sbt': 'scala',
    '.fs': 'fsharp', '.fsx': 'fsharp', '.ml': 'ocaml', '.mli': 'ocaml',
    '.jl': 'julia', '.r': 'r', '.zig': 'zig', '.rkt': 'racket',
    '.sim': 'txt', '.e': 'txt', '.qcl': 'txt', '.a68': 'txt', '.prg': 'txt',
    '.bas': 'txt', '.alg': 'txt', '.psc': 'txt',
  },
};
const LANG_BY_NAME = { 'CMakeLists.txt': 'cmake', Makefile: 'make', Dockerfile: 'docker', Gemfile: 'ruby' };
// Not shown inline: the READMEs themselves, generated lock files, and
// binary files. They are still in the ZIP download.
const HIDDEN = /(^|\/)(README\.md|package-lock\.json|Cargo\.lock|go\.sum|[^/]*\.lock|\.gitignore)$/;
const BINARY_EXT = new Set([...IMAGE_EXT, '.ico', '.icns', '.zip', '.jar', '.ttf', '.woff', '.woff2']);
const MAX_INLINE_BYTES = 20000;

function implFiles(dir) {
  return files.filter((f) => f.startsWith(dir + '/'))
    .map((f) => f.slice(dir.length + 1))
    .filter((f) => !HIDDEN.test(f) && !BINARY_EXT.has(path.extname(f).toLowerCase()))
    .filter((f) => fs.statSync(path.join(ROOT, dir, f)).size <= MAX_INLINE_BYTES)
    .sort((a, b) => Number(isScript(a, langOf(dir))) - Number(isScript(b, langOf(dir))) || a.localeCompare(b));
}

// The language of an implementation folder languages/<lang>/<folder>.
const langOf = (dir) => dir.split('/')[1];

function codeBlock(dir, file) {
  const text = read(`${dir}/${file}`).replace(/\n$/, '');
  const lang = shikiLang(file, langOf(dir));
  // A fence must be longer than any run of backticks inside the file.
  const longest = Math.max(2, ...(text.match(/`+/g) || []).map((s) => s.length));
  const fence = '`'.repeat(longest + 1);
  return `${fence}${lang} title=${JSON.stringify(file)}\n${text}\n${fence}`;
}

// Source files as code blocks; scripts are collapsed so the code stays first.
function sourceSection(dir, { scripts }) {
  const list = implFiles(dir).filter((f) => scripts || !isScript(f, langOf(dir)));
  return list.map((f) => {
    const block = codeBlock(dir, f);
    return isScript(f, langOf(dir))
      ? `<details>\n<summary><code>${f}</code></summary>\n\n${block}\n\n</details>`
      : block;
  }).join('\n\n');
}

const zipName = (lang, folder) => `hello-world-${lang}-${folder}.zip`;
const downloadButton = (lang, folder, ui) =>
  `<a class="download-zip" href="${BASE}downloads/${zipName(lang, folder)}" download>${ui['impl.downloadZip']}</a>`;

// ------------------------------------------------------------- anatomy

// The main source file of an implementation (see source-code.mjs).
const mainFile = (dir) => findMainFile(implFiles(dir), (f) => read(`${dir}/${f}`), langOf(dir));

const escapeHtml = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

// A comment paragraph as HTML. Lines indented further than the paragraph's
// own continuation lines are examples (commands, tables) and keep their
// layout in a <pre>. Blank lines are avoided on purpose: in Markdown a
// blank line would end the HTML block.
function noteHtml(note) {
  return note.map((para) => {
    const indents = para.map((l) => l.match(/^\s*/)[0].length);
    const rest = indents.slice(1);
    const base = rest.length ? Math.min(...rest) : indents[0];
    const out = [];
    let prose = [];
    let pre = [];
    const flushProse = () => { if (prose.length) out.push(`<p>${escapeHtml(prose.join(' '))}</p>`); prose = []; };
    const flushPre = () => { if (pre.length) out.push(`<pre>${pre.map(escapeHtml).join('&#10;')}</pre>`); pre = []; };
    para.forEach((line, i) => {
      if (i > 0 && indents[i] >= base + 2 || i === 0 && indents[0] >= 2 && base >= 2) {
        flushProse();
        pre.push(line.slice(Math.min(base, indents[i])));
      } else {
        flushPre();
        prose.push(line.trim());
      }
    });
    flushProse();
    flushPre();
    return out.join('');
  }).join('');
}

function shikiLang(file, lang) {
  return LANG_BY_NAME[path.basename(file)] || lookup(LANG_BY_EXT, file, lang) || 'txt';
}

// "Anatomy": the main file as numbered steps, each one a piece of code
// with the comment that explains it beside it. The comments are the ones
// already in the source file; nothing is written for this page.
function anatomySection(dir, ui, heading) {
  const file = mainFile(dir);
  if (!file) return '';
  const { header, steps } = anatomy(read(`${dir}/${file}`), file, langOf(dir));
  const lang = shikiLang(file, langOf(dir));
  const lineLabel = (code) => {
    if (!code.length) return '';
    const [a, b] = [code[0].n, code[code.length - 1].n];
    return a === b ? format(ui['anatomy.line'], { n: a }) : format(ui['anatomy.lines'], { from: a, to: b });
  };
  const parts = [
    `${heading} ${ui['anatomy.title']}`,
    format(ui['anatomy.intro'], { file: `\`${file}\`` }),
  ];
  if (header.length) parts.push(`<div class="anatomy-header not-content"><p class="anatomy-label">${escapeHtml(ui['anatomy.header'])}</p>${noteHtml(header)}</div>`);
  // Each step is HTML around a Markdown code fence; the blank lines around
  // the fence let Markdown (and Starlight's code highlighter) see it.
  const items = steps.map((step) => {
    const text = step.code.map((c) => c.text).join('\n');
    const longest = Math.max(2, ...(text.match(/`+/g) || []).map((s) => s.length));
    const fence = '`'.repeat(longest + 1);
    const code = step.code.length ? `\n\n${fence}${lang}\n${text}\n${fence}\n\n` : '\n';
    return `<li class="anatomy-step">\n<div class="anatomy-code">${code}</div>\n`
      + `<div class="anatomy-note"><p class="anatomy-label">${escapeHtml(lineLabel(step.code))}</p>${noteHtml(step.note)}</div>\n</li>`;
  });
  parts.push(`<ol class="anatomy not-content">\n${items.join('\n')}\n</ol>`);
  return parts.join('\n\n');
}

// The titles of the steps a script announces with step "..." (common.sh),
// without their "1/2" counters. Used by the comparator.
function scriptSteps(dir, script) {
  const f = `${dir}/${script}`;
  if (!fileSet.has(f)) return [];
  return [...read(f).matchAll(/^\s*step "([^"]*)"/gm)].map((m) => m[1].replace(/^\d+\/\d+\s+/, ''));
}

// One plain-text description per page (the <meta name="description"> that
// search engines show): the first paragraph of prose, cut at a word.
function describe(md, fallback = '') {
  const para = mapOutsideFences(md, (t) => t).split(/\n\s*\n/)
    // A heading directly above a paragraph is part of its block; drop it.
    .map((p) => p.trim().replace(/^(#.*(\n|$))+/, '').trim())
    .find((p) => p && !/^(#|\||<|!\[|```|~~~|-|\*|\d+\.|>)/.test(p));
  if (!para) return fallback;
  const plain = para.replace(/!?\[([^\]]*)\]\([^)]*\)/g, '$1').replace(/[`*_]/g, '').replace(/\s+/g, ' ').trim();
  if (plain.length <= 160) return plain;
  return plain.slice(0, 157).replace(/\s+\S*$/, '').replace(/[\s.,;:]+$/, '') + '…';
}

// ---------------------------------------------------------------- check

// --check: every implementation must have a main file whose language the
// tables know. Without this, a new language with an unknown extension
// would build fine, with no Anatomy section, plain-text code and no line
// counts in the Facts, and nothing would say so.
// Implementations shown as plain text on purpose: the CLRS pseudocode is a
// notation meant to be read, not a program, so it has no Anatomy section.
const PLAIN_TEXT = new Set(['languages/pseudocode/clrs']);
if (process.argv.includes('--check')) {
  const problems = [];
  let count = 0;
  let plain = 0;
  // Language folders named after --check; none means all of them.
  const only = process.argv.slice(process.argv.indexOf('--check') + 1);
  for (const slug of only) {
    if (!languages.some((l) => l.slug === slug)) problems.push(`languages/${slug}: no meta.yml`);
  }
  for (const lang of languages.filter((l) => !only.length || only.includes(l.slug))) {
    for (const cat of lang.categories) {
      const dir = `languages/${lang.slug}/${cat.folder}`;
      count++;
      if (PLAIN_TEXT.has(dir)) { plain++; continue; }
      const file = mainFile(dir);
      if (!file) {
        const unknown = implFiles(dir).filter((f) => !isScript(f, lang.slug)
          && read(`${dir}/${f}`).includes(GREETING) && !hasCommentSyntax(f, lang.slug));
        problems.push(unknown.length
          ? `${dir}: no comment syntax for ${unknown.join(', ')} (add it to COMMENT_SYNTAX in site/scripts/source-code.mjs)`
          : `${dir}: no source file contains "${GREETING}"`);
      } else if (!LANG_BY_NAME[path.basename(file)] && !lookup(LANG_BY_EXT, file, lang.slug)) {
        problems.push(`${dir}: no Shiki language id for ${file} (add it to LANG_BY_EXT in site/scripts/generate.mjs)`);
      }
    }
  }
  for (const p of problems) console.error(`error: ${p}`);
  if (problems.length) process.exit(1);
  console.log(`ok: the main file of all ${count} implementations has a known comment syntax and Shiki id`
    + ` (${plain} shown as plain text on purpose)`);
  process.exit(0);
}

// ---------------------------------------------------------------- pages

fs.rmSync(OUT_DOCS, { recursive: true, force: true });
fs.rmSync(OUT_I18N, { recursive: true, force: true });
fs.rmSync(OUT_DATA, { recursive: true, force: true });
fs.rmSync(OUT_ASSETS, { recursive: true, force: true });
fs.mkdirSync(OUT_DATA, { recursive: true });

let pageCount = 0;
const cardsByLocale = {};
const implsByLocale = {};
const genealogyByLocale = {};
const uiByLocale = {};

// Write every page of one locale. English writes all of them; another
// locale writes only the pages whose source is translated.
function generateLocale(loc) {
  const { strings: ui, translated: uiTranslated } = uiStrings(loc.tag);
  const langs = localizedLanguages(loc);
  const page = (route, fields, body) => { writePage(loc, route, fields, body); pageCount++; };

  // Home: docs/home.md on a splash page. The repository README stays the
  // front page on GitHub; links to it from other files lead here.
  const home = translated(loc, 'docs/home.md');
  if (home) {
    const [title, body] = splitTitle(home, 'Hello World');
    page('', {
      title,
      description: ui['site.description'],
      template: 'splash',
      hero: {
        tagline: ui['home.tagline'],
        actions: [
          { text: ui['home.startHere'], link: url('start-here', loc), icon: 'right-arrow' },
          { text: ui['home.browseLanguages'], link: url('languages', loc), variant: 'minimal' },
          { text: ui['home.compare'], link: url('compare', loc), variant: 'minimal' },
        ],
      },
    // On GitHub the "Languages" link of the home page opens the table of
    // every implementation (languages/README.md); on the site it opens the
    // Languages page, with its search and filters.
    }, rewriteLinks(body, 'docs/home.md', undefined, loc)
      .replaceAll(`](${url('implementations', loc)})`, `](${url('languages', loc)})`));
  }

  // Docs, CONTRIBUTING and the implementations table.
  for (const [file, route] of routes) {
    if (route === '' || file.startsWith('languages/') && file !== 'languages/README.md') continue;
    const md = translated(loc, file);
    if (!md) continue;
    const [title, body] = splitTitle(md, path.basename(file, '.md'));
    let extra = '';
    if (route === 'sources') extra = '\n\n' + sourcesByLanguage(langs, ui);
    const text = route === 'off-the-record' ? offTheRecord(body, langs, ui, loc) : body;
    page(route, { title, description: describe(body, title) }, rewriteLinks(text, file, undefined, loc) + extra);
  }

  // One page per language and per implementation.
  for (const lang of langs) {
    const readme = `languages/${lang.slug}/README.md`;
    const langMd = translated(loc, readme);
    if (langMd) {
      const [title, readmeBody] = splitTitle(langMd, lang.name);
      const body = `${topicSentence(lang, ui)}\n\n${dropPartOf(readmeBody)}`;
      const impls = lang.categories.map((cat) => {
        const dir = `languages/${lang.slug}/${cat.folder}`;
        const guide = url(`languages/${lang.slug}/${cat.folder}`, loc);
        // The implementation's own translation if there is one, else English.
        const quick = localSection(`${dir}/README.md`, 'Quick start', loc);
        return [
          `### ${cat.label || cat.folder}`,
          `${ui[`status.${cat.status}`] || cat.status} · ${cat.toolchain} · ${format(ui['impl.result'], { run: cat.run })}`,
          '',
          `${downloadButton(lang.slug, cat.folder, ui)} [${ui['impl.fullGuide']}](${guide})`,
          '',
          sourceSection(dir, { scripts: false }),
          quick ? `${format(ui['impl.howToRun'], { dir })}\n\n${rewriteLinks(quick, `${dir}/README.md`, guide, loc)}` : '',
        ].join('\n');
      });
      // The anatomy of the first implementation (the cli one, where there is one).
      const first = `languages/${lang.slug}/${lang.categories[0].folder}`;
      const anatomyMd = anatomySection(first, ui, '##');
      const code = (anatomyMd ? `${anatomyMd}\n\n` : '') + `## ${ui['code.heading']}\n${ui['code.intro']}\n\n${impls.join('\n\n')}\n`;
      // Put the code directly after the README's "Implementations" table.
      const history = `\n## ${ui['language.historyHeading']}\n`;
      let md = rewriteLinks(body, readme, undefined, loc);
      md = md.includes(history) ? md.replace(history, `\n${code}${history}`) : `${md}\n\n${code}`;
      md += '\n\n' + humorBox(lang, ui, loc);
      page(`languages/${lang.slug}`, { title, description: format(ui['language.description'], { name: lang.name }) }, md);
    }

    for (const cat of lang.categories) {
      const dir = `languages/${lang.slug}/${cat.folder}`;
      const implMd = translated(loc, `${dir}/README.md`);
      if (!implMd) continue;
      const [implTitle, readmeBody] = splitTitle(implMd, `${lang.name} · ${cat.folder}`);
      const implBody = dropPartOf(readmeBody);
      const anatomyMd = anatomySection(dir, ui, '##');
      page(`languages/${lang.slug}/${cat.folder}`, { title: implTitle, description: describe(implBody, implTitle) },
        `${downloadButton(lang.slug, cat.folder, ui)}\n\n${rewriteLinks(implBody, `${dir}/README.md`, undefined, loc)}\n\n`
        + (anatomyMd ? `${anatomyMd}\n\n` : '')
        + `## ${ui['impl.sourceFiles']}\n\n${sourceSection(dir, { scripts: true })}`);
    }
  }

  // Timeline: every language by the year it first appeared (from meta.yml).
  // All of its text comes from site-ui.yml, so it is written for a locale
  // as soon as that locale has a site-ui.yml.
  if (uiTranslated) {
    const rows = langs.filter((l) => l.year != null).sort((a, b) => a.year - b.year || a.name.localeCompare(b.name))
      .map((l) => `| ${l.year} | [${l.name}](${url(`languages/${l.slug}`, loc)}) | ${l.designers.join(', ')} | ${l.paradigms.join(', ')} | ${l.year_note || ''} |`);
    const undated = langs.filter((l) => l.year == null).map((l) => `- [${l.name}](${url(`languages/${l.slug}`, loc)}): ${l.year_note || ui['cards.noSingleYear']}`);
    page('timeline', { title: ui['timeline.title'], description: ui['timeline.intro'].replace(/`/g, '') }, [
      ui['timeline.intro'],
      '',
      `| ${['year', 'language', 'designers', 'paradigms', 'note'].map((k) => ui[`timeline.${k}`]).join(' | ')} |`, '|---|---|---|---|---|', ...rows,
      ...(undated.length ? ['', `**${ui['timeline.undated']}**`, '', ...undated] : []),
    ].join('\n'));
  }

  // Data for the language cards page (src/pages/[...locale]/languages/index.astro).
  cardsByLocale[loc.tag] = langs.map((l) => ({
    slug: l.slug, name: l.name, otherNames: l.other_names ?? [], year: l.year,
    designers: l.designers, paradigms: l.paradigms,
    kinds: [...new Set(l.categories.map((c) => c.kind))],
    implementations: l.categories.length, url: url(`languages/${l.slug}`, loc),
    // false when the language page has no translation in this locale yet:
    // the cards page then says how many languages are only in English.
    translated: loc === ROOT_LOCALE || fileSet.has(`i18n/${loc.tag}/languages/${l.slug}/README.md`),
  }));
  uiByLocale[loc.tag] = { strings: ui, translated: uiTranslated };

  // Data for the comparator (src/pages/[...locale]/compare/side-by-side.astro).
  implsByLocale[loc.tag] = langs.flatMap((l) => l.categories.map((c) => {
    const id = `${l.slug}/${c.folder}`;
    return {
      id, language: l.name, label: c.label || c.folder, kind: c.kind, toolchain: c.toolchain,
      status: ui[`status.${c.status}`] || c.status, url: url(`languages/${id}`, loc),
      ...implFacts.get(id),
    };
  }));

  // Data for the genealogy page (src/pages/[...locale]/genealogy.astro).
  genealogyByLocale[loc.tag] = langs.map((l) => ({
    slug: l.slug, name: l.name, year: l.year, url: url(`languages/${l.slug}`, loc),
    influencedBy: (l.influenced_by || []).map((i) => ({
      language: i.language, slug: i.slug || null, title: i.title, url: i.url, quote: i.quote,
    })),
  }));
}

// The facts of each implementation that do not depend on the locale: its
// main file, the code without comments, the entry point, the line that
// prints the greeting and the steps of its scripts.
const implFacts = new Map();
for (const lang of languages) {
  for (const cat of lang.categories) {
    const dir = `languages/${lang.slug}/${cat.folder}`;
    const file = mainFile(dir);
    const facts = { file, lang: file ? shikiLang(file, lang.slug) : null, code: null, entry: null, output: [], build: [], run: [] };
    if (file) {
      const text = read(`${dir}/${file}`);
      // The program without its comments; runs of blank lines become one.
      facts.code = classify(text, file, lang.slug).filter((l) => l.kind !== 'comment')
        .map((l) => l.text).join('\n').replace(/\n\s*\n(\s*\n)+/g, '\n\n').trim();
      facts.entry = entryPoint(text, file, lang.slug);
      facts.output = linesWith(text, file, GREETING, lang.slug).map((l) => ({ n: l.n, text: l.text.trim() }));
    }
    facts.build = scriptSteps(dir, 'build.sh');
    facts.run = scriptSteps(dir, 'run.sh');
    implFacts.set(`${lang.slug}/${cat.folder}`, facts);
  }
}

// The sources each meta.yml cites, appended to the Sources page.
function sourcesByLanguage(langs, ui) {
  return `## ${ui['sources.heading']}\n${ui['sources.intro']}\n\n` +
    langs.map((l) => `### ${l.name}\n` + l.sources.map((s) => `- [${s.title}](${s.url})`).join('\n')).join('\n\n');
}

// ------------------------------------------------------------- humor

// docs/off-the-record.md marks the parts built from meta.yml (humor) with
//   <!-- BEGIN SITE: <name> -->  ...  <!-- END SITE: <name> -->
// On GitHub the text between the markers is shown as it is; on the website
// fill(text between the markers) replaces it, markers included.
function siteBlock(md, name, fill) {
  const re = new RegExp(`<!-- BEGIN SITE: ${name} -->\\n([\\s\\S]*?)<!-- END SITE: ${name} -->`);
  if (!re.test(md)) throw new Error(`docs/off-the-record.md: no "${name}" block (BEGIN SITE / END SITE markers)`);
  return md.replace(re, (all, inner) => fill(inner).trim());
}

// A joke kept in meta.yml, quoted with where it was found.
function jokeMd(joke, ui) {
  const fields = { author: joke.author, title: joke.title, url: joke.url, date: joke.accessed };
  const quote = joke.text.split('\n').map((l) => `> ${l}`).join('\n');
  return `${quote}\n\n${format(ui[joke.author ? 'humor.byAuthor' : 'humor.originUnknown'], fields)}`;
}

// One dictionary entry as a list item: "- **Term** (n.): definition".
const entryMd = (e) => `- **${e.term}** (${e.part || 'n.'}): ${e.definition}`;

function offTheRecord(md, langs, ui, loc) {
  // One line per language, in the order of the language list (by name).
  md = siteBlock(md, 'humor-lines', () => langs
    .map((l) => `- **${l.humor.label || l.name}.** ${l.humor.line}`).join('\n'));
  // The jokes about a single language, after the page's own groups of jokes.
  md = siteBlock(md, 'humor-jokes', () => {
    const withJokes = langs.filter((l) => l.humor.jokes?.length);
    if (!withJokes.length) return '';
    return `### ${ui['humor.languageJokes']}\n\n` + withJokes.map((l) =>
      `**[${l.name}](${url(`languages/${l.slug}`, loc)})**\n\n` + l.humor.jokes.map((j) => jokeMd(j, ui)).join('\n\n'),
    ).join('\n\n');
  });
  // The dictionary: the page's own entries (list items that start with
  // "- **Term**") and each language's entries, merged from A to Z.
  md = siteBlock(md, 'humor-dictionary', (inner) => {
    const own = inner.split(/\n(?=- \*\*)/).map((e) => e.trim()).filter((e) => e.startsWith('- **'))
      .map((e) => ({ term: e.match(/^- \*\*(.+?)\*\*/)[1], md: e }));
    const fromMeta = langs.flatMap((l) => (l.humor.dictionary || []).map((e) => ({ term: e.term, md: entryMd(e) })));
    return [...own, ...fromMeta]
      .sort((a, b) => a.term.localeCompare(b.term, 'en', { sensitivity: 'base' }))
      .map((e) => e.md).join('\n');
  });
  return md;
}

// The "Off the record" box at the end of a language page: its line, its
// jokes, and a link to the page with the rest.
function humorBox(lang, ui, loc) {
  const parts = [lang.humor.line, ...(lang.humor.jokes || []).map((j) => jokeMd(j, ui)),
    format(ui['humor.more'], { url: url('off-the-record', loc) })];
  return `:::note[${ui['humor.boxTitle']}]\n${parts.join('\n\n')}\n:::`;
}

for (const loc of LOCALES) generateLocale(loc);

// The not-found page. Starlight looks up the entry "404" of the docs
// collection and the strings of the i18n collection, and logs a warning
// when either is missing. Starlight serves one 404 page, in the root
// locale, so only the root locale gets an i18n entry; the others keep
// Starlight's built-in translations.
// `draft: true` keeps the entry out of the normal page routes in a
// production build, where it would clash with Starlight's /404 route.
// https://starlight.astro.build/guides/i18n/#translate-starlights-ui
{
  const ui = uiStrings(ROOT_LOCALE.tag).strings;
  fs.writeFileSync(path.join(OUT_DOCS, '404.md'), frontmatter({
    title: ui['notFound.title'],
    template: 'splash',
    editUrl: false,
    pagefind: false,
    draft: true,
    hero: { tagline: ui['notFound.text'] },
  }));
  fs.mkdirSync(OUT_I18N, { recursive: true });
  fs.writeFileSync(path.join(OUT_I18N, `${ROOT_LOCALE.tag}.json`), JSON.stringify({ '404.text': ui['notFound.text'] }, null, 2) + '\n');
}
fs.writeFileSync(path.join(OUT_DATA, 'languages.json'), JSON.stringify(cardsByLocale, null, 2) + '\n');
fs.writeFileSync(path.join(OUT_DATA, 'ui.json'), JSON.stringify(uiByLocale, null, 2) + '\n');
fs.writeFileSync(path.join(OUT_DATA, 'implementations.json'), JSON.stringify(implsByLocale, null, 2) + '\n');
fs.writeFileSync(path.join(OUT_DATA, 'genealogy.json'), JSON.stringify(genealogyByLocale, null, 2) + '\n');

console.log(`generated ${pageCount} pages (${languages.length} languages, ${LOCALES.length} locales) into ${path.relative(ROOT, OUT_DOCS)}; strings from ${UI_SOURCE}`);
