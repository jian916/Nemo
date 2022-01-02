; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

push eax
mov eax, [{regName}]  // strlen
cmp al, 0
pop eax
jne _continue1
jmp continueAddr

_continue1:
%inshex stolenCode  // cmp ebx, 0A9
jne _continue2
jmp a9JmpAddr

_continue2:
jmp nonA9JmpAddr
