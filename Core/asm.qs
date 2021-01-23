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

function asm_textToObjVa(addrVa, commands, vars)
{
    var ret = asm.textToBytes(addrVa, commands, vars)
    if (ret === false)
        return false;
    var obj = new Object();
    obj.bytes = ret[0];
    obj.code = obj.bytes.toHex();
    obj.vars = ret[1];
    return obj;
}

function asm_textToObjRaw(addrRaw, commands, vars)
{
    return asm_textToObjVa(exe.Raw2Rva(addrRaw), commands, vars);
}

function asm_textToHexVa(addrVa, commands, vars)
{
    var ret = asm.textToBytes(addrVa, commands, vars)
    if (ret === false)
        return false;
    return ret[0].toHex();
}

function asm_textToHexRaw(addrRaw, commands, vars)
{
    return asm_textToHexVa(exe.Raw2Rva(addrRaw), commands, vars);
}

function asm_textToHexVaLength(addrVa, commands, vars)
{
    var ret = asm.textToBytes(addrVa, commands, vars)
    if (ret === false)
        return false;
    return ret[0].length;
}

function asm_textToHexRawLength(addrRaw, commands, vars)
{
    return asm_textToHexVaLength(exe.Raw2Rva(addrRaw), commands, vars);
}

function asm_cmdToObjVa(addrVa, command, vars)
{
    var ret = asm.cmdToBytes(addrVa, command, vars)
    if (ret === false)
        return false;
    var obj = new Object();
    obj.bestIndex = ret[0];
    obj.bytes = ret[1];
    obj.codes = [];
    for (var i = 0; i < obj.bytes.length; i ++)
    {
        obj.codes.push(obj.bytes[i].toHex());
    }
    obj.bestCode = obj.codes[obj.bestIndex];
    return obj;
}

function asm_cmdToObjRaw(addrRaw, command, vars)
{
    return asm_cmdToObjVa(exe.Raw2Rva(addrRaw), command, vars);
}

function asm_cmdToHexVa(addrVa, command, vars)
{
    var ret = asm.cmdToBytes(addrVa, command, vars)
    if (ret === false)
        return false;
    return ret[ret[0]].toHex();
}

function asm_cmdToHexRaw(addrRaw, command, vars)
{
    return asm_cmdToHexVa(exe.Raw2Rva(addrRaw), command, vars);
}

function asm_hexToAsm(code)
{
    code = code.trim();
    var parts = code.split(" ");
    var data = ""
    for (var i = 0; i < parts.length; i ++)
    {
        data = data + "db 0x" + parts[i] + "\n";
    }
    return data;
}

function asm_combine()
{
    var args = Array.prototype.slice.call(arguments);
    var code = ""
    for (var i = 0; i < args.length; i ++)
    {
        code = code + args[i] + "\n";
    }
    return code;
}

function registerAsm()
{
    asm.textToObjVa = asm_textToObjVa;
    asm.textToObjRaw = asm_textToObjRaw;
    asm.textToHexVa = asm_textToHexVa;
    asm.textToHexVaLength = asm_textToHexVaLength;
    asm.textToHexRaw = asm_textToHexRaw;
    asm.textToHexRawLength = asm_textToHexRawLength;
    asm.cmdToObjVa = asm_cmdToObjVa;
    asm.cmdToObjRaw = asm_cmdToObjRaw;
    asm.cmdToHexVa = asm_cmdToHexVa;
    asm.cmdToHexRaw = asm_cmdToHexRaw;
    asm.hexToAsm = asm_hexToAsm;
    asm.combine = asm_combine;
}
