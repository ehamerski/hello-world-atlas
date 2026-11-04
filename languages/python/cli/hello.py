# hello.py - Python cli: print "Hello, World!" to the terminal.
#
# Run it with:  python3 hello.py   (or ./run.sh, which explains each step)
#
# Lines that start with "#" are comments: Python ignores them. C, Java, and
# Go write comments as "// ..." instead.

# print() is a built-in function: it is always available, so nothing has to
# be imported first. In C, "#include <stdio.h>" is needed to use printf, and in
# Java, System.out.println is called from inside a class.
#
# Python runs a file from top to bottom, so this single line IS the whole
# program. There is no main() entry point, no class, and no semicolon, unlike
# C, Java, or C#.
#
# print() writes the text and then a newline ("\n"), like Java's println
# and unlike C's printf, which needs an explicit "\n".
print("Hello, World!")
