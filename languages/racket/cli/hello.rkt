#lang racket/base
; hello.rkt - Racket cli: print "Hello, World!" to the terminal.
;
; Run it with:  racket hello.rkt   (or ./run.sh, which explains each step)
;
; A line that starts with ";" is a comment. Scheme and Lisp use the same
; symbol; Python and Ruby use "#", and C, Java, and Go use "//".
;
; The first line, "#lang racket/base", says which language this file is written
; in. A Racket program file holds one module, and this line is a shorthand
; that reads the same as (module hello racket/base ...), where the module name
; comes from the file name (Racket Guide, section 6.2 "Module Syntax").
; racket/base is the smaller language; "#lang racket" is the normal, larger
; variant with more libraries. A Hello World needs only the smaller one.
;
; There is no main function and no import. Racket runs the module from top to
; bottom, as Ruby and Python run a file.
;
; (displayln "Hello, World!") is one expression. Racket writes every call in
; parentheses with the function first: (function argument ...). Other languages
; write function(argument), and Racket moves the function inside the parentheses.
; displayln prints its argument and then a newline, like Java's println and
; Ruby's puts, and unlike C's printf, which needs an explicit "\n".
; The string is printed without its quotation marks. (write would keep them.)
(displayln "Hello, World!")
