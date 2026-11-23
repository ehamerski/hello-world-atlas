"
hello.st - Smalltalk cli: the simplest complete GNU Smalltalk program

WHAT: prints Hello, World! to standard output.
WHY:  Smalltalk is a pure object-oriented language. Every value is an
      object, and every operation is a message send. This program
      sends the #displayNl message to the String literal.
HOW:  gst hello.st

GNU Smalltalk (gst) is the free implementation of Smalltalk maintained
by the GNU Project. It supports the standard Smalltalk dialect and can
run scripts from the command line.
Reference: www.gnu.org/software/smalltalk/

Comments in Smalltalk: a string literal that is not assigned to a
variable acts as a comment. The string is delimited by the double-quote
character. This is the traditional Smalltalk comment style, used since
Smalltalk-80. Multi-line comments are a single string spanning lines.
Reference: Goldberg and Robson, Smalltalk-80: The Language and Its
Implementation (the Blue Book), 1983.
"

" Print Hello, World! followed by a carriage return and newline."
'Hello, World!' displayNl
