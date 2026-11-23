// hello.fs - F# cli: print "Hello, World!" to the terminal.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// By hand (from the cli/ folder):
//   dotnet build hello.fsproj -o build
//   dotnet build/hello.dll

// F# is a language of the .NET family, like C# and VB.NET. The compiler turns
// this file into Common Intermediate Language (CIL), the same kind of code
// that the C# and VB.NET compilers write, so the .NET runtime runs all three.

// A file of an executable can hold statements at the top level. The compiler
// runs them from the first line to the last, and this is the entry point:
// there is no Main method and no class to declare. The compiler wraps the
// file in a module named Hello, after the file name. VB.NET, by contrast,
// needs "Module" and "Sub Main" in the source.
// Source: https://learn.microsoft.com/dotnet/fsharp/language-reference/modules
// The file must be the last one that hello.fsproj lists.
// F# also has an explicit entry point: [<EntryPoint>] on a function that
// takes the arguments and returns the exit code.
// Source: https://learn.microsoft.com/dotnet/fsharp/language-reference/functions/entry-point

// printfn writes the text and then a line break to standard output. The
// "f" is for "format": the compiler checks the format string against the
// arguments, for example %s against a string.
// The call has no parentheses and no semicolon: F# applies a function to
// the value that follows it, and a line break ends a statement.
// Strings use double quotes, as in C, Java and C#.
printfn "Hello, World!"
