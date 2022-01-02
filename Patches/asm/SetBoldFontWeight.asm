; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

%include CreateFontA_params

mov eax, dword ptr [esp + weight]
cmp eax, 700
jne skip
mov dword ptr [esp + weight], value

skip:
