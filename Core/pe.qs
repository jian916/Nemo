//
// Copyright (C) 2020-2021  Andrei Karas (4144)
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

function pe_find(code, startRaw, endRaw)
{
    checkArgs(arguments, [["String"], ["String", "Number"], ["String", "Number", "Number"]]);

    if (typeof(startRaw) === "undefined")
    {
        startRaw = 0;
        endRaw = 0x7fffffff;
    }
    else if (typeof(endRaw) === "undefined")
    {
        endRaw = 0x7fffffff;
    }
    return pe.findMaskInternal(code, startRaw, endRaw);
}

function pe_findAll(code, startRaw, endRaw)
{
    checkArgs(arguments, [["String"], ["String", "Number"], ["String", "Number", "Number"]]);

    if (typeof(startRaw) === "undefined")
    {
        startRaw = 0;
        endRaw = 0x7fffffff;
    }
    else if (typeof(endRaw) === "undefined")
    {
        endRaw = 0x7fffffff;
    }
    var offsets = []
    var offset = pe.findMaskInternal(code, startRaw, endRaw);
    var sz = code.hexlength();
    while (offset !== -1)
    {
        offsets.push(offset);
        startRaw = offset + sz;
        offset = pe.findMaskInternal(code, startRaw, endRaw);
    }
    return offsets;
}

function pe_findCode(code)
{
    checkArgs(arguments, [["String"]]);

    var sect = pe.sectionRaw(CODE);
    var startRaw = sect[0];
    var endRaw = sect[1];
    return pe.findMaskInternal(code, startRaw, endRaw);
}

function pe_findCodes(code)
{
    checkArgs(arguments, [["String"]]);

    var sect = pe.sectionRaw(CODE);
    var startRaw = sect[0];
    var endRaw = sect[1];
    var offsets = []
    var offset = pe.findMaskInternal(code, startRaw, endRaw);
    var sz = code.hexlength();
    while (offset !== -1)
    {
        offsets.push(offset);
        startRaw = offset + sz;
        offset = pe.findMaskInternal(code, startRaw, endRaw);
    }
    return offsets;
}

function pe_match(code, addrRaw)
{
    checkArgs(arguments, [["String", "Number"]]);

    var offset = pe.findMaskInternal(code, addrRaw, addrRaw + 1);
    if (offset !== addrRaw)
        return false;
    return true;
}

function registerPe()
{
    pe.find = pe_find;
    pe.findAll = pe_findAll;
    pe.findCode = pe_findCode;
    pe.findCodes = pe_findCodes;
    pe.match = pe_match;
}
