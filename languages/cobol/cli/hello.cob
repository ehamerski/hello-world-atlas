      *****************************************************************
      * hello.cob - COBOL cli: print "Hello, World!" to the terminal.
      *
      * Build and run it with ./build.sh and ./run.sh, which explain
      * each step. By hand (from the cli/ folder):
      *   cobc -x -std=cobol85 -Wall -o bin/hello-cli hello.cob
      *   ./bin/hello-cli
      *
      * This file uses the traditional FIXED format of COBOL-85, the
      * layout of 80-column punched cards. Every column has a job:
      *   1-6   sequence number (card number; left blank here)
      *   7     indicator: "*" makes the whole line a comment
      *   8-11  Area A: division, section and paragraph names start here
      *   12-72 Area B: statements go here
      *   73-80 reference area: ignored by the compiler
      * So this comment starts with "*" in column 7. GnuCOBOL also reads
      * free format (cobc -free), with no column rules, like C or Go.
      *****************************************************************

      * A COBOL program is split into DIVISIONS, always in this order.
      * The IDENTIFICATION DIVISION names the program.
      * Words are in upper case by tradition: the compiler does not
      * care about case.
       IDENTIFICATION DIVISION.
      * PROGRAM-ID gives the program its name, like the class name in
      * Java. Every sentence and header ends with a period.
       PROGRAM-ID. HELLO.

      * The ENVIRONMENT DIVISION (computer, files) and the DATA DIVISION
      * (variables) are left out: this program has no files and no
      * variables. Real programs usually declare their data there.

      * The PROCEDURE DIVISION holds the code that runs. Execution
      * starts at its first statement: there is no "main" function.
       PROCEDURE DIVISION.
      * DISPLAY writes its operands to the standard output, followed by
      * a line break (like Python's print, unlike C's printf). The
      * statement reads almost like English, which was a design goal.
           DISPLAY "Hello, World!".
      * STOP RUN ends the program and returns control to the operating
      * system (here with exit status 0, "success").
           STOP RUN.
