* hello.prg - dBASE III Plus cli: Hello, World!
*
* WHAT: prints one line, Hello, World!, and stops.
* WHY:  it shows the dBASE command style. A .prg file is a list of commands
*       that run from top to bottom, and ? and ?? write text to the screen.
*       ?  starts a new line first, then writes its text.
*       ?? writes its text at the current position, with no new line.
*       A bare ? then ends the line, so the output is exactly one line.
* COMPROMISE: dBASE III Plus is proprietary DOS software (Ashton-Tate, later
*       Borland). This file is written in dBASE III-compatible syntax and is
*       run here with Harbour 3.2.0, an open-source xBase compiler. The
*       original runs on DOS; students who own a licence can use DOSBox (README).
* Sources: ? and ??, Harbour Reference Guide (Clipper 5.3),
*          https://harbour.github.io/doc/clc53.html ;
*          Ashton-Tate and Borland, J.-P. Martel, A personal History of dBASE,
*          https://www.dbase.com/Knowledgebase/dbulletin/bu03hist.htm

?? "Hello, World!"
?
RETURN
