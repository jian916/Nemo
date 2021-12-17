//
// Copyright (C) 2018-2021 Andrei Karas (4144)
// Copyright (C) 2020 Asheraf
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

function ChangeAdventureAgencyLevelRange()
{
    var offset = pe.stringVa("%d");

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    var strHex = offset.packToHex(4);

    var code =
        "8D 46 05" +          // 0 lea eax, [esi+5]
        "66 C7 45 ?? 00 00" + // 3 mov [ebp+var_20], 0
        "50" +                // 9 push eax
        "68" + strHex +       // 10 push offset aD_2
        "6A FF";              // 15 push 0FFFFFFFFh

    var rangeUOffset = [2, 1];
    var offsetsU = pe.findCodes(code);

    if (offsetsU.length === 0)
    {
        var code =
            "8D 46 05" +      // 0 lea eax, [esi+5]
            "50" +            // 3 push eax
            "68" + strHex +   // 4 push offset aD_2
            "6A FF";          // 9 push 0FFFFFFFFh

        rangeUOffset = [2, 1];
        offsetsU = pe.findCodes(code);
    }

    if (offsetsU.length === 0)
        return "Failed in Step 1 - AgencyUpperLevelRange not found";

    var code =
        "8D 46 ??" +        // 0 lea eax, [esi-5]
        "0F 57 C0" +        // 3 xorps xmm0, xmm0
        "3B C1" +           // 6 cmp eax, ecx
        "66 0F D6 45 ??" +  // 8 movq [ebp+var_1C], xmm0
        "0F 4C C1" +        // 13 cmovl eax, ecx
        "50" +              // 16 push eax
        "68" + strHex +     // 17 push offset aD_2
        "6A FF";            // 22 push 0FFFFFFFFh

    var rangeLOffset = [2, 1];
    var offsetsL = pe.findCodes(code);

    if (offsetsL.length === 0)
    {
        var code =
            "8D 46 ??" +      // 0 lea eax, [esi-5]
            "3B C1" +         // 3 cmp eax, ecx
            "0F 4C C1" +      // 5 cmovl eax, ecx
            "50" +            // 8 push eax
            "68" + strHex +   // 9 push offset aD_2
            "6A FF";          // 14 push 0FFFFFFFFh

        rangeLOffset = [2, 1];
        offsetsL = pe.findCodes(code);
    }

    if (offsetsL.length === 0)
        return "Failed in Step 2 - AgencyLowerLevelRange not found";

    var upprangeVal = exe.getUserInput("$upprangeVal", XTYPE_BYTE, _("upper level range (default +5)"), _("Enter new upper level range"), "+5", 1, 127);
    var lowrangeVal = exe.getUserInput("$lowrangeVal", XTYPE_BYTE, _("lower level range (default -5)"), _("Enter new lower level range"), "-5", -127, -1);

    for (var i = 0; i < offsetsU.length; i++)
    {
        pe.replaceByte(offsetsU[i] + rangeUOffset[0], upprangeVal);
        logVaVar("MAX_ADVENTURE_AGENCY_LEVEL_RANGE", offsetsU[i], rangeUOffset);
    }

    for (var i = 0; i < offsetsL.length; i++)
    {
        pe.replaceByte(offsetsL[i] + rangeLOffset[0], lowrangeVal);
        logVaVar("MIN_ADVENTURE_AGENCY_LEVEL_RANGE", offsetsL[i], rangeLOffset);
    }

    return true;
}

//============================//
// Disable Unsupported client //
//============================//
function ChangeAdventureAgencyLevelRange_()
{
    return (pe.stringRaw("btn_job_def_on") !== -1);
}
