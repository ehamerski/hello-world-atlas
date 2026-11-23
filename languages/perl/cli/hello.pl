# hello.pl - Perl cli: print "Hello, World!" and exit.
#
# Run it with:  perl hello.pl   (or ./run.sh, which explains each step)
#
# Perl is interpreted: the "perl" program reads this file and runs it
# top to bottom, with no separate compile step (like Python and Ruby).

# "use strict" makes Perl refuse some risky code, such as using a variable
# that was never declared. "use warnings" prints a message when something
# looks like a mistake. Both are the usual first lines of a Perl program;
# without them Perl accepts a typo in a variable name silently.
use strict;
use warnings;

# print writes its argument to standard output. Perl has no main function:
# the statements in the file run in order, so this is the whole program.
# "\n" is the newline. Unlike Python's print() and Ruby's puts, Perl's
# print adds nothing by itself, so the newline is written explicitly (as
# in C's printf). Strings in double quotes understand "\n"; the
# statement ends with a semicolon, as in C and Java.
print "Hello, World!\n";
