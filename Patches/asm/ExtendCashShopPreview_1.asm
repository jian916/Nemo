;
; Copyright (C) 2018-2021  Andrei Karas (4144)
;
; Hercules is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

%insasm stolenCode
push eax
movzx eax, word ptr [{register} + block_size]
mov [ebp + itemInfo + view_sprite], eax
mov eax, [{register} + block_size + 2]
mov [ebp + itemInfo + location], eax
pop eax
jmp continueItemAddr
