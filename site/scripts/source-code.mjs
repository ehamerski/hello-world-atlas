// site/scripts/source-code.mjs - read a Hello World source file the way a
// teacher would: which lines are comments, which are code, where the
// program starts and which line prints the greeting.
//
// Used by scripts/generate.mjs (the "Anatomy" sections and the comparator)
// and scripts/measure-facts.mjs (comment and code line counts), so both
// count the same way.
//
// Only WHOLE-LINE comments are recognized: a line that starts with a
// comment marker, or a block comment that starts at the beginning of a
// line. A comment after code on the same line stays part of that code
// line. That is enough for this repository, whose comments are written as
// separate lines on purpose (see CONTRIBUTING.md).

import path from 'node:path';

// Comment markers per file extension.
//   line:  markers that start a line comment;
//   block: [open, close] pairs; `notOpen` is a prefix that looks like a
//          block opener but is code (a Pascal "{$mode ...}" directive);
//   column7: COBOL fixed format, where "*" in column 7 marks a comment.
// Each language's own Hello World file explains its comment syntax in
// its comments (for example languages/cobol/cli/hello.cob for column 7).
const C_LIKE = { line: ['//'], block: [['/*', '*/']] };
export const COMMENT_SYNTAX = {
  '.c': C_LIKE, '.h': C_LIKE, '.cpp': C_LIKE, '.hpp': C_LIKE, '.cs': C_LIKE,
  '.java': C_LIKE, '.go': C_LIKE, '.rs': C_LIKE, '.js': C_LIKE, '.mjs': C_LIKE,
  '.jsx': C_LIKE, '.ts': C_LIKE, '.alg': C_LIKE, '.psc': { line: ['//'], block: [] },
  '.php': { line: ['//', '#'], block: [['/*', '*/']], notLine: ['#['] },
  '.py': { line: ['#'], block: [] },
  '.adb': { line: ['--'], block: [] }, '.ads': { line: ['--'], block: [] },
  '.hs': { line: ['--'], block: [['{-', '-}']] },
  '.lisp': { line: [';'], block: [['#|', '|#']] },
  '.pl': { line: ['%'], block: [['/*', '*/']] },
  '.pas': { line: ['//'], block: [['{', '}'], ['(*', '*)']], notOpen: ['{$'] },
  '.pp': { line: ['//'], block: [['{', '}'], ['(*', '*)']], notOpen: ['{$'] },
  '.lpr': { line: ['//'], block: [['{', '}'], ['(*', '*)']], notOpen: ['{$'] },
  '.f90': { line: ['!'], block: [] },
  '.asm': { line: [';'], block: [] },
  '.bas': { line: ["'", 'REM ', 'REM\t'], block: [], wholeWord: ['REM'] },
  '.prg': { line: ['//', '&&', '*'], block: [['/*', '*/']] },
  '.cob': { line: ['*>'], block: [], column7: true },
};

export const hasCommentSyntax = (file) => Boolean(COMMENT_SYNTAX[path.extname(file).toLowerCase()]);

// Remove the decoration of one line inside a block comment: a leading
// " * " (C style), and the opening and closing markers.
function stripBlockLine(line, open, close, first, last) {
  let s = line;
  if (first) s = s.replace(open, '');
  if (last) s = s.slice(0, s.lastIndexOf(close));
  if (!first && open === '/*') s = s.replace(/^\s*\*(?!\/) ?/, '');
  return s;
}

// classify(text, file) -> one entry per line:
//   { n, kind: 'comment' | 'code' | 'blank', text, comment }
// `n` is the 1-based line number, `text` the original line and `comment`
// the comment text without its markers (comment lines only).
export function classify(text, file) {
  const syntax = COMMENT_SYNTAX[path.extname(file).toLowerCase()];
  const lines = text.replace(/\n$/, '').split('\n');
  const out = [];
  let block = null; // the [open, close] pair of the block comment we are in
  lines.forEach((line, i) => {
    const n = i + 1;
    const trimmed = line.trim();
    if (block) {
      const closes = line.includes(block[1]);
      out.push({ n, kind: 'comment', text: line, comment: stripBlockLine(line, block[0], block[1], false, closes) });
      if (closes) block = null;
      return;
    }
    if (!trimmed) { out.push({ n, kind: 'blank', text: line }); return; }
    if (!syntax) { out.push({ n, kind: 'code', text: line }); return; }
    if (syntax.column7 && line.length > 6 && (line[6] === '*' || line[6] === '/')) {
      out.push({ n, kind: 'comment', text: line, comment: line.slice(7).replace(/^\*+$/, '').replace(/^ /, '') });
      return;
    }
    const lineMarker = syntax.line.find((m) => trimmed.startsWith(m))
      || (syntax.wholeWord || []).find((w) => trimmed === w);
    if (lineMarker && !(syntax.notLine || []).some((p) => trimmed.startsWith(p))) {
      out.push({ n, kind: 'comment', text: line, comment: trimmed.slice(lineMarker.length).replace(/^ /, '') });
      return;
    }
    const pair = syntax.block.find(([open]) => trimmed.startsWith(open));
    if (pair && !(syntax.notOpen || []).some((p) => trimmed.startsWith(p))) {
      // The close marker must come after the opener on the same line.
      const closes = trimmed.indexOf(pair[1], pair[0].length) >= 0;
      // A one-line block comment followed by code ("{ x } begin") is code.
      if (closes && trimmed.slice(trimmed.indexOf(pair[1], pair[0].length) + pair[1].length).trim()) {
        out.push({ n, kind: 'code', text: line });
        return;
      }
      out.push({ n, kind: 'comment', text: line, comment: stripBlockLine(trimmed, pair[0], pair[1], true, closes).trimEnd().replace(/^ /, '') });
      if (!closes) block = pair;
      return;
    }
    out.push({ n, kind: 'code', text: line });
  });
  return out;
}

// Line counts of one file: code lines, comment lines and blank lines.
export function countLines(text, file) {
  const counts = { code: 0, comment: 0, blank: 0 };
  for (const l of classify(text, file)) counts[l.kind]++;
  return counts;
}

// anatomy(text, file) -> { header, steps }
//   header: the comment paragraphs before the first code line (what the
//           file is, how to run it);
//   steps:  [{ note, code: [{ n, text }] }], a comment and the code that
//           follows it. Code with no comment above it gets note: [].
// A note is a list of paragraphs; each paragraph is a list of lines.
export function anatomy(text, file) {
  const lines = classify(text, file);
  const steps = [];
  let header = null;
  let note = [];
  let para = [];
  let current = null;
  const endPara = () => { if (para.length) { note.push(para); para = []; } };
  for (const l of lines) {
    if (l.kind === 'comment') {
      if (current) { steps.push(current); current = null; }
      // A comment line with no text (" *", "#") separates paragraphs.
      if (l.comment.trim()) para.push(l.comment.replace(/\s+$/, ''));
      else endPara();
    } else if (l.kind === 'blank') {
      if (current) current.blank = true;
      else {
        endPara();
        // The first comment block of the file, when a blank line follows
        // it, is the file header (what the file is, how to run it).
        if (header === null && note.length) { header = note; note = []; }
      }
    } else {
      endPara();
      if (header === null) header = [];
      if (current && (!note.length && !current.blank)) {
        current.code.push({ n: l.n, text: l.text });
      } else {
        if (current) steps.push(current);
        current = { note, code: [{ n: l.n, text: l.text }] };
        note = [];
      }
    }
  }
  if (current) steps.push(current);
  endPara();
  if (note.length) steps.push({ note, code: [] });
  // Remove the common indentation of each step's code.
  for (const s of steps) {
    const indent = Math.min(...s.code.map((c) => c.text.match(/^\s*/)[0].length));
    if (Number.isFinite(indent)) for (const c of s.code) c.text = c.text.slice(indent);
    delete s.blank;
  }
  return { header: header || [], steps };
}

// Code lines of a file whose text contains `needle` (the greeting).
export function linesWith(text, file, needle) {
  return classify(text, file).filter((l) => l.kind === 'code' && l.text.includes(needle));
}

// Where the program starts: the first code line that declares the entry
// point, per language. null when the language has none (a script runs
// from its first line) or when no rule matches.
// References: C11 5.1.2.2.1 "Program startup" (main), JLS 12.1.4
// (public static void main), C# "Main() and command-line arguments" /
// top-level statements, Go spec "Program execution" (package main, func
// main), Rust Reference "Crates and source files" (fn main), Haskell 2010
// report 5 "Modules" (Main.main), Ada RM 10.2 (main subprogram), Pascal
// (program heading), COBOL (PROCEDURE DIVISION), Fortran (PROGRAM).
const ENTRY = {
  '.c': /\bint\s+main\s*\(/, '.cpp': /\bint\s+main\s*\(/,
  '.java': /\bstatic\s+void\s+main\s*\(/, '.cs': /\bstatic\b.*\bMain\s*\(/,
  '.go': /^func main\s*\(/, '.rs': /^\s*(async\s+)?fn main\s*\(/,
  '.hs': /^main\s*(::|=)/, '.adb': /^procedure\s+\w+/i,
  '.pas': /^program\s+\w+/i, '.cob': /PROCEDURE\s+DIVISION/i,
  '.f90': /^\s*program\s+\w+/i, '.asm': /^\s*_main\s*:/,
  '.lisp': /\(defun\s+main\b/i, '.pl': /initialization\(\s*main/,
  '.prg': /^\s*(PROCEDURE|FUNCTION)\s+Main\b/i,
  '.alg': /^\s*inicio\b/i, '.psc': /^\s*Algoritmo\b/i,
  '.py': /^if\s+__name__\s*==\s*["']__main__["']/,
};
// Languages where a file is a script that runs from the top: C# top-level
// statements also behave this way when there is no Main method.
const RUNS_FROM_TOP = new Set(['.py', '.js', '.mjs', '.php', '.bas', '.cs', '.lisp']);

export function entryPoint(text, file) {
  const ext = path.extname(file).toLowerCase();
  const rule = ENTRY[ext];
  const hit = rule && classify(text, file).find((l) => l.kind === 'code' && rule.test(l.text));
  if (hit) return { n: hit.n, text: hit.text.trim() };
  return RUNS_FROM_TOP.has(ext) ? { n: null, text: null, fromTop: true } : null;
}

// The text every Hello World program prints; it finds the line that does
// the work and the file that holds it.
export const GREETING = 'Hello, World';

// mainFile(names, read) -> the main source file of an implementation: the
// first file with a known comment syntax that contains the greeting,
// preferring a backend over a front end. `names` are paths relative to the
// implementation folder, `read(name)` returns a file's text. null when
// there is none (a README-only folder).
export function mainFile(names, read) {
  const candidates = names.filter((f) => !f.endsWith('.sh') && hasCommentSyntax(f) && read(f).includes(GREETING));
  return candidates.find((f) => !f.startsWith('frontend/')) || candidates[0] || null;
}
