// hello.zig - Hello World in Zig 0.17.0.
//
// Build it with: zig build-exe hello.zig   (or ./build.sh, which writes build/hello)
// Zig is compiled ahead of time: the compiler turns this file into a native program.

// @import is a built-in function (names that start with @ belong to the compiler).
// "std" is the standard library. const binds the name once; it cannot change.
const std = @import("std");

// pub makes main visible outside this file, so the startup code can call it.
// init is the argument that the startup code passes to main. Its fields include io (an
// Io implementation), gpa and arena (allocators) and environ_map (environment variables)
// (lib/std/process.zig, struct Init in Zig 0.17.0). Nothing is hidden or global.
//
// !void means "returns nothing, or returns an error": the part before ! is the error
// set, and leaving it out lets the compiler work it out. Errors are values in Zig.
pub fn main(init: std.process.Init) !void {
    // std.Io.File.stdout() is the standard output file.
    // writeStreamingAll writes every byte of the text, and it takes init.io as an argument:
    // Zig makes you pass the Io value, so every place that does input or output is visible.
    // "\n" is the newline character. Zig does not add one for you.
    //
    // try returns the error from main if the write fails. The "try" keyword is the
    // only error handling here, and it is visible: no hidden control flow.
    // std.debug.print writes to standard error (stderr), not standard output (stdout).
    // This program uses stdout, so a pipe such as ./run.sh | cat receives the line.
    try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, World!\n");
}
