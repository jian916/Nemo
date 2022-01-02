; Patch (c) 2021 by Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

%tablevar location = ITEM_INFO_location
%tablevar view_sprite = ITEM_INFO_view_sprite

%inshex stolenCode
push eax
push ecx
mov ecx, dword ptr [ebp + next + 0]
movzx eax, word ptr [ecx + block_size]
mov [ebp + itemInfo + view_sprite], eax
mov eax, dword ptr [ecx + block_size + 2]
mov [ebp + itemInfo + location], eax
pop ecx
pop eax
jmp continueItemAddr
