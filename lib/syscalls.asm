        %ifndef SYSCALLS

        SYS_WRITE equ 1
        SYS_OPEN equ 2
        SYS_EXIT equ 60

        OPEN_O_RDONLY equ 0x0
        OPEN_O_CLOEXEC equ 0x80000

        FILE_STDOUT equ 1

        %macro exit 1
        mov rax, SYS_EXIT
        mov rdi, %1
        syscall
        %endmacro

        %macro puts 2
        mov rax, SYS_WRITE
        mov rdi, FILE_STDOUT
        mov rsi, %1
        mov rdx, %2
        syscall
        %endmacro

        %endif
