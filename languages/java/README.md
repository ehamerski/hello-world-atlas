# Java

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented. The Java Language Specification describes
Java as "a general-purpose, concurrent, class-based, object-oriented
language" [1]. In practice this means that every piece of code lives
inside a class, even a one-line Hello World. Later versions added
functional features such as lambdas (Java 8) [7], which the
[desktop](desktop/) version uses once.

See also: [paradigms](../../docs/paradigms.md#object-oriented) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | JDK 21 (Temurin) + Maven | ✅ verified on macOS Intel |
| desktop | [desktop/](desktop/) | JDK 21 + Maven + JavaFX 21.0.13 | ✅ verified on macOS Intel |
| desktop (Swing variant) | [desktop-swing/](desktop-swing/) | JDK 21 + Maven; Swing is part of the JDK | ✅ verified on macOS Intel |
| web | [web/](web/) | JDK 21 + Maven + Spring Boot 4.1.2 | ✅ verified on macOS Intel |
| web + separate front end | [web-react/](web-react/) | Spring Boot 4.1.2 API + React 19 / Vite 8 front end | ✅ verified on macOS Intel |

## History
Java started in 1991 at Sun Microsystems. Sun's own account says it "was
created as a programming tool in a small, closed-door project initiated by
Patrick Naughton, Mike Sheridan, and James Gosling of Sun in 1991", and
that "creating a new language wasn't even the point of 'the Green
Project'" [2]. The team built a handheld device, the *7 ("StarSeven"), and
"it ran on an entirely new, processor-independent language" written by
Gosling: "Gosling called the new language 'Oak,' after the tree outside
his window" [2]. The Computer History Museum dates the first
demonstration of Oak to 1992-09-02 [3].

Java was announced to the public on 1995-05-23, at SunWorld, where Sun and Netscape said it "was going to be
incorporated into Netscape Navigator" [2]. Sun released Java 1.0 on
1996-01-23 [4]. The 1996 white paper by Gosling and Henry McGilton
lists the design goals: "Simple, Object Oriented, and Familiar", "Robust
and Secure", "Architecture Neutral and Portable", "High Performance" and
"Interpreted, Threaded, and Dynamic" [5].

Java code is compiled by `javac` into `.class` files that contain
"bytecodes — the machine language of the Java Virtual Machine", and the
`java` launcher runs them on a JVM [6]. That is why every Java folder in
this repository has a `build.sh`, and why the same `.jar` runs on any operating
system that has a JVM.

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1991 | The Green Project starts at Sun (Naughton, Sheridan, Gosling) | [2] |
| 1992-09-02 | First demonstration of the language, then called Oak | [3] |
| 1995-05-23 | Java announced at SunWorld, to be included in Netscape Navigator | [2] |
| 1996-01-23 | Java 1.0 available for download | [4] |
| 2004 | J2SE 5.0 adds generics, among other features | [8] |
| 2006-11 | Sun announces it is open-sourcing Java under the GPL v2 (OpenJDK) | [9] |
| 2010-01-27 | Oracle completes its acquisition of Sun Microsystems | [10] |
| 2014-03-18 | Java 8: lambda expressions ("Project Lambda") | [7] |
| 2017-09-21 | Java 9: the module system | [11] |
| 2017-09 | Proposal for a new feature release every six months, with periodic long-term support (LTS) releases | [12] |
| 2018-09-25 | Java 11 | [13] |
| 2021-09-14 | Java 17 (LTS) | [14] |
| 2023-09-19 | **Java 21 (LTS), the version used in this repository**: virtual threads, record patterns, pattern matching for `switch` | [15] |
| 2025-09-16 | Java 25 (LTS): compact source files and instance `main` methods (JEP 512) | [16][17] |
| 2026-09-15 | Java 27, the newest release at the time of writing | [18] |

Today OpenJDK "ships a feature release every six months according to a
strict, time-based model" [18]. Oracle lists "Java SE 8, 11, 17, 21, and
25" as LTS releases, plans the next LTS for September 2027 (Java 29), and
gives Java 21 Premier Support until September 2028 [19].

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Java is #4 with a rating of 8.41% (it was
  also #4 a year earlier) [20].
- **Stack Overflow Developer Survey 2026:** 27.6% of all respondents to the
  programming languages question used Java (3,885 of 14,099) [21]. In
  the web frameworks question, 12.8% used Spring Boot and 41.5% used
  React (base 10,281 respondents) [21].
- **Vendor claim (Oracle, not independent):** Oracle's Java page calls
  Java "the #1 programming language and development platform" and speaks
  of "more than 73 billion Java Virtual Machines worldwide" [23]. It gives
  no method or date for these figures, so they are marketing claims, not measurements.

## Importance then and now
- **Then (1990s):** the white paper argued that a language for networked
  computers "must be architecture neutral, portable, and dynamically
  adaptable" [5]. Its promise to programmers was: "Write your applications
  once, and you never need to port them--they will run without modification
  on multiple operating systems and hardware architectures" [5]. The
  JVM made that possible, because programs ship as bytecode instead of
  machine code [6].
- **Open source (2006–2007):** Sun announced it was open-sourcing "its
  entire Java stack ... under the GNU General Public License, version 2"
  [9]. Today's JDK releases are developed in the OpenJDK project [18], and
  Eclipse Temurin, the JDK used here, is "Built on OpenJDK" [22].
- **Now:** Java is #4 in TIOBE (October 2026) and was used by 27.6% of
  Stack Overflow's 2026 respondents [20][21]. Spring Boot, the framework of
  the [web](web/) versions, is the only Java framework with a double-digit
  share in that survey's web frameworks question [21].
- **In teaching:** a Java Hello World has long needed a class, `public
  static void main` and `System.out`, all before the first line of output.
  The OpenJDK project itself took this up: JEP 512 (final in Java 25) aims
  to let "beginners ... write their first programs without needing to
  understand" those features [17]. See the [cli README](cli/README.md#step-by-step-walkthrough)
  for the shorter form.

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [desktop-swing](desktop-swing/) | [web](web/) | [web-react](web-react/) |
|---|---|---|---|---|---|
| Lines of Java (no comments, no imports) | 6 | 24 (9 are the self-check) | 25 (10 are the self-check) | 12 | 13 (+ 15 lines of JavaScript) |
| Library | none (`System.out`) | JavaFX 21 (OpenJFX) | Swing (in the JDK) | Spring Boot 4.1 (Spring MVC, Tomcat) | Spring Boot 4.1 + React 19, Vite 8 |
| Entry point | `main` prints and returns | `main` → `launch()` → `start(Stage)` | `main` → `invokeLater()` → builds the window on the event dispatch thread | `main` → `SpringApplication.run()` | the same, plus `main.jsx` in the browser |
| Build output (`build.sh`) | `target/hello-cli.jar` | `target/hello-desktop.jar` + `target/lib/` (JavaFX) | `target/hello-swing.jar` | executable JAR with Spring and Tomcat inside | API JAR + `frontend/dist/` |
| How it runs | `java -jar` | `java --module-path target/lib --add-modules javafx.controls ...` | `java -jar` | `java -jar`, serves until Ctrl+C | `java -jar` + `vite preview`, both until Ctrl+C |
| Output | text on stdout | a native window | a native window | HTML from the server | JSON from the server; HTML drawn by React in the browser |
| Extra install | none | none (Maven downloads JavaFX) | none | none (Maven downloads Spring Boot) | Node.js; `npm ci` |

What stays the same: every version is a Maven project with the same
`src/main/java` layout, compiled by `javac` to bytecode and run by the
JVM, so all five have a `build.sh`. Compare the [Python](../python/README.md)
versions, which have none. What differs is which code runs the main loop. The cli
runs `main` and ends. In the desktop versions JavaFX or Swing waits for
window events. Swing and JavaFX are compared in the
[desktop-swing README](desktop-swing/README.md#swing-or-javafx). In the
web versions Tomcat waits for HTTP requests. In web-react, two programs
work together: the browser runs React, and React asks the Java server
for data.

All four categories are implemented for Java, plus a second desktop
version with Swing. For this reason the page has no "why no <category>"
section.

## Sources
1. The Java Language Specification, Java SE 21 Edition, Chapter 1. Introduction. Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-1.html> (accessed 2026-10-31)
2. Java Technology: The Early Years. Jon Byous, Sun Microsystems, 1998 (Internet Archive copy). <https://web.archive.org/web/20051230031802/http://java.sun.com/features/1998/05/birthday.html> (accessed 2026-10-31)
3. James Gosling. Computer History Museum. <https://computerhistory.org/profile/james-gosling/> (accessed 2026-10-31)
4. JavaSoft ships Java 1.0 (Sun Microsystems press release, 1996-01-23, archived in the java-interest mailing list). MIT. <https://diswww.mit.edu/charon.mit.edu/java-interest/5056> (accessed 2026-10-31)
5. The Java Language Environment (white paper, May 1996). James Gosling and Henry McGilton, Sun Microsystems; hosted by Oracle. <https://www.oracle.com/java/technologies/language-environment.html> (accessed 2026-10-31)
6. About the Java Technology (The Java Tutorials). Oracle. <https://docs.oracle.com/javase/tutorial/getStarted/intro/definition.html> (accessed 2026-10-31)
7. JDK 8. OpenJDK. <https://openjdk.org/projects/jdk8/> (accessed 2026-10-31)
8. J2SE 5.0 New Features. Oracle. <https://docs.oracle.com/javase/1.5.0/docs/relnotes/features.html> (accessed 2026-10-31)
9. One giant leap, two small steps. Mark Reinhold (Sun Microsystems), 2006-11-12. <https://mreinhold.org/blog/one-giant-leap> (accessed 2026-10-31)
10. Oracle Completes Acquisition of Sun (press release, 2010-01-27, SEC filing). Oracle Corporation / U.S. SEC. <https://www.sec.gov/Archives/edgar/data/1341439/000119312510015241/dex991.htm> (accessed 2026-10-31)
11. JDK 9. OpenJDK. <https://openjdk.org/projects/jdk9/> (accessed 2026-10-31)
12. Moving Java Forward Faster. Mark Reinhold, 2017-09-06. <https://mreinhold.org/blog/forward-faster> (accessed 2026-10-31)
13. JDK 11. OpenJDK. <https://openjdk.org/projects/jdk/11/> (accessed 2026-10-31)
14. JDK 17. OpenJDK. <https://openjdk.org/projects/jdk/17/> (accessed 2026-10-31)
15. JDK 21. OpenJDK. <https://openjdk.org/projects/jdk/21/> (accessed 2026-10-31)
16. JDK 25. OpenJDK. <https://openjdk.org/projects/jdk/25/> (accessed 2026-10-31)
17. JEP 512: Compact Source Files and Instance Main Methods. OpenJDK. <https://openjdk.org/jeps/512> (accessed 2026-10-31)
18. JDK Project (release list and cadence). OpenJDK. <https://openjdk.org/projects/jdk/> (accessed 2026-10-31)
19. Oracle Java SE Support Roadmap (updated 2026-10-20). Oracle. <https://www.oracle.com/java/technologies/java-se-support-roadmap.html> (accessed 2026-10-31)
20. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-10-31)
21. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
22. Eclipse Temurin. Eclipse Adoptium. <https://adoptium.net/temurin/> (accessed 2026-10-31)
23. Java Software. Oracle. <https://www.oracle.com/java/> (accessed 2026-10-31)
