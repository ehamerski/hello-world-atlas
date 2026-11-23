# Swift

> Part of [Hello World in many languages](../../README.md)

Swift is "a safe and fast programming language that combines the best in
modern language thinking with wisdom from a diverse open source
community" [11]. Apple introduced it in 2014 as "Swift, a powerful new
programming language" [1], and made it open source in 2015 [2].

## History and milestones

Chris Lattner "started work on the Swift Programming Language … in July of
2010", and "it became a major focus for the Apple Developer Tools group in
July 2013" [3]. He worked for Apple "from July 2005 to January 2017" [3].
Swift draws "ideas from Objective-C, Rust, Haskell, Ruby, Python, C#, CLU,
and far too many others to list" [3].

The dates of the numbered releases up to 6.0 are the release headings of
the Swift CHANGELOG [4]. From 6.1 on, the CHANGELOG has no dates, so the
dates are those of the release posts on swift.org.

| Date | Milestone |
|---|---|
| 2014-06-02 | Apple announces Swift with the iOS 8 SDK [1] |
| 2014-09-15 | Swift 1.0 (Xcode 6.0) [4] |
| 2015-09-17 | Swift 2.0 (Xcode 7.0): error handling (`throw`, `catch`), the `guard` statement, availability checking with `#available` [4] |
| 2015-12-03 | Swift is open source under the Apache 2.0 license with a runtime library exception, for Apple platforms and Linux; Swift.org launches [2] |
| 2016-09-13 | Swift 3.0 (Xcode 8.0): Objective-C APIs are imported with Swift-style names (SE-0005) [4] |
| 2017-09-19 | Swift 4.0 (Xcode 9.0) [4] |
| 2019-03-25 | Swift 5.0 (Xcode 10.2): ABI stability, so the Swift runtime ships in Apple's operating systems [5]; the `Result` type (SE-0235) [4] |
| 2021-09-20 | Swift 5.5 (Xcode 13.0): async/await (SE-0296) and actors (SE-0306) [4] |
| 2023-09-18 | Swift 5.9 (Xcode 15.0): "a new macro system" [4] |
| 2024-09-17 | Swift 6.0 (Xcode 16.0): the Swift 6 language mode, which "prevents the risk of data races at compile time" [4] |
| 2025-03-31 | Swift 6.1: package traits [6] |
| 2025-09-15 | Swift 6.2: `InlineArray`, "a new fixed-size array with inline storage" [7] |
| 2026-03-24 | Swift 6.3: the `@c` attribute exposes Swift functions and enums to C [8] |
| 2026-09-15 | Swift 6.4: Swift Build is the default build system of Swift Package Manager [9] |

On 2026-11-20 the latest release on GitHub was `swift-6.4.2-RELEASE`,
published on 2026-10-30 [10].

## Design and paradigms

The Swift book lists how Swift "defines away large classes of common
programming errors" [11]:

- "Variables are always initialized before use."
- "Array indices are checked for out-of-bounds errors."
- "Integers are checked for overflow."
- "Optionals ensure that `nil` values are handled explicitly."
- "Memory is managed automatically."
- "Error handling allows controlled recovery from unexpected failures."

Swift has "powerful features like type inference and pattern matching" [11],
and "Swift code is compiled and optimized to get the most out of modern
hardware" [11]. Apple's 2015 announcement describes it as combining "the
performance and efficiency of compiled languages with the simplicity and
interactivity of popular scripting languages" [2].

## Market usage today
Every number below has its date and source. They change every year.

- **Stack Overflow Developer Survey 2026:** 5.9% of all respondents to the
  programming languages question used Swift (831 of 14,099) [13].
- **TIOBE Index, November 2026:** Swift is #18 with a rating of 0.89% [14].

Beyond Apple platforms, the open-source release supports Linux [2], and
Swift.org describes the goal "to create the best available language for
uses ranging from systems programming to mobile and desktop apps, scaling
up to highly distributed cloud services" [12]. On the server, [Vapor]
"provides a safe, performant and easy to use foundation to build HTTP
servers, backends and APIs in Swift" [15].

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Swift 6 (swiftc) | ✅ |
| desktop | [desktop/](desktop/) | SwiftUI + AppKit | ✅ |
| web | [web/](web/) | Vapor 4 | ✅ |
| mobile-ios | [mobile-ios/](mobile-ios/) | SwiftUI + iOS Simulator (full Xcode) | ✅ |

The desktop and mobile-ios programs share the same SwiftUI `View` code. The
differences are the platform: a macOS window (desktop) and a full-screen iOS
app that needs full Xcode and an iOS Simulator (mobile-ios). Command Line
Tools alone build the macOS version only.

## Sources

1. Apple Releases iOS 8 SDK With Over 4,000 New APIs. Apple Inc., press release, 2014-06-02. <https://www.apple.com/newsroom/2014/06/02Apple-Releases-iOS-8-SDK-With-Over-4-000-New-APIs/> (accessed 2026-11-20)
2. Apple Releases Swift as Open Source. Apple Inc., press release, 2015-12-03. <https://www.apple.com/newsroom/2015/12/03Apple-Releases-Swift-as-Open-Source/> (accessed 2026-11-20)
3. Chris Lattner's Homepage. Chris Lattner. <https://nondot.org/sabre/> (accessed 2026-11-20)
4. Swift CHANGELOG. The Swift Project on GitHub. <https://github.com/swiftlang/swift/blob/main/CHANGELOG.md> (accessed 2026-11-20)
5. Swift 5 Released! Swift.org, 2019-03-25. <https://www.swift.org/blog/swift-5-released/> (accessed 2026-11-20)
6. Swift 6.1 Released. Swift.org, 2025-03-31. <https://www.swift.org/blog/swift-6.1-released/> (accessed 2026-11-20)
7. Swift 6.2 Released. Swift.org, 2025-09-15. <https://www.swift.org/blog/swift-6.2-released/> (accessed 2026-11-20)
8. Swift 6.3 Released. Swift.org, 2026-03-24. <https://www.swift.org/blog/swift-6.3-released/> (accessed 2026-11-20)
9. Swift 6.4 Released. Swift.org, 2026-09-15. <https://www.swift.org/blog/swift-6.4-released/> (accessed 2026-11-20)
10. Releases. The Swift Project on GitHub. <https://github.com/swiftlang/swift/releases> (accessed 2026-11-20)
11. The Swift Programming Language, "About Swift". Swift.org. <https://docs.swift.org/latest/documentation/the-swift-programming-language/aboutswift/> (accessed 2026-11-20)
12. Swift on Server. Swift.org. <https://www.swift.org/documentation/server/> (accessed 2026-11-20)
13. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
14. TIOBE Index for November 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-20)
15. Vapor. Vapor.codes. <https://vapor.codes/> (accessed 2026-11-20)

[Vapor]: https://vapor.codes/
