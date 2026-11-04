' hello.bas - BASIC cli: print "Hello, World!" to the terminal.
'
' Build and run it with ./build.sh and ./run.sh, which explain each step.
' By hand (from the cli/ folder):
'   qb64pe -x -q -w hello.bas -o bin/hello-cli
'   ./bin/hello-cli
'
' This file is QBasic / QuickBASIC 4.5 BASIC, Microsoft's BASIC for MS-DOS
' PCs, compiled with QB64 Phoenix Edition. Only
' the first line below is QB64-specific: it makes the program a plain
' terminal (console) program.
'
' A line that starts with an apostrophe is a comment, like "//" in C or
' "#" in Python. The older keyword REM ("remark") still works too:
' REM This is a comment.

' $CONSOLE:ONLY is a QB64 "metacommand": an instruction to the compiler,
' not to the program, a little like #include in C. QB64 programs normally
' open their own window, as QBasic did on the whole MS-DOS screen; :ONLY
' turns that window off so PRINT writes to the terminal instead.
' QB64 metacommands are not written inside a comment, unlike QuickBASIC's
' own '$DYNAMIC or '$INCLUDE.
$CONSOLE:ONLY

' There is no "main" function, no header, and no declarations: unlike C, Java
' or Pascal, a BASIC program runs its statements from top to bottom.
' PRINT writes the text and then a line break, like Python's print.
' (Typing ? in the QB64 editor is a shortcut that turns into PRINT.)
' Strings use double quotes. BASIC ignores case: print and PRINT are the same.
PRINT "Hello, World!"

' SYSTEM ends the program at once and returns to the operating system.
' Without it, or with END, QB64 prints "Press enter to continue" and waits
' for a key before it exits.
SYSTEM
