(* hello.pas - Delphi-dialect cli: Hello, World!

   WHAT: prints one line, Hello, World!, and stops.
   WHY:  it is the smallest Delphi-style program. The directive {$mode delphi}
         asks Free Pascal (FPC) to accept Delphi's language rules, so this
         file is written in the Delphi dialect and compiled by FPC.
   COMPROMISE: Delphi itself (Embarcadero, commercial, Windows) is NOT
         verified here. Only FPC 3.2.2 was used on the development machine.
   Source for the {$mode delphi} directive: Free Pascal User's Guide,
   "compiler modes", https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex

*)

(* A program in Pascal starts with the word program and a name. The name
   matches the file (hello.pas), as is usual. *)
program hello;

(* {$mode delphi} selects Delphi-compatible rules, for example Delphi's
   class and exception behavior. Without it, FPC uses its own default mode. *)
{$mode delphi}

(* WriteLn writes its arguments and then a line end. The text goes in single
   quotes: in Delphi and in Free Pascal a double-quoted string is not a Pascal string. *)
begin
  WriteLn('Hello, World!');
end.
