//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2018-2020 Andrei Karas (4144)
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
//########################################################################################
//# Purpose: Change the EAX after comparison to remove equipment swap button both on the #
//#          equipment window and costume window inside SWAPEQUIPMENTWNDINFO function.   #
//########################################################################################

function RemoveEquipmentSwap()
{
    // Step 1 - Find the location where equipment function is called
    var code =
        "E8 AB AB AB FF " +     // call    sub_59E810
        "8B 47 18 " +           // mov     eax, [edi+18h]
        "8B 8F AB AB 00 00 " +  // mov     ecx, [edi+100h]
        "83 E8 14 " +           // sub     eax, 14h
        "8B 11 " +              // mov     edx, [ecx]
        "50 ";                  // push    eax

    var repLoc = 15;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code = code.replace("83 E8 14 8B 11 50 ", "83 E8 14 50 "); // remove MOV EDX, [ECX]
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    exe.replace(offset + repLoc, "C0 ", PTYPE_HEX);

    // Step 2 - Find the location where costume function is called
    var code =
        "8B 8E AB AB 00 00 " +  // mov     ecx, [esi+100h]
        "85 C9 " +              // test    ecx, ecx
        "74 6F " +              // jz      short loc_66C1FF
        "8B 86 AB 00 00 00 " +  // mov     eax, [esi+0B8h]
        "8B 11 " +              // mov     edx, [ecx]
        "05 93 00 00 00 " +     // add     eax, 93h
        "50 ";                  // push    eax

    var repLoc = 19;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    exe.replace(offset + repLoc, "FF ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function RemoveEquipmentSwap_()
{
    return (exe.getClientDate() >= 20170208);
}
