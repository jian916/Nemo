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

function hooks_matchFunctionStart(offset)
{
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
    var obj = new Object();
    obj.stolenCode = exe.fetchHexBytes(offset, stolenCodeOffset);
    obj.continueOffsetVa = offsetVa + continueOffset;
    return obj;
}

function hooks_matchFunctionEnd(offset)
{
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
        throw "Second pattern not found";
    }
    var obj = new Object();
    obj.stolenCode = exe.fetchHexBytes(offset, stolenCodeOffset);
    obj.stolenCode1 = exe.fetchHexBytes(offset, stolenCode1Offset);
    obj.retCode = exe.fetchHexBytes(offset, retOffset);
    return obj;
}

function registerHooks()
{
    hooks = new Object();
    hooks.matchFunctionStart = hooks_matchFunctionStart;
    hooks.matchFunctionEnd = hooks_matchFunctionEnd;
}
