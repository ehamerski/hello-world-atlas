{ mainunit.pas - Pascal desktop: the window (a "form") and its behaviour.

  A Lazarus form is split in two files with the same name:
  - mainunit.lfm describes WHAT is on the window: its title, size, the
    label and its properties. Lazarus' form designer writes it when you
    drag components onto a form; it is plain text, so you can read it.
  - mainunit.pas (this file) is the Pascal code: the class of the form and
    what happens on events (here: when the window is shown).
  The $R directive below links the two. }
unit MainUnit;

{$mode objfpc}{$H+}

{ A unit has two halves. The "interface" part is public: other units that
  "use" this unit see it. The "implementation" part is private. C splits
  the same idea into a header (.h) and a source (.c) file; Pascal keeps
  both halves in one file. }
interface

uses
  SysUtils,  { GetEnvironmentVariable }
  Forms,     { TForm }
  StdCtrls,  { TLabel }
  ExtCtrls;  { TTimer }

type
  { The window is a class that inherits from TForm ("class(TForm)").
    The fields below have the same names as the objects in mainunit.lfm:
    when the form is created, the LCL reads the .lfm file, builds the
    label and the timer, and stores them in these fields. }
  TMainForm = class(TForm)
    HelloLabel: TLabel;
    VerifyTimer: TTimer;
    { Event handlers. mainunit.lfm connects them by name:
      "OnShow = FormShow" and "OnTimer = VerifyTimerTimer". }
    procedure FormShow(Sender: TObject);
    procedure VerifyTimerTimer(Sender: TObject);
  end;

var
  { The one window of the program; hello.lpr creates it. }
  MainForm: TMainForm;

implementation

{ Put the form description, mainunit.lfm, into the executable as a
  resource. "*" stands for the name of this unit's file. }
{$R *.lfm}

{ Called when the window appears. In normal use it does nothing: the label
  in mainunit.lfm already shows "Hello, World!".
  Self-check used by ./run.sh --verify (and scripts/verify-all.sh): with
  TF_VERIFY=1, print the label's text and start a 2-second timer that
  closes the window. A reader running ./run.sh never sees this. }
procedure TMainForm.FormShow(Sender: TObject);
begin
  if GetEnvironmentVariable('TF_VERIFY') = '1' then
  begin
    WriteLn(HelloLabel.Caption);
    Flush(Output);  { print now, not when the program ends }
    VerifyTimer.Enabled := True;
  end;
end;

{ Called by the timer. Closing the main form ends Application.Run in
  hello.lpr, so the program exits. }
procedure TMainForm.VerifyTimerTimer(Sender: TObject);
begin
  Close;
end;

end.
