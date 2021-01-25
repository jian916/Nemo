//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2017-2021 Andrei Karas (4144)
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
//##################################################
//# Purpose: Modify LuaErrorMsg function to return #
//#          without showing the MessageBox.       #
//##################################################

function IgnoreLuaErrors()
{
    consoleLog("Step 1 - Prep code for finding the LuaErrorMsg");
    var code =
        "FF AB AB AB AB 00 " +  // 00 call vsprintf
        "83 AB AB " +           // 06 add esp, 0Ch
        "8D AB AB AB FF FF " +  // 09 lea eax, [ebp+Text]
        "6A 00 " +              // 15 push 0
        "AB " +                 // 17 push esi
        "AB " +                 // 18 push eax
        "6A 00 " +              // 19 push 0
        "FF 15 AB AB AB 00 ";   // 21 call MessageBoxA

    var repLoc = 9;
    var hCode = "33 C0 90 90 90 90 90 90 90 ";
    var vsprintfOffset = 2;
    var messageBoxAOffset = 23;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code =
            "FF AB AB AB AB 00 " +  // 00 call vsprintf
            "83 AB AB " +           // 06 add esp, 0Ch
            "6A 00 " +              // 09 push 0
            "AB " +                 // 11 push esi
            "8D AB AB AB FF FF " +  // 12 lea eax, [ebp+Text]
            "AB " +                 // 18 push eax
            "6A 00 " +              // 19 push 0
            "FF 15 AB AB AB 00 ";   // 21 call MessageBoxA

        repLoc = 9;
        hCode = "90 90 90 33 C0 90 90 90 90 ";
        vsprintfOffset = 2;
        messageBoxAOffset = 23;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "FF AB AB AB AB 00 " +  // 00 call ds:vsprintf
            "83 AB AB " +           // 06 add esp, 0Ch
            "6A 00 " +              // 09 push 0
            "AB " +                 // 11 push esi
            "8D AB AB AB " +        // 12 lea eax, [esp+204h+Dest]
            "AB " +                 // 16 push eax
            "6A 00 " +              // 17 push 0
            "FF 15 AB AB AB 00 ";   // 19 call ds:MessageBoxA

        repLoc = 9;
        hCode = "90 90 90 33 C0 90 90 ";
        vsprintfOffset = 2;
        messageBoxAOffset = 21;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "E8 AB AB AB 00 " +     // 00 call _vsprintf
            "8B AB AB " +           // 05 mov eax, [ebp+lpCaption]
            "83 AB AB " +           // 08 add esp, 0Ch
            "8D AB AB AB FF FF " +  // 11 lea ecx, [ebp+Text]
            "6A 00 " +              // 17 push 0
            "AB " +                 // 19 push eax
            "AB " +                 // 20 push ecx
            "6A 00 " +              // 21 push 0
            "FF 15 AB AB AB 00 ";   // 23 call ds:MessageBoxA

        repLoc = 11;
        hCode = "90 90 90 90 90 90 33 C0 90 ";
        vsprintfOffset = 1;
        messageBoxAOffset = 25;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    logVaFunc("vsprintf", offset, vsprintfOffset);
    logVaFunc("MessageBoxA", offset, messageBoxAOffset);

    consoleLog("Step 2 - Replace with xor eax, eax followed by nops");
    var newCode =
        hCode +                // 00 xor eax, eax + nops
        "90 " +                // 09 nops
        "90 90 " +             // 10 nops
        "90 90 90 90 90 90 ";  // 12 nops

    exe.replace(offset + repLoc, newCode, PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function IgnoreLuaErrors_()
{
    return (exe.getClientDate() >= 20100000);
}
