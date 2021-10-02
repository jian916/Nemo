; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

cmp eax, 0xFFFFFFFF
jnz _ret
mov ecx, dword ptr [esp + 0xc - 4]
mov ecx, dword ptr [ecx]
cmp ecx, 3
jnz _ret
xor eax, eax
mov ecx, dword ptr [esp + 0xc - 4]
mov dword ptr [ecx], eax
_ret:
