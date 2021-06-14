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

    var obj = hooks.matchFunctionEnd(offset);
    var stolenCode = obj.stolenCode1;
    var retCode = obj.retCode;

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
