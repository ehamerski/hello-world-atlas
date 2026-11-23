# Smalltalk

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented [1]

See also: [paradigms](../../docs/paradigms.md#object-oriented)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | GNU Smalltalk (gst) | ✅ |
| desktop | [desktop/](desktop/) | Pharo 14, Morphic | ✅ |
| web | [web/](web/) | Pharo 14, Zinc HTTP | ✅ |

## History

Smalltalk was created at Xerox PARC by Alan Kay's Learning Research Group, with Dan Ingalls, Adele Goldberg and others. Kay's history dates the first real Smalltalk (Smalltalk-72) to 1972–76 and the release version, Smalltalk-80, to 1980–83 [2]. It was the first language to provide a fully object-oriented programming environment, including an integrated development environment (IDE) with a graphical user interface, all running inside a single virtual machine [3]. Smalltalk-80 was the release version of Smalltalk, developed between 1980 and 1983 [2].

Dan Ingalls' 1997 keynote at OOPSLA, "The Best Ideas in Smalltalk," demonstrated the power of the Smalltalk environment and is considered one of the most influential presentations in programming language history [4].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1972 | Smalltalk-72, the first version, created at Xerox PARC | [2] |
| 1980 | Work on Smalltalk-80, the release version, begins (it runs to 1983) | [2] |
| 1996 | Squeak 3.0, a free, open-source Smalltalk implementation | [5] |
| 2005 | GNU Smalltalk 2.0, the free GNU implementation | [6] |
| 2008 | Pharo 1.0, a modern, open-source Smalltalk environment | [7] |
| 2013 | Pharo 3.0 with improved tooling and VM | [7] |
| 2022 | Pharo 12 with modern VM and tooling | [7] |

## Market usage today

Smalltalk is no longer among the most widely used languages in industry. The TIOBE Index, November 2026, does not list Smalltalk in the top 50, and its list of positions 51 to 100 does not name it either [8]. However, it remains important in education and research, and the Pharo community is active. Smalltalk's influence is visible in Ruby, JavaScript, Python, and many other languages that adopted its object-oriented concepts, messaging model, and integrated development environment [9].

## Importance then and now

Smalltalk introduced concepts that are now standard in software development: objects as the fundamental unit of computation, message passing as the primary form of communication, a live development environment, and an integrated debugger and inspector [3]. Its influence extends far beyond its direct usage: Ruby's syntax and philosophy, JavaScript's prototype model, and the concept of an IDE all trace back to Smalltalk [9].

Today, Smalltalk is primarily used in education, research, and niche domains. Pharo continues to evolve as a modern Smalltalk environment, with active development in areas such as visual programming, data visualization, and educational tooling [7].

## Comparing the categories

The cli version uses GNU Smalltalk (gst), which can run `.st` scripts from the command line. It is the simplest way to run Smalltalk code without loading an image. The desktop and web versions use Pharo, which is an image-based system. In Pharo, the code runs inside a running Smalltalk image that contains the entire environment, including the Morphic UI toolkit (desktop) and Zinc HTTP Components (web). The image-based model is fundamentally different from the script-based model of GNU Smalltalk.

## Why there is no Flutter desktop

Dart desktop support is handled by Flutter, which requires Xcode on macOS. The Smalltalk desktop version uses Pharo's Morphic toolkit instead, which is part of the Pharo image and does not require external toolchains.

## Sources

1. Smalltalk-80: The Language. Goldberg, A. and Robson, D. Addison-Wesley, 1983. <https://archive.org/details/smalltalk-80> (accessed 2026-11-06)
2. The Early History of Smalltalk. Alan C. Kay. ACM SIGPLAN Notices 28(3), 1993 (HOPL-II). <https://worrydream.com/EarlyHistoryOfSmalltalk/> (accessed 2026-11-17)
3. The Best Ideas in Smalltalk. Dan Ingalls, OOPSLA 1997 keynote. <https://www.youtube.com/watch?v=SFU2bHuXnkk> (accessed 2026-11-06)
4. The Best Ideas in Smalltalk (transcript). Dan Ingalls. <https://www.squeakfoundation.org/the-best-ideas-in-smalltalk> (accessed 2026-11-06)
5. Squeak. Squeak Foundation. <https://squeak.org> (accessed 2026-11-06)
6. GNU Smalltalk. GNU Project. <https://www.gnu.org/software/smalltalk/> (accessed 2026-11-06; archived copy: <https://web.archive.org/web/20261103070437/http://www.gnu.org/software/smalltalk/>, accessed 2026-11-22)
7. Pharo. Pharo Project. <https://pharo.org> (accessed 2026-11-06)
8. TIOBE Index for November 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-20)
9. Influence of Smalltalk. Wikipedia. <https://en.wikipedia.org/wiki/Smalltalk#Influence> (accessed 2026-11-06)
