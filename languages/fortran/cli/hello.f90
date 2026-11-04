! hello.f90 - Fortran cli: print "Hello, World!" to the terminal.
!
! Build and run it with ./build.sh and ./run.sh, which explain each step.
! By hand (from the cli/ folder):
!   gfortran -std=f2008 -Wall -Wextra -o bin/hello-cli hello.f90
!   ./bin/hello-cli
!
! This is modern "free-form" Fortran: the ".f90" extension tells the
! compiler that a statement can start in any column. Older FORTRAN
! (".f" files, up to FORTRAN 77) used the fixed columns of punched cards,
! like the COBOL program in ../../cobol/cli. A comment starts with "!" and
! runs to the end of the line, like "//" in C99, Java, or Go.

! A main program starts with "program <name>" and ends with
! "end program <name>". The name is only a label: unlike C or Java, there
! is no function called "main". Fortran ignores case, so PROGRAM, Program,
! and program are the same word.
program hello
    ! "implicit none" switches off an old rule: without it, any undeclared
    ! name starting with I to N is an integer and any other is a real
    ! number, so a typo silently creates a new variable. This program
    ! has no variables, but the line belongs in every program.
    implicit none

    ! "print" writes to the standard output, adding the line break itself.
    ! The first item is the FORMAT: '(a)' means "one character string,
    ! as it is". The shorter "print *, ..." uses list-directed format
    ! (the compiler decides the layout), which starts the line with a
    ! blank, so it would print " Hello, World!" with a leading space.
    print '(a)', "Hello, World!"
end program hello
