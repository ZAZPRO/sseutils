        %include "syscalls.asm"
        global _start
_start:
        kill 1, 38
        exit 0
