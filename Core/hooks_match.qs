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

function hooks_matchFunctionStart(storageKey, offset)
{
    checkArgs("hooks.matchFunctionStart", arguments, [["Number", "Number"]]);

    var offsetVa = pe.rawToVa(offset)

    var code =
        "55 " +                       // 0 push ebp
        "8B EC " +                    // 1 mov ebp, esp
        "53 " +                       // 3 push ebx
        "8B D9 ";                     // 4 mov ebx, ecx
    var stolenCodeOffset = [0, 6];
    var continueOffset = 6;
    var found = pe.match(code, offset);

    if (found !== true)
    {
        code =
            "53 " +                       // 0 push ebx
            "56 " +                       // 1 push esi
            "8B F1 " +                    // 2 mov esi, ecx
            "8B 4E ??";                   // 4 mov ecx, [esi+18h]
        stolenCodeOffset = [0, 7];
        continueOffset = 7;
        found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "55 " +                       // 0 push ebp
            "8B EC " +                    // 1 mov ebp, esp
            "53 " +                       // 3 push ebx
            "56";                         // 4 push esi
        stolenCodeOffset = [0, 5];
        continueOffset = 5;
        found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "55 " +                       // 0 push ebp
            "8B EC " +                    // 1 mov ebp, esp
            "6A FF ";                     // 3 push 0FFFFFFFFh
        stolenCodeOffset = [0, 5];
        continueOffset = 5;
        found = pe.match(code, offset);
    }

    if (found !== true)
    {
        var code =
            "6A FF " +                    // 0 push 0FFFFFFFFh
            "68 ?? ?? ?? ??";             // 2 push offset loc_79D8EF
        stolenCodeOffset = [0, 7];
        continueOffset = 7;
        found = pe.match(code, offset);
    }

    if (found !== true)
    {
        throw "First pattern not found: 0x" + offsetVa.toString(16);
    }
    var obj = hooks.createHookObj();
    obj.patchAddr = offset;
    obj.stolenCode = exe.fetchHexBytes(offset, stolenCodeOffset);
    obj.stolenCode1 = obj.stolenCode;
    obj.continueOffsetVa = offsetVa + continueOffset;
    obj.retCode = "";
    obj.endHook = false;
    return obj;
}

function hooks_matchFunctionEnd(storageKey, offset)
{
    checkArgs("hooks.matchFunctionEnd", arguments, [["Number", "Number"]]);

    consoleLog("match known second pattern");
    var code =
        "5B " +                       // 0 pop ebx
        "5D " +                       // 1 pop ebp
        "C2 ?? ??";                   // 2 retn 8
    var stolenCodeOffset = [0, 5];
    var stolenCode1Offset = [0, 2];
    var retOffset = [2, 3];
    var found = pe.match(code, offset);

    if (found !== true)
    {
        code =
            "5E " +                       // 0 pop esi
            "5B " +                       // 1 pop ebx
            "C2 ?? ??";                   // 2 retn 8
        stolenCodeOffset = [0, 5];
        stolenCode1Offset = [0, 2];
        retOffset = [2, 3];
        found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "8B E5 " +                    // 0 mov esp, ebp
            "5D " +                       // 2 pop ebp
            "C2 ?? ?? ";                  // 3 retn 4
        stolenCodeOffset = [0, 6];
        stolenCode1Offset = [0, 3];
        retOffset = [3, 3];
        found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "83 C4 ?? " +                 // 0 add esp, 20h
            "C2 ?? ??";                   // 3 retn 4
        stolenCodeOffset = [0, 6];
        stolenCode1Offset = [0, 3];
        retOffset = [3, 3];
        found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "81 C4 ?? 00 00 00 " +        // 0 add esp, 88h
            "C2 ?? ?? ";                  // 6 retn 0Ch
        stolenCodeOffset = [0, 9];
        stolenCode1Offset = [0, 6];
        retOffset = [6, 3];
        var found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "5E " +                       // 0 pop esi
            "8B E5 " +                    // 1 mov esp, ebp
            "5D " +                       // 3 pop ebp
            "C3 ";                        // 4 ret retn
        stolenCodeOffset = [0, 5];
        stolenCode1Offset = [0, 4];
        retOffset = [4, 1];
        var found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "5E " +                       // 0 pop esi
            "83 C4 ?? " +                 // 1 add esp, 10h
            "C3 ";                        // 4 ret retn
        stolenCodeOffset = [0, 5];
        stolenCode1Offset = [0, 4];
        retOffset = [4, 1];
        var found = pe.match(code, offset);
    }

    if (found !== true)
    {
        code =
            "5B " +                       // 0 pop ebx
            "83 C4 ?? " +                 // 1 add esp, 10h
            "C3 ";                        // 4 ret retn
        stolenCodeOffset = [0, 5];
        stolenCode1Offset = [0, 4];
        retOffset = [4, 1];
        var found = pe.match(code, offset);
    }

    if (found !== true)
    {
        throw "Pattern not found for address: 0x" + pe.rawToVa(offset).toString(16);
    }
    var obj = hooks.createHookObj();
    obj.patchAddr = offset;
    obj.stolenCode = exe.fetchHexBytes(offset, stolenCodeOffset);
    obj.stolenCode1 = exe.fetchHexBytes(offset, stolenCode1Offset);
    obj.retCode = exe.fetchHexBytes(offset, retOffset);
    obj.continueOffsetVa = 0;
    obj.endHook = true;
    return obj;
}

function hooks_matchImportUsage_code(code, offset, importOffset)
{
    var found = pe.match(code, offset);  // call dword ptr [offset]
    var addrOffset = 2;

    if (found !== true)
        return false;

    var obj = hooks.createHookObj();
    obj.patchAddr = offset + addrOffset;
    obj.retCode = "FF 25" + importOffset.packToHex(4);
    obj.endHook = true;
    obj.importOffset = importOffset;
    obj.firstJmpType = hooks.jmpTypes.IMPORT;
    return obj;
}

function hooks_matchImportCallUsage(offset, importOffset)
{
    var obj = hooks_matchImportUsage_code("FF 15" + importOffset.packToHex(4), offset, importOffset)  // call dword ptr [offset]
    if (obj === false)
        throw "Import usage with address 0x" + importOffset.toString(16) + " not found.";
    return obj;
}

function hooks_matchImportJmpUsage(offset, importOffset)
{
    var obj = hooks_matchImportUsage_code("FF 25" + importOffset.packToHex(4), offset, importOffset)  // jmp dword ptr [offset]
    if (obj === false)
        throw "Import usage with address 0x" + importOffset.toString(16) + " not found.";
    return obj;
}

function hooks_matchImportMovUsage(offset, importOffset)
{
    var hexImportOffset = importOffset.packToHex(4);

    var obj = hooks_matchImportUsage_code("8B 3D" + hexImportOffset, offset, importOffset)  // mov edi, dword ptr [offset]
    if (obj !== false)
        return obj;

    obj = hooks_matchImportUsage_code("8B 35" + hexImportOffset, offset, importOffset)  // mov esi, dword ptr [offset]
    if (obj !== false)
        return obj;

    throw "Import usage with address 0x" + importOffset.toString(16) + " not found.";
}

function hooks_matchImportUsage(offset, importOffset)
{
    var hexImportOffset = importOffset.packToHex(4);

    var obj = hooks_matchImportUsage_code("FF 15" + hexImportOffset, offset, importOffset)  // call dword ptr [offset]
    if (obj !== false)
        return obj;

    var obj = hooks_matchImportUsage_code("FF 25" + hexImportOffset, offset, importOffset)  // jmp dword ptr [offset]
    if (obj !== false)
        return obj;

    var obj = hooks_matchImportUsage_code("8B 3D" + hexImportOffset, offset, importOffset)  // mov edi, dword ptr [offset]
    if (obj !== false)
        return obj;

    obj = hooks_matchImportUsage_code("8B 35" + hexImportOffset, offset, importOffset)  // mov esi, dword ptr [offset]
    if (obj !== false)
        return obj;

    throw "Import usage with address 0x" + importOffset.toString(16) + " not found.";
}
