        %include "syscalls.asm"
        global _start
_start:
        kill 1, SIG_RTMIN + 5
        exit 0
