//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2018-2021 Andrei Karas (4144)
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

function HidePacketsFromPeek()
{
    var code = "E8????????8BC8E8????????50E8????????8BC8E8????????6A01E8????????8BC8E8????????6A06";
    var pushOffset = 25;
    var callOffset = 27;
    var offsets = pe.findCodes(code);

    if (offsets.length === 0)
    {
        code = "E8????????8BC8E8????????50E8????????8BC8E8????????6A006A016A11B9????????E8????????6A01E8????????8BC8E8????????6A06";
        pushOffset = 41;
        callOffset = 43;
        offsets = pe.findCodes(code);
    }

    if (offsets.length === 0)
        return "Pattern not found";

    if (offsets.length > 2)
        return "Found wrong number of patterns: " + offsets.length;

    for (var f = 0; f < offsets.length; f++)
    {
        var instanceAddr = exe.fetchDWord(offsets[f] + callOffset + 1) + 2;
        var code = "E8 " + instanceAddr.packToHex(4) + "6A 01 ";

        exe.replace(offsets[f] + pushOffset, code, PTYPE_HEX);
    }

    return true;
}
