(* hello.lpr - Delphi-dialect desktop: Hello, World! in a window

   WHAT: opens one window whose title and label say Hello, World!. In verify
         mode (TF_VERIFY=1, set by run.sh --verify) it also prints the line
         and closes the window after about two seconds.
   WHY:  it shows the Delphi visual model in the Delphi dialect: a form is a
         class (TForm descendant), its components are objects, and events
         such as OnTimer are methods. The program is compiled by Free Pascal
         with the Lazarus Component Library (LCL).
   COMPROMISE: Delphi itself (Embarcadero, commercial, Windows) is NOT
         verified here. Lazarus 4.8 with Free Pascal 3.2.2 was used on the
         development machine (macOS Intel, Cocoa widgetset).
   Sources: Lazarus home page https://www.lazarus-ide.org/ ; Free Pascal
   User's Guide (compiler modes, Delphi mode):
   https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex
*)

program hello;

(* {$mode delphi} selects the Delphi dialect; {$H+} makes the String type
   a long string (AnsiString in Free Pascal) instead of a short one. *)
{$mode delphi}{$H+}

uses
  (* Interfaces must come first: it attaches the LCL to the widget set
     (Cocoa on macOS, GTK on Linux, Win32 on Windows). *)
  Interfaces, Classes, Forms, Controls, Graphics, StdCtrls, ExtCtrls, SysUtils;

type
  (* A form is a class that inherits from TForm, as in Delphi. *)
  TMainForm = class(TForm)
  private
    FGreeting: TLabel;
    FTimer: TTimer;
    (* An event handler is a method; it has the signature of TNotifyEvent. *)
    procedure CloseTimerFired(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  (* Always call the inherited constructor first: it builds the window itself. *)
  inherited Create(AOwner);
  Caption := 'Hello, World!';
  SetBounds(200, 200, 360, 160);
  Position := poScreenCenter;

  (* The label fills the form and centers its text. *)
  FGreeting := TLabel.Create(Self);
  FGreeting.Parent := Self;
  FGreeting.Align := alClient;
  FGreeting.Alignment := taCenter;
  FGreeting.Layout := tlCenter;
  FGreeting.Font.Size := 24;
  FGreeting.Caption := 'Hello, World!';

  (* TF_VERIFY=1 is set by run.sh --verify. Then the program prints the line
     and a timer closes the window, so verify-all.sh can finish by itself. *)
  if GetEnvironmentVariable('TF_VERIFY') = '1' then
  begin
    WriteLn('Hello, World!');
    FTimer := TTimer.Create(Self);
    FTimer.Interval := 2000;
    FTimer.OnTimer := CloseTimerFired;
  end;
end;

procedure TMainForm.CloseTimerFired(Sender: TObject);
begin
  (* Close closes this window; the application ends when its main form closes. *)
  Close;
end;

var
  MainForm: TMainForm;

begin
  (* Application starts the GUI system and owns every form.
     CreateForm makes MainForm; Run starts the event loop until the window closes. *)
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
