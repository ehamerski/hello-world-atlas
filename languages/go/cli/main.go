// main.go - Go cli: print "Hello, World!" to the terminal.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// By hand (from the cli/ folder):
//   go run .                      compile to a temporary file and run it
//   go build -o bin/hello-cli .   compile to bin/hello-cli, then ./bin/hello-cli

// Every Go file starts by naming its package. The package "main" is
// special: it is compiled into a program you can run, not into a library.
// Unlike Java, the folder does not have to repeat the package name, and
// there is no class around the code.
package main

// "fmt" (short for "format") is the standard library package for printed
// output. Go refuses to compile a file that imports a package it does not
// use; Java and Python accept unused imports.
import "fmt"

// The entry point. Go starts the program by calling main() in package main.
// It has no parameters and no return value, unlike C's int main(void) or
// Java's main(String[] args): command-line arguments are read from
// os.Args, and the exit code is set with os.Exit().
func main() {
	// Println prints its arguments and a line break to standard output.
	// It starts with a capital letter because only capitalized names are
	// visible outside their package (Go's replacement for "public").
	// No semicolon: Go's compiler adds them at the ends of lines for you.
	fmt.Println("Hello, World!")
}
