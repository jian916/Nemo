//
// Copyright (C) 2017-2021  Andrei Karas (4144)
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
//###########################################################################
//# Purpose: Restore login packet 0x64                                      #
//###########################################################################

function LoginPacketSend_match()
{
    var LANGTYPE = GetLangType();
    if (LANGTYPE.length === 1)
        throw "Failed in Step 1a - " + LANGTYPE[0];

    consoleLog("Search pattern");
    // search in CLoginMode_OnChangeState
    var code =
        "80 3D ?? ?? ?? ?? 00 " +     // 0 cmp ds:g_passwordEncrypt, 0
        "0F 85 ?? ?? ?? 00 " +        // 7 jnz loc_80923F
        "8B ?? " + LANGTYPE +         // 13 mov ecx, ds:g_serviceType
        "?? ?? " +                    // 19 test ecx, ecx
        "0F 84 ?? ?? 00 00 " +        // 21 jz loc_8090C2
        "83 ?? 12 " +                 // 27 cmp ecx, 12h
        "0F 84 ?? ?? 00 00 " +        // 30 jz loc_8090C2
        "83 ?? 0C " +                 // 36 cmp ecx, 0Ch
        "0F 84 ?? ?? 00 00 ";         // 39 jz loc_8090C2
    var passwordEncryptOffset = [2, 4];
    var nopRangeOffset = [19, 45];
    var offset = pe.findCode(code);

    if (offset === -1)
        throw "Pattern not found";

    logVaVar("g_passwordEncrypt", offset, passwordEncryptOffset);

    var obj = hooks.createHookObj();
//    obj.patchAddr = ;
    obj.stolenCode = "";
    obj.stolenCode1 = "";
    obj.retCode = "";
    obj.endHook = false;

    obj.offset = offset;
    obj.nopRangeOffset = nopRangeOffset;

    return obj;
}


function RestoreOldLoginPacket()
{
    var obj = LoginPacketSend_match();
    exe.setNopsRange(obj.offset + obj.nopRangeOffset[0], obj.offset + obj.nopRangeOffset[1]);

    return true;
}

//====================================================================//
// Disable for Unneeded Clients. Start from first zero client version //
//====================================================================//
function RestoreOldLoginPacket_()
{
    return (exe.getClientDate() > 20171019 && IsZero()) || exe.getClientDate() >= 20181114;
}
