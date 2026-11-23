' Program.vb — Visual Basic · web: Hello, World!
'
' WHAT: minimal ASP.NET Core web API in VB.NET that serves "Hello, World!"
'       at http://localhost:8080/ (or the port in the PORT environment variable)
' WHY:  shows a VB.NET program that serves HTTP with ASP.NET Core minimal
'       APIs. The .NET SDK has no VB.NET web template, so the project
'       file is hand-written.
'
' ASP.NET Core minimal APIs were added in .NET 6 and serve HTTP without
' controllers or a startup class. This program uses the WebApplication class.
' Sources: https://learn.microsoft.com/aspnet/core/release-notes/aspnetcore-6.0
'          https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis

Imports System
Imports Microsoft.AspNetCore.Builder

Module Program

    Sub Main(args As String())
        ' Create the web application builder and configure it.
        ' WebApplication.CreateBuilder is the entry point for minimal APIs.
        Dim builder = WebApplication.CreateBuilder(args)

        ' Build the application from the builder.
        Dim app = builder.Build()

        ' Map a GET request at "/" to return "Hello, World!"
        ' This is equivalent to app.MapGet("/", () => "Hello, World!") in C#.
        app.MapGet("/", Function() "Hello, World!")

        ' Listen on localhost. The port comes from PORT (default 8080), the
        ' convention of this repository (CONTRIBUTING.md, script contract).
        Dim port = Environment.GetEnvironmentVariable("PORT")
        If String.IsNullOrEmpty(port) Then port = "8080"
        app.Urls.Add("http://localhost:" & port)

        ' Start the server (blocks until the process is stopped).
        app.Run()
    End Sub

End Module
