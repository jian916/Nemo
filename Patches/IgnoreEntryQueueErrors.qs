//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020-2021 Andrei Karas (4144)
// Copyright (C) 2020-2021 X-EcutiOnner (xex.ecutionner@gmail.com)
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
//#########################################################
//# Purpose: Modify EntryQueueErrorMsg function to return #
//#          without showing the MessageBox.              #
//#########################################################

function IgnoreEntryQueueErrors()
{
    consoleLog("Step 1 - Search string 'Data\\Table\\EntryQueue.bex'");
    var offset = exe.findString("Data\\Table\\EntryQueue.bex", RVA);

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    var strHex = offset.packToHex(4);

    consoleLog("Step 2 - Prep code for finding the EntryQueueErrorMsg");
    var code =
        "68 " + strHex +        // 00 push offset aDataTableEntry_1 ; "Data\\Table\\EntryQueue.bex"
        "FF 15 ?? ?? ?? ?? " +  // 05 call ds:CreateFileA
        "8B F8 " +              // 11 mov edi, eax
        "83 FF FF " +           // 13 cmp edi, 0FFFFFFFFh
        "75 ?? " +              // 16 jnz short loc_7ADFA5
        "6A 30 " +              // 18 push 30h ; '0'
        "68 ?? ?? ?? ?? " +     // 20 push offset aLoadFailed ; "Load Failed"
        "68 " + strHex +        // 25 push offset aDataTableEntry_1 ; "Data\\Table\\EntryQueue.bex"
        "?? " +                 // 30 push esi
        "FF 15 ?? ?? ?? ?? " ;  // 31 call ds:MessageBoxA

    var createfileOffset = 7;
    var messageBoxOffset = 33;
    var replaceStartOffset = 18;
    var replaceEndOffset = 31 + 6;

    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "68 " + strHex +        // 00 push offset aDataTableEnt_1 ; "Data\\Table\\EntryQueue.bex"
            "FF 15 ?? ?? ?? ?? " +  // 05 call CreateFileA
            "8B D8 " +              // 11 mov ebx, eax
            "83 FB FF " +           // 13 cmp ebx, 0FFFFFFFFh
            "75 ?? " +              // 16 jnz short loc_856437
            "6A 30 " +              // 18 push 30h ; '0'
            "68 ?? ?? ?? ?? " +     // 20 push offset aLoadFailed ; "Load Failed"
            "68 " + strHex +        // 25 push offset aDataTableEnt_1 ; "Data\\Table\\EntryQueue.bex"
            "6A 00 " +              // 30 push 0
            "FF 15 ?? ?? ?? ?? " ;  // 32 call MessageBoxA

        createfileOffset = 7;
        messageBoxOffset = 34;
        replaceStartOffset = 18;
        replaceEndOffset = 32 + 6;

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    consoleLog("Log vars");
    logVaFunc("CreateFileA", offset, createfileOffset);
    logVaFunc("MessageBoxA", offset, messageBoxOffset);

    consoleLog("Step 3 - Replace with nops");
    exe.setNopsRange(offset + replaceStartOffset, offset + replaceEndOffset);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function IgnoreEntryQueueErrors_()
{
    return (exe.findString("Load Failed", RAW) !== -1);
}
