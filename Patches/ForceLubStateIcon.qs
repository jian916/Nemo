//
// Copyright (C) 2019  CH.C
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

function ForceLubStateIcon()
{
    consoleLog("step 1");
    var offset = exe.findString("GetEFSTImgFileName", RVA, true);
    if (offset === -1)
        return "Failed in Step 1 - Reference String Missing";

    consoleLog("step 2");
    offset = exe.findCode("68" + offset.packToHex(4), PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in Step 2";

    consoleLog("step 3");
    var code =
        "83 FB 04 " +                 // 0 cmp ebx, 4
        "0F 87 AB AB AB AB " +        // 3 ja loc_AB888E
        "FF 24 9D ";                  // 9 jmp off_AB88A4[ebx*4]
    var patchOffset = 3;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x80);
    if (offset === -1)
        return "Failed in Step 3";

    consoleLog("step 4");
    exe.replace(offset + patchOffset, " 90 E9", PTYPE_HEX);

    return true;
}
