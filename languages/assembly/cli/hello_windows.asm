; hello_windows.asm - Assembly (x86-64) cli for Windows: print "Hello, World!".
;
; The same idea as hello.asm (macOS): call the C library's write() and let
; the C runtime start and end the program. build.sh picks this file on
; Windows (Git Bash with MSYS2's NASM and gcc). By hand (from the cli/ folder,
; in an MSYS2 UCRT64 shell):
;   nasm -f win64 -o bin/hello.o hello_windows.asm
;   gcc -o bin/hello-cli bin/hello.o
;   ./bin/hello-cli
;
; What differs from the macOS file:
;  - The object format is COFF for 64-bit Windows ("-f win64"; NASM manual,
;    9.6 win32, win64: https://www.nasm.us/doc/nasm09.html#section-9.6).
;  - C names have no leading underscore on 64-bit Windows: main and write.
;  - The Microsoft x64 calling convention passes the first four integer
;    arguments in RCX, RDX, R8 and R9 (not RDI, RSI, RDX), and the caller
;    must reserve 32 bytes of "shadow space" above the return address for
;    the callee to spill them
;    (https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention).
;  - Stack alignment: on entry to main, RSP is 8 bytes past a 16-byte
;    boundary (the return address). "sub rsp, 40" reserves the 32 bytes of
;    shadow space plus 8 bytes that restore the 16-byte alignment that
;    every "call" requires.

        default rel
        global  main
        extern  write

        section .data
message:
        db      "Hello, World!", 10
message_len equ $ - message

        section .text
main:
        sub     rsp, 40             ; shadow space (32) + alignment (8)
        mov     ecx, 1              ; 1st argument (RCX): fd 1 = standard output
        lea     rdx, [message]      ; 2nd argument (RDX): address of the text
        mov     r8d, message_len    ; 3rd argument (R8): 14 bytes
        call    write               ; write(1, message, 14) in the C library
        xor     eax, eax            ; main returns 0 = success
        add     rsp, 40             ; give the stack back
        ret
