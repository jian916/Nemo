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
