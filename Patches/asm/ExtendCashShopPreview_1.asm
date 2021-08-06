%stolenCode
push eax
movzx eax, word ptr [{register} + block_size]
mov [ebp + itemInfo + view_sprite], eax
mov eax, [{register} + block_size + 2]
mov [ebp + itemInfo + location], eax
pop eax
jmp continueItemAddr
