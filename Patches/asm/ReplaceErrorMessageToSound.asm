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

%include MessageBoxA_params
%import GetModuleHandleA, kernel32.dll
%import GetProcAddress, kernel32.dll

push str_user32
call dword ptr [GetModuleHandleA]
push str_MessageBeep
push eax
call dword ptr [GetProcAddress]
push value
call eax  // MessageBeep

mov eax, 1
ret 16

str_user32:
asciz "user32.dll"
str_MessageBeep:
asciz "MessageBeep"
