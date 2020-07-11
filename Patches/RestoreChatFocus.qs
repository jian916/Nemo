//
// Copyright (C) 2018-2019  Andrei Karas (4144)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//###################################################################
//# Purpose: Dont remove edit focus if click outside of input field #
//###################################################################

function RestoreChatFocus()
{
    var mgrInfo = GetWinMgrInfo();
    if (typeof(mgrInfo) === "string")
        return "Failed in search g_windowMgr - " + mgrInfo;

    // search UIWindowMgr::SetFocusEdit call in CGameMode static member
    var code =
        "83 3D AB AB AB AB 01 " +  // cmp g_CMouse.button, 1
        "75 AB " +                 // jnz addr1
        "6A 00 " +                 // push 0
        mgrInfo['gWinMgr'] +       // mov ecx, offset g_windowMgr
        "E8 AB AB AB AB " +        // call UIWindowMgr::SetFocusEdit
        "EB ";                     // jmp addr2

    var patchOffset = 9;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    code =
        "90 90 " +
        "90 90 90 90 90" +
        "90 90 90 90 90";
    exe.replace(offset + patchOffset, code, PTYPE_HEX);  // replace edit lost focus call to nops

    return true;
}
