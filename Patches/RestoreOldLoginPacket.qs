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

function RestoreOldLoginPacket()
{
    // Step 1a - Force the client to send 0x64
    var LANGTYPE = GetLangType();
    if (LANGTYPE.length === 1)
        return "Failed in Step 1a - " + LANGTYPE[0];

    // Step 1b - Force the client to send 0x64
    // search in CLoginMode_virt28
    var code =
        " 80 3D AB AB AB AB 00" + // cmp g_passwordencrypt, 0
        " 0F 85 AB AB 00 00" +    // jne addr1
        " 8B AB" + LANGTYPE +     // mov ecx, clientinfo_lang_type
        " AB AB" +                // test ecx, ecx  < --  nop code from here
        " 0F 84 AB AB 00 00" +    // jz addr2
        " 83 AB 12" +             // cmp ecx, 12h
        " 0F 84 AB AB 00 00" +    // jz addr2
        " 83 AB 0C" +             // cmp ecx, 0Ch
        " 0F 84 AB AB 00 00";     // jz addr2
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 1b";

    exe.replace(offset + 19,
        " 90 90" +
        " 90 90 90 90 90 90" +
        " 90 90 90" +
        " 90 90 90 90 90 90" +
        " 90 90 90" +
        " 90 90 90 90 90 90",
        PTYPE_HEX);


    //Disable password encrypt for lang_type 4 & 7
    var offset2 = exe.find(" 83 F9 07 75 AB", PTYPE_HEX, true, "\xAB", offset, offset + 0xFF);
    if (offset2 === -1)
        return "Failed in Step 1c";
    exe.replace(offset2 + 3," EB",PTYPE_HEX);

    offset2 = exe.find(" 83 F9 04 75 AB", PTYPE_HEX, true, "\xAB", offset, offset + 0xFF);
    if (offset2 === -1)
        return "Failed in Step 1d";
    exe.replace(offset2 + 3," EB",PTYPE_HEX);



    return true;
}

//====================================================================//
// Disable for Unneeded Clients. Start from first zero client version //
//====================================================================//
function RestoreOldLoginPacket_()
{
  return (exe.getClientDate() > 20171019 && IsZero()) || exe.getClientDate() >= 20181114;
}
