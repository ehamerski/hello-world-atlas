# Kotlin

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm, object-oriented and functional. The Kotlin
FAQ says: "Kotlin has both object-oriented and functional constructs. You
can use it in both OO and FP styles, or mix elements of the two." [1] It is
also "statically typed" [1]: the compiler checks the types before the
program runs.

See also: [paradigms](../../docs/paradigms.md#object-oriented) (how this paradigm
compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | JDK 21, `kotlinc` 2.4.21 | ✅ |
| desktop | [desktop/](desktop/) | Compose Multiplatform, Gradle | ✅ |
| web | [web/](web/) | Ktor (Netty), Gradle | ✅ |
| mobile (Android) | [mobile-android/](mobile-android/) | Jetpack Compose, Android Gradle plugin, Android emulator (x86_64) | ✅ |

## History
JetBrains, the company that makes IntelliJ IDEA, develops Kotlin [1][2]. The
Kotlin FAQ says: "The project started in 2010 and was open source from very
early on. The first official 1.0 release was in February 2016." [1]

JetBrains unveiled the language in a post titled "Hello World", written by
Dmitry Jemerov: "Today at the JVM Language Summit, JetBrains is unveiling
the new project we've been working on for almost a year now. The project is
Kotlin, a new statically typed programming language for the JVM." [2] The
post gives the aim: "a language which is productive enough for today's
environment and at the same time simple enough for every programmer to
learn", and it promises that the compiler and the tools would be released
"as open-source under the Apache 2 license" once the language reached its
beta stage [2]. It also says: "since we're a development tools company,
we're building first-class IDE support for Kotlin in parallel with the
language itself" [2].

The 1.0 release post, by Andrey Breslav, defines the language as "a
pragmatic programming language for the JVM and Android that combines OO and
functional features and is focused on interoperability, safety, clarity,
and tooling support" [3]. It adds: "Being a general-purpose language,
Kotlin works everywhere where Java works: server-side applications, mobile
applications (Android), and desktop applications." [3]

Kotlin for the JVM "produces Java-compatible bytecode" [1].
This is why the [cli](cli/) folder ends with `java -jar`. The
FAQ also says that "Kotlin is 100% interoperable with the Java programming
language" [1]. The [Java](../java/README.md) folders and these folders use
the same JDK 21.

The same language targets more than the JVM. The FAQ lists "the JVM,
Android, JavaScript, Wasm, and Native" [1].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 2010 | The Kotlin project starts at JetBrains | [1] |
| 2011-07 | JetBrains unveils Kotlin at the JVM Language Summit (the post's address carries the month) | [2] |
| 2016-02 | Kotlin 1.0, the first official release | [1][3] |
| 2017-05-17 | The Android team announces "that we are officially adding support for the Kotlin programming language" | [4] |
| 2019-05-07 | Google I/O 2019: "Android development will become increasingly Kotlin-first" | [5] |
| 2026-06-03 | Kotlin 2.4.0, the release line of this repository | [6] |
| 2026-10-08 | **Kotlin 2.4.21, the version used in this repository** | [6] |

## Market usage today
Every number below has its date and source. They change every year.

- **Stack Overflow Developer Survey 2026:** 10.8% of all respondents to the
  programming languages question used Kotlin (1,524 of 14,099) [7].
- **TIOBE Index, October 2026:** Kotlin is #32 with a rating of 0.48% [8].
- **Android (Kotlin documentation, accessed 2026-11-04):** "Over 50% of
  professional Android developers use Kotlin as their primary language,
  while only 30% use Java as their main language", and "over 95% of the top
  thousand Android apps use Kotlin" [9]. The page gives no year for these
  figures. The Android Developers Blog reported "Over 50% of professional
  Android developers now use Kotlin" in May 2019 [5].

The numbers come from different measures: a developer survey, an index,
and a count of Android developers and apps. They do not compare directly.

## Importance then and now
- **Then (2011):** JetBrains aimed at a language for the JVM that is
  "productive enough for today's environment" and "simple enough for every
  programmer to learn" [2]. By the 1.0 release in 2016, interoperability
  with Java was a stated focus: "any Java library can be used in Kotlin, too; and vice
  versa" [3].
- **Android (2017–2019):** Google added official support for Kotlin on
  Android in 2017 [4] and made Android development Kotlin-first in 2019
  [5]. The Kotlin documentation says Android development has been
  "Kotlin-first since Google I/O in 2019" [9].
- **Now (2026):** Kotlin is used by 10.8% of Stack Overflow's 2026
  respondents [7]. JetBrains' UI framework, Compose Multiplatform, uses
  Kotlin to build "shared UIs across Android, iOS, desktop, and web" [10],
  and Ktor is JetBrains' framework for servers and clients in Kotlin [11]. The [desktop](desktop/) and
  [web](web/) folders use them.
- **In teaching:** a Kotlin Hello World is `fun main() { println("Hello,
  World!") }` [12]. It needs no class, no `static` and no argument array,
  which Java 21 requires (see the [Java cli](../java/cli/README.md#step-by-step-walkthrough)).

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Lines of Kotlin (no comments, no imports, no blank lines) | 3 | 13 (8 are the self-check) | 10 |
| Library | none (`println`) | Compose Multiplatform 1.12.2 | Ktor 3.6.1 with the Netty engine |
| Entry point | `main` prints and returns | `main` → `application { Window { Text } }` | `main` → `embeddedServer(...).start(wait = true)` |
| Build tool | `kotlinc` | Gradle | Gradle |
| Build output (`build.sh`) | `build/hello.jar` | `build/classes/` (Gradle `classes` task) | `build/libs/hello-web-all.jar` |
| How it runs | `java -jar` | `gradle run` | `java -jar`, serves until Ctrl+C |
| Output | text on stdout | a native window | HTML from the server |
| Extra install | the compiler (zip from JetBrains) | Gradle | Gradle |

What stays the same: every version in the table is Kotlin code compiled to
JVM bytecode and run on the JVM, so every folder has a `build.sh`. Compare
the [Python](../python/README.md) versions, which have none. What differs is
which code runs the main loop. The cli runs `main` and ends. In the desktop
version, Compose waits for window events until `exitApplication()` is
called. In the web version, Netty waits for HTTP requests. The cli uses the
compiler directly because one file needs no project. The other two use
Gradle because they need libraries from the internet, which Gradle
downloads.

## Sources
1. Kotlin FAQ. JetBrains. <https://kotlinlang.org/docs/faq.html> (accessed 2026-11-04)
2. Hello World. Dmitry Jemerov, The JetBrains Blog, 2011. <https://blog.jetbrains.com/kotlin/2011/07/hello-world-2/> (accessed 2026-11-04)
3. Kotlin 1.0 Released: Pragmatic Language for the JVM and Android. Andrey Breslav, The JetBrains Blog, 2016. <https://blog.jetbrains.com/kotlin/2016/02/kotlin-1-0-released-pragmatic-language-for-jvm-and-android/> (accessed 2026-11-04)
4. Android Announces Support for Kotlin. Android Developers Blog, 2017-05-17. <https://android-developers.googleblog.com/2017/05/android-announces-support-for-kotlin.html> (accessed 2026-11-04)
5. Google I/O 2019: Empowering developers to build the best experiences on Android + Play. Android Developers Blog, 2019-05-07. <https://android-developers.googleblog.com/2019/05/google-io-2019-empowering-developers-to-build-experiences-on-Android-Play.html> (accessed 2026-11-04)
6. Kotlin releases. JetBrains. <https://kotlinlang.org/docs/releases.html> (accessed 2026-11-04)
7. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
9. Android overview. JetBrains (Kotlin documentation). <https://kotlinlang.org/docs/android-overview.html> (accessed 2026-11-04)
10. Compose Multiplatform. JetBrains. <https://kotlinlang.org/compose-multiplatform/> (accessed 2026-11-04)
11. Ktor. JetBrains. <https://ktor.io/> (accessed 2026-11-04)
12. Kotlin command-line compiler. JetBrains. <https://kotlinlang.org/docs/command-line.html> (accessed 2026-11-04)
