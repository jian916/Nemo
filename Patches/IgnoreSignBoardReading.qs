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
//###################################################################
//# Purpose: Change the CALL after comparison for ignore to reading #
//#          SignBoardList.lub file inside FindFileData function.   #
//###################################################################

function IgnoreSignBoardReading()
{
    consoleLog("Step 1 - Search string 'Lua Files\\SignBoardList_F'");
    var offset = exe.findString("Lua Files\\SignBoardList_F", RVA);

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    var strHex = offset.packToHex(4);

    consoleLog("Step 2 - Prep code for finding the SignBoardList");
    var code =
        "8B 8E AB AB 00 00 " +  // 00 mov ecx, [esi+567Ch]
        "6A 00 " +              // 06 push 0
        "6A 01 " +              // 08 push 1
        "68 " + strHex +        // 10 push offset aLuaFilesSignbo
        "E8 AB AB AB AB " +     // 15 call sub_9FD390
        "8B 8E AB AB 00 00 " +  // 20 mov ecx, [esi+567Ch]
        "6A 00 " +              // 26 push 0
        "6A 01 " +              // 28 push 1
        "68 AB AB AB 00 " +     // 30 push offset aLuaFilesSign_0
        "E8 AB AB AB AB ";      // 35 call sub_9FD390

    var repLoc = 26;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    consoleLog("Step 3 - Replace with XOR EAX, EAX followed by NOPs");
    var code =
        "90 90 " +           // 00 nops
        "90 90 " +           // 02 nops
        "33 C0 90 90 90 " +  // 07 xor eax, eax + nops
        "33 C0 90 90 90 ";   // 12 xor eax, eax + nops

    exe.replace(offset + repLoc, code, PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function IgnoreSignBoardReading_()
{
    return (exe.findString("Lua Files\\SignBoardList_F", RVA) !== -1);
}
