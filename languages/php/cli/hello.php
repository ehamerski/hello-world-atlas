<?php
/*
 * hello.php - PHP cli: print "Hello, World!" to the terminal.
 *
 * Run it with:  php hello.php   (or ./run.sh, which explains each step)
 *
 * PHP was made to be mixed into HTML pages, so the interpreter copies any
 * text it finds outside "<?php ... ?>" tags straight to the output. The
 * "<?php" tag on line 1 switches into PHP code. Python, Java or Go files
 * need no such tag: the whole file is code.
 *
 * This is a block comment, like C's and Java's. One-line comments start
 * with "//" (like C, Java, and Go) or "#" (like Python). Note: a one-line
 * comment ends at the PHP closing tag, so the closing tag is only written
 * inside this block comment, where it is safe.
 */

// echo writes text to standard output. It is a language construct, not a
// function, so the parentheses are optional and usually left out.
//
// Unlike Python's print() or Java's println, echo does NOT add a newline:
// the "\n" is written by hand, as with C's printf. In double quotes PHP
// turns "\n" into a newline; in single quotes it would print a backslash
// and an "n".
//
// The semicolon ends the statement, as in C and Java. Like Python, there is
// no main() function and no class: PHP runs the file from top to bottom.
echo "Hello, World!\n";

// There is no closing tag at the end of this file. The PHP manual recommends
// leaving it out when a file ends with PHP code: any blank line typed after
// the closing tag would be printed too.
