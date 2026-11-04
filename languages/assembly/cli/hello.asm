; hello.asm - Assembly (x86-64) cli: print "Hello, World!" to the terminal.
;
; Build and run it with ./build.sh and ./run.sh, which explain each step.
; By hand (from the cli/ folder, on an Intel Mac):
;   nasm -f macho64 -o bin/hello.o hello.asm   ; assemble: text -> object file
;   cc -o bin/hello-cli bin/hello.o            ; link with the C library
;   ./bin/hello-cli
;
; Target: x86-64 (AMD64) CPU, macOS, Mach-O object format. Assembly is
; machine-specific: this file does NOT work on an Apple Silicon (arm64) Mac
; or on Linux without changes (see README.md, "Platform notes").
;
; Syntax: NASM, which uses Intel syntax: "mov destination, source".
; Comments start with ";" and run to the end of the line.
;
; Unlike every other folder in this repository, there is no "print"
; statement here. Each line below is one CPU instruction (or a directive to
; the assembler), and the program asks the C library function write() to do
; the output, exactly as a compiled C program would.

; ----------------------------------------------------------- directives ---
; Directives are orders to the assembler, not CPU instructions.

        ; Record the target platform (macOS, minimum version 11.0) in the
        ; object file. Apple's linker expects this "build version" in every
        ; object; without it, it warns "no platform load command found ...
        ; assuming: macOS". (The executable gets the version that cc passes
        ; to the linker, the current macOS by default, not this one.)
        build_version macos, 11, 0

        ; Make [label] mean "label relative to the instruction pointer (RIP)":
        ; data is found by its distance from the code, not by a fixed
        ; address, so the program works wherever it is loaded in memory.
        ; Without this line NASM stops with "Mach-O 64-bit format does not
        ; support 32-bit absolute addresses".
        default rel

        ; "global" exports a symbol so the linker can see it. _main is the
        ; entry point the C runtime calls, like main() in C. On macOS, C
        ; names get a leading underscore in object files: C's main is _main.
        global  _main

        ; "extern" declares a symbol defined somewhere else: write() lives
        ; in libSystem, macOS's C library. The linker connects the two.
        extern  _write

; ------------------------------------------------------------- the data ---
; A section groups bytes of the same kind. .data holds initialized data.
        section .data

        ; "message" is a label: a name for the address of the next byte.
        ; db ("define bytes") emits the 13 ASCII characters, then the byte
        ; 10, the line feed ("\n" in C). Nothing adds a terminating zero:
        ; write() takes a length, so none is needed.
message:
        db      "Hello, World!", 10

        ; equ defines a constant at assembly time; no memory is used.
        ; "$" is the current address, so $ - message = 14 bytes.
message_len equ $ - message

; ------------------------------------------------------------- the code ---
; .text holds the machine instructions. The operating system maps it
; read-only and executable.
        section .text

; The C runtime calls _main like a C function: it pushes the return address
; and jumps here. On entry the stack pointer RSP is 8 bytes past a 16-byte
; boundary (the pushed return address), and the routine must end with "ret".
_main:
        ; The calling convention (System V AMD64 ABI, which macOS follows)
        ; requires RSP to be a multiple of 16 at every "call". Pushing one
        ; 8-byte register restores that alignment. RBP is "callee-saved",
        ; so it must be given back unchanged: it is popped at the end.
        push    rbp

        ; write(int fd, const void *buf, size_t nbyte) needs 3 arguments.
        ; The ABI passes integer arguments in registers, in this order:
        ; RDI, RSI, RDX, RCX, R8, R9. Unlike C, nothing checks the types.

        ; 1st argument, fd = 1: file descriptor 1 is standard output.
        ; Writing EDI (the low 32 bits of RDI) also zeroes the upper 32 bits,
        ; and the instruction is shorter than "mov rdi, 1".
        mov     edi, 1

        ; 2nd argument, buf = the address of message. "lea" (load effective
        ; address) computes the address without reading memory; thanks to
        ; "default rel" it is computed as RIP + distance.
        lea     rsi, [message]

        ; 3rd argument, nbyte = 14, the constant computed above.
        mov     edx, message_len

        ; Call the C library. "call" pushes the return address and jumps to
        ; _write. The result (bytes written, or -1) comes back in RAX; this
        ; program ignores it, as most C Hello Worlds ignore printf's result.
        call    _write

        ; The return value of main goes in EAX: 0 means success, as in C's
        ; "return 0;". XOR-ing a register with itself is the usual way to
        ; set it to zero.
        xor     eax, eax

        ; Restore RBP (and the stack) to how the caller left them.
        pop     rbp

        ; Return to the caller. As in C, returning from main is the same as
        ; calling exit() with that value, so the program ends with status 0.
        ret
