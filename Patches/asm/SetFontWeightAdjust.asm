;
; Copyright (C) 2021  Andrei Karas (4144)
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

%include CreateFontA_params

mov eax, dword ptr [esp + weight]
add eax, value
cmp eax, 0
js tooSmall
cmp eax, 1000
jle normal

tooBig:
mov eax, 1000
jmp normal

tooSmall:
mov eax, 1

normal:
mov dword ptr [esp + weight], eax
