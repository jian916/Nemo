push ecx
%asmCopyArgs
push esi
push edi
mov esi, dword ptr [esp + 0x8]
mov edi, buffer
call func_strcpy
mov esi, str_before
call func_strcpy
mov dword ptr [esp + 0x8], buffer
pop edi
pop esi
push _normal_label
%stolenCode
jmp continueItemAddr

_normal_label:
pop ecx
push ecx
%asmCopyArgs
push _after_label
%stolenCode
jmp continueItemAddr

_after_label:
pop ecx
push eax
%asmCopyArgs
push esi
push edi
mov esi, dword ptr [esp + 0x8]
mov edi, buffer
call func_strcpy
mov esi, str_after
call func_strcpy
mov dword ptr [esp + 0x8], buffer
pop edi
pop esi
push _exit_label
%stolenCode
jmp continueItemAddr

_exit_label:
pop eax
ret argsOffset

func_strcpy:
mov al, [esi]
mov [edi], al
inc esi
inc edi
cmp byte ptr [esi], 0
jne func_strcpy
mov byte ptr [edi], 0
ret

str_before:
%strBefore
str_after:
%strAfter
