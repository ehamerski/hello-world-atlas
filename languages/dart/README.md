# Dart

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented [1]

See also: [paradigms](../../docs/paradigms.md#object-oriented)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Dart SDK | ✅ |
| web | [web/](web/) | `dart:io` HttpServer | ✅ |
| mobile | [mobile-flutter/](mobile-flutter/) | Flutter 3.47.9 (Android) | ✅ |

## History

Lars Bak of the Dart team at Google introduced an early preview of Dart on 2011-10-10 as a class-based, optionally typed language for building web applications [2]. Its stated design goals were a structured yet flexible language for web programming, one that feels familiar and runs with high performance on all modern web browsers [2]. The first stable release, Dart 1.0, was published on 2013-11-14 [4].

Dart is also the language of Flutter, Google's UI toolkit for building mobile, web, desktop, and embedded apps from a single codebase [5]. Dart 2 was announced on 2018-02-22 as a reboot of the language, optimized for client-side development for web and mobile, with strong typing among its new features [6]. Dart 2.0 was released on 2018-08-07 [3].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 2011 | Early preview of Dart introduced (2011-10-10) | [2] |
| 2013 | Dart 1.0 released (2013-11-14) | [4] |
| 2018 | Dart 2 announced (2018-02-22); Dart 2.0 released (2018-08-07) | [6], [3] |
| 2021 | Dart 2.12 enables sound null safety by default (2021-03-03) | [3] |
| 2023 | Dart 3.0 released (2023-05-10) with records, patterns and class modifiers | [7] |

## Market usage today

Every number below has its date and source. They change every month.

- **TIOBE Index, November 2026:** Dart is #20 with a rating of 0.74% [8].
- **PYPL Index, November 2026:** Dart is #20 with a share of 0.49% [9].

## Importance then and now

Dart was introduced in 2011 as a language for structured web programming that runs on all modern web browsers [2]. Today the Flutter home page describes Flutter as "powered by Dart, a language optimized for fast apps on any platform" [5].

## Comparing the categories

The cli version (`dart hello.dart`) runs directly on the Dart VM and uses only `dart:core`. The web version uses `dart:io`, which provides networking capabilities including HTTP server support. Both use the same Dart SDK and the same compilation model: the `dart` command compiles to an intermediate kernel format and runs it on the VM. Neither version requires a separate build step or third-party packages.

The mobile version (`mobile-flutter`) is different. It is a Flutter app, so it
needs the Flutter SDK and the Android SDK, and `build.sh` packs the app into an
APK for Android [11]. The Dart code is still the same language. The screen is
built from Flutter widgets (`MaterialApp`, `Scaffold`, `Text`) instead of a
line of output or an HTTP response.

## Why there is no desktop version

Dart does not include a GUI toolkit in its standard library. Desktop GUI for
Dart means Flutter, a cross-platform UI framework that targets macOS, Windows,
Linux, iOS, Android, and the web from a single codebase [5], [10]. Flutter desktop
apps need platform toolchains — Xcode on macOS [12], Visual Studio on Windows
[13], and the GTK development package `libgtk-3-dev` on Linux [14] — a heavier
setup than a standard CLI or web runtime. Flutter desktop support is described at
[flutter.dev/development/desktop](https://flutter.dev/development/desktop) [10].

## Sources

1. Classes. Dart Team, Google. <https://dart.dev/language/classes> (accessed 2026-11-20)
2. Dart: a language for structured web programming. Lars Bak, Google Code Blog, 2011-10-10. <https://web.archive.org/web/20121114043040/http://googlecode.blogspot.com/2011/10/dart-language-for-structured-web.html> (archived copy of the blog post, accessed 2026-11-17)
3. Dart SDK changelog. Dart Team, Google. <https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md> (accessed 2026-11-20)
4. Dart 1.0: A stable SDK for structured web apps. Lars Bak, Dart News & Updates, 2013-11-14. <https://news.dartlang.org/2013/11/dart-10-stable-sdk-for-structured-web.html> (accessed 2026-11-17)
5. Flutter - Build apps for any screen. Google. <https://flutter.dev> (accessed 2026-11-20)
6. Announcing Dart 2: Optimized for Client-Side Development. Anders Thorhauge Sandholm, The Dart Blog, 2018-02-22. <https://dart.dev/blog/announcing-dart-2-optimized-for-client-side-development> (accessed 2026-11-17)
7. Announcing Dart 3. Michael Thomsen, The Dart Blog, 2023-05-10. <https://dart.dev/blog/announcing-dart-3> (accessed 2026-11-17)
8. TIOBE Index for November 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-20)
9. PYPL PopularitY of Programming Language index, November 2026. Pierre Carbonnelle. <https://pypl.github.io/PYPL.html> (accessed 2026-11-20)
10. Desktop. Flutter Team, Google. <https://flutter.dev/development/desktop> (accessed 2026-11-20)
11. Build and release an Android app. Flutter Team, Google. <https://docs.flutter.dev/deployment/android> (accessed 2026-11-12)
12. Set up macOS development. Flutter Team, Google. <https://docs.flutter.dev/platform-integration/macos/setup> (accessed 2026-11-20)
13. Set up Windows development. Flutter Team, Google. <https://docs.flutter.dev/platform-integration/windows/setup> (accessed 2026-11-20)
14. Set up Linux development. Flutter Team, Google. <https://docs.flutter.dev/platform-integration/linux/setup> (accessed 2026-11-20)
