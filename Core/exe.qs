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
        exe.replace(patchAddr, code, PTYPE_HEX);
    else
        pe.directReplace(patchAddr, code);
}

function exe_setJmpRaw(patchAddr, jmpAddrRaw, cmd, codeLen)
{
    exe_setJmpVa(patchAddr, exe.Raw2Rva(jmpAddrRaw), cmd, codeLen);
}

function exe_setNops(patchAddr, nopsCount)
{
    var code = "";
    for (var i = 0; i < nopsCount; i ++)
    {
        code = code + "90 ";
    }
    exe.replace(patchAddr, code, PTYPE_HEX);
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
            storage.zero = storage.zero + size + 4;
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

function exe_replaceAsmText(patchAddr, commands, vars)
{
    var obj = asm.textToHexRaw(patchAddr, commands, vars);
    exe.replace(patchAddr, obj, PTYPE_HEX);
    return obj;
}

function exe_replaceAsmFile(fileName, vars)
{
    var commands = asm.load(fileName);
    return exe_replaceAsmText(commands, vars);
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
    var size = offset2[1];
    var addr = offset + offset2[0];
    if (size == 1)
    {
        return exe.fetchByte(addr);
    }
    else if (size == 2)
    {
        return exe.fetchWord(addr);
    }
    else if (size == 4)
    {
        return exe.fetchDWord(addr);
    }
    else if (size == 8)
    {
        return exe.fetchQWord(addr);
    }
    else
    {
        fatalError("Unknown size in exe.fetchValue: " + size);
    }
}

function exe_fetchValueSimple(offset)
{
    return exe_fetchValue(0, offset);
}

function exe_setValue(offset, offset2, value)
{
    var size = offset2[1];
    var addr = offset + offset2[0];
    exe.replace(addr, value.packToHex(size), PTYPE_HEX);
}

function exe_setValueSimple(offset, value)
{
    exe_setValue(0, offset, value);
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

    exe.replace(patchAddr, code, PTYPE_HEX);
}

function exe_setShortJmpRaw(patchAddr, jmpAddrRaw, cmd)
{
    exe_setShortJmpVa(patchAddr, exe.Raw2Rva(jmpAddrRaw), cmd);
}

function exe_fetchRelativeValue(offset, offset2)
{
    var value = exe_fetchValue(offset, offset2);
    var addr = exe.Raw2Rva(offset + offset2[0]) + offset2[1] + value;
    return addr;
}

function exe_fetchHexBytes(offset, offset2)
{
    var size = offset2[1];
    var addr = offset + offset2[0];
    return exe.fetchHex(addr, size);
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
