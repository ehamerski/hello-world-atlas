# Clojure

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** functional, with built-in support for concurrency. Rich
Hickey's history of the language says that Clojure "was designed to be a
general-purpose, practical functional language, suitable for use by
professionals wherever its host language, e.g., Java, would be", and that it
"complements programming with pure functions of immutable data with
concurrency-safe state management constructs that support writing correct
multithreaded programs without the complexity of mutex locks" [1]. It is a
dialect of Lisp, so the code is written as lists, and it runs on a host: the
Java Virtual Machine (JVM) in this repository [1].

See also: [paradigms](../../docs/paradigms.md#functional)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Clojure CLI 1.12.6.1673 | ✅ |
| desktop | [desktop/](desktop/) | Swing via Java interop, Clojure CLI | ✅ |
| web | [web/](web/) | Ring + Jetty, Clojure CLI | ✅ |

None of the three folders has a `build.sh`. Clojure is compiled, but the
compiler runs when the program loads; the reason is in the
[cli README](cli/README.md#why-there-is-no-buildsh).

## History
**Who and why.** Rich Hickey wrote the language. He had worked as a
commercial developer since 1987, "first in C++, then Java and C#", and then
used Common Lisp for two systems [1]. Of that experience he wrote: "It was
a revelation. Huge layers of unnecessary complexity simply vanished" [1].
In the first of the two systems, the program "had to be rewritten in C++ in
order to be acceptable for deployment", and in the second "Common Lisp was
not acceptable for deployment" either [1]. The
objective for Clojure, in his words: "I wanted a language as acceptable as
Java or C#, but supporting a much simpler programming model, to use for the
kinds of information system development I had been doing professionally"
[1]. The clojure.org rationale puts it as a wish for "A Lisp for Functional
Programming symbiotic with an established Platform designed for Concurrency"
[2].

**When and where.** "I started working on Clojure in 2005, during a
sabbatical I funded out of retirement savings" [1]. He announced it on
2007-10-17 to the members of a mailing list, as "Clojure, a dialect of Lisp
for the JVM. It’s currently alpha, but fairly complete" [1], and "announced
and released the first version of Clojure, as an open source project, in the
fall of 2007" [1]. He did "100% of the implementation work" until the
release, and "more than 90% through the 1.2 release in 2010" [1]. After
that the community contributed, and the author is accepted as "benevolent
dictator for life" [1].

**What kind of Lisp.** The abstract of the paper says that "Clojure is a
dialect of Lisp, but is not a direct descendant of any prior Lisp" [1]. The
rationale lists what it keeps (code as data, little syntax, a small core)
and what it changes: for the standard Lisps it lists "Core data structures mutable, not
extensible" and "No concurrency in specs" [2].
Clojure uses immutable, persistent data structures and offers built-in
concurrency support, "software transactional memory and asynchronous
agents" [2].

**Hosted.** Clojure "is intentionally hosted, in that it compiles to and
runs on the runtime of another language, such as the JVM" [1]. On the JVM,
"Clojure is always compiled (on the JVM, to Java bytecode), there is no
interpreter" [1]. Programs call Java libraries directly. The
[desktop](desktop/) version uses Swing this way, and the [web](web/) version
runs on Jetty, a Java web server.

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 2005 | Rich Hickey starts the work on a self-funded sabbatical | [1] |
| 2007-10-17 | First announcement: "Clojure, a dialect of Lisp for the JVM", at the alpha stage | [1] |
| 2009-05 | Clojure 1.0; the first book on Clojure appears at the same time | [1] |
| 2009-12 | Clojure 1.1: chunked sequences and transients | [1] |
| 2010 | First annual survey of the Clojure community (487 respondents); Clojure 1.2 adds protocols, `reify`, `deftype`, and `defrecord` | [1] |
| 2011 | ClojureScript, an implementation of Clojure that runs on JavaScript engines | [1] |
| 2013 | Cognitect is formed and becomes "the de facto corporate sponsor of Clojure" | [1] |
| 2015-06 | Clojure 1.7: reader conditionals and transducers | [1][3] |
| 2020-06 | Hickey's "A History of Clojure" is published for the fourth conference on the History of Programming Languages (HOPL IV) | [1][4] |
| 2024-09 | Clojure 1.12.0: new Java interop, among other features (qualified methods such as `Class/method`, functional interface conversion) | [3][5] |
| 2026-09-02 | Clojure 1.12.6, the stable release at the time of writing, with Java 25 recommended and Java 8 the minimum | [6] |

The paper dates Clojure 1.0 to "May of 2009" [1], while the "Older
Downloads" page of clojure.org lists "Clojure 1.0.0 (Jul, 2009)" [3]. This
page follows the author's account and notes the difference.

## Market usage today
Every number below has its date and source. They change every year.

- **Stack Overflow Developer Survey 2026:** 1.3% of all respondents to the
  programming languages question have done extensive development work in
  Clojure over the past year (187 of 14,099) [7]. In the same survey,
  48.7% of the respondents who have used Clojure want to keep using it
  ("admired"), and 2.5% of all respondents want to use it next year
  ("desired") [7].
- **TIOBE Index, October 2026:** Clojure is not in the top 50. TIOBE lists
  it only by name, in alphabetical order, among the languages ranked 51
  to 100 [8].
- **State of Clojure 2025 survey (results published 2026-02-18):**
  respondents came from 80 countries, and about two thirds use Clojure as
  their primary language. Work use (71%) leads, and 52% use it for hobby
  projects. Financial services, enterprise software, and healthcare are the
  top industries [9]. 70% of the respondents "said they were very likely to
  recommend Clojure" [9].
- **Earlier survey, 2019:** 2,461 respondents; 60% of the Clojure shops
  also used ClojureScript [1]. The paper adds that "Clojure is in
  production at hundreds of companies" [1].

The State of Clojure survey asks Clojure users, so its respondents are not
a sample of all programmers [9]. For the whole profession, the Stack
Overflow figure is the better guide.

## Importance then and now
- **Then (2005–2009):** the author wrote that "the year 2005 may have
  represented the nadir of language diversity in commercial software
  development", with many businesses "considering themselves either Java or
  .Net ‘shops’" [1]. Advice from professional developers was that Lisp was
  "it’s dead", functional programming was "what’s that?", and writing a new
  language was "you’re crazy" [1]. Clojure answered with a Lisp that runs on
  the platform those businesses already approved, the JVM, "with
  immutable persistent data structures" and built-in concurrency [2]. The
  rationale says "pervasive, unmoderated mutation simply has to go" for the
  concurrent future [2].
- **Now:** Clojure remains a small language by usage (1.3% in the Stack
  Overflow 2026 survey, outside the TIOBE top 50) [7][8], with a loyal
  community: 48.7% of its users in the Stack Overflow survey would use it
  again [7], and the 2025 community survey shows work use as the leading
  purpose [9]. The abstract of the paper lists adoption "in industries as
  diverse as finance, climate science, retail, databases, analytics,
  publishing, healthcare, advertising and genomics" [1]. The language is
  still developed: 1.12.6 is the stable release, and 1.13 pre-releases
  are published [6].
- **In teaching:** a Clojure Hello World is a namespace and one function.
  Compare the Java version of the [cli](../java/cli/) program, which needs a
  class and a `public static void main` before the first line of output.

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Lines of Clojure (no comments, no blank lines; the `ns` form counts) | 3 | 25 (9 are the self-check) | 9 |
| Library | none (`println`) | Swing (in the JDK), through interop | Ring 1.15.6 + Jetty 12.1.14 |
| `deps.edn` `:deps` | empty | empty | `ring/ring-core`, `ring/ring-jetty-adapter` |
| Entry point | `-main` prints and returns | `-main` calls `invokeLater`; the window is built on the event dispatch thread | `-main` calls `run-jetty`, which blocks |
| Build output | none; the code is compiled in memory | none | none |
| How it runs | `clojure -M -m hello.core` | the same | the same, serves until Ctrl+C |
| Output | text on stdout | a native window | HTML from the server |
| Extra install | none | none | none (the CLI downloads Ring and Jetty) |

What stays the same: every version is a `deps.edn` project with the code in
`src/hello/core.clj`, started by `clojure -M -m hello.core`. No version has a
`build.sh` or a `target/` folder; only the CLI's `.cpcache/` appears. Compare
[Java](../java/README.md#comparing-the-categories), where each version is a
Maven project that `javac` compiles first.

What differs is the library and which code runs the main loop. The cli runs
`-main` and ends. In the desktop version, Swing's event dispatch thread waits
for window events. In the web version, Jetty waits for HTTP requests. The
Clojure part also changes in style. The cli is one call. The desktop version
is mostly Java interop (`(JFrame. ...)`, `(.pack frame)`), so it reads like
the [Java version](../java/desktop-swing/) with the parentheses moved. The web
version is the most Clojure-like: the handler is a function that returns a
map, as the Ring specification defines it [10].

All three categories are implemented for Clojure, so the page has no "why
no category" section.

## Sources
1. A History of Clojure. Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, Article 71, June 2020 (author's PDF as linked from clojure.org/about/history; Internet Archive copy, because download.clojure.org redirects to dl.acm.org, which refuses automated downloads). <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (accessed 2026-11-04). The published version: <https://doi.org/10.1145/3386321>.
2. Rationale. Rich Hickey, clojure.org. <https://clojure.org/about/rationale> (accessed 2026-11-04)
3. Older Downloads (release dates of Clojure 1.0.0 to 1.12.x). clojure.org. <https://clojure.org/releases/downloads_older> (accessed 2026-11-04)
4. History. clojure.org (about the HOPL IV paper). <https://clojure.org/about/history> (accessed 2026-11-04)
5. Changes to Clojure in Version 1.12.0. Clojure core team, GitHub. <https://github.com/clojure/clojure/blob/master/changes.md> (accessed 2026-11-04)
6. Clojure Downloads (stable release 1.12.6, Sep 2, 2026; development release 1.13.0-alpha11; Java recommendation). clojure.org. <https://clojure.org/releases/downloads> (accessed 2026-11-04)
7. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
9. State of Clojure 2025 Results. Christoph Neumann, clojure.org, 2026-02-18. <https://clojure.org/news/2026/02/18/state-of-clojure-2025> (accessed 2026-11-04)
10. The Ring Specification (SPEC.md). ring-clojure, GitHub. <https://github.com/ring-clojure/ring/blob/master/SPEC.md> (accessed 2026-11-04)
