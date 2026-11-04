// Program.cs - C# web-angular (backend): an ASP.NET Core API that answers
// GET /api/hello with the JSON {"message":"Hello, World!"}.
//
// Unlike ../../web, this server sends no HTML at all. The page is built in
// the browser by the separate Angular front end (../frontend), which calls
// this API and shows the message. Build and run both with ../build.sh and
// ../run.sh.

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// The handler returns a Greeting object, not a string. ASP.NET Core writes
// any returned object as JSON ("Content-Type: application/json"), using
// System.Text.Json, which comes with .NET. Property names are written in
// camelCase by default, so Message becomes "message". The /api prefix keeps
// the API's paths apart from the front end's pages.
app.MapGet("/api/hello", () => new Greeting("Hello, World!"));

// The API's port comes from PORT (default 8080). ../run.sh sets it, and
// ../frontend/proxy.conf.js reads the same variable for its proxy.
var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";
app.Run($"http://127.0.0.1:{port}");

// A record is a class that only carries data. This one line gives Greeting
// a constructor, a read-only Message property, equality and ToString().
// It is the same idea as the Java record in ../../../java/web-react.
// With top-level statements, type declarations must come after the code.
record Greeting(string Message);
