; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

push ecx
%insasm asmCopyArgs
push esi
push edi
mov esi, dword ptr [esp + 0x8]
mov edi, buffer
call simple_strcpy
mov esi, str_before
call simple_strcpy
mov dword ptr [esp + 0x8], buffer
pop edi
pop esi
push _normal_label
%inshex stolenCode
jmp continueItemAddr

_normal_label:
pop ecx
push ecx
%insasm asmCopyArgs
push _after_label
%inshex stolenCode
jmp continueItemAddr

_after_label:
pop ecx
push eax
%insasm asmCopyArgs
push esi
push edi
mov esi, dword ptr [esp + 0x8]
mov edi, buffer
call simple_strcpy
mov esi, str_after
call simple_strcpy
mov dword ptr [esp + 0x8], buffer
pop edi
pop esi
push _exit_label
%inshex stolenCode
jmp continueItemAddr

_exit_label:
pop eax
ret argsOffset

%include simple_strcpy

str_before:
asciz "_before"
str_after:
asciz "_after"
