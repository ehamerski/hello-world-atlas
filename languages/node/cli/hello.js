// hello.js - Node.js cli: print "Hello, World!" to the terminal.
//
// Run it with:  node hello.js   (or ./run.sh, which explains each step)
//
// Lines that start with "//" are comments, as in C, Java and Go. Python
// uses "#" instead.

// console is a global object: Node.js provides it in every file, so nothing
// has to be imported first (Python's print() is also always there; C needs
// "#include <stdio.h>" for printf). The same console.log works in a web
// browser, where it writes to the browser's developer console instead.
//
// Node.js runs a file from top to bottom, like Python, so this single line
// IS the whole program: no main() function and no class, unlike C, Java or
// Go. The ";" ends the statement; JavaScript would insert it for you if it
// were missing, but writing it is the common style.
//
// console.log() writes the text and then a newline ("\n") to standard
// output, like Python's print() and Java's println.
console.log("Hello, World!");
