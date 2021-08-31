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

%include CreateWindowExA_params
%include win32_constants

cmp dword ptr [tmpVar], 0
jnz skip

inc dword ptr [tmpVar]

mov eax, dword ptr [esp + dwStyle]
and eax, WS_POPUP
cmp eax, 0
jne skip

cmp dword ptr [esp + {offset}], value
{compare} skip

mov dword ptr [esp + {offset}], value

jmp skip

tmpVar:
long 0

skip:
