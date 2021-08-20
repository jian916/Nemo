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

function pe_find(code, startRaw, endRaw)
{
    checkArgs("pe.find", arguments, [["String"], ["String", "Number"], ["String", "Number", "Number"]]);

    if (typeof(startRaw) === "undefined")
    {
        startRaw = 0;
        endRaw = 0x7fffffff;
    }
    else if (typeof(endRaw) === "undefined")
    {
        endRaw = 0x7fffffff;
    }
    return pe.findMaskInternal(code, startRaw, endRaw);
}

function pe_findAll(code, startRaw, endRaw)
{
    checkArgs("pe.findAll", arguments, [["String"], ["String", "Number"], ["String", "Number", "Number"]]);

    if (typeof(startRaw) === "undefined")
    {
        startRaw = 0;
        endRaw = 0x7fffffff;
    }
    else if (typeof(endRaw) === "undefined")
    {
        endRaw = 0x7fffffff;
    }
    var offsets = []
    var offset = pe.findMaskInternal(code, startRaw, endRaw);
    var sz = code.hexlength();
    while (offset !== -1)
    {
        offsets.push(offset);
        startRaw = offset + sz;
        offset = pe.findMaskInternal(code, startRaw, endRaw);
    }
    return offsets;
}

function pe_findCode(code)
{
    checkArgs("pe.findCode", arguments, [["String"]]);

    var sect = pe.sectionRaw(CODE);
    var startRaw = sect[0];
//    var endRaw = sect[1];
// emulating Nemo limit from exe.findCode
    var endRaw = pe.dataBaseRaw();
    return pe.findMaskInternal(code, startRaw, endRaw);
}

function pe_findCodes(code)
{
    checkArgs("pe.findCodes", arguments, [["String"]]);

    var sect = pe.sectionRaw(CODE);
    var startRaw = sect[0];
//    var endRaw = sect[1];
// emulating Nemo limit from exe.findCode
    var endRaw = pe.dataBaseRaw();
    var offsets = []
    var offset = pe.findMaskInternal(code, startRaw, endRaw);
    var sz = code.hexlength();
    while (offset !== -1)
    {
        offsets.push(offset);
        startRaw = offset + sz;
        offset = pe.findMaskInternal(code, startRaw, endRaw);
    }
    return offsets;
}

function pe_match(code, addrRaw)
{
    checkArgs("pe.match", arguments, [["String", "Number"]]);

    var offset = pe.findMaskInternal(code, addrRaw, addrRaw + 1);
    if (offset !== addrRaw)
        return false;
    return true;
}

function pe_stringRaw(str)
{
    checkArgs("pe.stringRaw", arguments, [["String"]]);

    var code = ("\x00" + str + "\x00").toHex();
    var startRaw = pe.dataBaseRaw();
    var endRaw = 0x7fffffff;
    var res = pe.findMaskInternal(code, startRaw, endRaw);
    if (res === -1)
    {
        return -1;
    }
    return res + 1;
}

function pe_stringVa(str)
{
    checkArgs("pe.stringVa", arguments, [["String"]]);

    var res = pe_stringRaw(str);
    if (res === -1)
    {
        return -1;
    }
    return pe.rawToVa(res);
}

function pe_stringHex4(str)
{
    checkArgs("pe.stringHex4", arguments, [["String"]]);

    var addr = pe_stringVa(str);
    if (addr === -1)
        throw "String " + str + " not found";
    return addr.packToHex(4);
}

function pe_directReplace(addrRaw, code)
{
    return pe.directReplaceBytes(addrRaw, code.toAscii());
}

function pe_fetchUQWord(addrRaw)
{
    var value = pe.fetchQWord(addrRaw);
    if (value === false)
        return false;
    return value >>> 0;
}

function pe_fetchUDWord(addrRaw)
{
    var value = pe.fetchDWord(addrRaw);
    if (value === false)
        return false;
    return value >>> 0;
}

function pe_fetchUWord(addrRaw)
{
    var value = pe.fetchWord(addrRaw);
    if (value === false)
        return false;
    return value & 0xffff;
}

function pe_fetchUByte(addrRaw)
{
    var value = pe.fetchByte(addrRaw);
    if (value === false)
        return false;
    return value & 0xff;
}

function pe_getImportTable()
{
    var data = pe.getSubSection(1);
    if (data === false)
        throw "Cant get import table address";
    return data;
}

function pe_getSubSection(index)
{
    var opt = pe.getOptHeader();
    if (opt.size <= 92)
        throw "Pe opt header too small for sub sections";

    var count = pe.fetchUDWord(opt.offset + 92);
    if (count <= index)
        return false;

    var offset = opt.offset + 96 + 8 * index;
    return {
        "offset" : pe.rvaToRaw(pe.fetchUDWord(offset)),
        "size" : pe.fetchUDWord(offset + 4)
    };
}

function pe_getImageBase()
{
    var opt = pe.getOptHeader();
    if (opt.size <= 28)
        throw "Pe opt header too small for image base";
    return pe.fetchUDWord(opt.offset + 28);
}

function pe_getPeHeader()
{
    var offset = pe.fetchUDWord(0x3c);
    if (pe.fetchUDWord(offset) !== 0x4550)
        throw "Wrong PE header found";
    return offset;
}

function pe_getOptHeader()
{
    var offset = pe.getPeHeader() + 4 + 0x14;
    var size = pe.fetchUWord(offset - 4);
    return {
        "offset" : offset,
        "size" : size
    };
}

function pe_rvaToVa(offsetRva)
{
    return offsetRva + pe.getImageBase();
}

function pe_rvaToRaw(offsetRva)
{
    return pe.vaToRaw(offsetRva + pe.getImageBase());
}

function registerPe()
{
    pe.find = pe_find;
    pe.findAll = pe_findAll;
    pe.findCode = pe_findCode;
    pe.findCodes = pe_findCodes;
    pe.match = pe_match;
    pe.stringVa = pe_stringVa;
    pe.stringRaw = pe_stringRaw;
    pe.stringHex4 = pe_stringHex4;
    pe.directReplace = pe_directReplace;
    pe.fetchUQWord = pe_fetchUQWord;
    pe.fetchUDWord = pe_fetchUDWord;
    pe.fetchUWord = pe_fetchUWord;
    pe.fetchUByte = pe_fetchUByte;
    pe.getPeHeader = pe_getPeHeader;
    pe.getOptHeader = pe_getOptHeader;
    pe.getSubSection = pe_getSubSection;
    pe.getImageBase = pe_getImageBase;
    pe.getImportTable = pe_getImportTable;
    pe.rvaToVa = pe_rvaToVa;
    pe.rvaToRaw = pe_rvaToRaw;
}
