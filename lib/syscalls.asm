        %ifndef SYSCALLS

; Syscalls ids
        SYS_WRITE equ 1
        SYS_OPEN equ 2
        SYS_EXIT equ 60
        SYS_KILL equ 62

; Open flags
        OPEN_O_RDONLY equ 0x0
        OPEN_O_CLOEXEC equ 0x80000

; Standard files
        FILE_STDOUT equ 1

; Kill signals
        SIG_RTMIN equ 34

; Generic syscall wrappers
        %macro syscall_1 2
        mov rax, %1
        mov rdi, %2
        syscall
        %endmacro

        %macro syscall_2 3
        mov rax, %1
        mov rdi, %2
        mov rsi, %3
        syscall
        %endmacro

        %macro syscall_3 4
        mov rax, %1
        mov rdi, %2
        mov rsi, %3
        mov rdx, %4
        syscall
        %endmacro

; Syscall macros
        %macro exit 1
        syscall_1 SYS_EXIT, %1
        %endmacro

        %macro puts 2
        syscall_3 SYS_WRITE, FILE_STDOUT, %1, %2
        %endmacro

        %macro kill 2
        syscall_2 SYS_KILL, %1, %2
        %endmacro

        %endif
