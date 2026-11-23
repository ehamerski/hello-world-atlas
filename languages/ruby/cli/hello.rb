# hello.rb - Ruby cli: print "Hello, World!" to the terminal.
#
# Run it with:  ruby hello.rb   (or ./run.sh, which explains each step)
#
# Lines that start with "#" are comments: Ruby ignores them. Python and
# Perl use the same symbol; C, Java, and Go write "// ..." instead.

# puts is a method of the Kernel module, which every Ruby object can call, so
# nothing has to be imported first. In C, "#include <stdio.h>" is needed to
# use printf, and in Java, System.out.println is called from inside a class.
#
# Ruby runs a file from top to bottom, so this single line IS the whole
# program. There is no main() entry point, no class, and no semicolon, unlike
# C, Java, or C#. The parentheses around the argument are optional in Ruby;
# Python 3's print("...") requires them.
#
# puts writes the text and then a newline ("\n") unless the text already ends
# with one, like Java's println and unlike C's printf, which needs an
# explicit "\n".
puts "Hello, World!"
