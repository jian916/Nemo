//
// Copyright (C) 2018-2019  Andrei Karas (4144)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//#############################################################
//# Purpose: Allow party leader to leave party if no other    #
//#          members on same map in function CGameMode_virt24 #
//#############################################################

function AllowLeavelPartyLeader()
{
    var code =
        "84 C0" +                 // test al, al
        "74 34" +                 // jz addr1
        "C7 45 AB FF FF FF FF" +  // mov [ebp+A], 0FFFFFFFFh
        "8D 8D AB AB AB AB" +     // lea ecx, [ebp+fInfo]
        "E8 AB AB AB AB" +        // call FRIEND_INFO_destructor
        "46" +                    // inc esi
        "3B F3" +                 // cmp esi, ebx
        "7C AB" +                 // jl addr2
        "8A 85 AB AB AB AB" +     // mov al, byte ptr [ebp+B]
        "84 C0" +                 // test al, al
        "74 AB" +                 // jz addr3    <-- patch here
        "6A 00" +                 // push 0
        "6A 00" +                 // push 0
        "68 FF 00 00 00" +        // push 0FFh
        "68 C9 0C 00 00" +        // push 0CC9h
        "E9"                      // jmp addr3
    var jzOffset = 2;
    var friendInfoDestructorOffset = 18;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    if (exe.fetchUByte(offset + jzOffset) !== 0x74)
        return "Failed in step 1 - wrong jz offset";

    logRawFunc("FRIEND_INFO_destructor", offset, friendInfoDestructorOffset);
    exe.replace(offset + jzOffset, "EB", PTYPE_HEX);  // change jz addr3 to jmp addr3

    return true;
}
