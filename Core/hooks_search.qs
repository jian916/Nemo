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

function hooks_searchCodes_add(arr, code, importOffset)
{
    var offsets = pe.findCodes(code);
    for (var i = 0; i < offsets.length; i ++)
    {
        arr.push([offsets[i], importOffset]);
    }
}

function hooks_searchImportCallUsage(importInfo)
{
    var importOffset = imports.ptrValidated(importInfo[0], importInfo[1], importInfo[2]);
    var arr = [];
    hooks_searchCodes_add(arr, "FF 15" + importOffset.packToHex(4), importOffset);  // call dword ptr [importOffset]
    return arr;
}

function hooks_searchImportJmpUsage(importInfo)
{
    var importOffset = imports.ptrValidated(importInfo[0], importInfo[1], importInfo[2]);
    var arr = [];
    hooks_searchCodes_add(arr, "FF 25" + importOffset.packToHex(4), importOffset);  // jmp dword ptr [importOffset]
    return arr;
}

function hooks_searchImportMovUsage(importInfo)
{
    var importOffset = imports.ptrValidated(importInfo[0], importInfo[1], importInfo[2]);
    var importOffsetHex = importOffset.packToHex(4);
    var arr = [];

    hooks_searchCodes_add(arr, "8B 3D" + importOffsetHex, importOffset);  // mov edi, dword ptr [importOffset]
    hooks_searchCodes_add(arr, "8B 35" + importOffsetHex, importOffset);  // mov esi, dword ptr [importOffset]

    return arr;
}

function hooks_searchImportUsage(importInfo)
{
    var importOffset = imports.ptrValidated(importInfo[0], importInfo[1], importInfo[2]);
    var importOffsetHex = importOffset.packToHex(4);
    var arr = [];

    hooks_searchCodes_add(arr, "FF 15" + importOffsetHex, importOffset);  // call dword ptr [importOffset]
    hooks_searchCodes_add(arr, "FF 25" + importOffsetHex, importOffset);  // jmp dword ptr [importOffset]
    hooks_searchCodes_add(arr, "8B 3D" + importOffsetHex, importOffset);  // mov edi, dword ptr [importOffset]
    hooks_searchCodes_add(arr, "8B 35" + importOffsetHex, importOffset);  // mov esi, dword ptr [importOffset]

    return arr;
}
