//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2021 Andrei Karas (4144)
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
        "68 " + strHex +              // 0 push offset aIseffecthatite
        "C6 01 00 " +                 // 5 mov byte ptr [ecx], 0
        "E8 ?? ?? ?? ?? " +           // 8 call std_string_assign
        "C7 45 ?? ?? ?? 00 00 " +     // 13 mov [ebp+var_4], 10h
        "FF 35 ?? ?? ?? ?? " +        // 20 push g_session.m_lua_state
        "C7 45 ?? FF FF FF FF " +     // 26 mov [ebp+var_4], 0FFFFFFFFh
        "E8 ?? ?? ?? ?? " +           // 33 call lua_call_va
        "83 C4 28 " +                 // 38 add esp, 28h
        "80 BD ?? ?? ?? FF 01 " +     // 41 cmp [ebp+var_2CD], 1
        "0F 84 ?? ?? ?? ?? " +        // 48 jz loc_5DEB75
        "68 ?? ?? 00 00 " +           // 54 push 0C8h
        "E8 ?? ?? ?? ?? " +           // 59 call operator_new
        "83 C4 04 " +                 // 64 add esp, 4
        "89 85 ?? ?? ?? FF " +        // 67 mov [ebp+var_2D4], eax
        "C7 45 ?? ?? ?? 00 00 " +     // 73 mov [ebp+var_4], 11h
        "85 C0 " +                    // 80 test eax, eax
        "74 09 " +                    // 82 jz short loc_5DE656
        "8B C8 " +                    // 84 mov ecx, eax
        "E8 ?? ?? ?? ?? " +           // 86 call UIBasicButton_UIBasicButton
        "EB ";                        // 91 jmp short loc_5DE658

    var repLoc = 48;
    var stringAssignOffset = 9;
    var luaStateOffset = [22, 4];
    var luaCallVaOffset = 34;
    var UIBasicButtonSize = [55, 4];
    var newOffset = 60;
    var UIBasicButtonConstructorOffset = 87;
    var offset = pe.findCode(code);

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    logRawFunc("std_string_assign", offset, stringAssignOffset);
    logField("CSession::m_lua_state", offset, luaStateOffset);
    logRawFunc("lua_call_va", offset, luaCallVaOffset);
    logVal("sizeof UIBasicButton", offset, UIBasicButtonSize);
    logRawFunc("operator_new", offset, newOffset);
    logRawFunc("UIBasicButton_UIBasicButton", offset, UIBasicButtonConstructorOffset);

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
