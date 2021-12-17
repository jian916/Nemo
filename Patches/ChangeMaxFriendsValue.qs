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
//#############################################################################
//# Purpose: Change the PUSH after comparison to edit value on friends window #
//#          inside UIMessengerGroupWnd_virt68 function.                      #
//#############################################################################

function ChangeMaxFriendsValue()
{
    consoleLog("Step 1 - Search pattern for jump to the friends window");
    var code =
        "8B ?? ?? " +          // 00 mov edx, [esi+78h]
        "8B ?? ?? " +          // 03 mov eax, [edx+0Ch]
        "99 " +                // 06 cdq
        "F7 F9 " +             // 07 idiv ecx
        "89 ?? ?? 00 00 00 ";  // 09 mov [esi+0E0h], eax

    var offses = pe.findCode(code);

    if (offses === -1)
    {
        code =
            "8B ?? ?? 00 00 00 " +  // 00 mov eax, [edi+90h]
            "8B ?? ?? " +           // 06 mov eax, [eax+18h]
            "99 " +                 // 09 cdq
            "F7 F9 " +              // 10 idiv ecx
            "89 ?? ?? 00 00 00 ";   // 12 mov [edi+0F0h], eax

        offses = pe.findCode(code);
    }

    if (offses === -1)
    {
        code =
            "8B 87 ?? 00 00 00 " +  // 00 mov eax, [edi+98h]
            "8B 40 18 " +           // 06 mov eax, [eax+18h]
            "99 " +                 // 09 cdq
            "F7 BF ?? ?? 00 00 " +  // 10 idiv dword ptr [edi+100h]
            "89 87 ?? 00 00 00 ";   // 16 mov [edi+0F8h], eax

        offses = pe.findCode(code);
    }

    if (offses === -1)
        return "Failed in Step 1 - Pattern not found";

    consoleLog("Step 2 - Search string '%s(%d/%d)' for friends list");
    var offzet = pe.stringVa("%s(%d/%d)");

    if (offzet === -1)
        return "Failed in Step 2 - String not found";

    var strHex = offzet.packToHex(4);

    consoleLog("Step 3 - Prep code for finding the friends window");
    var code =
        "8B 93 ?? 00 00 00 " +  // 00 mov edx, [ebx+0A0h]
        "8B 44 8D ?? " +        // 06 mov eax, [ebp+ecx*4+var_4C]
        "6A ?? " +              // 10 push 28h
        "52 " +                 // 12 push edx
        "50 " +                 // 13 push eax
        "8D 8D ?? ?? FF FF " +  // 14 lea ecx, [ebp+MultiByteStr]
        "68 " + strHex +        // 20 push offset aSDD_1
        "51 " +                 // 25 push ecx
        "E8 ?? ?? ?? ?? " +     // 26 call _sprintf
        "83 C4 14 ";            // 31 add esp, 14h

    var repLoc = 11;
    var sprintfOffset = [27, false];
    var offset = pe.find(code, offses, offses + 0xBC);

    if (offset === -1)
    {
        code =
            "8B ?? ?? 00 00 00 " +     // 00 mov edx, [esi+0BCh]
            "8B ?? 8C ?? " +           // 06 mov eax, [esp+ecx*4+3B0h+var_398]
            "6A ?? " +                 // 10 push 28h
            "?? " +                    // 12 push edx
            "?? " +                    // 13 push eax
            "8D ?? 24 ?? ?? 00 00 " +  // 14 lea ecx, [esp+3BCh+Dest]
            "68 " + strHex +           // 21 push offset aSDD_5
            "?? " +                    // 25 push ecx
            "FF 15 ?? ?? ?? ?? " +     // 26 call ds:sprintf
            "83 C4 14 ";               // 32 add esp, 14h

        repLoc = 11;
        sprintfOffset = [28, true];
        offset = pe.find(code, offses, offses + 0xBC);
    }

    if (offset === -1)
    {
        code =
            "8B 96 ?? 00 00 00 " +     // 00 mov edx, [esi+0D0h]
            "8B 84 8D ?? ?? FF FF " +  // 06 mov eax, [ebp+ecx*4+var_3B4]
            "6A ?? " +                 // 13 push 28h
            "52 " +                    // 15 push edx
            "50 " +                    // 16 push eax
            "8D 8D ?? ?? FF FF " +     // 17 lea ecx, [ebp+MultiByteStr]
            "68 " + strHex +           // 23 push offset aSDD_4
            "51 " +                    // 28 push ecx
            "FF 15 ?? ?? ?? ?? " +     // 29 call sprintf
            "83 C4 14 ";               // 35 add esp, 14h

        repLoc = 14;
        sprintfOffset = [31, true];
        offset = pe.find(code, offses, offses + 0xBC);
    }

    if (offset === -1)
    {
        code =
            "6A ?? " +                 // 00 push 28h
            "FF B7 ?? 00 00 00 " +     // 02 push dword ptr [edi+0D4h]
            "FF B4 85 ?? ?? FF FF " +  // 08 push [ebp+eax*4+var_3C8]
            "8D 85 ?? ?? FF FF " +     // 15 lea eax, [ebp+MultiByteStr]
            "68 " + strHex +           // 21 push offset aSDD_5
            "50 " +                    // 26 push eax
            "FF 15 ?? ?? ?? ?? " +     // 27 call sprintf
            "83 C4 14 ";               // 33 add esp, 14h

        repLoc = 1;
        sprintfOffset = [29, true];
        offset = pe.find(code, offses, offses + 0xBC);
    }

    if (offset === -1)
    {
        code =
            "6A ?? " +                 // 00 push 28h
            "FF B7 ?? ?? 00 00 " +     // 02 push dword ptr [edi+0DCh]
            "8D 85 ?? ?? FF FF " +     // 08 lea eax, [ebp-150h]
            "FF B4 8D ?? ?? FF FF " +  // 14 push dword ptr [ebp+ecx*4-460h]
            "68 " + strHex +           // 21 push offset aSDD_8
            "50 " +                    // 26 push eax
            "FF 15 ?? ?? ?? ?? " +     // 27 call ds:sprintf
            "83 C4 14 ";               // 33 add esp, 14h

        repLoc = 1;
        sprintfOffset = [29, true];
        offset = pe.find(code, offses, offses + 0xBC);
    }

    if (offset === -1)
    {
        code =
            "6A ?? " +                 // 00 push 28h
            "FF B7 ?? ?? 00 00 " +     // 02 push dword ptr [edi+0DCh]
            "8D 85 ?? ?? FF FF " +     // 08 lea eax, [ebp-16Ch]
            "FF B4 8D ?? ?? FF FF " +  // 14 push dword ptr [ebp+ecx*4-118h]
            "68 " + strHex +           // 21 push offset aSDD_6
            "50 " +                    // 26 push eax
            "E8 ?? ?? ?? ?? " +        // 27 call sub_47A2E0
            "83 C4 14 ";               // 32 add esp, 14h

        repLoc = 1;
        sprintfOffset = [28, false];
        offset = pe.find(code, offses, offses + 0xBC);
    }

    if (offset === -1)
        return "Failed in Step 3 - Pattern not found";

    if (sprintfOffset[1] === true)
        logVaFunc("sprintf", offset, sprintfOffset[0]);
    else
        logRawFunc("sprintf", offset, sprintfOffset[0]);

    logVal("max friends count", offset, [repLoc, 1]);

    consoleLog("Step 4 - Get value frome user input");
    var value = exe.getUserInput("$max_friends_value", XTYPE_BYTE, _("Max Friends"), _("Set Max Friends Value: (Max:127, Default:40)"), "40", 1, 127);

    consoleLog("Step 5 - Replace with value from user input");
    pe.replaceByte(offset + repLoc, value);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function ChangeMaxFriendsValue_()
{
    return (pe.stringRaw("%s(%d/%d)") !== -1);
}
