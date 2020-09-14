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
//##############################################################
//# Purpose: Change exp guild limit from 50 to custom value in #
//# UIGuildPositionManageWnd_virt136                           #
//##############################################################

function ChangeGuildExpLimit()
{
    // search in UIGuildPositionManageWnd_virt136
    // step 1
    var code =
        "85 C0 " +                    // 0 test eax, eax
        "78 09 " +                    // 2 js short loc_69636D
        "83 F8 32 " +                 // 4 cmp eax, 32h
        "0F 8E AB AB 00 00 " +        // 7 jle loc_6963ED
        "6A 00 " +                    // 13 push 0
        "6A 32 " +                    // 15 push 32h
        "68 9E 0D 00 00 " +           // 17 push 0D9Eh
        "E8 ";                        // 22 call MsgStr
    var limitOffset = 6;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code = code.replace("78 09 ", "78 05 "); //JLE short
        code = code.replace("0F 8E AB AB 00 00 ", " 7E AB "); //JLE short
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in step 1 - check limit pattern not found";

    var limit = exe.getUserInput("$guildExpLimit", XTYPE_BYTE, _("Number Input"), _("Enter new guild exp limit (0-100, default is 50):"), 50, 0, 100);
    if (limit === 50)
    {
        return "Patch Cancelled - New value is same as old";
    }

    exe.replace(offset + limitOffset, limit.packToHex(1), PTYPE_HEX);

    return true;
}
