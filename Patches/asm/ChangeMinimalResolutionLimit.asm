cmp eax, 0
jnl _no
xor eax, eax

_no:
%codeIns

push retAddr
ret
