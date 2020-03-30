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
//####################################################
//# Purpose: Modify QuestErrorMsg function to return #
//#          without showing the MessageBox.         #
//####################################################

function IgnoreQuestErrors()
{
    // Step 1 - Prep code for finding the QuestErrorMsg
    var code =
        "68 AB AB AB 00 " +        // push    offset aNotFoundQuestI
        "AB " +                    // push    eax
        "E8 AB AB AB 00 " +        // call    sub_789D90
        "83 AB AB " +              // add     esp, 0Ch
        "C7 45 FC 01 00 00 00 " +  // mov     [ebp+var_4], 1
        "83 AB AB AB " +           // cmp     dword ptr [eax+14h], 10h
        "72 02 " +                 // jb      short loc_58E144
        "8B 00 " +                 // mov     eax, [eax]
        "6A 00 " +                 // push    0
        "68 AB AB AB 00 " +        // push    offset aError
        "AB " +                    // push    eax
        "FF 35 AB AB AB AB " +     // push    hWndParent
        "FF 15 AB AB AB 00 ";      // call    ds:MessageBoxA

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    // Step 2 - Replace with xor eax, eax followed by nops
    var newCode =
        "33 C0 90 90 90 " +     // xor eax, eax + nops
        "90 " +                 // nops
        "90 90 90 90 90 90 " +  // nops
        "90 90 90 90 90 90 ";   // nops

    exe.replace(offset + 31, newCode, PTYPE_HEX);

    return true;
}
