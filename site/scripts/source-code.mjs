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

// Every table below is looked up by LANGUAGE first, then by EXTENSION
// (see lookup()). The language is the folder name in languages/<lang>/.
// Most extensions mean one language, so the extension tables do the work;
// a language entry is needed only when an extension is shared: ".pl" is
// Perl in languages/perl/ and Prolog in languages/prolog/, ".h" is C or
// Objective-C, and ".sh" is a Bash program only in languages/bash/.
//   table = { byLanguage: { <lang>: { <ext>: value } }, byExt: { <ext>: value } }
export function lookup(table, file, lang) {
  const ext = path.extname(file).toLowerCase();
  return table.byLanguage[lang]?.[ext] ?? table.byExt[ext];
}

// Comment markers.
//   line:  markers that start a line comment;
//   block: [open, close] pairs; `notOpen` is a prefix that looks like a
//          block opener but is code (a Pascal "{$mode ...}" directive);
//   column7: COBOL fixed format, where "*" in column 7 marks a comment.
// Block openers are tried before line markers, because some start with
// one ("--[[" in Lua starts with "--").
// Each language's own Hello World file explains its comment syntax in
// its comments (for example languages/cobol/cli/hello.cob for column 7).
// References for the languages that have no Hello World file yet:
//   Ruby       docs.ruby-lang.org/en/master/syntax/comments_rdoc.html
//   Perl       perldoc.perl.org/perlsyn#Comments, perldoc.perl.org/perlpod
//   Lua        www.lua.org/manual/5.4/manual.html#3.1
//   Kotlin     kotlinlang.org/docs/basic-syntax.html#comments
//   Clojure    clojure.org/reference/reader (";" comment)
//   Erlang     Erlang reference manual ("%" starts a comment)
//   Elixir     hexdocs.pm/elixir/syntax-reference.html
//   Swift      The Swift Programming Language, "The Basics", Comments
//   Dart       dart.dev/language/comments
//   Smalltalk  Goldberg and Robson, "Smalltalk-80" (the Blue Book): comments in double quotes
//   Simula     SIMULA Common Base Language ("comment" or "!", up to ";")
//   Eiffel     ECMA-367 ("--" comments)
//   QCL        the "//" comments in tph.itp.tuwien.ac.at/~oemer/doc/quprog/node12.html
//   VB.NET     learn.microsoft.com, Visual Basic "Comments in code"
//   Scala      Scala 3 reference, "Lexical Syntax"
//   F#, OCaml  F# language reference; OCaml manual, "Lexical conventions"
//   Julia      Julia manual ("#" and "#= =#")
//   R          R Language Definition, "Comments"
//   Zig        ziglang.org/documentation/master/#Comments
//   Bash       Bash Reference Manual 3.1.3 "Comments"
//   Racket     Racket reference, "Reading Comments"
//   ALGOL 68   www.algol68-lang.org/docs/GNU68-2025-005-nestable-comments.txt
//              ("# ... #" and "COMMENT ... COMMENT"; the short "CO ... CO"
//              is not recognized, because "CO" also starts ordinary words)
const C_LIKE = { line: ['//'], block: [['/*', '*/']] };
const HASH = { line: ['#'], block: [] };
const PASCAL = { line: ['//'], block: [['{', '}'], ['(*', '*)']], notOpen: ['{$'] };
const BASIC = { line: ["'", 'REM ', 'REM\t'], block: [], wholeWord: ['REM'] };
const ML = { line: [], block: [['(*', '*)']] };
export const COMMENT_SYNTAX = {
  byLanguage: {
    perl: { '.pl': { line: ['#'], block: [['=pod', '=cut'], ['=head1', '=cut'], ['=begin', '=cut']] } },
    prolog: { '.pl': { line: ['%'], block: [['/*', '*/']] } },
    bash: { '.sh': HASH },
  },
  byExt: {
    '.c': C_LIKE, '.h': C_LIKE, '.cpp': C_LIKE, '.hpp': C_LIKE, '.cs': C_LIKE,
    '.java': C_LIKE, '.go': C_LIKE, '.rs': C_LIKE, '.js': C_LIKE, '.mjs': C_LIKE,
    '.jsx': C_LIKE, '.ts': C_LIKE, '.alg': C_LIKE, '.psc': { line: ['//'], block: [] },
    '.php': { line: ['//', '#'], block: [['/*', '*/']], notLine: ['#['] },
    '.py': HASH,
    '.adb': { line: ['--'], block: [] }, '.ads': { line: ['--'], block: [] },
    '.hs': { line: ['--'], block: [['{-', '-}']] },
    '.lisp': { line: [';'], block: [['#|', '|#']] },
    '.pas': PASCAL, '.pp': PASCAL, '.lpr': PASCAL, '.dpr': PASCAL,
    '.f90': { line: ['!'], block: [] },
    '.asm': { line: [';'], block: [] },
    '.bas': BASIC, '.vb': BASIC,
    '.prg': { line: ['//', '&&', '*'], block: [['/*', '*/']] },
    '.cob': { line: ['*>'], block: [], column7: true },
    '.rb': { line: ['#'], block: [['=begin', '=end']] },
    '.ru': HASH, // config.ru, the Ruby "rackup" file of a Rack application
    '.pm': { line: ['#'], block: [['=pod', '=cut'], ['=head1', '=cut'], ['=begin', '=cut']] },
    '.lua': { line: ['--'], block: [['--[[', ']]']] },
    '.kt': C_LIKE, '.kts': C_LIKE,
    '.clj': { line: [';'], block: [] }, '.cljs': { line: [';'], block: [] }, '.cljc': { line: [';'], block: [] },
    '.erl': { line: ['%'], block: [] }, '.hrl': { line: ['%'], block: [] },
    '.ex': HASH, '.exs': HASH,
    '.swift': C_LIKE, '.m': C_LIKE, '.dart': C_LIKE,
    '.st': { line: [], block: [['"', '"']] },
    '.sim': { line: [], block: [['!', ';'], ['comment', ';'], ['COMMENT', ';']] },
    '.e': { line: ['--'], block: [] },
    '.qcl': { line: ['//'], block: [] },
    '.tsx': C_LIKE, '.scala': C_LIKE, '.sc': C_LIKE,
    '.fs': { line: ['//'], block: [['(*', '*)']] }, '.fsx': { line: ['//'], block: [['(*', '*)']] },
    '.ml': ML, '.mli': ML,
    '.jl': { line: ['#'], block: [['#=', '=#']] },
    '.r': HASH,
    '.zig': { line: ['//'], block: [] },
    '.rkt': { line: [';'], block: [['#|', '|#']] },
    '.a68': { line: [], block: [['#', '#'], ['COMMENT', 'COMMENT']] },
  },
};

const syntaxOf = (file, lang) => lookup(COMMENT_SYNTAX, file, lang);
export const hasCommentSyntax = (file, lang) => Boolean(syntaxOf(file, lang));

// The repository's own scripts (install.sh, build.sh, run.sh, helpers):
// every .sh file, except in a language whose programs are .sh files
// (Bash), where only the scripts with these names are.
const REPO_SCRIPT = /(^|\/)(install|build|run|[^/]*-env)\.sh$/;
export const isScript = (file, lang) =>
  file.endsWith('.sh') && (!COMMENT_SYNTAX.byLanguage[lang]?.['.sh'] || REPO_SCRIPT.test(file));

// Remove the decoration of one line inside a block comment: a leading
// " * " (C style), and the opening and closing markers.
function stripBlockLine(line, open, close, first, last) {
  let s = line;
  if (first) s = s.replace(open, '');
  if (last) s = s.slice(0, s.lastIndexOf(close));
  if (!first && open === '/*') s = s.replace(/^\s*\*(?!\/) ?/, '');
  return s;
}

// classify(text, file, lang) -> one entry per line:
//   { n, kind: 'comment' | 'code' | 'blank', text, comment }
// `n` is the 1-based line number, `text` the original line and `comment`
// the comment text without its markers (comment lines only).
export function classify(text, file, lang) {
  const syntax = syntaxOf(file, lang);
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
    const lineMarker = syntax.line.find((m) => trimmed.startsWith(m))
      || (syntax.wholeWord || []).find((w) => trimmed === w);
    if (lineMarker && !(syntax.notLine || []).some((p) => trimmed.startsWith(p))) {
      out.push({ n, kind: 'comment', text: line, comment: trimmed.slice(lineMarker.length).replace(/^ /, '') });
      return;
    }
    out.push({ n, kind: 'code', text: line });
  });
  return out;
}

// Line counts of one file: code lines, comment lines and blank lines.
export function countLines(text, file, lang) {
  const counts = { code: 0, comment: 0, blank: 0 };
  for (const l of classify(text, file, lang)) counts[l.kind]++;
  return counts;
}

// anatomy(text, file, lang) -> { header, steps }
//   header: the comment paragraphs before the first code line (what the
//           file is, how to run it);
//   steps:  [{ note, code: [{ n, text }] }], a comment and the code that
//           follows it. Code with no comment above it gets note: [].
// A note is a list of paragraphs; each paragraph is a list of lines.
export function anatomy(text, file, lang) {
  const lines = classify(text, file, lang);
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
export function linesWith(text, file, needle, lang) {
  return classify(text, file, lang).filter((l) => l.kind === 'code' && l.text.includes(needle));
}

// Where the program starts: the first code line that declares the entry
// point, per language. `top: true` means the file is a script that runs
// from its first line when no rule matches (C# top-level statements also
// behave this way when there is no Main method). null when no rule
// matches and the language does not run from the top.
// References: C11 5.1.2.2.1 "Program startup" (main), JLS 12.1.4
// (public static void main), C# "Main() and command-line arguments" /
// top-level statements, Go spec "Program execution" (package main, func
// main), Rust Reference "Crates and source files" (fn main), Haskell 2010
// report 5 "Modules" (Main.main), Ada RM 10.2 (main subprogram), Pascal
// (program heading), COBOL (PROCEDURE DIVISION), Fortran (PROGRAM),
// Kotlin "Basic syntax" (fun main), Swift "Attributes" (@main) and
// top-level code, Dart "The main() function", Scala 3 "Main methods"
// (@main def), F# "Explicit entry point" ([<EntryPoint>]), Zig "Hello
// World" (pub fn main), Erlang escript (main/1), Clojure "gen-class"
// (-main), Racket guide "Main and Test Submodules", VB.NET Sub Main,
// Prolog initialization/1 directive, Ruby "__FILE__ == $0", Simula and
// ALGOL 68 (a program is a block).
const TOP = { top: true };
const ENTRY = {
  byLanguage: {
    prolog: { '.pl': { rule: /initialization\(\s*main/ } },
    perl: { '.pl': TOP },
    typescript: { '.ts': TOP },
  },
  byExt: {
    '.c': { rule: /\bint\s+main\s*\(/ }, '.cpp': { rule: /\bint\s+main\s*\(/ },
    '.java': { rule: /\bstatic\s+void\s+main\s*\(/ }, '.cs': { rule: /\bstatic\b.*\bMain\s*\(/, top: true },
    '.go': { rule: /^func main\s*\(/ }, '.rs': { rule: /^\s*(async\s+)?fn main\s*\(/ },
    '.hs': { rule: /^main\s*(::|=)/ }, '.adb': { rule: /^procedure\s+\w+/i },
    '.pas': { rule: /^program\s+\w+/i }, '.dpr': { rule: /^program\s+\w+/i },
    '.cob': { rule: /PROCEDURE\s+DIVISION/i },
    '.f90': { rule: /^\s*program\s+\w+/i }, '.asm': { rule: /^\s*_main\s*:/ },
    '.lisp': { rule: /\(defun\s+main\b/i, top: true },
    '.prg': { rule: /^\s*(PROCEDURE|FUNCTION)\s+Main\b/i },
    '.alg': { rule: /^\s*inicio\b/i }, '.psc': { rule: /^\s*Algoritmo\b/i },
    '.py': { rule: /^if\s+__name__\s*==\s*["']__main__["']/, top: true },
    '.js': TOP, '.mjs': TOP, '.php': TOP, '.bas': TOP,
    '.rb': { rule: /^if\s+__FILE__\s*==\s*\$(0|PROGRAM_NAME)/, top: true },
    '.ru': TOP, '.pm': TOP, '.lua': TOP, '.jl': TOP, '.r': TOP, '.sh': TOP, '.exs': TOP,
    '.st': TOP, '.qcl': TOP, '.ml': { rule: /^let\s+\(\)\s*=/, top: true },
    '.kt': { rule: /^\s*fun\s+main\s*\(/ }, '.swift': { rule: /^@main\b/, top: true },
    '.m': { rule: /\bint\s+main\s*\(/ }, '.dart': { rule: /^\s*(void\s+|Future<void>\s+)?main\s*\(/ },
    '.scala': { rule: /(@main\s+def\s+\w+|\bdef\s+main\s*\()/ },
    '.fs': { rule: /\[<EntryPoint>\]/, top: true }, '.fsx': TOP,
    '.zig': { rule: /^pub\s+fn\s+main\s*\(/ }, '.erl': { rule: /^main\s*\(/ },
    '.clj': { rule: /\(defn\s+-main\b/, top: true },
    '.rkt': { rule: /\(module\+\s+main\b/, top: true },
    '.vb': { rule: /\bSub\s+Main\s*\(/i },
    '.sim': { rule: /^\s*begin\b/i }, '.a68': { rule: /^\s*(BEGIN\b|\()/ },
  },
};

export function entryPoint(text, file, lang) {
  const { rule, top } = lookup(ENTRY, file, lang) || {};
  const hit = rule && classify(text, file, lang).find((l) => l.kind === 'code' && rule.test(l.text));
  if (hit) return { n: hit.n, text: hit.text.trim() };
  return top ? { n: null, text: null, fromTop: true } : null;
}

// The text every Hello World program prints; it finds the line that does
// the work and the file that holds it.
export const GREETING = 'Hello, World';

// mainFile(names, read, lang) -> the main source file of an implementation: the
// first file with a known comment syntax that contains the greeting,
// preferring a backend over a front end. `names` are paths relative to the
// implementation folder, `read(name)` returns a file's text. null when
// there is none (a README-only folder).
export function mainFile(names, read, lang) {
  const candidates = names.filter((f) => !isScript(f, lang) && hasCommentSyntax(f, lang) && read(f).includes(GREETING));
  return candidates.find((f) => !f.startsWith('frontend/')) || candidates[0] || null;
}
