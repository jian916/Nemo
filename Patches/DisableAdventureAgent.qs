//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2021 Andrei Karas (4144)
// Copyright (C) 2021 X-EcutiOnner (xex.ecutionner@gmail.com)
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
//###############################################################################
//# Purpose: Nops all offset after comparison to disable adventure agent button #
//#          on the party window inside UIMessengerGroupWnd_virt68 function.    #
//###############################################################################

function DisableAdventureAgent()
{
    consoleLog("Step 1 - Search string '유저인터페이스\\basic_interface\\mesbtn_partymaster_01.bmp' for adventure agent button");
    var btn_name = "\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\\basic_interface\\mesbtn_partymaster_01.bmp";
    var offses = pe.stringVa(btn_name);

    if (offses === -1)
        return "Failed in Step 1 - String not found";

    var strHex = offses.packToHex(4);

    consoleLog("Step 2 - Prep code for finding the adventure agent button in party window");
    var code =
        "C6 81 ?? ?? ?? 00 00 " +     // 0 mov [ecx+UIBitmapButton.button_flag], 0
        "FF 90 ?? ?? ?? 00 " +        // 7 call [eax+UIBitmapButton_vtable.UIWindow_SendMsg]
        "8B 8F ?? ?? ?? 00 " +        // 13 mov ecx, [edi+UIMessengerGroupWnd.m_mesbtn]
        "6A 00 " +                    // 19 push 0
        "68 " + strHex +              // 21 push    offset aIBasicInterfac_1 ; ASCII "유저인터페이스\\basic_interface\\mesbtn_partymaster_01.bmp"
        "E8 ?? ?? ?? ?? " +           // 26 call UIBitmapButton_SetBitmapName
        "8B 8F ?? ?? ?? 00 " +        // 31 mov ecx, [edi+UIMessengerGroupWnd.m_mesbtn]
        "6A 01 " +                    // 37 push 1
        "68 ?? ?? ?? ?? " +           // 39 push offset aPFBasic_interfaceMesbtn_partyma_0
        "E8 ?? ?? ?? ?? " +           // 44 call UIBitmapButton_SetBitmapName
        "8B 8F ?? ?? ?? 00 " +        // 49 mov ecx, [edi+UIMessengerGroupWnd.m_mesbtn]
        "6A 02 " +                    // 55 push 2
        "68 ?? ?? ?? ?? " +           // 57 push offset aPFBasic_interfaceMesbtn_partyma_1
        "E8 ?? ?? ?? ?? " +           // 62 call UIBitmapButton_SetBitmapName
        "68 BA 0D 00 00 " +           // 67 push 0DBAh
        "E8 ?? ?? ?? ?? " +           // 72 call MsgStr
        "8B 8F ?? ?? ?? 00 " +        // 77 mov ecx, [edi+UIMessengerGroupWnd.m_mesbtn]
        "83 C4 04 " +                 // 83 add esp, 4
        "50 " +                       // 86 push eax
        "E8 ?? ?? ?? ?? " +           // 87 call UIBitmapButton_SetText
        "33 C0 " +                    // 92 xor eax, eax
        "E9 ?? ?? ?? 00 ";            // 94 jmp loc_5EADD9
    var nopStart = 0;
    var nopEnd = 92;
    var buttonFlagOffset = [2, 1];
    var sendMsgOffset = [9, 4];
    var mesBtnOffsets = [[15, 4], [33, 4], [51, 4], [79, 4]];
    var setBitmapNameOffsets = [27, 45, 63];
    var setBitmapButtonTextOffset = 88;

    var offset = pe.findCode(code);

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    logField("UIBitmapButton::button_flag", offset, buttonFlagOffset);
    logField("UIBitmapButton_vtable::UIWindow_SendMsg", offset, sendMsgOffset);
    for (var i = 0; i < mesBtnOffsets.length; i ++)
    {
        logField("UIMessengerGroupWnd::m_mesbtn", offset, mesBtnOffsets[i]);
    }
    for (var i = 0; i < setBitmapNameOffsets.length; i ++)
    {
        logRawFunc("UIBitmapButton_SetBitmapName", offset, setBitmapNameOffsets[i]);
    }
    logRawFunc("UIBitmapButton_SetText", offset, setBitmapButtonTextOffset);

    consoleLog("Step 3 - NOPs out the assignment for the correct match");
    pe.setNopsRange(offset + nopStart, offset + nopEnd);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableAdventureAgent_()
{
    var btn_name = "\xC0\xAF\xC0\xFA\xC0\xCE\xC5\xCD\xC6\xE4\xC0\xCC\xBD\xBA\\basic_interface\\mesbtn_partymaster_01.bmp";

    return (pe.stringRaw(btn_name) !== -1);
}
