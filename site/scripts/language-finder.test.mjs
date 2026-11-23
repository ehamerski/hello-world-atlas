// site/scripts/language-finder.test.mjs - tests for the search, filters,
// sort order and address of the Languages page (src/scripts/language-finder.ts).
// Run: npm test (from site/; scripts/build-site.sh runs it), or
//   node --test site/scripts/language-finder.test.mjs
// https://nodejs.org/api/test.html
import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  counts, emptyState, fromQuery, matches, search, sortLangs, toQuery,
} from '../src/scripts/language-finder.ts';

const lang = (slug, name, year, more = {}) => ({
  slug, name, year, otherNames: [], paradigms: ['imperative'], kinds: ['cli'],
  implementations: 1, translated: true, ...more,
});
const LANGS = [
  lang('go', 'Go', 2009, { otherNames: ['golang'], paradigms: ['imperative', 'concurrent'], kinds: ['cli', 'web', 'web-frontend'], implementations: 4 }),
  lang('algol68', 'ALGOL 68', 1968),
  lang('haskell', 'Haskell', 1990, { paradigms: ['functional'], kinds: ['cli', 'web'], implementations: 2, translated: false }),
  lang('cpp', 'C++', 1985, { otherNames: ['C with Classes'], paradigms: ['imperative', 'object-oriented'], implementations: 3 }),
  lang('pseudocode', 'Pseudocode', null, { implementations: 3 }),
  lang('assembly', 'Assembly (x86-64)', null),
];
const names = (langs) => langs.map((l) => l.slug);
const known = {
  paradigm: new Set(['imperative', 'functional', 'concurrent', 'object-oriented']),
  released: new Set(['1960s', '1980s', '1990s', '2000s', 'undated']),
  platform: new Set(['cli', 'web', 'web-frontend']),
  page: new Set(['translated', 'english']),
};
const state = (change) => ({ ...emptyState(), ...change, filters: { ...emptyState().filters, ...change.filters } });

test('search finds names and other names, without case or accents', () => {
  assert.deepEqual(search(LANGS[0], 'GO'), { via: null });
  assert.deepEqual(search(LANGS[0], 'golang'), { via: 'golang' });
  assert.deepEqual(search(LANGS[1], 'algol'), { via: null });
  assert.deepEqual(search(LANGS[3], 'classes'), { via: 'C with Classes' });
  assert.deepEqual(search(LANGS[3], 'cpp'), { via: null }, 'the address of the page');
  assert.deepEqual(search(LANGS[3], 'c++'), { via: null });
  assert.equal(search(LANGS[2], 'xyz'), null);
  assert.deepEqual(search(LANGS[2], 'Häs'), { via: null });
});

test('a search of one or two characters matches only the start of a word', () => {
  assert.ok(search(LANGS[0], 'go'));
  assert.equal(search(LANGS[1], 'go'), null, '"ALGOL" contains "go" but does not start with it');
  assert.ok(search(LANGS[1], '68'));
  assert.ok(search(LANGS[1], 'gol'), 'three characters match anywhere');
});

test('values of one filter add languages, filters narrow the list', () => {
  const pick = (filters, q = '') => names(LANGS.filter((l) => matches(l, state({ q, filters }))));
  assert.deepEqual(pick({ paradigm: ['functional'] }), ['haskell']);
  assert.deepEqual(pick({ paradigm: ['functional', 'concurrent'] }), ['go', 'haskell']);
  assert.deepEqual(pick({ paradigm: ['functional', 'concurrent'], platform: ['web-frontend'] }), ['go']);
  assert.deepEqual(pick({ released: ['undated'] }), ['pseudocode', 'assembly']);
  assert.deepEqual(pick({ page: ['english'] }), ['haskell']);
  assert.deepEqual(pick({ paradigm: ['functional'] }, 'go'), []);
});

test('counts say what ticking a value would show', () => {
  const s = state({ filters: { paradigm: ['functional'], platform: ['web'] } });
  // Paradigm counts ignore the paradigm filter but keep the platform one.
  assert.deepEqual(Object.fromEntries(counts(LANGS, s, 'paradigm')),
    { imperative: 1, concurrent: 1, functional: 1 });
  assert.deepEqual(Object.fromEntries(counts(LANGS, s, 'platform')), { cli: 1, web: 1 });
});

test('sort orders, with undated languages last in both year orders', () => {
  assert.deepEqual(names(sortLangs(LANGS, 'name')), ['algol68', 'assembly', 'cpp', 'go', 'haskell', 'pseudocode']);
  assert.deepEqual(names(sortLangs(LANGS, 'oldest')), ['algol68', 'cpp', 'haskell', 'go', 'assembly', 'pseudocode']);
  assert.deepEqual(names(sortLangs(LANGS, 'newest')), ['go', 'haskell', 'cpp', 'algol68', 'assembly', 'pseudocode']);
  assert.deepEqual(names(sortLangs(LANGS, 'most')), ['go', 'cpp', 'pseudocode', 'haskell', 'algol68', 'assembly']);
});

test('the address keeps the state and ignores unknown values', () => {
  const s = state({ q: 'go', filters: { paradigm: ['functional', 'concurrent'], released: ['2000s'] }, sort: 'oldest', view: 'table' });
  const query = toQuery(s);
  assert.equal(query, '?q=go&paradigm=functional%2Cconcurrent&released=2000s&sort=oldest&view=table');
  assert.deepEqual(fromQuery(query, known), s);
  assert.equal(toQuery(emptyState()), '');
  assert.deepEqual(fromQuery('?paradigm=functional,nope&sort=size&view=grid&platform=', known),
    state({ filters: { paradigm: ['functional'] } }));
});
