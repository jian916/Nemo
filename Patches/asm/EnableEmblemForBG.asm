; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

%tablevar g_session
%tablevar CSession_IsBattleFieldMode

call CSession_IsSiegeMode
test eax, eax
jnz drawAddr
mov ecx, g_session
call CSession_IsBattleFieldMode
test eax, eax
jz continueAddr
jmp drawAddr
