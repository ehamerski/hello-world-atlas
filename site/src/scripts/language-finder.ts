// site/src/scripts/language-finder.ts - search, filters, sort order and the
// address (URL) of the Languages page (src/pages/[...locale]/languages/).
// Only plain functions here, without the page, so that
// scripts/language-finder.test.mjs can run them with `node --test`.
// Node.js runs this file directly: it uses only type annotations, no enums.
// https://nodejs.org/api/typescript.html#type-stripping

export interface Lang {
  slug: string;
  name: string;
  otherNames: string[];
  year: number | null;
  paradigms: string[];
  kinds: string[];
  implementations: number;
  translated: boolean;
}

export const FILTERS = ['paradigm', 'released', 'platform', 'page'] as const;
export type Filter = (typeof FILTERS)[number];
export const SORTS = ['name', 'oldest', 'newest', 'most'] as const;
export type Sort = (typeof SORTS)[number];
export const VIEWS = ['cards', 'table'] as const;
export type View = (typeof VIEWS)[number];

export interface State {
  q: string;
  filters: Record<Filter, string[]>;
  sort: Sort;
  view: View;
}

export function emptyState(): State {
  return { q: '', filters: { paradigm: [], released: [], platform: [], page: [] }, sort: 'name', view: 'cards' };
}

// The values a language has for a filter. They are keys, the same in every
// locale, so a copied address works on the English and the translated site.
export function values(lang: Lang, filter: Filter): string[] {
  switch (filter) {
    case 'paradigm': return lang.paradigms;
    case 'released': return [lang.year == null ? 'undated' : `${Math.floor(lang.year / 10) * 10}s`];
    case 'platform': return lang.kinds;
    case 'page': return [lang.translated ? 'translated' : 'english'];
  }
}

// Lower case, without accents, so "algol" finds "ALGOL 68" and "e" finds "é".
export function fold(text: string): string {
  return text.normalize('NFD').replace(/\p{M}/gu, '').toLowerCase().trim();
}

// Does `name` match the search? A search of one or two characters (such as
// "go" or "r") matches only the start of a word, so it does not find every
// name that merely contains those letters; a longer one matches anywhere.
function nameMatches(name: string, q: string): boolean {
  const folded = fold(name);
  if (q.length >= 3) return folded.includes(q);
  return folded.split(/[^\p{L}\p{N}+#]+/u).some((word) => word.startsWith(q));
}

// null: no match. Otherwise `via` is the other name that matched, or null
// when the name itself (or the address, such as "cpp") matched.
export function search(lang: Lang, query: string): { via: string | null } | null {
  const q = fold(query);
  if (!q || nameMatches(lang.name, q) || lang.slug.startsWith(q)) return { via: null };
  const via = lang.otherNames.find((n) => nameMatches(n, q));
  return via ? { via } : null;
}

// Values of one filter combine with OR, different filters with AND.
// `skip` leaves one filter out, to count what ticking one of its values adds.
export function matches(lang: Lang, state: State, skip?: Filter): boolean {
  if (!search(lang, state.q)) return false;
  return FILTERS.every((f) => f === skip || state.filters[f].length === 0
    || values(lang, f).some((v) => state.filters[f].includes(v)));
}

// How many languages each value of `filter` would show, with the search and
// the other filters as they are.
export function counts(langs: Lang[], state: State, filter: Filter): Map<string, number> {
  const result = new Map<string, number>();
  for (const lang of langs) {
    if (!matches(lang, state, filter)) continue;
    for (const v of new Set(values(lang, filter))) result.set(v, (result.get(v) ?? 0) + 1);
  }
  return result;
}

const byName = (a: Lang, b: Lang) => a.name.localeCompare(b.name, 'en');

// Languages without a single year come last in both year orders.
export function sortLangs(langs: Lang[], sort: Sort): Lang[] {
  const year = (l: Lang, missing: number) => l.year ?? missing;
  const compare: Record<Sort, (a: Lang, b: Lang) => number> = {
    name: byName,
    oldest: (a, b) => year(a, Infinity) - year(b, Infinity) || byName(a, b),
    newest: (a, b) => year(b, -Infinity) - year(a, -Infinity) || byName(a, b),
    most: (a, b) => b.implementations - a.implementations || byName(a, b),
  };
  return [...langs].sort((a, b) => {
    // Infinity - Infinity is NaN: two undated languages are equal by year.
    const c = compare[sort](a, b);
    return Number.isNaN(c) ? byName(a, b) : c;
  });
}

// State -> "?q=go&paradigm=functional,logic&sort=oldest". Default values are
// left out, so the plain page has the plain address.
export function toQuery(state: State): string {
  const params = new URLSearchParams();
  if (state.q.trim()) params.set('q', state.q.trim());
  for (const f of FILTERS) if (state.filters[f].length) params.set(f, state.filters[f].join(','));
  if (state.sort !== 'name') params.set('sort', state.sort);
  if (state.view !== 'cards') params.set('view', state.view);
  const query = params.toString();
  return query ? `?${query}` : '';
}

// Address -> state. A value the page does not know (an old link, a typo) is
// left out instead of showing an error.
export function fromQuery(query: string, known: Record<Filter, Set<string>>): State {
  const params = new URLSearchParams(query);
  const state = emptyState();
  state.q = params.get('q') ?? '';
  for (const f of FILTERS) {
    const wanted = (params.get(f) ?? '').split(',').filter((v) => known[f].has(v));
    state.filters[f] = [...new Set(wanted)];
  }
  const sort = params.get('sort');
  if ((SORTS as readonly string[]).includes(sort ?? '')) state.sort = sort as Sort;
  const view = params.get('view');
  if ((VIEWS as readonly string[]).includes(view ?? '')) state.view = view as View;
  return state;
}
