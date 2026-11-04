// Program.cs - C# web: an ASP.NET Core server that answers GET / with
// <p>Hello, World!</p>
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The server sends the finished HTML itself; there is no separate front
// end (compare ../web-angular, where the page is drawn by Angular).
//
// This is an ASP.NET Core "minimal API": like ../cli, the file uses
// top-level statements, so there is no class or Main method to write.

// The builder collects the app's settings and services (logging,
// configuration, the Kestrel web server) before the app is created.
// "var" lets the compiler infer the type (WebApplicationBuilder); C# is
// still statically typed, the same as "auto" in C++ or "var" in Java 10+.
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// MapGet connects the path "/" (HTTP GET only) to a handler. The handler
// is a lambda: "() => ..." is a function with no parameters, written in
// place, like Java's "() -> ..." or a C++ lambda.
// Results.Content sends the text as-is with the given Content-Type. A
// plain string return would be sent as text/plain, and the browser would
// show the tags instead of drawing a paragraph.
app.MapGet("/", () => Results.Content("<p>Hello, World!</p>", "text/html"));

// The port comes from PORT (default 8080); ./run.sh sets it.
// "??" returns the right side when the left side is null, so it gives the
// default when the variable is not set.
var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";

// Run starts Kestrel on the given URL and blocks until Ctrl+C. 127.0.0.1
// means this computer only: nobody else on the network can connect.
app.Run($"http://127.0.0.1:{port}");
