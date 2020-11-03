//
// Copyright (C) 2020  Andrei Karas (4144)
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

function simpleReplace(str1, type1, str2, type2, useMask)
{
    useMask = useMask || false;
    var offset = exe.find(str1, type1, useMask, "\xAB");
    if (offset === -1)
        return false;
    exe.replace(offset, str2, type2);
    return offset;
}

function simpleReplaceAll(str1, type1, str2, type2, useMask)
{
    useMask = useMask || false;
    var offsets = exe.findAll(str1, type1, useMask, "\xAB");
    if (offsets.length === 0)
        return offsets;
    for (var i = 0; i < offsets.length; i++)
    {
        exe.replace(offsets[i], str2, type2);
    }
    return offsets;
}


function simpleReplaceHex(str1, str2, useMask)
{
    return simpleReplace(str1, PTYPE_HEX, str2, PTYPE_HEX, useMask);
}

function simpleReplaceAllHex(str1, str2, useMask)
{
    return simpleReplaceAll(str1, PTYPE_HEX, str2, PTYPE_HEX, useMask);
}


function simpleReplaceStr(str1, str2, useMask)
{
    return simpleReplace(str1, PTYPE_STRING, str2, PTYPE_STRING, useMask);
}

function simpleReplaceAllStr(str1, str2, useMask)
{
    return simpleReplaceAll(str1, PTYPE_STRING, str2, PTYPE_STRING, useMask);
}
