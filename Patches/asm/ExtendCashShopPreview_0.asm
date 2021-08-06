%stolenCode
push eax
push ecx
mov ecx, dword ptr [ebp + next + 0]
movzx eax, word ptr [ecx + block_size]
mov [ebp + itemInfo + view_sprite], eax
mov eax, dword ptr [ecx + block_size + 2]
mov [ebp + itemInfo + location], eax
pop ecx
pop eax
jmp continueItemAddr
