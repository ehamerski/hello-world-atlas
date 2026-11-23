# Rust

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm, for systems programming. The Rust book says
"Rust is influenced by many programming paradigms, including OOP" [1], and
"one significant influence is *functional programming*" [2]. On the
question whether Rust is object-oriented, the book answers: "By some of these definitions Rust is object oriented but
by others it is not" [3]: it has structs, methods, and traits, but no
classes and no inheritance. Its home page describes it as "A language
empowering everyone to build reliable and efficient software" [4]. What
sets it apart is **memory safety without a garbage collector**: the
compiler checks who owns each value, which is why even the
[web](web/) and [desktop](desktop/) versions use borrowing
(`&'static str`) and ownership (`move`).

See also: [paradigms](../../docs/paradigms.md#every-language-and-its-paradigm) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Cargo | ✅ |
| desktop | [desktop/](desktop/) | eframe / egui | ✅ |
| web | [web/](web/) | Axum | ✅ |

## History
Rust began as Graydon Hoare's personal project. In a 2025 essay he
recalls it "starting from my amusing frustration with a broken elevator in
2006", and that "The baby Rust I wrote in 2006-09 had essentially no type
checker at all" [5]. It stayed "an unfunded solo hobby project" until
"Mozilla's decision to invest in Rust in 2009 immediately quadrupled the
size of the team", and "Mozilla sustained this very unusual, very
improbable investment in Rust from 2009-2020" [5].

After years of change, **Rust 1.0** was released on 2015-05-15: "a new
programming language aiming to make it easier to build reliable, efficient
systems" [6]. Since then "Rust releases every six weeks, like clockwork"
[7]. Bigger changes that could break old code come in **editions**, which each crate opts into in its
`Cargo.toml` [8]: 2018 (Rust 1.31) [9], 2021 (Rust 1.56) [10], and 2024
(Rust 1.85) [11]. Every folder here uses edition 2024.

In 2021 Rust left Mozilla for an independent foundation: "Today, on behalf
of the Rust Core team, I'm excited to announce the Rust Foundation", with
"Founding member companies, AWS, Huawei, Google, Microsoft, and Mozilla"
[12].

Rust then entered the Linux kernel. Linux 6.1 brought
"the introduction of support for the Rust programming language" to the
kernel, although at first "No system with a production 6.1 kernel will be
running any Rust code" [13]. In December 2025 the kernel developers
concluded that "Rust in the kernel is no longer experimental" [14]; the
patch that followed says: "the experiment is done, i.e. Rust is here to
stay" [15].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 2006 | Graydon Hoare starts Rust as a personal project | [5] |
| 2009 | Mozilla starts investing in Rust | [5] |
| 2015-05-15 | **Rust 1.0**, the first stable release; six-week releases from then on | [6][7] |
| 2018-12-06 | Rust 1.31 and the first new edition, Rust 2018 | [9] |
| 2020-05-30 | egui 0.1.0, the GUI library used in [desktop/](desktop/), is published | [16] |
| 2021-02-08 | The Rust Foundation is founded (AWS, Huawei, Google, Microsoft, Mozilla) | [12] |
| 2021-10-21 | Rust 1.56 and the Rust 2021 edition | [10] |
| 2022 | Linux 6.1 is the first kernel with Rust support | [13] |
| 2025-02-20 | Rust 1.85 and the **Rust 2024 edition** (used here) | [11] |
| 2025-12 | Linux kernel developers declare the Rust experiment over: "Rust is here to stay" | [14][15] |
| 2026-08-20 | Rust 1.98.0 (1.98.1 is the version used on the test machine) | [17] |
| 2026-10-15 | Rust 1.99.1, the latest stable release on 2026-10-31 | [18] |

## Market usage today
Every number below has its date and source. They change every year.

- **Stack Overflow Developer Survey 2026:** 18.0% of all respondents to the
  programming languages question used Rust (2,542 of 14,099) [19]. Of those
  who used it, 67.4% want to keep using it ("admired"); 26.3% of all
  respondents want to use it ("desired") [19]. In that table only two
  languages have a higher "admired" score, Elm (94.1%) and Odin (82.4%),
  each used by fewer than 0.5% of respondents [19].
- **TIOBE Index, October 2026:** Rust is #10 with a rating of 1.44%. It was
  #16 in October 2025 [20].
- **State of Rust Survey 2024** (the Rust project's own survey, 7,310
  completed responses): "45% of respondents answered that their
  organisation makes non-trivial use of Rust", and 38% use Rust at work
  for the majority of their coding [21]. The 2025 survey (7,156 responses,
  published 2026-03-02) found that the answers "pretty closely match the
  results of last year" [22].
- **Where Rust is used** (the companies' own reports, with their dates):
  - AWS, 2022: "We use Rust to deliver services such as Amazon Simple
    Storage Service (Amazon S3), Amazon Elastic Compute Cloud (Amazon
    EC2), Amazon CloudFront, and more" [23].
  - Cloudflare, 2022: Pingora, "a new HTTP proxy we've built in-house using
    Rust that serves over 1 trillion requests a day" [24].
  - Google, 2024: in Android, memory safety issues "accounted for 76% of
    Android vulnerabilities in 2019, and are currently 24% in 2024", as new
    code is written in memory-safe languages such as Rust [25].

## Importance then and now
- **The problem it addresses:** "~70% of the vulnerabilities Microsoft
  assigns a CVE each year continue to be memory safety issues" (Microsoft,
  2019) [26]. Those bugs occur in languages such as C and C++, where the
  programmer manages memory by hand. Languages with a garbage collector
  (Java, Go, Python) avoid them but add one to every program. In Rust,
  ownership "enables Rust to make memory safety guarantees without needing
  a garbage collector" [28]: the compiler checks who owns and who borrows
  each value.
- **Then (2015):** Rust 1.0 promised C-like control with safety checked
  at compile time [6], and a stable language after years of change.
- **Now:** security agencies name it as a memory-safe language. The 2023 guide *The Case for
  Memory Safe Roadmaps* (CISA, NSA, FBI, and partner agencies) states that
  "Memory safety vulnerabilities are the most prevalent type of disclosed
  software vulnerability", lists Rust among the memory-safe languages, and
  notes that "Rust enforces correctness at compile time to prevent memory
  safety and concurrency problems at runtime" [27]. Rust is in the Linux
  kernel to stay [15], and it is #10 in TIOBE (October 2026) [20].
- **In teaching:** the Hello World is as short as Go's (one `main`, one
  `println!`). The new ideas appear as soon as a program grows: the book
  calls ownership "Rust's most unique feature" [28], and the
  [web](web/) and [desktop](desktop/) versions already need borrowed
  strings (`&'static str`) and `move` closures.

## Comparing the categories
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Lines of Rust (no comments, no blank lines) | 3 | 28 (13 are the self-check) | 15 |
| Dependencies in `Cargo.toml` | none (standard library) | `eframe` | `axum`, `tokio` |
| Crates compiled on macOS (`cargo tree`) | 1 | 179 | 48 |
| Minimum Rust (`rust-version`) | 1.85 (edition 2024) | 1.95 (eframe 0.37) | 1.85 (edition 2024, Tokio) |
| First build on the test machine (macOS Intel) | about 1 s | 4 min 18 s | about 40 s |
| Executable (`target/release/`) | `hello-cli`, 418 KB | `hello-desktop`, 15.1 MB | `hello-web`, 1.6 MB |
| Who owns the loop | nobody: `main` prints and returns | eframe's event loop (`run_ui_native`) | Tokio's runtime (`#[tokio::main]`, `axum::serve`) |
| Output | text on stdout | a native window (drawn with wgpu/Metal) | HTML from the server |

Sizes are from `stat` on macOS Intel with Rust 1.98.1 (2026-10-31).
For comparison, the same three programs in [Go](../go/README.md#comparing-the-categories)
are 2.5 MB, 34.2 MB, and 13.6 MB.

What stays the same: every folder is a Cargo package with `Cargo.toml`,
`Cargo.lock` and `src/main.rs`, and every `build.sh` runs
`cargo build --release --locked`. The result is always one native
executable that runs without Rust installed. Compare
[Java](../java/README.md), which needs a JVM at run time, and
[Python](../python/README.md), which has no build step.

Rust has an implementation in each of its three categories, so this page
has no section that explains a missing category.

## Sources
1. The Rust Programming Language, ch. 18.1 "Characteristics of Object-Oriented Languages". The Rust Project. <https://doc.rust-lang.org/book/ch18-01-what-is-oo.html> (accessed 2026-10-31)
2. The Rust Programming Language, ch. 13 "Functional Language Features: Iterators and Closures". The Rust Project. <https://doc.rust-lang.org/book/ch13-00-functional-features.html> (accessed 2026-10-31)
3. The Rust Programming Language, ch. 18 "Object-Oriented Programming Features". The Rust Project. <https://doc.rust-lang.org/book/ch18-00-oop.html> (accessed 2026-10-31)
4. Rust Programming Language (home page). The Rust Project. <https://www.rust-lang.org/> (accessed 2026-10-31)
5. 10 Years of Stable Rust: An Infrastructure Story. Graydon Hoare, Rust Foundation, 2025-05-15. <https://rustfoundation.org/media/10-years-of-stable-rust-an-infrastructure-story/> (accessed 2026-10-31)
6. Announcing Rust 1.0. The Rust Core Team, 2015-05-15. <https://blog.rust-lang.org/2015/05/15/Rust-1.0/> (accessed 2026-10-31)
7. The Rust Programming Language, appendix G "How Rust is Made and Nightly Rust". The Rust Project. <https://doc.rust-lang.org/book/appendix-07-nightly-rust.html> (accessed 2026-10-31)
8. The Rust Edition Guide: What are editions?. The Rust Project. <https://doc.rust-lang.org/edition-guide/editions/index.html> (accessed 2026-10-31)
9. Announcing Rust 1.31 and Rust 2018. The Rust Core Team, 2018-12-06. <https://blog.rust-lang.org/2018/12/06/Rust-1.31-and-rust-2018/> (accessed 2026-10-31)
10. Announcing Rust 1.56.0 and Rust 2021. The Rust Team, 2021-10-21. <https://blog.rust-lang.org/2021/10/21/Rust-1.56.0/> (accessed 2026-10-31)
11. Announcing Rust 1.85.0 and Rust 2024. The Rust Release Team, 2025-02-20. <https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/> (accessed 2026-10-31)
12. Hello World! (announcing the Rust Foundation). The Rust Foundation, 2021-02-08. <https://rustfoundation.org/news/2021-02-08-hello-world/> (accessed 2026-10-31)
13. A first look at Rust in the 6.1 kernel. Jonathan Corbet, LWN.net, 2022-10-13. <https://lwn.net/Articles/910762/> (accessed 2026-10-31)
14. The (successful) end of the kernel Rust experiment. Jonathan Corbet, LWN.net, 2025-12-10. <https://lwn.net/Articles/1049831/> (accessed 2026-10-31)
15. [PATCH] rust: conclude the Rust experiment. Miguel Ojeda, Linux kernel mailing list, 2025-12-12. <https://lkml.iu.edu/hypermail/linux/kernel/2512.1/06411.html> (accessed 2026-10-31)
16. egui CHANGELOG. emilk/egui (GitHub). <https://github.com/emilk/egui/blob/main/CHANGELOG.md> (accessed 2026-10-31)
17. Announcing Rust 1.98.0. The Rust Release Team, 2026-08-20. <https://blog.rust-lang.org/2026/08/20/Rust-1.98.0/> (accessed 2026-10-31)
18. Announcing Rust 1.99.1. The Rust Release Team, 2026-10-15. <https://blog.rust-lang.org/2026/10/15/Rust-1.99.1/> (accessed 2026-10-31)
19. Stack Overflow Developer Survey 2026: Technology data (programming languages; admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
20. TIOBE Index, October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-10-31)
21. 2024 State of Rust Survey Results. The Rust Survey Team, 2025-02-13. <https://blog.rust-lang.org/2025/02/13/2024-State-Of-Rust-Survey-results/> (accessed 2026-10-31)
22. 2025 State of Rust Survey Results. The Rust Survey Team, 2026-03-02. <https://blog.rust-lang.org/2026/03/02/2025-State-Of-Rust-Survey-results> (accessed 2026-10-31)
23. Sustainability with Rust. Shane Miller and Carl Lerche, AWS Open Source Blog, 2022-02-11. <https://aws.amazon.com/blogs/opensource/sustainability-with-rust/> (accessed 2026-10-31)
24. How we built Pingora, the proxy that connects Cloudflare to the Internet. Cloudflare Blog, 2022-09-14. <https://blog.cloudflare.com/how-we-built-pingora-the-proxy-that-connects-cloudflare-to-the-internet/> (accessed 2026-10-31)
25. Eliminating Memory Safety Vulnerabilities at the Source. Google Security Blog, 2024-09-25. <https://security.googleblog.com/2024/09/eliminating-memory-safety-vulnerabilities-Android.html> (accessed 2026-10-31)
26. A proactive approach to more secure code. Microsoft Security Response Center, 2019-07-16. <https://www.microsoft.com/en-us/msrc/blog/2019/07/a-proactive-approach-to-more-secure-code> (accessed 2026-10-31)
27. The Case for Memory Safe Roadmaps. CISA, NSA, FBI and international partners, December 2023. <https://www.cisa.gov/resources-tools/resources/case-memory-safe-roadmaps> (accessed 2026-10-31)
28. The Rust Programming Language, ch. 4 "Understanding Ownership". The Rust Project. <https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html> (accessed 2026-10-31)
