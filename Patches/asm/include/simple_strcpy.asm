; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

simple_strcpy:
mov al, [esi]
mov [edi], al
inc esi
inc edi
cmp byte ptr [esi], 0
jne simple_strcpy
mov byte ptr [edi], 0
ret
