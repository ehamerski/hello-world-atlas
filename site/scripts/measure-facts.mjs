// site/scripts/measure-facts.mjs - measure every Hello World implementation
// and save the numbers in site/data/facts.json (the "Measured facts" page).
//
// WHAT: for every folder languages/<lang>/<folder>/ it records
//   - code and comment lines of the main source file (counted by
//     source-code.mjs, the same rules the Anatomy sections use);
//   - the number of source files (files git knows, tracked or new and not
//     ignored, that are not the README, a .sh script, a lock file or a
//     binary; generate.mjs reads the same files);
//   - direct dependencies declared in the folder's manifests
//     (package.json, Cargo.toml, go.mod, requirements.txt, pom.xml, *.csproj,
//     *.cabal); toolchains and standard libraries are not counted;
//   - the steps announced by build.sh and run.sh (their `step "..."` lines);
//   and, for command-line ("cli") implementations only, when not --static:
//   - build output: the bytes of every git-ignored file in the folder after
//     build.sh ran (what the build writes, compiler caches included);
//   - run time: the median wall-clock time of RUNS runs of run.sh, the
//     script included, after one warm-up run. A run counts only if it
//     exits with status 0 and prints the greeting.
// WHY: the numbers on the site must come from a script anyone can run
//   again, not from a table typed by hand. The method and the machine are
//   saved with the numbers, because run times depend on both.
// HOW:
//   node site/scripts/measure-facts.mjs            # everything (slow: builds every cli)
//   node site/scripts/measure-facts.mjs --static   # only the counts, no builds or runs;
//                                                  # keeps earlier times from facts.json
//   node site/scripts/measure-facts.mjs --only c/cli,go/cli   # re-measure some cli folders
//                                                  # (a language folder, "go", means all of its folders)
//   node site/scripts/measure-facts.mjs --check [--only python]
//       measure nothing and write nothing; fail when facts.json is out of
//       date: an implementation is missing or gone, its counts changed, or
//       a cli implementation with a run.sh has no run time.
// Each implementation's toolchain must be installed (its install.sh) for
// its build output and run time to be measured; otherwise they are null
// with the reason in "error".

import { execFileSync, spawnSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import YAML from 'yaml';
import { GREETING, countLines, isScript, mainFile } from './source-code.mjs';

const SITE = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const ROOT = path.dirname(SITE);
const OUT = path.join(SITE, 'data', 'facts.json');
const RUNS = 5;

const args = process.argv.slice(2);
const STATIC = args.includes('--static');
const onlyAt = args.indexOf('--only');
const ONLY = onlyAt >= 0 ? new Set((args[onlyAt + 1] || '').split(',').filter(Boolean)) : null;
const CHECK = args.includes('--check');
const selected = (id) => !ONLY || ONLY.has(id) || ONLY.has(id.split('/')[0]);

const git = (...a) => execFileSync('git', a, { cwd: ROOT, encoding: 'utf8' }).split('\n').filter(Boolean);
const read = (f) => fs.readFileSync(path.join(ROOT, f), 'utf8');

// Files that are not "source": documentation, scripts (isScript in
// source-code.mjs), lock files, binaries.
const NOT_SOURCE = /(^|\/)(README\.md|\.gitignore|package-lock\.json|Cargo\.lock|go\.sum|[^/]*\.lock)$|\.(png|jpe?g|gif|svg|ico|icns|zip|jar|ttf|woff2?)$/i;

// Direct dependencies per manifest. Each counter reads only the section
// that lists dependencies of the program itself.
function countDeps(name, text) {
  const base = path.basename(name);
  if (base === 'package.json') {
    const j = JSON.parse(text);
    return Object.keys({ ...j.dependencies, ...j.devDependencies }).length;
  }
  if (base === 'Cargo.toml') {
    const section = text.match(/^\[dependencies\]\n([\s\S]*?)(?=^\[|(?![\s\S]))/m);
    return section ? section[1].split('\n').filter((l) => /^\s*[\w-]+\s*=/.test(l)).length : 0;
  }
  if (base === 'go.mod') {
    // Only direct requirements: Go marks the others "// indirect".
    // https://go.dev/ref/mod#go-mod-file-require
    const block = text.match(/^require\s*\(([\s\S]*?)\)/m);
    const lines = block ? block[1].split('\n') : [...text.matchAll(/^require\s+(.*)$/gm)].map((m) => m[1]);
    return lines.filter((l) => l.trim() && !l.includes('// indirect')).length;
  }
  if (base === 'requirements.txt') return text.split('\n').filter((l) => l.trim() && !l.trim().startsWith('#')).length;
  if (base === 'pom.xml') return (text.match(/<dependency>/g) || []).length;
  if (base.endsWith('.csproj')) return (text.match(/<PackageReference\b/g) || []).length;
  if (base.endsWith('.cabal')) {
    // build-depends: base, scotty, text  (one field, comma-separated)
    const field = text.match(/build-depends:\s*([\s\S]*?)(?=\n\s*[\w-]+:|\n\S|$)/);
    return field ? field[1].split(',').filter((d) => d.trim()).length : 0;
  }
  return null;
}
const isManifest = (f) => countDeps(f, '{}') !== null || /\.(csproj|cabal)$/.test(f);

function scriptSteps(dir, script) {
  const f = `${dir}/${script}`;
  return fs.existsSync(path.join(ROOT, f)) ? [...read(f).matchAll(/^\s*step "/gm)].length : 0;
}

// Runs a script of the folder; returns { ok, ms, out }.
function runScript(dir, script) {
  const start = process.hrtime.bigint();
  const r = spawnSync('/bin/sh', [script], { cwd: path.join(ROOT, dir), encoding: 'utf8', timeout: 15 * 60 * 1000 });
  const ms = Number(process.hrtime.bigint() - start) / 1e6;
  return { ok: r.status === 0, ms, out: (r.stdout || '') + (r.stderr || '') };
}

function ignoredBytes(dir) {
  return git('ls-files', '--others', '--ignored', '--exclude-standard', '--', dir)
    .reduce((sum, f) => sum + fs.statSync(path.join(ROOT, f)).size, 0);
}

// A folder without build.sh has no build output (null, not 0); one without
// run.sh (a pseudocode text to read) is not run.
function measureRun(dir) {
  const has = (f) => fs.existsSync(path.join(ROOT, dir, f));
  if (!has('run.sh')) return { error: 'no run.sh' };
  let bytes = null;
  if (has('build.sh')) {
    if (!runScript(dir, 'build.sh').ok) return { error: 'build.sh failed' };
    bytes = ignoredBytes(dir);
  }
  const times = [];
  for (let i = 0; i <= RUNS; i++) {
    const r = runScript(dir, 'run.sh');
    if (!r.ok || !r.out.includes(GREETING)) return { buildBytes: bytes, error: 'run.sh failed or printed no greeting' };
    if (i > 0) times.push(r.ms); // run 0 is the warm-up
  }
  times.sort((a, b) => a - b);
  return { buildBytes: bytes, runMs: Math.round(times[Math.floor(times.length / 2)]) };
}

// The machine, without anything that identifies a person (no host or user name).
function machine() {
  const sh = (cmd, a) => { try { return execFileSync(cmd, a, { encoding: 'utf8' }).trim(); } catch { return null; } };
  const osName = process.platform === 'darwin' ? `macOS ${sh('sw_vers', ['-productVersion'])}` : `${os.type()} ${os.release()}`;
  return {
    os: `${osName} (${os.arch()})`,
    cpu: `${os.cpus()[0].model.replace(/\s+/g, ' ').trim()}, ${os.cpus().length} logical cores`,
    memory: `${Math.round(os.totalmem() / 2 ** 30)} GiB`,
    node: process.version,
  };
}

const previous = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, 'utf8')) : { impls: {} };
const tracked = git('ls-files', '--cached', '--others', '--exclude-standard', 'languages');
const result = { measuredOn: new Date().toISOString().slice(0, 10), runs: RUNS, machine: machine(), impls: {} };
if (STATIC || ONLY) {
  // Partial run: the times and the machine of the previous full run stay.
  result.measuredOn = previous.measuredOn || result.measuredOn;
  result.machine = previous.machine || result.machine;
}

const slugs = fs.readdirSync(path.join(ROOT, 'languages')).filter((s) => fs.existsSync(path.join(ROOT, 'languages', s, 'meta.yml'))).sort();
for (const slug of slugs) {
  const meta = YAML.parse(read(`languages/${slug}/meta.yml`));
  for (const cat of meta.categories) {
    const id = `${slug}/${cat.folder}`;
    const dir = `languages/${id}`;
    const names = tracked.filter((f) => f.startsWith(dir + '/')).map((f) => f.slice(dir.length + 1));
    const file = mainFile(names, (f) => read(`${dir}/${f}`), slug);
    const lines = file ? countLines(read(`${dir}/${file}`), file, slug) : null;
    const deps = names.filter(isManifest).reduce((n, f) => n + countDeps(f, read(`${dir}/${f}`)), 0);
    const facts = {
      kind: cat.kind, file, codeLines: lines && lines.code, commentLines: lines && lines.comment,
      files: names.filter((f) => !NOT_SOURCE.test(f) && !isScript(f, slug)).length, deps,
      steps: scriptSteps(dir, 'build.sh') + scriptSteps(dir, 'run.sh'),
      buildBytes: null, runMs: null,
    };
    const old = previous.impls[id] || {};
    if (cat.kind === 'cli' && !STATIC && !CHECK && selected(id)) {
      process.stderr.write(`measuring ${id} ... `);
      const measured = measureRun(dir);
      delete facts.error;
      Object.assign(facts, measured);
      process.stderr.write(facts.error ? `${facts.error}\n` : `${facts.runMs} ms\n`);
    } else if (cat.kind === 'cli') {
      for (const k of ['buildBytes', 'runMs', 'error']) if (k in old) facts[k] = old[k];
    }
    result.impls[id] = facts;
  }
}

// --check: compare what was just counted with facts.json. The run times
// are not measured again (that needs every toolchain and takes minutes);
// only their presence is checked.
if (CHECK) {
  const COUNTS = ['kind', 'file', 'codeLines', 'commentLines', 'files', 'deps', 'steps'];
  const problems = [];
  for (const [id, facts] of Object.entries(result.impls)) {
    if (!selected(id)) continue;
    const old = previous.impls[id];
    if (!old) { problems.push(`${id}: not in facts.json`); continue; }
    const changed = COUNTS.filter((k) => old[k] !== facts[k]);
    if (changed.length) {
      problems.push(`${id}: ${changed.map((k) => `${k} is ${JSON.stringify(facts[k])}, facts.json says ${JSON.stringify(old[k])}`).join('; ')}`);
    }
    const hasRun = fs.existsSync(path.join(ROOT, 'languages', id, 'run.sh'));
    if (facts.kind === 'cli' && hasRun && typeof old.runMs !== 'number') {
      problems.push(`${id}: no run time in facts.json${old.error ? ` (${old.error})` : ''}`);
    }
  }
  for (const id of Object.keys(previous.impls)) {
    if (selected(id) && !(id in result.impls)) problems.push(`${id}: in facts.json, but not in any meta.yml`);
  }
  for (const p of problems) console.error(`error: ${p}`);
  if (problems.length) {
    console.error('Measure again: node site/scripts/measure-facts.mjs --only <lang> (or --static for the counts only)');
    process.exit(1);
  }
  const n = Object.keys(result.impls).filter(selected).length;
  console.log(`ok: facts.json is up to date for ${n} implementations`);
  process.exit(0);
}

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, JSON.stringify(result, null, 2) + '\n');
console.log(`wrote ${path.relative(ROOT, OUT)} (${Object.keys(result.impls).length} implementations)`);
