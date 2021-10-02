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

cmp dword ptr [tmpVar], 0
jnz skip

inc dword ptr [tmpVar]
or dword ptr [esp + dwStyle], WS_SYSMENU

jmp skip

tmpVar:
long 0

skip:
