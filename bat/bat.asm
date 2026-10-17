        global _start

        SYS_WRITE equ 1
        SYS_OPEN equ 2
        SYS_EXIT equ 60
        O_RDONLY equ 0x0
        O_CLOEXEC equ 0x80000
        STDOUT equ 1
        error_msg_bat0_len equ error_msg_bat0_end - error_msg_bat0
        error_msg_read_len equ error_msg_read_end - error_msg_read

        %macro exit 1
        mov rax, SYS_EXIT
        mov rdi, %1
        syscall
        %endmacro

        %macro puts 2
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, %1
        mov rdx, %2
        syscall
        %endmacro

        section .rodata
bat_path:
        db `/sys/class/power_supply/BAT0/capacity\0`
error_msg_bat0:
        db `No BAT0 found\n`
error_msg_bat0_end:
error_msg_read:
        db `Failed to read\n`
error_msg_read_end:

        section .bss
buf:
        resb 5                         ; I will need to store max of "100%\n" = 5 bytes

        section .text
_start:
        mov rax, SYS_OPEN
        mov rdi, bat_path
        mov rsi, (O_CLOEXEC | O_RDONLY)
        syscall
        cmp rax, 0                     ; compare rax with 0
        cs jl _error_bat0                   ; jump if rax is smaller than zero & cs = not taken branch hint
        mov r9, rax                    ; Save open fd

        mov rdi, rax
        xor rax, rax                   ; read
        mov rsi, buf
        mov rdx, 4                     ; "100\n" = 4 max string len
        syscall
        cmp rax, 1                     ; read error check
        cs jl _error_read
        mov rdx, rax                   ; store read len
        mov word [buf + rax - 1], `%\n` ; Store '%\n' in the end

        mov rax, SYS_WRITE             ; write
        mov rdi, STDOUT
        inc rdx                        ; print one char more, because of '%'
        syscall

        exit 0

_error_bat0:
        puts error_msg_bat0, error_msg_bat0_len
        exit -1

_error_read:
        puts error_msg_read, error_msg_read_len
        exit -1

; no need to close file
