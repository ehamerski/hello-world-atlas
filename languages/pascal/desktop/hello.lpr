{ hello.lpr - Pascal desktop: the main program of the Lazarus project.

  Build and run it with ./build.sh and ./run.sh, which explain each step.
  ".lpr" means "Lazarus program": it is an ordinary Pascal program file.
  The window itself is described in mainunit.pas and mainunit.lfm; this
  file only starts the application. Lazarus writes a file like this when
  you create a new "Application" project. Its template also adds a few
  optional lines (thread support on Unix, display scaling, a taskbar
  setting for Windows); they are left out here to keep only what a Hello
  World needs.

  Compare ../cli/hello.pas: that program is ISO Standard Pascal. This one,
  like all Lazarus code, is Object Pascal (classes, units, long strings),
  the dialect of Delphi and of Free Pascal's "objfpc" mode. }
program hello;

{ Compiler directives: a comment that starts with a dollar sign, as on the
  next line, is an instruction to the compiler. "mode objfpc" selects Free
  Pascal's Object Pascal dialect, and "H+" makes "string" a long,
  reference-counted string (without it, a string is the old Turbo Pascal
  "shortstring" of at most 255 characters). }
{$mode objfpc}{$H+}

{ "uses" lists the units (modules) this program needs, like "import" in
  Java or Python.
  - Interfaces: connects the LCL to the operating system's own widgets
    (Cocoa on macOS, Win32 on Windows, GTK or Qt on Linux). The choice
    is made when compiling (lazbuild --ws=...), not in the code: that is
    how the same source builds on every platform.
  - Forms: the Application object and the TForm class.
  - MainUnit: the unit of this project that defines the window, in
    mainunit.pas. }
uses
  Interfaces, Forms, MainUnit;

begin
  { The LCL's usual three steps: prepare the application, create the main
    form (a "form" is a window), then run the event loop. Application.Run
    returns only when the main form is closed, like GTK's
    g_application_run in ../../c/desktop or tkinter's mainloop() in
    ../../python/desktop. }
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
