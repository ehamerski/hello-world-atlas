# TypeScript

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm, object-oriented. JavaScript is described by
its standard as "an object-oriented programming language" [2], and
TypeScript programs can mix objects, functions, and plain statements in the
same way. On top of JavaScript, TypeScript adds optional static type
checking: its creators call it "a superset of JavaScript that combines type
checking and static analysis, explicit interfaces, and best practices into a
single language and compiler", and "types are optional" [1]. A Hello World needs no class and no `main` function, as in
[Node.js](../node/README.md).

See also: [paradigms](../../docs/paradigms.md#every-language-and-its-paradigm)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with
the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Node.js + TypeScript 7.0.2 (`tsc`) | ✅ |
| web | [web/](web/) | Node.js + TypeScript 7.0.2 (`tsc`), `node:http` | ✅ |

## History
TypeScript was announced on 2012-10-01 by Microsoft. The announcement
describes "a new programming language that solves a very specific problem
– getting JavaScript development to scale" and links to an "early preview"
download, the language specification, and the source of the compiler [1].
The compiler was published under the Apache 2.0 license, and the language
specification under the Open Web Foundation Final Specification Agreement
[1]. Anders Hejlsberg presented the language in the introductory video
that the announcement links [1]. Hejlsberg is a "Microsoft Technical
Fellow and lead architect of TypeScript" [3].

The design goal was that "all JavaScript code is already TypeScript
code": types are optional, and the compiler erases the annotations and
writes standard JavaScript [1]. TypeScript 1.0 followed on 2014-04-02 [4].
Version 2.0 (2016-09-22) added the `--strictNullChecks` mode, which is
opt-in because it breaks existing code [5]. Version 5.0 appeared on
2023-03-16 [6].

On 2025-03-11 Hejlsberg announced "a native port of the TypeScript
compiler and tools", with the goal of cutting most build times by "10x"
[3]. TypeScript 6.0 (2026-03-23) was "the last release based on the
current JavaScript codebase" [7]. TypeScript 7.0 (2026-07-08) is the native
version, written in Go, and it provides the `tsc` command [8].

Node.js can run TypeScript files without a compiler since type stripping
arrived in v22.6.0. Type stripping replaces the type syntax with
whitespace and does no type checking [9].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 2012-10-01 | Microsoft announces TypeScript with an early preview, the language specification, and the compiler source | [1] |
| 2014-04-02 | TypeScript 1.0 | [4] |
| 2016-09-22 | TypeScript 2.0: `--strictNullChecks` | [5] |
| 2023-03-16 | TypeScript 5.0 | [6] |
| 2025-03-11 | Anders Hejlsberg announces the native port of the compiler | [3] |
| 2025-11-11 | Node.js 25.2.0: type stripping is stable (also in 24.12.0) | [9][13] |
| 2026-03-23 | TypeScript 6.0, the last release on the JavaScript codebase | [7] |
| 2026-07-08 | **TypeScript 7.0 (used here)**: native compiler, `tsc` | [8] |

## Market usage today
Every number below has its year and source. They change every year.

- **Stack Overflow Developer Survey 2026:** 43.8% of all respondents used
  TypeScript (6,171 of 14,099) in the programming languages question.
  JavaScript was used by 62.0% [10].
- **TIOBE Index, November 2026:** TypeScript is ranked 41st with a rating
  of 0.26% [11].

## Importance then and now
- **Then (2012):** JavaScript left the browser, and "applications of
  unprecedented size" were written in it [1]. TypeScript offered type
  checking and tooling for those programs without leaving JavaScript [1].
- **Now:** the TypeScript home page calls it "JavaScript with syntax for
  types" [12] and the Stack Overflow survey 2026 counts 43.8% of
  respondents as users [10]. The compiler itself moved to native code in
  version 7.0 [8].

## Comparing the categories
| | [`cli`](cli/) | [`web`](web/) |
|---|---|---|
| Lines of TypeScript (no comments, no blank lines) | 2 | 9 |
| Library | none (`console` is a Node.js global) | `node:http`, built into Node.js |
| Packages installed | `typescript`, `@types/node` | the same two |
| Build step | `tsc -p .` | `tsc -p .` |
| What Node.js runs | `build/hello.js` | `build/server.js` |
| Who owns the loop | nothing is scheduled, so the program exits after `console.log` | Node.js's event loop, kept alive by the listening server |
| Output | text on stdout | HTML from the server |

Each folder has its own `package.json`, lock file, and `node_modules/`
(34 MB on macOS Intel, measured with `du -sh` on 2026-11-11).

What stays the same: both versions have a compile step, both run as
JavaScript on Node.js, and both use the same compiler settings. Compare
[Node.js](../node/README.md), where no version has a compile step.

## Why there is no desktop version
TypeScript compiles to JavaScript [12], so a desktop window needs a
JavaScript framework such as Electron, which the
[Node.js desktop](../node/desktop/README.md) version already shows; a
TypeScript version would repeat it with an added compile step.

## Sources
1. TypeScript: JavaScript Development at Application Scale. Microsoft, 2012-10-01 (archive of an MSDN blog). <https://learn.microsoft.com/en-us/archive/blogs/somasegar/typescript-javascript-development-at-application-scale> (accessed 2026-11-11)
2. ECMAScript Language Specification (Overview). Ecma TC39. <https://tc39.es/ecma262/> (accessed 2026-11-11)
3. A 10x faster TypeScript. Anders Hejlsberg, TypeScript blog, 2025-03-11. <https://devblogs.microsoft.com/typescript/typescript-native-port/> (accessed 2026-11-11)
4. Announcing TypeScript 1.0. TypeScript blog, 2014-04-02. <https://devblogs.microsoft.com/typescript/announcing-typescript-1-0/> (accessed 2026-11-11)
5. Announcing TypeScript 2.0. TypeScript blog, 2016-09-22. <https://devblogs.microsoft.com/typescript/announcing-typescript-2-0/> (accessed 2026-11-11)
6. Announcing TypeScript 5.0. TypeScript blog, 2023-03-16. <https://devblogs.microsoft.com/typescript/announcing-typescript-5-0/> (accessed 2026-11-11)
7. Announcing TypeScript 6.0. TypeScript blog, 2026-03-23. <https://devblogs.microsoft.com/typescript/announcing-typescript-6-0/> (accessed 2026-11-11)
8. Announcing TypeScript 7.0. TypeScript blog, 2026-07-08. <https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/> (accessed 2026-11-11)
9. Modules: TypeScript. Node.js v26 Documentation. <https://nodejs.org/api/typescript.html> (accessed 2026-11-11)
10. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-11)
11. TIOBE Index for November 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-11)
12. TypeScript: JavaScript with syntax for types (home page). Microsoft. <https://www.typescriptlang.org/> (accessed 2026-11-11)
13. Node.js 25.2.0 (Current). Node.js Blog, 2025-11-11. <https://nodejs.org/en/blog/release/v25.2.0> (accessed 2026-11-11)
