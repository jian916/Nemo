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
    consoleLog("Search string 'Not found Quest Info = %lu'");
    var offset = exe.findString("Not found Quest Info = %lu", RVA);
    if (offset === -1)
        return "String not found";

    var strHex = offset.packToHex(4);

    consoleLog("Prep code for finding the QuestErrorMsg");
    var code =
        "68 " + strHex +              // 0 push offset aNotFoundQuestI
        "50 " +                       // 5 push eax
        "E8 AB AB AB AB " +           // 6 call std_string_sprintf
        "83 C4 0C " +                 // 11 add esp, 0Ch
        "C7 45 AB 01 00 00 00 " +     // 14 mov [ebp+var_4], 1
        "83 78 14 10 " +              // 21 cmp dword ptr [eax+14h], 10h
        "72 02 " +                    // 25 jb short loc_561264
        "8B 00 " +                    // 27 mov eax, [eax]
        "6A 00 " +                    // 29 push 0
        "68 AB AB AB AB " +           // 31 push offset aError
        "50 " +                       // 36 push eax
        "FF 35 AB AB AB AB " +        // 37 push g_hMainWnd
        "FF 15 AB AB AB AB ";         // 43 call ds:MessageBoxA
    var sprintfOffset = 7;
    var mainWndOffset = 39;
    var replaceOffset = 29;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Pattern not found";

    consoleLog("Log vars");
    logRawFunc("std_string_sprintf", offset, sprintfOffset);
    logVaVar("g_hMainWnd", offset, mainWndOffset);

    consoleLog("Replace with xor eax, eax followed by nops");
    var newCode =
        "90 90 " +              // nops
        "33 C0 90 90 90 " +     // xor eax, eax + nops
        "90 " +                 // nops
        "90 90 90 90 90 90 " +  // nops
        "90 90 90 90 90 90 ";   // nops

    exe.replace(offset + replaceOffset, newCode, PTYPE_HEX);

    return true;
}
