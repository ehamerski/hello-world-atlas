# Objective-C

> Part of [Hello World in many languages](../../README.md)

Objective-C is an object-oriented programming language that adds
Smalltalk-style messaging to C. Apple calls it "the primary programming
language you use when writing software for OS X and iOS" [2]. It
"became the basis for Apple's Mac OS X and then iOS platforms" [1].

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | clang + Foundation | ✅ |
| desktop | [desktop/](desktop/) | clang + AppKit | ✅ |
| web | [web/](web/) | clang + Foundation + BSD sockets | ✅ |

## History and milestones

"The roots of Objective-C began at ITT in the early 1980s in a research
group led by Tom Love" [1]. Brad Cox, a member of that group, wrote the
Object-Oriented Pre-Compiler (OOPC), "that would translate a Smalltalk-like
syntax into C" [1]. Love and Cox then co-founded Productivity Products
International (PPI), later Stepstone, and "at PPI, Cox developed OOPC into
Objective-C" [1]. The paper's abstract gives no single year for the first
version of the language [1].

| Date | Milestone |
|---|---|
| Early 1980s | Brad Cox writes the Object-Oriented Pre-Compiler (OOPC) at ITT, in the research group led by Tom Love [1] |
| Early 1980s | Love and Cox co-found PPI (later Stepstone); Cox develops OOPC into Objective-C [1] |
| 1986 | Steve Naroff joins Stepstone, as NeXT uses Objective-C in its NeXTSTEP operating system [1] |
| 1988 | Naroff leaves Stepstone for NeXT and adds Objective-C support to the GNU GCC compiler [1] |
| 1994 | Stepstone folds, and NeXT acquires all rights to Objective-C [1] |
| 1997 | Apple acquires NeXT, and the rights pass to Apple [1] |
| 2008-03-06 | Apple releases the beta iPhone SDK, free to download [3] |
| 2009-08-28 | Mac OS X v10.6 Snow Leopard goes on sale [4] with Grand Central Dispatch (GCD) [4], which Snow Leopard integrates through "programming language extensions" [5]; blocks are available in GCC and Clang "as shipped with the OS X v10.6 Xcode developer tools" [6] |
| 2011-10-12 | Apple publishes the Transitioning to ARC Release Notes [8]: Automatic Reference Counting (ARC), supported in Xcode 4.2 for OS X v10.6 and v10.7 (64-bit applications) and for iOS 4 and iOS 5 [7] |
| 2014-06-02 | Apple releases the iOS 8 SDK with Swift, which "coexists with Objective-C code" [9] |

Naroff and others at Apple "added additional features to the language in
the late 2000s as the iPhone App Store greatly expanded Objective-C's user
base" [1].

## Design and paradigms

Objective-C is an **object-oriented** and **imperative** language. It "is
a strict superset of C" [10]: it "inherits the syntax, primitive types, and
flow control statements of C and adds syntax for defining classes and
methods" [2]. The language adds:

- **Smalltalk-style messaging**: method calls use square-bracket syntax
  (`[object method:]`) instead of dot notation. Messages are dynamically
  dispatched at runtime through the `objc_msgSend` function.
- **Dynamic typing**: objects can be declared as `id` (any type), and the
  runtime resolves the actual class at execution time. Apple describes the
  language as "providing dynamic typing and binding" [2].
- **Categories and extensions**: methods can be added to existing classes
  without subclassing. Naroff and others added categories and protocols at
  NeXT [1].
- **Protocols**: formal interfaces that define method contracts, similar to
  Java interfaces or Swift protocols.
- **Blocks**: "a C language extension for creating anonymous functions" [10],
  available since OS X v10.6 and iOS 4.0 [6].
- **Automatic Reference Counting (ARC)**: "a compiler feature that provides
  automatic memory management of Objective-C objects" [7]. Clang documents
  its full specification [10].

The runtime system (`libobjc`) handles object allocation, message dispatch,
and memory management. On macOS and iOS, this is the Apple Objective-C
runtime. On other platforms, GNUstep provides a compatible runtime.

## Market usage

Apple's archived guide teaches Objective-C together with "the framework
classes provided by Cocoa and Cocoa Touch" [2]. Swift, released with the
iOS 8 SDK in 2014, "coexists with Objective-C code, so developers can easily
integrate Swift into their existing apps" [9].

Outside Apple platforms, the [GNUstep] project offers frameworks whose core
"closely follows Apple's Cocoa APIs" [11]. Clang, the LLVM front end for
"languages in the C language family (C, C++, Objective C/C++, OpenCL, and
CUDA)", also compiles Objective-C [13].

## Importance

Objective-C brought Smalltalk-style objects to C programmers. Cox saw it as
"a crucial link in his larger vision of creating a market for
'pre-fabricated' software components ('software-ICs')" [1]. Through NeXT, it
"became the basis for Apple's Mac OS X and then iOS platforms" [1].

## Sources

1. The Origins of Objective-C at PPI/Stepstone and its Evolution at NeXT. Brad Cox, Steve Naroff and Hansen Hsu, HOPL IV. Program page with the paper's abstract. <https://hopl4.sigplan.org/details/hopl-4-papers/18/The-Origins-of-Objective-C-at-PPI-Stepstone-and-its-Evolution-at-NeXT> (accessed 2026-11-20)
2. Programming with Objective-C: About Objective-C. Apple Inc., Documentation Archive. <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html> (accessed 2026-11-20)
3. Apple Announces iPhone 2.0 Software Beta. Apple Inc., press release, 2008-03-06. <https://www.apple.com/newsroom/2008/03/06Apple-Announces-iPhone-2-0-Software-Beta/> (accessed 2026-11-20)
4. Apple to Ship Mac OS X Snow Leopard on August 28. Apple Inc., press release, 2009-08-24. <https://www.apple.com/newsroom/2009/08/24Apple-to-Ship-Mac-OS-X-Snow-Leopard-on-August-28/> (accessed 2026-11-20)
5. Apple Unveils Mac OS X Snow Leopard. Apple Inc., press release, 2009-06-08. <https://www.apple.com/newsroom/2009/06/08Apple-Unveils-Mac-OS-X-Snow-Leopard/> (accessed 2026-11-20)
6. Blocks Programming Topics: Introduction. Apple Inc., Documentation Archive. <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Blocks/Articles/00_Introduction.html> (accessed 2026-11-20)
7. Transitioning to ARC Release Notes. Apple Inc., Documentation Archive. <https://developer.apple.com/library/archive/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html> (accessed 2026-11-20)
8. Transitioning to ARC Release Notes: Document Revision History. Apple Inc., Documentation Archive. <https://developer.apple.com/library/archive/releasenotes/ObjectiveC/RN-TransitioningToARC/RevisionHistory.html> (accessed 2026-11-20)
9. Apple Releases iOS 8 SDK With Over 4,000 New APIs. Apple Inc., press release, 2014-06-02. <https://www.apple.com/newsroom/2014/06/02Apple-Releases-iOS-8-SDK-With-Over-4-000-New-APIs/> (accessed 2026-11-20)
10. Objective-C Automatic Reference Counting (ARC). Clang documentation, LLVM Project. <https://clang.llvm.org/docs/AutomaticReferenceCounting.html> (accessed 2026-11-20)
11. GNUstep. <https://www.gnustep.org/> (accessed 2026-11-20)
12. Objective-C on Wikipedia, used only as a pointer to the sources above. <https://en.wikipedia.org/wiki/Objective-C> (accessed 2026-11-20)
13. Clang. LLVM Project. <https://clang.llvm.org/> (accessed 2026-11-20)

[GNUstep]: https://www.gnustep.org/
