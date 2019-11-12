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
//# Purpose: Hide packets table from peek                     #
//#############################################################

function HidePacketsFromPeek()
{
    var code = "E8ABABABAB8BC8E8ABABABAB50E8ABABABAB8BC8E8ABABABAB6A01E8ABABABAB8BC8E8ABABABAB6A06";
    var pushOffset = 25;
    var callOffset = 27;
    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    if (offsets.length === 0)
        return "Failed in search pattern";

    if (offsets.length > 2)
        return "Found wrong number of patterns: " + offsets.length;

    for (var f = 0; f < offsets.length; f ++)
    {
        var instanceAddr = exe.fetchDWord(offsets[f] + callOffset + 1) + 2;

        var code = "E8 " + instanceAddr.packToHex(4) + " 6A 01";
        exe.replace(offsets[f] + pushOffset, code, PTYPE_HEX);
    }

    return true;
}
