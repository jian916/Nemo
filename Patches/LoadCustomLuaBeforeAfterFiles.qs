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

function LoadCustomLuaBeforeAfterFiles()
{
    consoleLog("Read table");

    var offset = table.getRaw(table.CLua_Load);
    if (offset < 0)
    {
        return "CLua_Load not set";
    }
    var CLua_Load = table.get(table.CLua_Load);

    consoleLog("Parse function start");

    var matchObj = hooks.matchFunctionStart(offset);

    consoleLog("allocate buffer");

    var free = exe.findZeros(300);
    if (free === -1)
        return "Not enough free space";
    var str = "";
    for (var i = 0; i < 300; i ++)
        str = str + "\x00";
    exe.insert(free, 300, str, PTYPE_STRING);
    var buffer = pe.rawToVa(free);

    consoleLog("Prepary own code");

    var info = lua.getCLuaLoadInfo(4);

    var text = asm.combine(
        "push ecx",
        info.asmCopyArgs,
        "push esi",
        "push edi",
        "mov esi, dword ptr [esp + 0x8]",
        "mov edi, buffer",
        "call func_strcpy",
        "mov esi, str_before",
        "call func_strcpy",
        "mov dword ptr [esp + 0x8], buffer",
        "pop edi",
        "pop esi",
        "push _normal_label",
        asm.hexToAsm(matchObj.stolenCode),
        "jmp continueItemAddr",

        "_normal_label:",
        "pop ecx",
        "push ecx",
        info.asmCopyArgs,
        "push _after_label",
        asm.hexToAsm(matchObj.stolenCode),
        "jmp continueItemAddr",

        "_after_label:",
        "pop ecx",
        "push eax",
        info.asmCopyArgs,
        "push esi",
        "push edi",
        "mov esi, dword ptr [esp + 0x8]",
        "mov edi, buffer",
        "call func_strcpy",
        "mov esi, str_after",
        "call func_strcpy",
        "mov dword ptr [esp + 0x8], buffer",
        "pop edi",
        "pop esi",
        "push _exit_label",
        asm.hexToAsm(matchObj.stolenCode),
        "jmp continueItemAddr",

        "_exit_label:",
        "pop eax",
        "ret argsOffset",

        "func_strcpy:",
        "mov al, [esi]",
        "mov [edi], al",
        "inc esi",
        "inc edi",
        "cmp byte ptr [esi], 0",
        "jne func_strcpy",
        "mov byte ptr [edi], 0",
        "ret",

        "str_before:",
        asm.stringToAsm("_before\x00"),
        "str_after:",
        asm.stringToAsm("_after\x00")
    );
    var vars = {
        "continueItemAddr": matchObj.continueOffsetVa,
        "CLua_Load": CLua_Load,
        "buffer": buffer,
        "argsOffset": info.argsOffset
    }

    var data = exe.insertAsmText(text, vars);
    var free = data[0]

    consoleLog("add jump to own code");
    exe.setJmpRaw(offset, free);

    return true;
}
