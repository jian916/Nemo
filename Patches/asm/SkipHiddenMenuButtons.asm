push eax
mov eax, [{regName}]  // strlen
cmp al, 0
pop eax
jne _continue1
jmp continueAddr

_continue1:
%stolenCode  // cmp ebx, 0A9
jne _continue2
jmp a9JmpAddr

_continue2:
jmp nonA9JmpAddr
