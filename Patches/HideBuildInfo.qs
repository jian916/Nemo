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
//#############################################################
//# Purpose: Hide build info                                  #
//#############################################################

function HideBuildInfo()
{
    var buildStr = exe.findString("build : %s - %s", RVA);
    if (buildStr === -1)
        return "Failed in search 'build : %s - %s'";

    var verStr = exe.findString("ver : %d.%d.%d", RVA);
    if (verStr === -1)
        return "Failed in search 'ver : %d.%d.%d'";

    var snStr = exe.findString("s/n : %s", RVA);
    if (snStr === -1)
        return "Failed in search 's/n : %s'";

    // search in CGameMode::ProcessTalkType
    // erase time and date
    var code =
        "68 AB AB AB AB " +            // 0 push offset a113155
        "68 AB AB AB AB " +            // 5 push offset aOct312017
        "68 " + buildStr.packToHex(4); // 10 push offset aBuildSS
    var timeOffset = 1;
    var dateOffset = 6;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in search build string usage";

    var timeAddr = exe.Rva2Raw(exe.fetchDWord(offset + timeOffset));
    var dateAddr = exe.Rva2Raw(exe.fetchDWord(offset + dateOffset));
    eraseString(timeAddr, 0);
    eraseString(dateAddr, 0);

    var code =
        "6A AB " +                    // 0 push 3
        "6A AB " +                    // 2 push 2
        "6A AB " +                    // 4 push 0Eh
        "68 " + verStr.packToHex(4);  // 6 push offset aVerD_D_D
    var ver1Offset = 1;
    var ver2Offset = 3;
    var ver3Offset = 5;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in search ver string usage";

    exe.replaceByte(offset + ver1Offset, 0);
    exe.replaceByte(offset + ver2Offset, 0);
    exe.replaceByte(offset + ver3Offset, 0);

    var code =
        "68 AB AB AB AB " +           // 0 push offset aT9mx8utS35wzas
        "68 " + snStr.packToHex(4);   // 5 push offset aSNS
    var snOffset = 1;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in search sn string usage";
    var snAddr = exe.Rva2Raw(exe.fetchDWord(offset + snOffset));
    eraseString(snAddr, 0);

    // search "mylog("
    var myStr = exe.find("6D 79 6C 6F 67 28", PTYPE_HEX, false, "\xAB");
    if (myStr !== -1)
    {
        eraseString(myStr, 0);
    }

    // search "EnterTraceLog("
    var logStr = exe.find("45 6E 74 65 72 54 72 61 63 65 4C 6F 67 28", PTYPE_HEX, false, "\xAB");
    if (logStr !== -1)
    {
        eraseString(logStr, 0);
    }

    // search any "year-" strings
    var code = ("" + exe.getClientDate()).substr(0, 4) + "-";
    var codes = exe.findAll(code, PTYPE_STRING, false, "\xAB");
    if (codes.length !== 0)
    {
        for (var f = 0; f < codes.length; f ++)
        {
            eraseString(codes[f], 0);
        }
    }

    var peHeader = exe.fetchDWord(0x3c);
    var optHeader = peHeader + 4 + 0x14;
    // erase PE time stamp
    exe.replaceDWord(peHeader + 8, 0);
    // erase PE checksum
    exe.replaceDWord(optHeader + 64, 0);

    return true;
}
