//
// Copyright (C) 2021  Andrei Karas (4144)
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

function addPostHook(patchAddr, stolenCode, retCode, text, vars)
{
    var text = asm.combine(
        asm.hexToAsm(stolenCode),
        text,
        "_ret:",
        asm.hexToAsm(retCode));

    var data = exe.insertAsmText(text, vars);
    var free = data[0]

    consoleLog("add jump to own code");
    exe.setJmpRaw(patchAddr, free);
}

function EnableSlashAtCommands()
{
    consoleLog("Match code for hook");

    var offset = table.getRaw(table.CSession_GetTalkType_ret);
    if (offset < 0)
    {
        return "ret address not found";
    }

    var code =
        "8B E5 " +                    // 0 mov esp, ebp
        "5D " +                       // 2 pop ebp
        "C2 0C 00 ";                  // 3 retn 0Ch
    var stolenCodeOffset = [0, 3];
    var retOffset = [3, 3];
    var found = exe.match(code, false, offset);

    if (found !== true)
    {
        code =
            "81 C4 AB 00 00 00 " +        // 0 add esp, 88h
            "C2 0C 00 ";                  // 6 retn 0Ch
        stolenCodeOffset = [0, 6];
        retOffset = [6, 3];
        var found = exe.match(code, true, offset);
    }

    if (found !== true)
    {
        throw "Pattern not found";
    }

    var stolenCode = exe.fetchHexBytes(offset, stolenCodeOffset);
    var retCode = exe.fetchHexBytes(offset, retOffset);

    consoleLog("Prepary own code");

    var text = asm.combine(
        "cmp eax, 0xFFFFFFFF",
        "jnz _ret",
        "mov ecx, dword ptr [esp + 0xc - 4]",
        "mov ecx, dword ptr [ecx]",
        "cmp ecx, 3",
        "jnz _ret",
        "xor eax, eax",
        "mov ecx, dword ptr [esp + 0xc - 4]",
        "mov dword ptr [ecx], eax"
    );

    consoleLog("Set hook");

    addPostHook(offset, stolenCode, retCode, text, {});
    return true;
}
