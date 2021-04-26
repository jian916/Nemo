//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2021 Andrei Karas (4144)
// Copyright (C) 2018-2021 X-EcutiOnner (xex.ecutionner@gmail.com)
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
//#####################################################################
//# Purpose: NOPs out the JZ following TEST EAX, EAX after Comparison #
//#          to Show Damage on GvG Maps during the Guild War.         #
//#####################################################################

function EnableGvGDamage()
{
    consoleLog("Step 1 - Prep code for finding the GvG Damage display");
    var code =
        "B9 ?? ?? ?? ?? " +    // 00 mov ecx, 11029E0h
        "E8 ?? ?? ?? 00 " +    // 05 call sub_843990
        "85 C0 " +             // 10 test eax, eax
        "74 14 " +             // 12 jz short loc_7174D8
        "6A 07 " +             // 14 push 7
        "B9 ?? ?? ?? ?? " +    // 16 mov ecx, 11029E0h
        "E8 ?? ?? ?? 00 " +    // 21 call sub_829820
        "85 C0 " +             // 26 test eax, eax
        "0F 84 ?? ?? 00 00 ";  // 28 jz def_717AF0

    var offset = pe.findCode(code);

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    var csize = code.hexlength();

    consoleLog("Step 2 - Replace offset found in step 1 with NOPs");
    exe.setNops(offset, csize);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function EnableGvGDamage_()
{
    var code =
        "B9 ?? ?? ?? ?? " +    // 00 mov ecx, 11029E0h
        "E8 ?? ?? ?? 00 " +    // 05 call sub_843990
        "85 C0 " +             // 10 test eax, eax
        "74 14 " +             // 12 jz short loc_7174D8
        "6A 07 " +             // 14 push 7
        "B9 ?? ?? ?? ?? " +    // 16 mov ecx, 11029E0h
        "E8 ?? ?? ?? 00 " +    // 21 call sub_829820
        "85 C0 " +             // 26 test eax, eax
        "0F 84 ?? ?? 00 00 ";  // 28 jz def_717AF0

    return (pe.findCode(code) !== -1);
}
