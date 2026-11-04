// site/plugins/academic.mjs - give the Markdown pages the conventions of a
// paper: numbered tables and figures, and a bibliography-style list of
// references.
//
// WHAT: runs on the HTML tree (HAST) of every Markdown page and
//   - adds <caption>Table n. <heading></caption> to each table, where
//     <heading> is the text of the nearest heading above it;
//   - turns a paragraph that holds only an image into
//     <figure><img><figcaption>Figure n. <alt text></figcaption></figure>;
//   - marks the list right after a "Sources" or "References" heading with
//     class="references" (src/styles/theme.css shows it as [1], [2], ...).
// WHY: the READMEs are plain GitHub Markdown, which has no syntax for
//   captions. Numbering them here keeps the Markdown simple and gives the
//   site the look of a paper. A <caption> also names the table for screen
//   readers (https://www.w3.org/WAI/tutorials/tables/caption-summary/).
// HOW: a HAST plugin for Sätteri, the Markdown processor of Astro 7 (the
//   one Starlight extends), set in astro.config.mjs under
//   markdown.processor. The `before` hook sees the whole tree once, in
//   document order, which "the nearest heading above" needs.
//   Plugin API: https://satteri.bruits.org/docs/
//   HAST, the tree format: https://github.com/syntax-tree/hast
//
// Labels such as "Table" come from site-ui.yml (or its translation), chosen
// by the page's locale folder; see captionLabels() below.

import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { LOCALES, ROOT_LOCALE, uiStrings } from '../i18n.mjs';

const HEADING = /^h[1-6]$/;
const REFERENCE_HEADINGS = new Set(['sources', 'references']);

const el = (tagName, properties, children) => ({ type: 'element', tagName, properties, children });
const txt = (value) => ({ type: 'text', value });

// The locale of a page, from its path: src/content/docs/<dir>/... is a
// translation, anything else is English.
function captionLabels(fileURL) {
  const parts = fileURL ? fileURLToPath(fileURL).split(path.sep) : [];
  const at = parts.lastIndexOf('docs');
  const dir = at >= 0 ? parts[at + 1] : '';
  const loc = LOCALES.find((l) => l.dir && l.dir === dir) || ROOT_LOCALE;
  const { strings } = uiStrings(loc.tag);
  return { table: strings['caption.table'], figure: strings['caption.figure'] };
}

// A plugin factory: Sätteri calls it once per document with its fileURL.
export default function academic({ fileURL }) {
  const labels = captionLabels(fileURL);
  return {
    name: 'academic',
    before(root, ctx) {
      let tables = 0;
      let figures = 0;
      let heading = '';
      // Walk the tree in document order, so "the nearest heading above" is
      // the last heading seen.
      function walk(parent) {
        const kids = (parent.children || []).filter((n) => n.type === 'element');
        kids.forEach((node, i) => {
          if (HEADING.test(node.tagName)) {
            heading = ctx.textContent(node).trim();
            // The list that follows a "Sources" heading is a bibliography.
            const next = kids[i + 1];
            if (REFERENCE_HEADINGS.has(heading.toLowerCase()) && next && /^(ol|ul)$/.test(next.tagName)) {
              ctx.setProperty(next, 'className', [...(next.properties.className || []), 'references']);
            }
            return;
          }
          if (node.tagName === 'table') {
            tables++;
            ctx.prependChild(node, el('caption', {}, [txt(`${labels.table} ${tables}` + (heading ? `. ${heading}` : ''))]));
            return;
          }
          // A paragraph that holds one image and nothing else (whitespace aside).
          if (node.tagName === 'p') {
            const content = node.children.filter((n) => !(n.type === 'text' && !n.value.trim()));
            if (content.length === 1 && content[0].type === 'element' && content[0].tagName === 'img') {
              figures++;
              const alt = String(content[0].properties.alt || '').trim();
              ctx.replaceNode(node, el('figure', { className: ['figure'] },
                [content[0], el('figcaption', {}, [txt(`${labels.figure} ${figures}` + (alt ? `. ${alt}` : ''))])]));
              return;
            }
          }
          walk(node);
        });
      }
      walk(root);
    },
  };
}
