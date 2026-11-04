algoritmo "OlaMundo"
// ola-mundo.alg - Hello World in Portugol, VisuAlg dialect (Portuguese keywords)
//
// Every VisuAlg program starts with the keyword algoritmo ("algorithm") and
// its name in double quotes. It must be the first line (the Delégua
// interpreter used by run.sh rejects even a comment before it). There is no main
// function, no import and no class: the commands between inicio and
// fimalgoritmo run from top to bottom.
// Comments start with // and run to the end of the line, as in C++ or Java.
// Keywords are case-insensitive: ALGORITMO, Algoritmo and algoritmo are the same.

// var ("variables") opens the section where every variable must be declared
// with its type before inicio, as in Pascal. This program needs none, so
// the section is empty.
var

// inicio ("start") marks where the commands begin, like Pascal's begin.
inicio
   // escreval ("write line") prints its value and then a line break, like
   // Python's print. escreva (without the l) prints without the line break.
   escreval("Hello, World!")
// fimalgoritmo ("end algorithm") closes the program, like Pascal's end.
fimalgoritmo
