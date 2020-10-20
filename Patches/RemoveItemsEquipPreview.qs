//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
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
//##############################################################################
//# Purpose: Change the JZ after comparison to remove equipment preview button #
//#          on the items description window inside ITEMWNDINFO function.      #
//##############################################################################

function RemoveItemsEquipPreview()
{
    consoleLog("Step 1 - Search string 'IsEffectHatItem'");
    var offset = exe.findString("IsEffectHatItem", RVA);

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    var strHex = offset.packToHex(4);

    consoleLog("Step 2 - Find the location where equipment preview function is called");
    var code =
        "68 " + strHex +           // 00 push offset aIseffecthatite
        "C6 01 00 " +              // 05 mov  byte ptr [ecx], 0
        "E8 AB AB AB FF " +        // 08 call loc_45D190
        "C7 45 FC AB 00 00 00 " +  // 13 mov  [ebp+var_4], 13h
        "FF 35 AB AB AB AB " +     // 20 push lpCaption
        "C7 45 FC FF FF FF FF " +  // 26 mov  [ebp+var_4], 0FFFFFFFFh
        "E8 AB AB AB 00 " +        // 33 call sub_9FC510
        "83 C4 28 " +              // 38 add  esp, 28h
        "80 BD AB FD FF FF 01 " +  // 41 cmp  [ebp+var_205], 1
        "0F 84 AB 05 00 00 " +     // 48 jz   loc_55E1D8
        "68 AB 00 00 00 " +        // 54 push 0D0h
        "E8 AB AB AB 00 " +        // 59 call sub_BD090F
        "83 C4 04 " +              // 64 add  esp, 4
        "89 85 AB AB FF FF " +     // 67 mov  [ebp+var_1FC], eax
        "C7 45 FC AB 00 00 00 " +  // 73 mov  [ebp+var_4], 14h
        "85 C0 " +                 // 80 test eax, eax
        "74 09 " +                 // 82 jz   short loc_55DC3D
        "8B C8 " +                 // 84 mov  ecx, eax
        "E8 AB AB AB FF " +        // 86 call sub_4DB7A0
        "EB 02 ";                  // 91 jmp  short loc_55DC3F

    var repLoc = 48;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    consoleLog("Step 3 - Replace the JZ offset with NOP + JMP at location found in Step 2");
    exe.replace(offset + repLoc, "90 E9 ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function RemoveItemsEquipPreview_()
{
    return (exe.findString("IsEffectHatItem", RAW) !== -1);
}
