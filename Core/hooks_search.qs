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

function hooks_searchCodes_add(codes, importInfo)
{
    var importOffset = imports.ptrValidated(importInfo[0], importInfo[1], importInfo[2]);
    var importOffsetHex = importOffset.packToHex(4);
    var arr = [];
    for (var c = 0; c < codes.length; c ++)
    {
        var offsets = pe.findCodes(codes[c] + importOffsetHex);  // XXX dword ptr [importOffset]
        for (var i = 0; i < offsets.length; i ++)
        {
            arr.push([offsets[i], importOffset]);
        }
    }
    return arr;
}

function hooks_searchImportCallUsage(importInfo)
{
    return hooks_searchCodes_add(
        [
            "FF 15"  // call dword ptr [importOffset]
        ],
        importInfo
    );
}

function hooks_searchImportJmpUsage(importInfo)
{
    return hooks_searchCodes_add(
        [
            "FF 25"  // jmp dword ptr [importOffset]
        ],
        importInfo
    );
}

function hooks_searchImportMovUsage(importInfo)
{
    return hooks_searchCodes_add(
        [
            "8B 3D",  // mov edi, dword ptr [importOffset]
            "8B 35"   // mov esi, dword ptr [importOffset]
        ],
        importInfo
    );
}

function hooks_searchImportUsage(importInfo)
{
    return hooks_searchCodes_add(
        [
            "FF 15",  // call dword ptr [importOffset]
            "FF 25",  // jmp dword ptr [importOffset]
            "8B 3D",  // mov edi, dword ptr [importOffset]
            "8B 35"   // mov esi, dword ptr [importOffset]
        ],
        importInfo
    );
}
