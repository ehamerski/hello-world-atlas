// site/scripts/check-a11y.mjs - check the built site against WCAG 2.2 AA
// with axe-core, in light and dark mode, and optionally take screenshots.
//
// WHAT: serves site/dist/ on a local port, opens each page of PAGES in a
//   headless Chrome (playwright-core drives it), sets the color theme the
//   way Starlight's theme picker does, runs axe-core and prints every
//   violation. Exit status 1 when there is a violation.
// WHY: the target is WCAG 2.2 level AA (https://www.w3.org/TR/WCAG22/).
//   axe-core finds the failures a program can find (contrast, names of
//   links and form fields, alt text, landmarks); keyboard use and reading
//   order still need a person. The axe rule tags used are listed at
//   https://github.com/dequelabs/axe-core/blob/develop/doc/API.md#axe-core-tags
// HOW:
//   scripts/build-site.sh                          # build site/dist/ first
//   node site/scripts/check-a11y.mjs               # the check
//   node site/scripts/check-a11y.mjs --screenshots <dir>   # also save PNGs
//   CHROME=/path/to/chrome node site/scripts/check-a11y.mjs
// playwright-core downloads no browser; it uses the installed Google Chrome
// (https://playwright.dev/docs/browsers#google-chrome--microsoft-edge),
// or the one in CHROME.

import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';
import { chromium } from 'playwright-core';

const SITE = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const DIST = path.join(SITE, 'dist');
const AXE = fs.readFileSync(createRequire(import.meta.url).resolve('axe-core/axe.min.js'), 'utf8');
const TAGS = ['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa', 'wcag22aa'];

// The pages of the acceptance list, by name (the name is the screenshot's).
const PAGES = {
  home: '/', languages: '/languages/', python: '/languages/python/',
  comparator: '/compare/side-by-side/', facts: '/facts/', genealogy: '/genealogy/',
  about: '/about/', 'off-the-record': '/off-the-record/', 'pt-br-home': '/pt-br/',
};

const args = process.argv.slice(2);
const shotsAt = args.indexOf('--screenshots');
const SHOTS = shotsAt >= 0 ? path.resolve(args[shotsAt + 1]) : null;

const TYPES = { '.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript', '.svg': 'image/svg+xml',
  '.png': 'image/png', '.woff2': 'font/woff2', '.json': 'application/json', '.zip': 'application/zip' };

// A minimal static server for site/dist/ (a folder URL serves its index.html).
const server = http.createServer((req, res) => {
  let file = path.join(DIST, decodeURIComponent(new URL(req.url, 'http://x').pathname));
  if (!file.startsWith(DIST)) { res.writeHead(403).end(); return; }
  if (fs.existsSync(file) && fs.statSync(file).isDirectory()) file = path.join(file, 'index.html');
  if (!fs.existsSync(file)) { res.writeHead(404).end(); return; }
  res.writeHead(200, { 'content-type': TYPES[path.extname(file)] || 'application/octet-stream' });
  fs.createReadStream(file).pipe(res);
});
await new Promise((ok) => server.listen(0, '127.0.0.1', ok));
const origin = `http://127.0.0.1:${server.address().port}`;

const browser = await chromium.launch(process.env.CHROME ? { executablePath: process.env.CHROME } : { channel: 'chrome' });
let violations = 0;
try {
  for (const theme of ['light', 'dark']) {
    // Starlight reads the theme from localStorage "starlight-theme" before
    // the page paints: https://starlight.astro.build/guides/customization/#dark-and-light-themes
    const context = await browser.newContext({ viewport: { width: 1280, height: 900 }, colorScheme: theme });
    await context.addInitScript((t) => localStorage.setItem('starlight-theme', t), theme);
    const page = await context.newPage();
    for (const [name, url] of Object.entries(PAGES)) {
      await page.goto(origin + url, { waitUntil: 'networkidle' });
      // Wait for the fonts and for the scripts that run when the browser is
      // idle: the code blocks make themselves keyboard-scrollable then.
      await page.evaluate(() => document.fonts.ready.then(() => new Promise((ok) => requestIdleCallback(() => setTimeout(ok, 200)))));
      await page.addScriptTag({ content: AXE });
      const result = await page.evaluate((tags) => window.axe.run(document, { runOnly: { type: 'tag', values: tags } }), TAGS);
      const count = result.violations.reduce((n, v) => n + v.nodes.length, 0);
      violations += count;
      console.log(`${count ? 'FAIL' : 'ok  '} ${theme.padEnd(5)} ${url}  (${result.passes.length} rules passed, ${count} violations)`);
      for (const v of result.violations) {
        console.log(`     ${v.id} [${v.impact}] ${v.help}`);
        for (const n of v.nodes.slice(0, 5)) console.log(`       ${n.target.join(' ')}: ${n.failureSummary.split('\n').slice(1).join(' ').trim()}`);
      }
      if (SHOTS) {
        fs.mkdirSync(SHOTS, { recursive: true });
        // The Python page is long (all its code); its shot shows the Anatomy section.
        const anatomy = name === 'python' && await page.$('#anatomy-of-hello-world');
        if (anatomy) await anatomy.evaluate((h) => window.scrollTo(0, h.getBoundingClientRect().top + window.scrollY - 80));
        await page.screenshot({ path: path.join(SHOTS, `${name}-${theme}.png`), fullPage: !anatomy });
      }
    }
    await context.close();
  }
} finally {
  await browser.close();
  server.close();
}
console.log(violations ? `${violations} WCAG 2.2 AA violations` : 'no WCAG 2.2 AA violations found by axe-core');
process.exit(violations ? 1 : 0);
