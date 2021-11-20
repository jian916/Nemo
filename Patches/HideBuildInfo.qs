//
// Copyright (C) 2018-2021  Andrei Karas (4144)
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
    consoleLog("search strings");
    var buildStr = pe.stringVa("build : %s - %s");
    if (buildStr === -1)
        return "Failed in search 'build : %s - %s'";

    var verStr = pe.stringVa("ver : %d.%d.%d");
    if (verStr === -1)
        return "Failed in search 'ver : %d.%d.%d'";

    var snStr = pe.stringVa("s/n : %s");
    if (snStr === -1)
        return "Failed in search 's/n : %s'";

    consoleLog("search in CGameMode::ProcessTalkType");
    // erase time and date
    var code =
        "68 ?? ?? ?? ?? " +            // 0 push offset a113155
        "68 ?? ?? ?? ?? " +            // 5 push offset aOct312017
        "68 " + buildStr.packToHex(4); // 10 push offset aBuildSS
    var timeOffset = 1;
    var dateOffset = 6;
    var offset = pe.findCode(code);
    if (offset === -1)
        return "Failed in search build string usage";

    var timeAddr = pe.vaToRaw(pe.fetchDWord(offset + timeOffset));
    var dateAddr = pe.vaToRaw(pe.fetchDWord(offset + dateOffset));
    consoleLog("Erase timeAddr");
    eraseString(timeAddr, 0);
    consoleLog("Erase dateAddr");
    eraseString(dateAddr, 0);

    consoleLog("search version string usage");
    var code =
        "6A ?? " +                    // 0 push 3
        "6A ?? " +                    // 2 push 2
        "6A ?? " +                    // 4 push 0Eh
        "68 " + verStr.packToHex(4);  // 6 push offset aVerD_D_D
    var ver1Offset = 1;
    var ver2Offset = 3;
    var ver3Offset = 5;
    var offset = pe.findCode(code);
    if (offset === -1)
        return "Failed in search ver string usage";

    consoleLog("Remove ver1");
    exe.replaceByte(offset + ver1Offset, 0);
    consoleLog("Remove ver2");
    exe.replaceByte(offset + ver2Offset, 0);
    consoleLog("Remove ver3");
    exe.replaceByte(offset + ver3Offset, 0);

    consoleLog("search sn string usage");
    var code =
        "68 ?? ?? ?? ?? " +           // 0 push offset aT9mx8utS35wzas
        "68 " + snStr.packToHex(4);   // 5 push offset aSNS
    var snOffset = 1;
    var offset = pe.findCode(code);
    if (offset === -1)
        return "Failed in search sn string usage";
    var snAddr = pe.vaToRaw(pe.fetchDWord(offset + snOffset));
    consoleLog("Erase snAddr");
    eraseString(snAddr, 0);

    consoleLog("search \"mylog(\"");
    var myStr = pe.find("6D 79 6C 6F 67 28");
    if (myStr !== -1)
    {
        consoleLog("Erase myStr");
        eraseString(myStr, 0);
    }

    consoleLog("search \"EnterTraceLog(\"");
    var logStr = pe.find("45 6E 74 65 72 54 72 61 63 65 4C 6F 67 28");
    if (logStr !== -1)
    {
        consoleLog("Erase logStr");
        eraseString(logStr, 0);
    }

    consoleLog("search any \"year-\" strings");
    var code = ("" + exe.getClientDate()).substr(0, 4) + "-";
    var codes = pe.findAll(code.toHex());
    if (codes.length !== 0)
    {
        for (var f = 0; f < codes.length; f ++)
        {
            consoleLog("Erase year string");
            eraseString(codes[f], 0);
        }
    }

    var peHeader = pe.fetchDWord(0x3c);
    var optHeader = peHeader + 4 + 0x14;
    consoleLog("erase PE time stamp");
    exe.replaceDWord(peHeader + 8, 0);
    consoleLog("erase PE checksum");
    exe.replaceDWord(optHeader + 64, 0);

    return true;
}
