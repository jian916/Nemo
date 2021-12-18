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

function exe_setJmpVa(patchAddr, jmpAddrVa, cmd, codeLen)
{
    if (typeof(cmd) === "undefined")
        cmd = "jmp";
    var vars = {
        "offset": jmpAddrVa,
    };
    var code = asm.textToHexRaw(patchAddr, cmd + " offset", vars);
    if (typeof(codeLen) !== "undefined")
    {
        var sz = code.hexlength();
        if (sz > codeLen)
            fatalError("Jmp Code bigger than requested");
        for (var i = 0; i < codeLen - sz; i ++)
        {
            code = code + " 90";
        }
    }

    if (patch.getState() !== 2)
        pe.replaceHex(patchAddr, code);
    else
        pe.directReplace(patchAddr, code);
}

function exe_setJmpRaw(patchAddr, jmpAddrRaw, cmd, codeLen)
{
    exe_setJmpVa(patchAddr, pe.rawToVa(jmpAddrRaw), cmd, codeLen);
}

function exe_setNops(patchAddr, nopsCount)
{
    var code = "";
    for (var i = 0; i < nopsCount; i ++)
    {
        code = code + "90 ";
    }
    pe.replaceHex(patchAddr, code);
}

function exe_setNopsRange(patchStartAddr, patchEndAddr)
{
    exe_setNops(patchStartAddr, patchEndAddr - patchStartAddr);
}

function exe_insertAsmText(commands, vars, freeSpace)
{
    if (typeof(freeSpace) === "undefined")
        freeSpace = 0;
    var size = asm.textToHexLength(commands, vars) + freeSpace;
    var free = exe.findZeros(size);
    if (free === -1)
        fatalError("Failed in exe.insertAsm - Not enough free space");

    var obj = asm.textToObjRaw(free, commands, vars);
    exe.insert(free, size, obj.code, PTYPE_HEX);
    return [free, obj.code, obj.vars];
}

function exe_insertAsmTextObj(commands, vars, freeSpace, dryRun)
{
    if (typeof(freeSpace) === "undefined")
        freeSpace = 0;
    if (typeof(dryRun) === "undefined")
        dryRun = false;
    var size = asm.textToHexLength(commands, vars) + freeSpace;
    if (patch.getState() !== 2)
    {
        var free = exe.findZeros(size);
        if (free === -1)
            fatalError("Failed in exe.insertAsm - Not enough free space");
    }
    else
    {
        if (storage.zero == 0)
            fatalError("Failed in exe.insertAsm - Not enough free space");
        free = storage.zero;
    }

    var obj = asm.textToObjRaw(free, commands, vars);
    if (dryRun !== true)
    {
        if (patch.getState() !== 2)
        {
            exe.insert(free, size, obj.code, PTYPE_HEX);
        }
        else
        {
            pe.directReplace(free, obj.code);
            storage.zero = storage.zero + size;
        }
    }
    obj.free = free;
    obj.isFinal = false;
    return obj;
}

function exe_insertAsmFile(fileName, vars, freeSpace, dryRun)
{
    var commands = asm.load(fileName);
    return exe_insertAsmTextObj(commands, vars, freeSpace, dryRun);
}

function exe_insertDWord(value, dryRun)
{
    if (typeof(dryRun) === "undefined")
        dryRun = false;

    if (patch.getState() !== 2)
    {
        var free = exe.findZeros(size);
        if (free === -1)
            fatalError("Failed in exe.insertDWord - Not enough free space");
    }
    else
    {
        if (storage.zero == 0)
            fatalError("Failed in exe.insertDWord - Not enough free space");
        free = storage.zero;
    }
    var obj = asm.textToObjRaw(free, "long " + value, {});
    var size = 4;
    if (dryRun !== true)
    {
        if (patch.getState() !== 2)
        {
            exe.insert(free, size, obj.code, PTYPE_HEX);
        }
        else
        {
            pe.directReplace(free, obj.code);
            storage.zero = storage.zero + size;
        }
    }
    return free;
}

function exe_insertHex(value)
{
    var size = value.hexlength();
    var free = exe.findZeros(size);
    if (free === -1)
        fatalError("Failed in exe.insertHex - Not enough free space");

    exe.insert(free, size, value, PTYPE_HEX);
    return free;
}

function exe_replaceAsmText(patchAddr, commands, vars)
{
    reportLegacy("Please replace exe.replaceAsmText to pe.replaceAsmText");
}

function exe_replaceAsmFile(fileName, vars)
{
    reportLegacy("Please replace exe.replaceAsmFile to pe.replaceAsmFile");
}

function exe_match(code, useMask, addrRaw)
{
    reportLegacy("Please replace exe.match to pe.match");

    var offset = exe.find(code, PTYPE_HEX, useMask, "\xAB", addrRaw, addrRaw + 1);
    if (offset !== addrRaw)
        return false;
    return true;
}

function exe_fetchValue(offset, offset2)
{
    reportLegacy("Please replace exe.fetchValue to pe.fetchValue");
}

function exe_fetchValueSimple(offset)
{
    reportLegacy("Please replace exe.fetchValueSimple to pe.fetchValueSimple");
}

function exe_setValue(offset, offset2, value)
{
    reportLegacy("Please replace exe.setValue to pe.setValue");
}

function exe_setValueSimple(offset, value)
{
    reportLegacy("Please replace exe.setValueSimple to pe.setValueSimple");
}

function exe_setShortJmpVa(patchAddr, jmpAddrVa, cmd)
{
    if (typeof(cmd) === "undefined")
        cmd = "jmp";
    var vars = {
        "offset": jmpAddrVa,
    };
    var code = asm.textToHexRaw(patchAddr, cmd + " offset", vars);
    if (code.hexlength() !== 2)
        fatalError(cmd + " is not short");

    pe.replaceHex(patchAddr, code);
}

function exe_setShortJmpRaw(patchAddr, jmpAddrRaw, cmd)
{
    exe_setShortJmpVa(patchAddr, pe.rawToVa(jmpAddrRaw), cmd);
}

function exe_fetchRelativeValue(offset, offset2)
{
    reportLegacy("Please replace exe.fetchRelativeValue to pe.fetchRelativeValue");
}

function exe_fetchHexBytes(offset, offset2)
{
    reportLegacy("Please replace exe.fetchHexBytes to pe.fetchHexBytes");
}

function registerExe()
{
    exe.setJmpVa = exe_setJmpVa;
    exe.setJmpRaw = exe_setJmpRaw;
    exe.setNops = exe_setNops;
    exe.setNopsRange = exe_setNopsRange;
    exe.insertAsmText = exe_insertAsmText;
    exe.insertAsmTextObj = exe_insertAsmTextObj;
    exe.insertAsmFile = exe_insertAsmFile;
    exe.insertDWord = exe_insertDWord;
    exe.insertHex = exe_insertHex;
    exe.replaceAsmText = exe_replaceAsmText;
    exe.replaceAsmFile = exe_replaceAsmFile;
    exe.match = exe_match;
    exe.fetchValue = exe_fetchValue;
    exe.fetchValueSimple = exe_fetchValueSimple;
    exe.fetchHexBytes = exe_fetchHexBytes;
    exe.setValue = exe_setValue;
    exe.setValueSimple = exe_setValueSimple;
    exe.setShortJmpRaw = exe_setShortJmpRaw;
    exe.setShortJmpVa = exe_setShortJmpVa;
    exe.fetchRelativeValue = exe_fetchRelativeValue;
    registerExeLegacy();
}
