        global _start

        SYS_EXIT equ 60

        section .text
_start:
        rdtsc                          ; edx/rdx 32-bit high  eax/rax 32-bit low

        mov rax, SYS_EXIT
        mov rdi, %1
        syscall

; no need to close file
