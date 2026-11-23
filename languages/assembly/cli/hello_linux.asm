; hello_linux.asm - Assembly (x86-64) cli for Linux: print "Hello, World!".
;
; The same program as hello.asm (macOS), changed only where Linux differs.
; build.sh picks this file on Linux. By hand (from the cli/ folder):
;   nasm -f elf64 -o bin/hello.o hello_linux.asm
;   cc -o bin/hello-cli bin/hello.o
;   ./bin/hello-cli
;
; What differs from the macOS file:
;  - The object format is ELF ("-f elf64"), not Mach-O, so there is no
;    "build_version" line (NASM manual, 9.2 elf32, elf64, elfx32:
;    https://www.nasm.us/doc/nasm09.html#section-9.2).
;  - C names have no leading underscore on Linux: main and write, not
;    _main and _write.
;  - Linux programs are position independent by default, so a call into
;    another library goes through the procedure linkage table (PLT):
;    "wrt ..plt" asks the linker for that entry (NASM manual, 9.2.5).
;  - A ".note.GNU-stack" section tells the linker that this program does not
;    need an executable stack; without it newer linkers print a warning.
; The calling convention (System V AMD64 ABI) is the same as on macOS, so the
; instructions are identical. See hello.asm for the comments on each of them.

        default rel
        global  main
        extern  write

        section .data
message:
        db      "Hello, World!", 10
message_len equ $ - message

        section .text
main:
        push    rbp                 ; realign the stack to 16 bytes for the call
        mov     edi, 1              ; 1st argument: fd 1 = standard output
        lea     rsi, [message]      ; 2nd argument: address of the text
        mov     edx, message_len    ; 3rd argument: 14 bytes
        call    write wrt ..plt     ; write(1, message, 14) in the C library
        xor     eax, eax            ; main returns 0 = success
        pop     rbp
        ret

        section .note.GNU-stack noalloc noexec nowrite progbits
