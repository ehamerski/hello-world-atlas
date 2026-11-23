# Julia

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm. The Julia manual says the language combines features of imperative, functional, and object-oriented programming [1]. Its central feature is multiple dispatch: the compiler picks the method of a function from the types of all its arguments [2].

See also: [paradigms](../../docs/paradigms.md) (how the paradigms compare) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Julia 1.13.4 (official tarball, `julia --startup-file=no`) | ✅ |

## History
Four people designed Julia: Jeff Bezanson, Stefan Karpinski, Viral B. Shah, and Alan Edelman [3]. They worked on scientific computing and used Matlab, R, Python, C, and other languages. Their announcement says each language is "perfect for some aspects of the work and terrible for others", and that they wanted the speed of C together with the dynamism of Ruby [3].

Julia has been in development since 2009, and its authors announced a public release in February 2012 [2]. The announcement is dated 2012-02-14 [3]. It says the authors started "about two and a half years ago" [3].

The authors describe the design in the paper "Julia: A Fresh Approach to Numerical Computing" [2][4]. The paper names two ideas: multiple dispatch, and generic programming. It also names "just-in-time" (JIT) compilation with the LLVM compiler framework as part of the implementation [2]. The Julia manual states the same: the language uses JIT compilation, implemented with LLVM, and optionally ahead-of-time compilation [1].

Julia 1.0 was released in 2018. The announcement calls it "the culmination of nearly a decade of work" [5]. This repository uses Julia 1.13.4, the stable release that the Julia downloads page listed on 2026-11-20 (released 2026-11-13) [6]. The same page lists Julia 1.10.13 as the long-term support release [6].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 2009 | Julia is in development, as the authors report in their paper | [2] |
| 2012 | Public release announced: "Why We Created Julia", 2012-02-14 | [3] |
| 2014 | The paper "Julia: A Fresh Approach to Numerical Computing" is submitted to arXiv (2014-11-06) | [4] |
| 2017 | The paper appears in SIAM Review, volume 59, issue 1, pages 65–98 | [7] |
| 2018 | Julia 1.0 is released (2018-08-08) | [5] |
| 2026 | Julia 1.13.4 is released (2026-11-13) | [6] |

## Market usage today
- TIOBE Index, November 2026: Julia is in position 23, with a rating of 0.68 % [8]. The TIOBE headline of that month says Julia re-entered the top 20 in October 2026 and left it again in November [8].
- Stack Overflow Developer Survey 2026: 1.5 % of all respondents (211 of 14,099) named Julia among the languages they had done extensive development work in during the past year [9].

## Importance then and now
In 2012 the authors wanted one language that is as fast as C and as usable as the dynamic languages they used daily [3]. The paper states the goal: dynamic programs do not have to be slow, and one does not have to prototype in one language and rewrite in another for speed [2]. Today the manual describes Julia as a flexible dynamic language, appropriate for scientific and numerical computing, with performance comparable to traditional statically typed languages [1].

## Comparing the categories
Only the `cli` category exists: the official Julia tarball has no toolkit for windows and no web server, so `desktop` and `web` would need additional packages (see the two sections below). `hello.jl` has no build step: `julia` compiles each function the first time the program calls it, and then runs the program [1]. The `cli` folder shows how to install Julia from the official tarball and run the file. See [cli/README.md](cli/README.md).

## Why there is no desktop version
There is no desktop version because the standard library of Julia has no toolkit for windows. The manual lists the standard library modules, from `ArgTools` to `UUIDs`, and none is a graphical toolkit [10]. A desktop window needs an additional package, and this repository keeps each implementation to the toolchain in the official Julia tarball.

## Why there is no web version
There is no web version because the standard library of Julia has no web server. The manual lists `Sockets` for network connections and `Downloads` for fetching files, and no HTTP server module [10]. A web page served over HTTP needs an additional package, and this repository keeps each implementation to the toolchain in the official Julia tarball.

## Sources
1. Julia Documentation, Introduction (Julia 1.13). The Julia Project. <https://docs.julialang.org/en/v1.13/> (accessed 2026-11-11)
2. Bezanson, J., Edelman, A., Karpinski, S., Shah, V. B. "Julia: A Fresh Approach to Numerical Computing". arXiv:1411.1607, version 4, 2015-07-19. <https://arxiv.org/abs/1411.1607> (accessed 2026-11-11)
3. Bezanson, J., Karpinski, S., Shah, V. B., Edelman, A. "Why We Created Julia", 2012-02-14. The Julia Project. <https://julialang.org/blog/2012/02/why-we-created-julia/> (accessed 2026-11-11)
4. arXiv listing of reference 2, with its submission history (submitted 2014-11-06). Cornell University. <https://arxiv.org/abs/1411.1607> (accessed 2026-11-11)
5. "Announcing the release of Julia 1.0", 2018-08-08. The Julia Project. <https://julialang.org/blog/2018/08/one-point-zero/> (accessed 2026-11-11)
6. Install Julia (stable release 1.13.4, November 13, 2026; long-term support release 1.10.13). The Julia Project. <https://julialang.org/downloads/> (accessed 2026-11-20)
7. Bezanson, J., Edelman, A., Karpinski, S., Shah, V. B. "Julia: A Fresh Approach to Numerical Computing". SIAM Review 59(1), 65–98, 2017, DOI 10.1137/141000671, bibliographic record from the Crossref API. Crossref. <https://api.crossref.org/works/10.1137/141000671> (accessed 2026-11-11)
8. TIOBE Index for November 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-11)
9. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
10. Julia Documentation, Standard Library (table of contents of the Julia 1.13 manual). The Julia Project. <https://docs.julialang.org/en/v1.13/> (accessed 2026-11-11)
