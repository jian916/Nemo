//
// Copyright (C) 2018  Andrei Karas (4144)
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
//#############################################################
//# Purpose: Nemo self test                                   #
//#############################################################

function NemoSelfTest_sub(log)
{
    log.data(arguments.callee.name, "arguments.callee.name 2");
//    log.data(arguments.callee.caller, "arguments.callee.caller 2");
    log.data(arguments.callee.caller.name, "arguments.callee.caller.name 2");
}

function NemoSelfTest()
{
    // open log
    var log = new Logger();

    log.open("jstest");
    if (!log.file)
        return "Open log file failed";

    log.test("for");
    for (var i = 0; i < 100; i++)
    {
        var tmp  = i * 2;
        if (i === 50)
        {
            break;
        }
    }
    log.data(i, "i");

    for (var i = 0; i < 100; i++)
    {
        var tmp  = i * 2;
    }
    log.data(i, "i");

    var i = 0;
    while(i < 100)
    {
        i ++;
        if (i === 50)
            break;
    }
    log.data(i, "i");

    var i = 0;
    do
    {
        i ++;
        if (i === 50)
            break;
    }
    while(i < 100)
    log.data(i, "i");

    log.test("objects");
    log.data(Client, "Client");
    log.data(exe, "exe");
//    log.data(this, "this");
//    log.data(this.prototype, "this.prototype");
    log.data(Client.prototype, "Client.prototype");
    log.data(Client.prototype.constructor, "Client.prototype.constructor");
    log.data(exe.prototype, "exe.prototype");

    log.test("proxy functions");
    function testFunc1(val)
    {
        log.data(val, "testfunc1");
    }
    testFunc1(10);
    testFunc1_ori = testFunc1;
    testFunc1 = function(val)
    {
        log.data(val, "testproxy1");
        testFunc1_ori(val);
    };
    testFunc1(20);
    delete testFunc1_ori;

    log.test("try/catch");
    try
    {
        var a = b;
    }
    catch(err)
    {
        log.data("a try/catch");
    }

    eval("var testeval1 = 123;");
    log.data(testeval1, "testeval1");

    // TextFile tests
    log.reopen("textfile");

    // open test file for read
    log.test("read");
    var f = new TextFile();
    log.bool(f, "new TextFile");
    log.data(f.open(APP_PATH + "/Input/tests/testfile1.txt", "r"), "open testfile1.txt r");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");
    log.data(f.open(APP_PATH + "/Input/tests/testfile3.txt", "r"), "open testfile3.txt r");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");

    // open test file for write/read
    log.test("write/read");
    f = new TextFile();
    log.bool(f, "new TextFile");
    log.data(f.open(APP_PATH + "/Output/testfile2.txt", "w"), "open testfile2.txt w");
    log.data(f.eof(), "eof");
    log.data(f.writeline("test1"), "writeline");
    log.data(f.eof(), "eof");
    log.data(f.write("other str "), "write");
    log.data(f.eof(), "eof");
    log.data(f.writeline("test2"), "writeline");
    log.data(f.eof(), "eof");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");
    log.bool(f, "new TextFile");
    log.data(f.eof(), "eof");
    log.data(f.open(APP_PATH + "/Output/testfile2.txt", "r"), "open testfile2.txt r");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.readline(), "readline");
    log.data(f.eof(), "eof");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");

    log.test("append");
    f = new TextFile();
    log.bool(f, "new TextFile");
    log.data(f.open(APP_PATH + "/Output/testfile3.txt", "a"), "open testfile3.txt a");
    log.data(f.eof(), "eof");
    log.data(f.writeline("append"), "writeline");
    log.data(f.eof(), "eof");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");

    // BinFile tests
    log.reopen("binfile");

    // open binary file for read
    log.test("read");
    var f = new BinFile();
    log.bool(f, "new BinFile");
    log.data(f.open(APP_PATH + "/Input/NEMO.ico", "r"), "open NEMO.ico r");
    log.data(f.eof(), "eof");
    log.data(f.readHex(0, 0), "f.read(0, 0)");
    log.data(f.eof(), "eof");
    log.data(f.readHex(0, 7), "f.read(0, 4)");
    log.data(f.eof(), "eof");
    log.data(f.readHex(1, 4), "f.read(1, 4)");
    log.data(f.eof(), "eof");
    log.data(f.readHex(1000000, 2), "f.read(1000000, 2)");
    log.data(f.eof(), "eof");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");

    log.test("read/write");
    log.bool(f, "new BinFile");
    log.data(f.open(APP_PATH + "/Output/testfile3.txt", "w"), "open testfile3.txt w");
    log.data(f.eof(), "eof");
    log.data(f.writeHex(0, "24"), "f.writeHex(0, \"24\")");
    log.data(f.eof(), "eof");
    log.data(f.writeHex(8, "25 26 27 28"), "f.writeHex(8, \"25 26 27 28\")");
    log.data(f.eof(), "eof");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");
    log.data(f.open(APP_PATH + "/Output/testfile3.txt", "r"), "open testfile3.txt r");
    log.data(f.eof(), "eof");
    log.data(f.readHex(0, 0), "f.read(0, 0)");
    log.data(f.eof(), "eof");
    log.data(f.readHex(0, 1), "f.read(0, 1)");
    log.data(f.eof(), "eof");
    log.data(f.readHex(1, 5), "f.read(1, 5)");
    log.data(f.close(), "close");
    log.data(f.eof(), "eof");


    log.reopen("globals")
    log.data(getActivePatches(), "getActivePatches");
    log.data(globalVarTest, "globalVarTest");
    log.data(CLIENT_FILE, "CLIENT_FILE");

    // unicode strings
    log.reopen("unicode")
    log.data("\xff\xff\xff\x01\xc0\xff\xfe", "str1");

    // exe object tests
    log.reopen("exe")

    log.test("exe.isThemida");
    log.bool(exe.isThemida(), "exe.isThemida()");

    log.test("exe.getROffset / exe.getRSize");
    log.hex(exe.getROffset(CODE), "exe.getROffset(CODE)");
    log.hex(exe.getRSize(CODE), "exe.getRSize(CODE)");
    log.hex(exe.getROffset(CODE) + exe.getRSize(CODE), "exe.getROffset(CODE) + exe.getRSize(CODE)");
    log.hex(exe.getROffset(DATA), "exe.getROffset(DATA)");
    log.hex(exe.getRSize(DATA), "exe.getRSize(DATA)");
    log.hex(exe.getROffset(DATA) + exe.getRSize(DATA), "exe.getROffset(DATA) + exe.getRSize(DATA)");
    log.hex(exe.getROffset(IMPORT), "exe.getROffset(IMPORT)");
    log.hex(exe.getRSize(IMPORT), "exe.getRSize(IMPORT)");
    log.hex(exe.getROffset(IMPORT) + exe.getRSize(IMPORT), "exe.getROffset(IMPORT) + exe.getRSize(IMPORT)");
    log.hex(exe.getROffset(RSRC), "exe.getROffset(RSRC)");
    log.hex(exe.getRSize(RSRC), "exe.getRSize(RSRC)");
    log.hex(exe.getROffset(RSRC) + exe.getRSize(RSRC), "exe.getROffset(RSRC) + exe.getRSize(RSRC)");
    log.hex(exe.getROffset(DIFF), "exe.getROffset(DIFF)");
    log.hex(exe.getRSize(DIFF), "exe.getRSize(DIFF)");
    log.hex(exe.getROffset(DIFF) + exe.getRSize(DIFF), "exe.getROffset(DIFF) + exe.getRSize(DIFF)");

    log.test("exe.getVOffset / exe.getVSize");
    log.hex(exe.getVOffset(CODE), "exe.getVOffset(CODE)");
    log.hex(exe.getVSize(CODE), "exe.getVSize(CODE)");
    log.hex(exe.getVOffset(CODE) + exe.getVSize(CODE), "exe.getVOffset(CODE) + exe.getVSize(CODE)");
    log.hex(exe.getVOffset(DATA), "exe.getVOffset(DATA)");
    log.hex(exe.getVSize(DATA), "exe.getVSize(DATA)");
    log.hex(exe.getVOffset(DATA) + exe.getVSize(DATA), "exe.getVOffset(DATA) + exe.getVSize(DATA)");
    log.hex(exe.getVOffset(IMPORT), "exe.getVOffset(IMPORT)");
    log.hex(exe.getVSize(IMPORT), "exe.getVSize(IMPORT)");
    log.hex(exe.getVOffset(IMPORT) + exe.getVSize(IMPORT), "exe.getVOffset(IMPORT) + exe.getVSize(IMPORT)");
    log.hex(exe.getVOffset(RSRC), "exe.getVOffset(RSRC)");
    log.hex(exe.getVSize(RSRC), "exe.getVSize(RSRC)");
    log.hex(exe.getVOffset(RSRC) + exe.getVSize(RSRC), "exe.getVOffset(RSRC) + exe.getVSize(RSRC)");
    log.hex(exe.getVOffset(DIFF), "exe.getVOffset(DIFF)");
    log.hex(exe.getVSize(DIFF), "exe.getVSize(DIFF)");
    log.hex(exe.getVOffset(DIFF) + exe.getVSize(DIFF), "exe.getVOffset(DIFF) + exe.getVSize(DIFF)");

    log.test("exe.getPEOffset");
    log.hex(exe.getPEOffset(), "exe.getPEOffset()");

    log.test("exe.getImageBase");
    log.hex(exe.getImageBase(), "exe.getImageBase()");

    log.test("exe.Raw2Rva");
    log.hex(exe.Raw2Rva(exe.getROffset(CODE)), "exe.Raw2Rva(exe.getROffset(CODE))");
    log.hex(exe.Rva2Raw(exe.Raw2Rva(exe.getROffset(CODE))), "exe.Rva2Raw(exe.Raw2Rva(exe.getROffset(CODE)))");
    log.hex(exe.Raw2Rva(exe.getROffset(CODE) + exe.getRSize(CODE)), "exe.Raw2Rva(exe.getROffset(CODE) + exe.getRSize(CODE))");
    log.hex(exe.Raw2Rva(exe.getROffset(CODE) + exe.getVSize(CODE)), "exe.Raw2Rva(exe.getROffset(CODE) + exe.getVSize(CODE))");
    log.hex(exe.Raw2Rva(exe.getROffset(CODE) - 1), "exe.Raw2Rva(exe.getROffset(CODE) - 1)");
    log.hex(exe.Raw2Rva(exe.getROffset(CODE) + 1), "exe.Raw2Rva(exe.getROffset(CODE) + 1)");
    log.hex(exe.Raw2Rva(exe.getROffset(DATA)), "exe.Raw2Rva(exe.getROffset(DATA))");
    log.hex(exe.Rva2Raw(exe.Raw2Rva(exe.getROffset(DATA))), "exe.Rva2Raw(exe.Raw2Rva(exe.getROffset(DATA)))");
    log.hex(exe.Raw2Rva(exe.getROffset(DATA) + exe.getRSize(DATA)), "exe.Raw2Rva(exe.getROffset(DATA) + exe.getRSize(DATA))");
    log.hex(exe.Raw2Rva(exe.getROffset(DATA) + exe.getVSize(DATA)), "exe.Raw2Rva(exe.getROffset(DATA) + exe.getVSize(DATA))");
    log.hex(exe.Raw2Rva(exe.getROffset(DATA) - 1), "exe.Raw2Rva(exe.getROffset(DATA) - 1)");
    log.hex(exe.Raw2Rva(exe.getROffset(DATA) + 1), "exe.Raw2Rva(exe.getROffset(DATA) + 1)");

    log.test("exe.Rva2Raw");
    log.hex(exe.Rva2Raw(exe.getVOffset(CODE)), "exe.Rva2Raw(exe.getVOffset(CODE))");
    log.hex(exe.Rva2Raw(exe.getVOffset(DATA)), "exe.Rva2Raw(exe.getVOffset(DATA))");

    log.test("exe.findCode 1");
    var byte = exe.fetchUByte(exe.getROffset(CODE));
    log.hex(byte, "exe.fetchUByte(exe.getROffset(CODE))");
    log.hex(exe.findCode(byte.toString(16), PTYPE_HEX), "findCode 1");
    log.hex(exe.findCode(byte.toString(16), PTYPE_HEX, false, "\xAB"), "findCode 2");
    log.hex(exe.findCode(byte.toString(16), PTYPE_HEX, true, "\xAB"), "findCode 3");
    log.hex(exe.findCode(byte.toString(16) + "AB", PTYPE_HEX, true, "\xAB"), "findCode 4");
    log.hex(exe.findCode(byte.toString(16) + " AB", PTYPE_HEX, true, "\xAB"), "findCode 5");
    byte = String.fromCharCode(byte);
    log.hex(exe.findCode(byte, PTYPE_STRING), "findCode 6");
    log.hex(exe.findCode(byte, PTYPE_STRING, false, "\xAB"), "findCode 7");
    log.hex(exe.findCode(byte, PTYPE_STRING, true, "\xAB"), "findCode 8");
    log.hex(exe.findCode(byte + "\xAB", PTYPE_STRING, true, "\xAB"), "findCode 9");
//    byte = exe.fetchUByte(exe.getROffset(CODE));
// below broken function call
//    log.hex(exe.findCode(byte.toString(16), PTYPE_HEX, 0x10000, 0x10001), "findCode 10");

    log.test("exe.findCode 2");
    var byte = exe.fetchUByte(exe.getROffset(DATA));
    log.hex(byte, "exe.fetchUByte(exe.getROffset(DATA))");
    log.hex(exe.findCode(byte.toString(16), PTYPE_HEX), "findCode 1");
    log.hex(exe.findCode(byte.toString(16), PTYPE_HEX, false, "\xAB"), "findCode 2");
    log.hex(exe.findCode(byte.toString(16), PTYPE_HEX, true, "\xAB"), "findCode 3");
    log.hex(exe.findCode(byte.toString(16) + "AB", PTYPE_HEX, true, "\xAB"), "findCode 4");
    log.hex(exe.findCode(byte.toString(16) + " AB", PTYPE_HEX, true, "\xAB"), "findCode 5");
    byte = String.fromCharCode(byte);
    log.hex(exe.findCode(byte, PTYPE_STRING), "findCode 6");
    log.hex(exe.findCode(byte, PTYPE_STRING, false, "\xAB"), "findCode 7");
    log.hex(exe.findCode(byte, PTYPE_STRING, true, "\xAB"), "findCode 8");
    log.hex(exe.findCode(byte + "\xAB", PTYPE_STRING, true, "\xAB"), "findCode 9");

    log.test("exe.findCode 3");
    log.hex(exe.findCode("C7 85 F0 FC FF FF 00 00 00 00", PTYPE_HEX, false, "\xAB"), "findCode1");
    log.hex(exe.findCode(".?AUIDispatch@@", PTYPE_STRING, false, "\xAB"), "findCode2");
    log.hex(exe.findCode("%s\xA1\xBA%s\xA1\xBB", PTYPE_STRING), "find3");
    log.hex(exe.find("%s\xA1\xBA%s\xA1\xBB", PTYPE_STRING), "find1");

    log.test("exe.findString 1");
    log.hex(exe.findString(".?AUIDispatch@@"), "findString1");
    log.hex(exe.findString(".?AUIDispatch@@", RVA), "findString2");
    log.hex(exe.findString(".?AUIDispatch@@", RAW), "findString3");
    log.hex(exe.findString(".?AUIDispatch@@", RAW, true), "findString4");
    log.hex(exe.findString("?AUIDispatch@@", RAW, true), "findString5");
    log.hex(exe.findString("?AUIDispatch@@", RAW, false), "findString6");
    log.hex(exe.findString("?AUIDispatch@@", RVA, false), "findString6");
    log.hex(exe.findString("%s\xA1\xBA%s\xA1\xBB", RVA), "findString7");
    log.hex(exe.findString("%s\xA1\xBA%s\xA1\xBB", RVA, false), "findString8");
    log.hex(exe.findString("d>d", RAW, true), "findString d>d RAW");
    log.hex(exe.findString("d>d", RVA, true), "findString d>d RVA");

    log.test("exe.fetch");
    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchUByte(exe.getROffset(CODE) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchUByte from CODE");
    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchUByte(exe.getROffset(DATA) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchUByte from DATA");

    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchByte(exe.getROffset(CODE) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchByte from CODE");
    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchByte(exe.getROffset(DATA) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchByte from DATA");

    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchWord(exe.getROffset(CODE) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchWord from CODE");
    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchWord(exe.getROffset(DATA) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchWord from DATA");

    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchDWord(exe.getROffset(CODE) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchDWord from CODE");
    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchDWord(exe.getROffset(DATA) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchDWord from DATA");

    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchQWord(exe.getROffset(CODE) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchQWord from CODE");
    var str = "";
    for (var i = 0; i < 100; i++)
    {
        byte = exe.fetchQWord(exe.getROffset(DATA) + i);
        str = str + " " + byte.toString(16)
    }
    log.data(str, "exe.fetchQWord from DATA");

    log.test("exe.findCodes 1");
    log.hex(exe.findCodes("C7 85 F0 FC FF FF 00 00 00 00", PTYPE_HEX, false, "\xAB"), "findCodes1");
    log.hex(exe.findCodes(".?AUIDispatch@@", PTYPE_STRING, false, "\xAB"), "findCodes2");
    log.hex(exe.findCodes("C7 85 F0 AB AB FF 00 00 00 00", PTYPE_HEX, true, "\xAB"), "findCodes3");

    log.test("exe.find 1");
    var addr1 = exe.find("C7 85 F0 FC FF FF 00 00 00 00", PTYPE_HEX, false, "\xAB");
    log.hex(addr1, "find1");
    log.hex(exe.find("C7 85 F0 FC FF FF 00 00 00 00", PTYPE_HEX, false, "\xAB", addr1 + 1), "find2");
    log.hex(exe.find("C7 85 F0 AB AB FF 00 00 00 00", PTYPE_HEX, true, "\xAB"), "find3");
    log.hex(exe.find(".?AUIDispatch@@", PTYPE_STRING, false, "\xAB"), "find4");
//    log.hex(exe.find(".?AUIDispatch@@", PTYPE_STRING, false, ""), "find5");

    log.test("exe.findAll 1");
    log.hex(exe.findAll("C7 85 F0 FC FF FF 00 00 00 00", PTYPE_HEX, false, "\xAB"), "findAll1");
    log.hex(exe.findAll(".?AUIDispatch@@", PTYPE_STRING, false, "\xAB"), "findAll2");
    log.hex(exe.findAll("C7 85 F0 AB AB FF 00 00 00 00", PTYPE_HEX, true, "\xAB"), "findAll3");
    log.hex(exe.findAll("2E 74 78 74 00", PTYPE_HEX, false, "\xAB", exe.getROffset(DATA), exe.getROffset(DATA) + exe.getRSize(DATA)), "findAll4");

    log.test("exe.fetch 1");
    var addr = exe.getROffset(DATA) + 104;
    for (var i = 0; i < 10; i ++)
    {
        log.hex(exe.fetch(addr, i), "exe.fetch(0x" + addr.toString(16) + ", " + i + ")")
    }
    log.test("exe.fetch 2");
    for (var i = 0; i < 10; i ++)
    {
        log.hex(exe.fetch(addr + i, i * 2), "exe.fetch(0x" + (addr + i).toString(16) + ", " + (i * 2) + ")")
    }
    log.test("exe.fetch 3");
    var addr = exe.findString(".?AUIDispatch@@", RAW) - 3;
    if (addr !== -4)
    {
        for (var i = 0; i < 10; i ++)
        {
            log.hex(exe.fetch(addr + i, i * 2), "exe.fetch(0x" + (addr + i).toString(16) + ", " + (i * 2) + ")")
        }
    }

    log.test("exe.fetchHex 1");
    var addr = exe.getROffset(DATA) + 104;
    for (var i = 0; i < 10; i ++)
    {
        log.data(exe.fetchHex(addr, i), "exe.fetchHex(0x" + addr.toString(16) + ", " + i + ")")
    }
    log.test("exe.fetchHex 2");
    for (var i = 0; i < 10; i ++)
    {
        log.data(exe.fetchHex(addr + i, i * 2), "exe.fetchHex(0x" + (addr + i).toString(16) + ", " + (i * 2) + ")")
    }
    log.test("exe.fetchHex 3");
    var addr = exe.findString(".?AUIDispatch@@", RAW) - 3;
    if (addr !== -4)
    {
        for (var i = 0; i < 10; i ++)
        {
            log.data(exe.fetchHex(addr + i, i * 2), "exe.fetchHex(0x" + (addr + i).toString(16) + ", " + (i * 2) + ")")
        }
    }

    log.test("exe.findZero 1");
    log.hex(exe.findZeros(1), "exe.findZeros(1)");
    log.hex(exe.findZeros(0x10), "exe.findZeros(0x10)");
    log.hex(exe.findZeros(0x20), "exe.findZeros(0x20)");

    log.test("exe.findZero / exe.insert 1");
    log.bool(exe.insert(exe.findZeros(1), 2, "33", PTYPE_HEX), "exe.insert(exe.findZeros(1), 2, \"33\", PTYPE_HEX)");
    log.hex(exe.findZeros(1), "exe.findZeros(1)");
    log.bool(exe.insert(exe.findZeros(1), 1, "t", PTYPE_STRING), "exe.insert(exe.findZeros(1), 1, \"t\", PTYPE_STRING)");
    log.hex(exe.findZeros(1), "exe.findZeros(1)");
    log.bool(exe.insert(exe.findZeros(2), 4, "34 35", PTYPE_HEX), "exe.insert(exe.findZeros(2), 4, \"34 35\", PTYPE_HEX)");
    log.hex(exe.findZeros(1), "exe.findZeros(1)");
    log.bool(exe.insert(exe.findZeros(2), 2, "es", PTYPE_STRING), "exe.insert(exe.findZeros(2), 2, \"es\", PTYPE_STRING)");
    log.hex(exe.findZeros(1), "exe.findZeros(1)");
//    log.bool(exe.insert(exe.findZeros(2), 2, "36 37 38 39 40 41 42 43 44", PTYPE_HEX), "exe.insert(exe.findZeros(2), 2, \"36 37 38 39 40 41 42 43 44\", PTYPE_HEX)");
//    log.hex(exe.findZeros(1), "exe.findZeros(1)");
//    log.bool(exe.insert(exe.findZeros(2), 2, "this is test line", PTYPE_STRING), "exe.insert(exe.findZeros(2), 2, \"this is test line\", PTYPE_STRING)");
//    log.hex(exe.findZeros(1), "exe.findZeros(1)");

    log.test("exe.replace 1");
    addr = exe.find("%s\xA1\xBA%s\xA1\xBB", PTYPE_STRING);
    log.hex(exe.findString("%s\xA1\xBA%s\xA1\xBB", RAW), "find1");
    log.bool(exe.replace(addr, "33", PTYPE_HEX), "replace 1");
    log.hex(exe.findString("%s\xA1\xBA%s\xA1\xBB", RAW), "find2");
    log.bool(exe.replace(addr + 1, "test", PTYPE_STRING), "replace 2");
    log.hex(exe.findString("%s\xA1\xBA%s\xA1\xBB", RAW), "find3");

    log.test("exe.replace 2");
    addr = exe.find("%s\xA1\xBA%s\xA1\xBB", PTYPE_STRING);
    log.bool(exe.replaceByte(addr + 3, 0x10), "replace 1");
    log.bool(exe.replaceWord(addr + 4, 0x2030), "replace 2");
    log.bool(exe.replaceDWord(addr + 6, 0x40506070), "replace 3");

    log.reopen("other");
    var myfile = exe.getUserInput("$selfTestInfo", XTYPE_STRING, "String input - maximum 28 characters including folder name/", "Enter the new ItemInfo path (should be relative to RO folder)", "qqqqqq", 1, 5);
//    var myfile = exe.getUserInput("$newItemInfo", XTYPE_BYTE, "String input - maximum 28 characters including folder name/", "Enter the new ItemInfo path (should be relative to RO folder)", 30, -1000, 1000);

//    var color = exe.getUserInput("$guildChatColor", XTYPE_COLOR, "Color input", "Select the new Guild Chat Color", 0x00B4FFB4);
//    var color2 = exe.getUserInput("$guild2ChatColor", XTYPE_COLOR, "$guildChatColor", "$guildChatColor", "$guildChatColor");
//    log.data(exe.getUserInput("$achievement", XTYPE_BYTE, "Set Button", "Set Button Hide(0) or Show(1)", 0, 0, 1), "test input");
    log.data(myfile, "test1");
//    log.data("${guildChatColor}", "test1");
    exe.replace(0x400, "$selfTestInfo", PTYPE_STRING);

    log.reopen("ranges");
    var cnt = 0;
    var addr = exe.find("C7 85 F0 FC FF FF 00 00 00 00", PTYPE_HEX, false, "\xAB");
    log.test("exe.find 1");
    if (addr !== -1)
    {
        for (var i = -2; i < 15; i ++)
        {
            for (var j = i; j < 15; j ++)
            {
                log.hex(exe.find("C7 85 F0 FC FF FF 00 00 00 00",
                    PTYPE_HEX,
                    false,
                    "\xAB", addr + i, addr + j),
                    "find(" + i + ", " + j + ")");
                cnt = cnt + 1;
            }
        }
        log.hex(cnt, "cnt");
        log.test("exe.find 2");
        for (var i = -2; i < 15; i ++)
        {
            for (var j = i; j < 15; j ++)
            {
                log.hex(exe.find("C7 85 F0 FC FF FF 00 00 00 00",
                    PTYPE_HEX,
                    true,
                    "\xAB", addr + i, addr + j),
                    "find(" + i + ", " + j + ")");
                cnt = cnt + 1;
            }
        }

        log.test("exe.findAll 1");
        var arr = exe.findAll("C7 85 F0 FC FF FF 00 00 00 00", PTYPE_HEX, false, "\xAB");
        if (arr.length > 4)
            var addr2 = arr[3]
        else
            var addr2 = arr[arr.length - 1]
        for (var i = -2; i < 15; i ++)
        {
            for (var j = -2; j < 15; j ++)
            {
                log.hex(exe.findAll("C7 85 F0 FC FF FF 00 00 00 00",
                    PTYPE_HEX,
                    false,
                    "\xAB", addr + i, addr2 + j),
                    "find(" + i + ", " + j + ")");
                cnt = cnt + 1;
            }
        }
    }

    // close log
    log.close();
    return true;
}
