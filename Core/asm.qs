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
    checkArgs("asm.textToObjVa", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    var ret = asm_textToBytes(addrVa, commands, vars)
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
    checkArgs("asm.textToObjRaw", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    return asm_textToObjVa(exe.Raw2Rva(addrRaw), commands, vars);
}

function asm_textToHexVa(addrVa, commands, vars)
{
    checkArgs("asm.textToHexVa", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    var ret = asm_textToBytes(addrVa, commands, vars)
    if (ret === false)
        return false;
    return ret[0].toHex();
}

function asm_textToHexRaw(addrRaw, commands, vars)
{
    checkArgs("asm.textToHexRaw", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    return asm_textToHexVa(exe.Raw2Rva(addrRaw), commands, vars);
}

function asm_textToHexVaLength(addrVa, commands, vars)
{
    checkArgs("asm.textToHexVaLength", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    var ret = asm_textToBytes(addrVa, commands, vars)
    if (ret === false)
        return false;
    return ret[0].length;
}

function asm_textToHexRawLength(addrRaw, commands, vars)
{
    checkArgs("asm.textToHexRawLength", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    return asm_textToHexVaLength(exe.Raw2Rva(addrRaw), commands, vars);
}

function asm_textToHexLength(commands, vars)
{
    checkArgs("asm.textToHexLength", arguments, [["Object", "Object"], ["String", "Object"]]);

    var size = asm.textToHexVaLength(0, commands, vars);
    if (size === false)
        throw "Asm code error1";

    var size2 = asm.textToHexVaLength(0x5000000, commands, vars);
    if (size2 === false)
        throw "Asm code error2";
    if (size2 > size)
        size = size2;

    size2 = asm.textToHexVaLength(0xf000000, commands, vars);
    if (size2 === false)
        throw "Asm code error3";
    if (size2 > size)
        size = size2;

    return size;
}

function asm_cmdToObjVa(addrVa, command, vars)
{
    checkArgs("asm.cmdToObjVa", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
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
    checkArgs("asm.cmdToObjRaw", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    return asm_cmdToObjVa(exe.Raw2Rva(addrRaw), command, vars);
}

function asm_cmdToHexVa(addrVa, command, vars)
{
    checkArgs("asm.cmdToHecVa", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    var ret = asm.cmdToBytes(addrVa, command, vars)
    if (ret === false)
        return false;
    return ret[ret[0]].toHex();
}

function asm_cmdToHexRaw(addrRaw, command, vars)
{
    checkArgs("asm.cmdToHecRaw", arguments, [["Number", "Object", "Object"], ["Number", "String", "Object"]]);
    return asm_cmdToHexVa(exe.Raw2Rva(addrRaw), command, vars);
}

function asm_hexToAsm(code)
{
    checkArgs("asm.hexToAsm", arguments, [["String"]]);

    if (code.length === 0)
        return "";
    code = code.trim();
    var parts = code.split(" ");
    var data = ""
    for (var i = 0; i < parts.length; i ++)
    {
        data += "db 0x" + parts[i] + "\n";
    }
    return data;
}

function asm_stringToAsm(string)
{
    checkArgs("asm.stringToAsm", arguments, [["String"]]);

    var data = ""
    for (var i = 0; i < string.length; i++)
    {
        data += 'db 0x' + string.charCodeAt(i).toString(16) + "\n";
    }
    return data;
}

function asm_combine()
{
    var args = Array.prototype.slice.call(arguments);
    var code = ""
    for (var i = 0; i < args.length; i ++)
    {
        code = code + args[i];
        if (code[code.length - 1] != "\n")
            code = code + "\n";
    }
    return code;
}

function asm_loadHex(fileName)
{
    if (typeof(fileName) === "undefined" || fileName === "")
        fileName = patch.getName();
    var file = new BinFile();
    if (!file.open(APP_PATH + "/Patches/asm/" + fileName + ".asm"))
        throw "Cant load asm file: " + fileName;
    var text = file.readHex(0, 0);
    file.close();
    return text;
}

function asm_load(fileName)
{
    var text = asm_loadHex(fileName).toAscii();
    return text;
}

function asm_textToBytes(addrVa, commands, vars)
{
    commands = asm_replaceVars(commands, vars);
    return asm.textToBytesInternal(addrVa, commands, vars)
}

function asm_replaceVars(commands, vars)
{
    commands = commands.replaceAll(/[ ][ ][//][//][ ].+\n/g, "\n")
    for (var name in vars)
    {
        var value = vars[name];
        if (typeof(value) !== "string")
            continue;
        commands = commands.replaceAll("{" + name + "}", value);
        commands = commands.replaceAll("%" + name + "\n", value);
    }
    commands = commands.replaceAll(/[ ][ ][//][//][ ].+\n/g, "\n")
    return commands;
}

function registerAsm()
{
    asm.textToBytes = asm_textToBytes;
    asm.textToObjVa = asm_textToObjVa;
    asm.textToObjRaw = asm_textToObjRaw;
    asm.textToHexVa = asm_textToHexVa;
    asm.textToHexVaLength = asm_textToHexVaLength;
    asm.textToHexRaw = asm_textToHexRaw;
    asm.textToHexRawLength = asm_textToHexRawLength;
    asm.textToHexLength = asm_textToHexLength;
    asm.cmdToObjVa = asm_cmdToObjVa;
    asm.cmdToObjRaw = asm_cmdToObjRaw;
    asm.cmdToHexVa = asm_cmdToHexVa;
    asm.cmdToHexRaw = asm_cmdToHexRaw;
    asm.hexToAsm = asm_hexToAsm;
    asm.stringToAsm = asm_stringToAsm;
    asm.combine = asm_combine;
    asm.load = asm_load;
    asm.loadHex = asm_loadHex;
    asm.replaceVars = asm_replaceVars;
}
