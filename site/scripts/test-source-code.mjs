// site/scripts/test-source-code.mjs - fixture tests for the language tables
// of source-code.mjs and for `generate.mjs --check`.
//
// WHAT: writes small dummy implementations into a temporary folder and
//   checks that
//   - Perl and Prolog files, both named hello.pl, each get their own
//     comment rules and entry point (the tables are keyed by language
//     folder first, extension second);
//   - in languages/bash/ a hello.sh is the program and run.sh a script;
//   - a Lua "--[[ ... ]]" block comment is read as one comment;
//   - `generate.mjs --check` passes on the fixture, fails when an
//     implementation's main file has an unknown extension, and passes on
//     this repository.
// WHY: a wrong table entry does not stop the build; the page just shows
//   the wrong Anatomy. These tests make such a mistake visible.
// HOW: node site/scripts/test-source-code.mjs   (exit status 1 on failure)

import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { classify, entryPoint, mainFile } from './source-code.mjs';

const GENERATE = path.join(path.dirname(fileURLToPath(import.meta.url)), 'generate.mjs');

let failed = 0;
function test(name, fn) {
  try { fn(); console.log(`ok    ${name}`); } catch (e) { failed++; console.log(`FAIL  ${name}\n      ${e.message.split('\n').join('\n      ')}`); }
}
const kinds = (text, file, lang) => classify(text, file, lang).map((l) => l.kind).join(' ');

// The same three lines read as Perl and as Prolog: "#" starts a comment
// only in Perl, "%" only in Prolog.
const BOTH = '# hash line\n% percent line\nmain :- write(x).\n';
const PERL = '#!/usr/bin/env perl\n# Prints the greeting.\nuse strict;\nprint "Hello, World!\\n";\n';
const PROLOG = '% Prints the greeting.\n:- initialization(main).\nmain :- write(\'Hello, World!\'), nl.\n';

test('perl/cli/hello.pl uses Perl comments (#)', () => {
  assert.equal(kinds(BOTH, 'hello.pl', 'perl'), 'comment code code');
  assert.equal(kinds(PERL, 'hello.pl', 'perl'), 'comment comment code code');
});
test('prolog/cli/hello.pl uses Prolog comments (%)', () => {
  assert.equal(kinds(BOTH, 'hello.pl', 'prolog'), 'code comment code');
  assert.equal(kinds(PROLOG, 'hello.pl', 'prolog'), 'comment code code');
});
test('Perl POD (=pod ... =cut) is one comment', () => {
  assert.equal(kinds('=pod\n\nText.\n\n=cut\nprint 1;\n', 'hello.pl', 'perl'), 'comment comment comment comment comment code');
});
test('entry point: Perl runs from the top, Prolog starts at initialization(main)', () => {
  assert.deepEqual(entryPoint(PERL, 'hello.pl', 'perl'), { n: null, text: null, fromTop: true });
  assert.deepEqual(entryPoint(PROLOG, 'hello.pl', 'prolog'), { n: 2, text: ':- initialization(main).' });
});
test('a .pl file outside perl/ and prolog/ has no comment rules (no guess)', () => {
  assert.equal(mainFile(['hello.pl'], () => PERL, 'other'), null);
});
test('bash: hello.sh is the program, run.sh and install.sh are scripts', () => {
  const files = { 'hello.sh': '# Greets.\necho "Hello, World!"\n', 'run.sh': '# echo "Hello, World!"\n', 'install.sh': '' };
  assert.equal(mainFile(Object.keys(files).sort(), (f) => files[f], 'bash'), 'hello.sh');
  assert.equal(mainFile(Object.keys(files).sort(), (f) => files[f], 'python'), null);
});
test('Lua: "--[[ ... ]]" is a block comment, "--" a line comment', () => {
  assert.equal(kinds('--[[ first\nsecond ]]\n-- line\nprint("Hello, World!")\n', 'hello.lua', 'lua'), 'comment comment comment code');
});

// A fixture repository for generate.mjs --check: git lists its files, as
// in the real repository.
const tmp = fs.mkdtempSync(path.join(process.env.TMPDIR || os.tmpdir(), 'source-code-test-'));
const write = (f, text) => { fs.mkdirSync(path.dirname(path.join(tmp, f)), { recursive: true }); fs.writeFileSync(path.join(tmp, f), text); };
const meta = (name) => `name: "${name}"\ncategories:\n  - folder: "cli"\n    kind: "cli"\n`;
write('languages/perl/meta.yml', meta('Perl'));
write('languages/perl/cli/hello.pl', PERL);
write('languages/prolog/meta.yml', meta('Prolog'));
write('languages/prolog/cli/hello.pl', PROLOG);
spawnSync('git', ['init', '-q'], { cwd: tmp });
const check = (root) => spawnSync(process.execPath, [GENERATE, '--check'],
  { env: { ...process.env, REPO_ROOT: root }, encoding: 'utf8' });

test('generate.mjs --check passes on the perl and prolog fixtures', () => {
  const r = check(tmp);
  assert.equal(r.status, 0, r.stderr + r.stdout);
});
test('generate.mjs --check fails on an unknown extension (.xyz)', () => {
  write('languages/xyz/meta.yml', meta('Xyz'));
  write('languages/xyz/cli/hello.xyz', '; Prints the greeting.\nsay "Hello, World!"\n');
  const r = check(tmp);
  assert.equal(r.status, 1, r.stderr + r.stdout);
  assert.match(r.stderr, /languages\/xyz\/cli: no comment syntax for hello\.xyz/);
  console.log(`      (expected) ${r.stderr.trim()}`);
});
test('generate.mjs --check passes on this repository', () => {
  const r = spawnSync(process.execPath, [GENERATE, '--check'], { encoding: 'utf8' });
  assert.equal(r.status, 0, r.stderr + r.stdout);
});
fs.rmSync(tmp, { recursive: true, force: true });

console.log(failed ? `${failed} test(s) failed` : 'all tests passed');
process.exit(failed ? 1 : 0);
