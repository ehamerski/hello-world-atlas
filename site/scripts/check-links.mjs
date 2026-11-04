// site/scripts/check-links.mjs - check every internal link of the built site.
//
// WHAT: reads every HTML file in site/dist/ and checks each href that
//   points inside the site: the target file must exist, and an "#anchor"
//   must match an id on the target page. External links (https:, mailto:)
//   are not fetched; the release link check covers them (docs/sources.md).
//
// WHY: the generator rewrites every relative link of the READMEs, so this
//   proves that the rewritten links still land on a real page and heading.
//
// HOW: node scripts/check-links.mjs   (after astro build; run by
//   scripts/build-site.sh). Exit code 0 = no broken link, 1 = broken links.
//   SITE_BASE must be the same as for the build.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const DIST = path.join(path.dirname(path.dirname(fileURLToPath(import.meta.url))), 'dist');
const BASE = ('/' + (process.env.SITE_BASE || '/') + '/').replace(/\/+/g, '/');

function* htmlFiles(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) yield* htmlFiles(p);
    else if (entry.name.endsWith('.html')) yield p;
  }
}

const idCache = new Map();
function ids(file) {
  if (!idCache.has(file)) {
    const html = fs.readFileSync(file, 'utf8');
    idCache.set(file, new Set([...html.matchAll(/\sid="([^"]+)"/g)].map((m) => m[1])));
  }
  return idCache.get(file);
}

const unescape = (s) => s.replace(/&amp;/g, '&').replace(/&#39;/g, "'").replace(/&quot;/g, '"');

let links = 0;
const broken = [];
for (const file of htmlFiles(DIST)) {
  const html = fs.readFileSync(file, 'utf8');
  for (const m of html.matchAll(/href="([^"]+)"/g)) {
    const href = unescape(m[1]);
    if (/^[a-z][a-z0-9+.-]*:/i.test(href)) continue; // external
    links++;
    const [p, anchor] = href.split('#');
    let target = file;
    if (p) {
      if (p.startsWith('/') && !p.startsWith(BASE)) { broken.push([file, href]); continue; }
      const rel = p.startsWith('/') ? p.slice(BASE.length) : null;
      target = rel !== null ? path.join(DIST, decodeURI(rel)) : path.resolve(path.dirname(file), decodeURI(p));
      if (fs.existsSync(target) && fs.statSync(target).isDirectory()) target = path.join(target, 'index.html');
      if (!fs.existsSync(target)) { broken.push([file, href]); continue; }
    }
    if (anchor && target.endsWith('.html') && !ids(target).has(decodeURIComponent(anchor))) {
      broken.push([file, href]);
    }
  }
}

for (const [file, href] of broken) console.log(`BROKEN ${path.relative(DIST, file)} -> ${href}`);
console.log(`${links} internal links checked, ${broken.length} broken`);
process.exit(broken.length ? 1 : 0);
