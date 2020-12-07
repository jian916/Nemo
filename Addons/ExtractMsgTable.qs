//######################################################################
//# Purpose: Extract the Hardcoded msgStringTable in the loaded Client #
//#          to translated using the reference tables.                 #
//######################################################################

function ExtractMsgTable()
{
    consoleLog("Step 1a - Search string 'msgStringTable.txt'");
    var offset = exe.findString("msgStringTable.txt", RVA);

    if (offset === -1)
        throw "Failed in Step 1a - String not found";

    consoleLog("Step 1b - Search its reference");
    var offset = exe.findCode("68 " + offset.packToHex(4) + "68 ", PTYPE_HEX, false);

    if (offset === -1)
        throw "Failed in Step 1b - Pattern not found";

    consoleLog("Step 1c - Search the msgString PUSH after it");
    var code =
        "73 05 " +                // 00 jnb short addr1
        "8B 04 B0 " +             // 02 mov reg32_A, dword ptr ds:[reg32_B*4 + reg32_C]
        "EB 1B " +                // 05 jmp short addr2
        "8B 14 F5 AB AB AB 00 ";  // 07 mov reg32_D, dword ptr ds:[reg32_B*8 + tblAddr]

    var offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset + 10, offset + 80);

    if (offset2 === -1)
    {
        code =
            "73 05 " +                // 00 jnb short addr1
            "8B 0C B1 " +             // 02 mov reg32_A, dword ptr ds:[reg32_B*4 + reg32_C]
            "EB 1A " +                // 05 jmp short addr2
            "FF 34 F5 AB AB AB 00 ";  // 07 push reg32_D, dword ptr ds:[reg32_B*8 + tblAddr]

        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset + 10, offset + 80);
    }

    if (offset2 === -1)
    {
        code =
            "56 " +                // 00 push esi
            "33 F6 " +             // 01 xor esi, esi
            "33 D2 " +             // 03 xor edx, edx
            "8B FF " +             // 05 mov edi, edi
            "8B 8A AB AB AB 00 ";  // 07 mov ecx, off_DB76DC[edx] ; Ascii "동의 하십니까?"

        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 40, offset + 10);
    }

    if (offset2 === -1)
    {
        code =
            "56 " +                // 00 push esi
            "33 F6 " +             // 01 xor esi, esi
            "33 D2 " +             // 03 xor edx, edx
            "66 90 " +             // 05 xchg ax, ax
            "A1 AB AB AB 00 " +    // 07 mov eax, ds:0EB2680h
            "8D 76 04 " +          // 12 lea esi, [esi+4]
            "8B 8A AB AB AB 00 ";  // 15 mov ecx, [edx+0E6D02Ch] ; Ascii "동의 하십니까?"

        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 40, offset + 10);
    }

    if (offset2 === -1)
    {
        code =
            "33 F6 " +          // 00 xor esi, esi
            "BF AB AB AB 00 ";  // 02 mov reg32_A, tblAddr ; Ascii "동의 하십니까?"

        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset + 10, offset + 30);

        if (offset2 != -1 && (exe.fetchByte(offset2 + 2) & 0xB8) != 0xB8) // Checking the opcode is within 0xB8 to 0xBF
            offset2 = -1;
    }

    if (offset2 === -1)
        throw "Failed in Step 1c - Pattern not found";

    consoleLog("Step 1d - Extract the tblAddr");
    offset = exe.Rva2Raw(exe.fetchDWord(offset2 + code.hexlength() - 4)) - 4;

    consoleLog("Step 2a - Read the reference strings from file (Korean original in hex format)");
    var fp = new TextFile();
    var refList = [];
    var msgStr = "";

    fp.open(APP_PATH + "/Input/msgStringRef.txt", "r");

    while (!fp.eof())
    {
        var parts = fp.readline().split('#');

        for (var i = 1; i <= parts.length; i++)
        {
            msgStr += parts[i - 1].replace(/\\r/g, "0D ").replace(/\\n/g, "0A ");

            if (i < parts.length)
            {
                refList.push(msgStr.toAscii());
                msgStr = "";
            }
        }
    }

    fp.close();

    consoleLog("Step 2b - Read the translated strings from file (English regular text)");
    msgStr = "";
    var index = 0;
    var engMap = {};

    fp.open(APP_PATH + "/Input/msgStringEng.txt", "r");

    while (!fp.eof())
    {
        var parts = fp.readline().split('#');

        for (var i = 1; i <= parts.length; i++)
        {
            msgStr += parts[i - 1];
            msgStr = msgStr.replace("#", "_");

            if (i < parts.length)
            {
                engMap[refList[index]] = msgStr;
                msgStr = "";
                index++;
            }
        }
    }

    fp.close();

    consoleLog("Step 3 - Loop through the table inside the client (Each Entry)");
    var done = false;
    var id = 0;

    fp.open(APP_PATH + "/Output/msgstringtable_" + exe.getClientDate() + ".txt", "w");

    while (!done)
    {
        if (exe.fetchDWord(offset) === id)
        {
            consoleLog("Step 3a - Get the string for id: " + id);
            var start_offset = exe.Rva2Raw(exe.fetchDWord(offset + 4));
            if (start_offset === -1)
            {
                msgStr = "empty";
            }
            else
            {
                var end_offset = exe.find("00 ", PTYPE_HEX, false, "\xAB", start_offset);

                msgStr = exe.fetch(start_offset, end_offset - start_offset);
            }

            consoleLog("Step 3b - Map the Korean string to English");
            if (engMap[msgStr])
            {
                fp.writeline(engMap[msgStr] + '#');
            }
            else
            {
                msgStr = msgStr.replace(/\r/g, "\\r");
                msgStr = msgStr.replace(/\n/g, "\\n");
                msgStr = msgStr.replace("#", "_");
                fp.writeline(msgStr + "#");
            }

            offset += 8;
            id++;
        }
        else
        {
            done = true;
        }
    }

    fp.close();

    return "Success - msgStringTable.txt has been Extracted to Output folder";
}
