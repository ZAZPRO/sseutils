        %include "syscalls.asm"
        global _start
_start:
        kill 1, SIG_RTMIN + 4
        exit 0
