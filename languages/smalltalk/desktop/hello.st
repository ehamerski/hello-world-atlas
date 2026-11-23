"hello.st - Smalltalk desktop: a Morphic window with a greeting.

WHAT: opens a window titled 'Hello World' showing Hello, World using
      Pharo's Morphic UI toolkit.
WHY:  Morphic is Pharo's retained-mode GUI framework, descended from the
      original Self Morphic system. Every UI element is a Morph - an object
      that knows how to draw itself and respond to events [1].
      SystemWindow is the standard titled window class in Pharo 14 [2].
HOW:  Called by run.sh:
        pharo-ui Pharo.image st hello.st
      Self-check: when the TF_VERIFY environment variable is 1, the window
      still opens, the greeting is also printed to stdout, and Pharo quits
      after about 2 seconds without saving the image.

Sources:
  [1] Morphic reference. Pharo consortium. https://pharo.org/documentation
  [2] Pharo by Example 5. Pharo consortium (2024).
      https://books.pharo.org/pharo-by-example/

Note: Pharo .st files use chunk format in which ASCII 33 (exclamation mark)
ends a code chunk. The greeting string is built by concatenation so the
literal character does not terminate the chunk prematurely.
"

| greeting window text bang |

" Build the greeting string. The exclamation mark (ASCII 33) is added by
  concatenation to avoid the chunk-format parser treating it as a separator. "
bang := (Character value: 33) asString.
greeting := 'Hello, World', bang.

" Create a titled window using SystemWindow, the standard window class in Pharo. "
window := SystemWindow labelled: 'Hello World'.

" Create a TextMorph to display the greeting.
  TextMorph is a Morph that shows editable or read-only text. "
text := TextMorph new.
text contents: greeting.

" Add the TextMorph to the window's content area. Morphic uses a tree of
  Morphs: each Morph can hold sub-Morphs. addMorph:frame: places it below the
  title bar; the frame (0@0 corner: 1@1) is a fraction of that area, here all
  of it. addMorphBack: alone would draw the text over the title bar. "
window addMorph: text frame: (0 @ 0 corner: 1 @ 1).

" Open the window in the Morphic World (the main display surface).
  After this call, Pharo's event loop keeps the window alive until closed. "
window openInWorld.

" Self-check (TF_VERIFY=1): print the greeting, then quit after ~2 s.
  OSEnvironment reads the process environment. fork runs the block in its own
  process, so the window is drawn while it waits. snapshot: false quits without
  saving the image. "
(OSEnvironment current at: 'TF_VERIFY' ifAbsent: [nil]) = '1' ifTrue: [
	Stdio stdout nextPutAll: greeting; lf; flush.
	[ (Delay forSeconds: 2) wait.
	  Smalltalk snapshot: false andQuit: true ] fork ].
