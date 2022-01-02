; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

%include CreateWindowExA_params
%include win32_constants
%import GetSystemMetrics, user32.dll

cmp dword ptr [tmpVar], 0
jnz skip

inc dword ptr [tmpVar]

push SM_CXSCREEN
call dword ptr [GetSystemMetrics]
cmp dword ptr [esp + width], eax
jl skip
mov dword ptr [tmpVar], eax
push SM_CYSCREEN
call dword ptr [GetSystemMetrics]
cmp dword ptr [esp + height], eax
jl skip

mov dword ptr [esp + height], eax
mov dword ptr [esp + dwStyle], WS_POPUP + WS_VISIBLE
mov dword ptr [esp + x], 0
mov dword ptr [esp + y], 0
mov eax, dword ptr [tmpVar]
mov dword ptr [esp + width], eax

jmp skip

tmpVar:
long 0

skip:
