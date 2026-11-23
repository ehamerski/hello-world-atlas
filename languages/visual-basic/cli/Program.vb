' Program.vb — Visual Basic · cli: Hello, World!
'
' WHAT: simplest VB.NET console program that prints "Hello, World!" to
'       standard output.
' WHY:  demonstrates VB.NET's module structure, the Sub Main entry point,
'       and Console.WriteLine for output. VB.NET runs on the .NET runtime
'       and is compiled to Common Intermediate Language (CIL).
'
' Visual Basic .NET (VB.NET) followed Visual Basic 6.0 (VB6). Support for
' the VB6 IDE ended on 2008-04-08; the VB6 runtime is still supported on
' supported Windows versions. VB.NET is an object-oriented language that
' runs on .NET.
' Sources: https://learn.microsoft.com/previous-versions/visualstudio/visual-basic-6/visual-basic-6-support-policy
'          https://learn.microsoft.com/dotnet/visual-basic/

Module Program

    ' Sub Main is the entry point of a VB.NET console application.
    Sub Main()
        Console.WriteLine("Hello, World!")
    End Sub

End Module
