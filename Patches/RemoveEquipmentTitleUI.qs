//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020 CH.C (jchcc)
// Copyright (C) 2020 Andrei Karas (4144)
// Copyright (C) 2020 X-EcutiOnner (xex.ecutionner@gmail.com)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//
//##########################################################################
//# Purpose: Change the JNZ after comparison to remove title window button #
//#          on the equipment window inside EQUIPMENTWNDINFO function.     #
//##########################################################################

function RemoveEquipmentTitleUI()
{
    consoleLog("Step 1 - Find the location where equipment function is called");
    var code =
        "E8 AB AB AB FF " +        // 00 call sub_520A80
        "83 BF AB 00 00 00 00 " +  // 05 cmp dword ptr [edi+94h], 0
        "75 19 " +                 // 12 jnz short loc_53F479
        "68 7D 0A 00 00 " +        // 14 push 0A7Dh
        "E8 AB AB AB AB " +        // 19 call sub_45BE00
        "8B 8F AB 00 00 00 " +     // 24 mov ecx, [edi+0C8h]
        "83 C4 04 ";               // 30 add esp, 4

    var repLoc = 0x0C;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    exe.replace(offset + repLoc, "EB ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function RemoveEquipmentTitleUI_()
{
    return (exe.getClientDate() >= 20170208 && IsSakray()) || exe.getClientDate() >= 20170620;
}
