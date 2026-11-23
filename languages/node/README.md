# Node.js (JavaScript)

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm, event-driven. Node.js is a *runtime*, not a
language: it runs **JavaScript**, whose standard (ECMA-262) says
"ECMAScript is an object-oriented programming language" and "ECMAScript is
object-based: basic language and host facilities are provided by objects"
[1]. Its objects "are not fundamentally class-based such as those in C++,
Smalltalk, or Java" [1]: they inherit from other objects (prototypes). A
Hello World needs no class and no `main` function, as in
[Python](../python/README.md). Node.js adds the event-driven part: it is
"an asynchronous event-driven JavaScript runtime" [2], and the
[web](web/) and [desktop](desktop/) versions only register functions that
are called later, when events happen.

See also: [paradigms](../../docs/paradigms.md#every-language-and-its-paradigm) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Node.js | ✅ |
| desktop | [desktop/](desktop/) | Electron | ✅ |
| web | [web/](web/) | Express | ✅ |

## History
**JavaScript** came first. The ECMAScript standard says: "The language was
invented by Brendan Eich at Netscape and first appeared in that company's
Navigator 2.0 browser" [1]. Eich wrote in 2008 that "Mocha", its first
name, "had proven itself via rapid prototyping and embedding in Netscape
Navigator 2.0" [3]. To make it a standard shared by all browsers, Ecma
International adopted the first edition of ECMA-262 in June 1997 [1][4].
The 17th edition, ECMAScript 2026, was published in June 2026 [4].

**Node.js** runs JavaScript outside the browser, as an ordinary program
on your computer. Its repository starts with two commits by
Ryan Dahl on 2009-02-16, "add dependencies" and "add readme and initial
code" [5]. Node.js is built on V8, Google Chrome's JavaScript engine [6],
and was designed around events instead of threads: "users of Node.js are
free from worries of dead-locking the process, since there are no locks",
and it was "influenced by, systems like Ruby's Event Machine and Python's
Twisted" [2].

**npm**, the package manager installed with Node.js, followed the same
year: "npm was created by Isaac Z. Schlueter in 2009" [7]. The [web](web/)
and [desktop](desktop/) versions use it to download Express and Electron.

In 2015 the project was split in two and then reunited. A fork called
**io.js** "inherits the majority of the changes found in the v0.11 branch
of the joyent/node repository" [8]. In May 2015 "the io.js TC voted to join
in the Foundation effort" [9], and Node.js 4.0.0 (2015-09-08) "represents
countless hours of hard work encapsulated in both the Node.js project and
the io.js project that are now combined in a single codebase" [10], under
the new Node.js Foundation [11]. In 2019 "The Node.js Foundation and the JS
Foundation ... announced they are merging to form the OpenJS Foundation"
[12], which hosts Node.js, Express and Electron today [13].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1995 | Brendan Eich, who was "studying Java in April and May 1995", creates JavaScript ("Mocha") at Netscape; it first appears in Navigator 2.0 | [1][3] |
| 1997-06 | ECMA-262, 1st edition: JavaScript becomes the ECMAScript standard | [1][4] |
| 2009-02-16 | First commits of Node.js, by Ryan Dahl | [5] |
| 2009-09-29 | First commit of npm, by Isaac Z. Schlueter | [7][14] |
| 2015-06-16 | Node.js Foundation: "The Node.js and io.js Technical Committees are merging" | [11] |
| 2015-09-08 | Node.js 4.0.0: Node.js and io.js combined in a single codebase | [10] |
| 2015-10-12 | Node.js 4.2.0 "Argon", "the first release covered under the new Long Term Support plan" | [15] |
| 2019-03-12 | Node.js Foundation and JS Foundation merge into the OpenJS Foundation | [12] |
| 2019-11-21 | Node.js 13.2.0 removes the `--experimental-modules` flag: ES modules (`import`) without a flag | [16] |
| 2024-12-03 | Node.js 22.12.0: "require(esm) is now enabled by default" | [17] |
| 2025-11-11 | Node.js 25.2.0: TypeScript "type stripping" marked stable (`node file.ts` runs TypeScript) | [18] |
| 2026-10-28 | **Node.js 26 (used here) becomes LTS**, codename "Lithium", supported to April 2029 | [19][20] |

From Node.js 27 on, the schedule changes: "the release cycle will be
annual and every major version will move to LTS status after its
six-month Current phase" [20]. Until Node.js 26, only even-numbered
versions became LTS [20], and "Production applications should only use
Active LTS or Maintenance LTS releases" [20].

## Market usage today
Every number below has its date and source. They change every year.

- **Stack Overflow Developer Survey 2026:** JavaScript was used by 62.0%
  of all respondents to the programming languages question (8,742 of
  14,099), "at the top of the list for 12th year in a row"; TypeScript
  by 43.8% [21]. In the web frameworks and
  technologies question, Node.js was used by 46.4% (4,769 of 10,281); the
  survey sums it up as "46% have used Node and 42% have used React" [21]. 46.1% of Node.js
  users want to keep using it ("admired") [21].
- **TIOBE Index, October 2026:** JavaScript is #6 with a rating of 2.77%,
  the same position as in October 2025 [22].
- **Where it is used:** Node.js runs servers such as the [web](web/)
  version; Electron, built on Node.js, is used by desktop applications
  such as VS Code, Slack, Discord, and Figma, according to Electron's own
  list [23]. That list is a project testimonial, not an independent survey.

## Importance then and now
- **Then (2009):** JavaScript was the language of the browser. Node.js let
  the same language run servers and command-line tools, built around
  events instead of blocking calls: "Almost no
  function in Node.js directly performs I/O, so the process never blocks
  except when the I/O is performed using synchronous methods" [2].
- **npm** turned that into an ecosystem: one command installs a library
  into the project's own `node_modules/` folder, as the [web](web/) and
  [desktop](desktop/) versions show.
- **Now:** JavaScript is the most used language in the Stack Overflow
  survey for the 12th year in a row, and 46.4% of respondents used
  Node.js (2026) [21]. The same language now runs in the
  browser, on the server (Express), and on the desktop (Electron).
- **In teaching:** the `cli` Hello World is one line, like Python's. The
  other two versions show early what most JavaScript code looks like:
  callbacks, events, and Promises instead of a program that runs from top
  to bottom and stops.

## Comparing the categories
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Lines of JavaScript (no comments, no blank lines) | 1 | 32 (14 are the self-check) + `index.html` | 12 |
| Library | none (`console` is global) | Electron 45.2.1 | Express 5.3.0 |
| `package.json` / `node_modules/` | none | yes / about 284 MB (almost all the Electron program) | yes / about 3.8 MB (Express and 64 packages it needs) |
| Which Node.js runs the code | the installed `node` (26.8.2) | **Electron's own** Node.js 24.22.1, plus Chromium 156 for the page | the installed `node` (26.8.2) |
| Build step | none | none (packaging with Electron Forge is optional) | none |
| Who owns the loop | Node.js: nothing is scheduled, so it exits after `console.log` | Electron's event loop (window events) | Node.js's event loop, kept alive by the listening server |
| Output | text on stdout | a window with an HTML page | HTML from the server |

Sizes from `du -sh` and versions from `process.versions` on macOS Intel
(2026-10-31).

What stays the same: no version has a compile step, every version is
JavaScript run by V8, and the code is written as functions that Node.js
(or Electron) calls. What changes is what is installed next to the code:
nothing for `cli`, a small framework for `web`, and a whole browser engine
for `desktop`. Compare [Go](../go/README.md), where every category is compiled
into one executable, and [Python](../python/README.md), whose desktop
toolkit (`tkinter`) ships with the language.

Node.js has an implementation in each of its three categories (the
desktop version uses Electron; see
[desktop/README.md](desktop/README.md#why-this-toolchain)), so this page
has no section that explains a missing category.

## Sources
1. ECMAScript Language Specification (Introduction; Overview). Ecma TC39. <https://tc39.es/ecma262/> (accessed 2026-10-31)
2. About Node.js. OpenJS Foundation. <https://nodejs.org/en/about> (accessed 2026-10-31)
3. Popularity. Brendan Eich, 2008-04-03. <https://brendaneich.com/2008/04/popularity/> (accessed 2026-10-31)
4. ECMA-262 (editions list). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-262/> (accessed 2026-10-31)
5. Commit 9d7895c ("add dependencies"), 2009-02-16, and the commit history of nodejs/node. GitHub. <https://github.com/nodejs/node/commit/9d7895c567e8f38abfff35da1b6d6d6a0a06f9aa> (accessed 2026-10-31)
6. V8 JavaScript engine (home page). The V8 Project Authors. <https://v8.dev/> (accessed 2026-10-31)
7. "npm, Inc. and Scalenpm". npm Blog, 2014-09-11. <https://blog.npmjs.org/post/97261727560/npm-inc-and-scalenpm.html> (accessed 2026-10-31)
8. io.js changelog. nodejs/node (GitHub). <https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_IOJS.md> (accessed 2026-10-31)
9. Node.js and io.js leaders are building an open, neutral Node.js Foundation to support the future of the platform. Mike Dolan, Node.js Blog, 2015-05-15. <https://nodejs.org/en/blog/community/node-leaders-building-open-neutral-foundation> (accessed 2026-10-31)
10. Node.js 4.0.0 (Current). Node.js Blog, 2015-09-08. <https://nodejs.org/en/blog/release/v4.0.0> (accessed 2026-10-31)
11. Node.js Foundation Advances Community Collaboration, Announces New Members and Ratified Technical Governance. The Linux Foundation, 2015-06-16. <https://www.linuxfoundation.org/press-release/node-js-foundation-advances-community-collaboration-announces-new-members-and-ratified-technical-governance> (accessed 2026-10-31)
12. Node.js Foundation and JS Foundation Merge to Form OpenJS Foundation. The Linux Foundation, 2019-03-12. <https://www.linuxfoundation.org/press/press-release/node-js-foundation-and-js-foundation-merge-to-form-openjs-foundation> (accessed 2026-10-31)
13. Projects. OpenJS Foundation. <https://openjsf.org/projects> (accessed 2026-10-31)
14. Commit 4626dfa ("Initial drop."), 2009-09-29. npm/cli (GitHub). <https://github.com/npm/cli/commit/4626dfa73b7847e9c42c1f799935f8242794d020> (accessed 2026-10-31)
15. Node.js 4.2.0 (LTS). Node.js Blog, 2015-10-12. <https://nodejs.org/en/blog/release/v4.2.0> (accessed 2026-10-31)
16. Node.js 13.2.0 (Current). Node.js Blog, 2019-11-21. <https://nodejs.org/en/blog/release/v13.2.0> (accessed 2026-10-31)
17. Node.js 22.12.0 (LTS). Node.js Blog, 2024-12-03. <https://nodejs.org/en/blog/release/v22.12.0> (accessed 2026-10-31)
18. Node.js 25.2.0 (Current). Node.js Blog, 2025-11-11. <https://nodejs.org/en/blog/release/v25.2.0> ; Modules: TypeScript (history). Node.js Documentation. <https://nodejs.org/api/typescript.html> (accessed 2026-10-31)
19. Node.js 26.13.0 (LTS). Node.js Blog, 2026-10-28. <https://nodejs.org/en/blog/release/v26.13.0> (accessed 2026-10-31)
20. Node.js Releases. OpenJS Foundation. <https://nodejs.org/en/about/previous-releases> and Node.js Release Working Group schedule. <https://github.com/nodejs/Release> (accessed 2026-10-31)
21. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
22. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-10-31)
23. Electron home page ("Apps users love, built with Electron"). Electron. <https://www.electronjs.org/> (accessed 2026-10-31)
