#!/usr/bin/env bash
# hello.sh - Bash cli: print "Hello, World!" to the terminal.
#
# Run it with:  bash hello.sh   (or ./run.sh, which explains each step)
#
# The first line is the shebang. When the operating system runs this file as a
# program (./hello.sh), it reads "#!" and starts the interpreter named after it.
# "/usr/bin/env bash" finds the first bash on your PATH, so a newer Bash
# installed by Homebrew is used when you have one.
# Any other line that starts with "#" is a comment: the shell ignores the "#"
# and the rest of that line.
#
# The install and run scripts of this repository are POSIX sh ("#!/bin/sh").
# This file is Bash. POSIX sh is the common core that every shell offers; Bash
# adds features on top of it (arrays, [[ ]], and more). This program uses only
# printf, which both languages have, so it also runs under sh.

# printf is a shell builtin: it runs inside the shell and needs no import.
# Its first argument is the format. printf prints it as written, except for
# escape sequences such as \n (newline). Unlike Python's print or Ruby's puts,
# printf never adds a newline for you, so the format ends with \n.
# Single quotes preserve the literal value of every character inside them, so
# the shell passes the text to printf unchanged.
# echo would also work here, but its handling of options and backslashes
# differs between shells, so POSIX recommends printf for new programs.
printf 'Hello, World!\n'
