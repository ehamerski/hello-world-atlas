// Program.cs - C# cli: print "Hello, World!" to the terminal.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// By hand (from the cli/ folder):
//   dotnet build -c Release
//   dotnet bin/Release/net10.0/hello-cli.dll
//
// The whole program is one line. This is a "top-level statement" (C# 9 and
// later): the compiler wraps it in a class with a Main method for you.
// Before C# 9, and still in many code bases, the same program reads:
//
//   using System;
//
//   class Program
//   {
//       static void Main()
//       {
//           Console.WriteLine("Hello, World!");
//       }
//   }
//
// That is almost exactly ../../java/cli: in Java and (classic) C#, every
// function must live inside a class, even main.

// Console is a class from the System namespace. "using System;" is not
// written here because ImplicitUsings in hello-cli.csproj adds it to every
// file. WriteLine is a static method: it is called on the class itself, no
// object is created. It prints the text and then a line break, so no "\n"
// is needed (unlike C's printf or C++'s std::cout).
Console.WriteLine("Hello, World!");
