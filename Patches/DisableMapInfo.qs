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
//# Purpose: Zero out the system\mapInfo*.lub file strings use for displaying #
//#          map sign inside CMapInfoMgr function when players entering map.  #
//#############################################################################

function DisableMapInfo()
{
    consoleLog("Step 1 - Search string 'system\mapInfo*.lub'");
    if (IsSakray())
        iiName = "system\\mapInfo_sak.lub";
    else
        iiName = "system\\mapInfo_true.lub";

    var offset = exe.findString(iiName, RAW);

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    consoleLog("Step 2 - Zero it out string 'system\mapInfo*.lub'");
    exe.replace(offset, "00 ", PTYPE_HEX);

    consoleLog("Step 3 - Prep code for finding the CMapInfoMgr ErrorMsg window");
    var code =
        "0F 84 B4 00 00 00 " +  // 00 jz loc_9E7B40
        "FF 75 EC " +           // 06 push [ebp+var_14]
        "E8 AB AB AB AB " +     // 09 call sub_475E20
        "6A 00 " +              // 14 push 0
        "68 AB AB AB AB " +     // 16 push 9E8270h
        "FF 75 EC " +           // 21 push [ebp+var_14]
        "E8 AB AB AB AB ";      // 24 call sub_46BC60

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 3 - Pattern not found";

    consoleLog("Step 4 - Replace offset found in step 3 with NOP + JMP");
    exe.replace(offset, "90 E9 ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableMapInfo_()
{
    if (IsSakray())
        iiName = "system\\mapInfo_sak.lub";
    else
        iiName = "system\\mapInfo_true.lub";

    return (exe.findString(iiName, RAW) !== -1);
}
