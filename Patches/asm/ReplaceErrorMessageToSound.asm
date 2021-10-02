; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

%include MessageBoxA_params
%import GetModuleHandleA, kernel32.dll
%import GetProcAddress, kernel32.dll

push str_user32
call dword ptr [GetModuleHandleA]
push str_MessageBeep
push eax
call dword ptr [GetProcAddress]
push value
call eax  // MessageBeep

mov eax, 1
ret 16

str_user32:
asciz "user32.dll"
str_MessageBeep:
asciz "MessageBeep"
