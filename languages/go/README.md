# Go

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative, with built-in concurrency. The specification
calls Go "a general-purpose language designed with systems programming in
mind. It is strongly typed and garbage-collected and has explicit support
for concurrent programming" [1]. On the question whether Go is
object-oriented, the FAQ answers:
"Yes and no. Although Go has types and methods and allows an
object-oriented style of programming, there is no type hierarchy" [2].
There are no classes: compare the [Java](../java/README.md) versions,
where even a one-line program needs one. The
[desktop](desktop/) version uses Go's concurrency once, with a goroutine.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Go toolchain | ✅ |
| desktop | [desktop/](desktop/) | Fyne | ✅ |
| web | [web/](web/) | `net/http` + `html/template` (standard library) | ✅ |
| web + separate front end | [web-vue/](web-vue/) | Go API + Vue (Vite) | ✅ |

## History
Go was designed at Google. The FAQ gives the exact date of its start: "Robert
Griesemer, Rob Pike and Ken Thompson started sketching the goals for a new
language on the white board on September 21, 2007" [2]. "By January 2008,
Ken had started work on a compiler with which to explore ideas; it
generated C code as its output." In May 2008 Ian Taylor started a GCC front
end for Go, and "Russ Cox joined in late 2008 and helped move the language
and libraries from prototype to reality" [2].

The FAQ gives the reason for a new language: "Go was born out of frustration with existing
languages and environments for the work we were doing at Google. ... One
had to choose either efficient compilation, efficient execution, or ease of
programming; all three were not available in the same mainstream
language" [2]. Rob Pike's 2012 keynote states: "Go is a
programming language designed by Google to help solve Google's problems,
and Google has big problems", and among those problems it lists "slow
builds" and "uncontrolled dependencies" [3].

"Go became a public open source project on November 10, 2009" [2]. That
day the Google Open Source Blog announced "an experimental new language
called Go" [4]. Go 1 followed on March 28, 2012, defining "a language and
a set of core libraries to provide a stable foundation for creating
reliable products, projects, and publications" [5]. Its compatibility
promise still holds: "programs written to the Go 1 specification will
continue to compile and run correctly, unchanged, over the lifetime of that
specification" [6]. For this reason, every release since then has a 1.x
version number [7].

Go compiles to native machine code, and "the linker in the gc toolchain
creates statically-linked binaries by default" [2]. Every program still
carries a runtime, which "implements garbage collection, concurrency, stack
management, and other critical features", but "Go's runtime does not
include a virtual machine, such as is provided by the Java runtime" [2].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 2007-09-21 | Griesemer, Pike, and Thompson sketch the goals of the language on a whiteboard | [2] |
| 2008-01 | Ken Thompson starts the first compiler (it generated C code) | [2] |
| 2009-11-10 | Go becomes an open source project | [2][4] |
| 2012-03-28 | Go 1: a stable language and standard library, with the Go 1 compatibility promise | [5][6][7] |
| 2015-08-19 | Go 1.5: "The compiler and runtime are now written entirely in Go (with a little assembler)" | [7][8] |
| 2018-08-24 | Go 1.11: "preliminary support for a new concept called "modules"" | [7][9] |
| 2021-02-16 | Go 1.16: module-aware mode on by default; `//go:embed` | [7][10] |
| 2022-03-15 | Go 1.18: generics ("an implementation of generic features as described by the Type Parameters Proposal") | [7][11] |
| 2023-08-08 | Go 1.21: the `go` line in `go.mod` becomes a requirement, not advice | [7][12] |
| 2024-02-06 | **Go 1.22, the minimum used in this repository**: method and wildcard patterns in `net/http`'s router | [7][13] |
| 2026-08-19 | Go 1.27, the newest major release on 2026-10-31 (1.27.3 on 2026-10-19) | [7] |

Go has no long-term support releases: "Each major Go release is supported
until there are two newer major releases" [7]. Recent major releases came
out in February and August: Go 1.25 on 2025-08-12, Go 1.26 on 2026-02-10,
and Go 1.27 on 2026-08-19 [7].

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Go is #11 with a rating of 1.39%. It was
  #8 in October 2025 [14]. TIOBE notes that it added Mandarin search terms
  that month, so compare rankings across months with care [14].
- **Stack Overflow Developer Survey 2026:** 16.5% of all respondents to the
  programming languages question used Go (2,332 of 14,099) [15]. Of those who
  used it, 49.5% want to keep using it ("admired"); 17.7% of all
  respondents want to use it ("desired") [15]. In the web frameworks
  question, 17.2% used Vue.js (base 10,281) [15].
- **Where Go is used:** "Go is used widely in production inside Google",
  and "a couple of major cloud infrastructure projects written in Go are
  Docker and Kubernetes, but there are many more" (a statement by the Go
  team in its FAQ) [2]. Go's case-studies page lists companies such as
  American Express, Cloudflare, Dropbox, Microsoft, Monzo, Netflix, PayPal,
  Twitch, and Uber [16]; ByteDance says "70% of microservices within
  ByteDance are written by Go" [16]. These are company testimonials
  collected by the Go project, not independent measurements.

## Importance then and now
- **Then (2007–2012):** Go was a reaction to slow builds and complex
  languages at Google. Its authors wanted "the efficiency, the safety, and
  the fluidity in a single language" [2]. Go "addressed these issues by
  attempting to combine the ease of programming of an interpreted,
  dynamically typed language with the efficiency and safety of a statically
  typed, compiled language", with "support for networked and multicore
  computing" [2].
- **Stability:** since 2012 the Go 1 promise has kept old programs
  compiling [6]. Code from this repository written for Go 1.22 builds
  unchanged with Go 1.27.
- **Now:** Go is a language of networked services and cloud
  infrastructure (Docker and Kubernetes, per the FAQ [2]). It was used by
  16.5% of Stack Overflow's 2026 respondents [15] and is #11 in TIOBE
  (October 2026) [14].
- **In teaching:** a Go Hello World is a package clause, an import, and a
  `main` function: shorter than Java, longer than Python. The language is strict
  in ways that help beginners spot mistakes early: "Go refuses to compile
  programs with unused variables or imports" [2], and `gofmt` gives all Go
  code one layout [17].

## Comparing the categories
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) | [`web-vue`](web-vue/) |
|---|---|---|---|---|
| Lines of Go (no comments, no blank lines) | 5 | 27 (9 are the self-check) | 23 | 25 (+ 26 lines of Vue/JavaScript) |
| Library | `fmt` (standard library) | Fyne v2.8.2 (downloaded) | `net/http`, `html/template` (standard library) | `net/http`, `encoding/json` + Vue 3.5, Vite 8 |
| Needs a C compiler (cgo) | no | **yes** | no | no |
| Downloaded Go modules (`go.sum`) | none | Fyne and its dependencies | none | none (npm installs the front end's packages) |
| Build output (`build.sh`) | `bin/hello-cli` (2.5 MB) | `bin/hello-desktop` (34.2 MB) | `bin/hello-web` (13.6 MB) | `backend/bin/hello-api` (10.0 MB) + `frontend/dist/` |
| First build on the test machine (macOS Intel) | a few seconds | about 55 s (Fyne's C code) | a few seconds | a few seconds (Go + Vite) |
| Who owns the loop | nobody: `main` prints and returns | Fyne's event loop (`ShowAndRun`) | `http.ListenAndServe` | the Go server, and Vue in the browser |
| Output | text on stdout | a native window | HTML from the server | JSON from the server; HTML drawn by Vue |

Executable sizes are from `ls -l` on macOS Intel with Go 1.27.3 (2026-10-31).
They show what static linking means: each executable contains its whole
runtime and every package it uses, and the desktop one contains Fyne too.

What stays the same: every folder is a Go module with a `go.mod` and a
`main.go` at its root, and every `build.sh` runs `go build -o bin/<name> .`.
The result is always one native executable that runs without Go installed.
Compare [Java](../java/README.md), where every version needs a JVM at run
time, and [Python](../python/README.md), which has no build step.

Go has an implementation in each of its four categories, so this page has
no section that explains a missing category.


## Sources
1. The Go Programming Language Specification (Introduction). The Go Authors. <https://go.dev/ref/spec> (accessed 2026-10-31)
2. Frequently Asked Questions (FAQ). The Go Authors. <https://go.dev/doc/faq> (accessed 2026-10-31)
3. Go at Google: Language Design in the Service of Software Engineering. Rob Pike, SPLASH 2012 keynote (2012-10-25). <https://go.dev/talks/2012/splash.article> (accessed 2026-10-31)
4. Hey! Ho! Let's Go!. Google Open Source Blog, 2009-11-10. <https://opensource.googleblog.com/2009/11/hey-ho-lets-go.html> (accessed 2026-10-31)
5. Go version 1 is released. Andrew Gerrand, The Go Blog, 2012-03-28. <https://go.dev/blog/go1> (accessed 2026-10-31)
6. Go 1 and the Future of Go Programs. The Go Authors. <https://go.dev/doc/go1compat> (accessed 2026-10-31)
7. Release History. The Go Authors. <https://go.dev/doc/devel/release> (accessed 2026-10-31)
8. Go 1.5 Release Notes. The Go Authors. <https://go.dev/doc/go1.5> (accessed 2026-10-31)
9. Go 1.11 Release Notes. The Go Authors. <https://go.dev/doc/go1.11> (accessed 2026-10-31)
10. Go 1.16 Release Notes. The Go Authors. <https://go.dev/doc/go1.16> (accessed 2026-10-31)
11. Go 1.18 Release Notes. The Go Authors. <https://go.dev/doc/go1.18> (accessed 2026-10-31)
12. Go Modules Reference (go directive). The Go Authors. <https://go.dev/ref/mod#go-mod-file-go> (accessed 2026-10-31)
13. Routing Enhancements for Go 1.22. Jonathan Amsterdam, The Go Blog, 2024-02-13. <https://go.dev/blog/routing-enhancements> (accessed 2026-10-31)
14. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-10-31)
15. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
16. Case Studies. The Go Authors. <https://go.dev/solutions/case-studies> (accessed 2026-10-31)
17. Effective Go (Formatting). The Go Authors. <https://go.dev/doc/effective_go#formatting> (accessed 2026-10-31)
