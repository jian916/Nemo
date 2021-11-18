//######################################################################
//# Purpose: Extract the Hardcoded msgStringTable in the loaded Client #
//#          to translated using the reference tables.                 #
//######################################################################

function ExtractMsgTableTranslate()
{
    consoleLog("Step 1a - Search string 'msgStringTable.txt'");

    var offset = table.getRaw(table.msgStringTable) - 4;

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

    var fp = new BinFile();
    fp.open(APP_PATH + "/Input/msgStringEng.txt", "r");
    var data = fp.readHex(0, 0).toAscii();
    fp.close();

    data = data.replace(/\r/g, "").replaceAll("\n", "");

    var parts = data.split('#');
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

    consoleLog("Step 3 - Loop through the table inside the client (Each Entry)");
    var done = false;
    var id = 0;

    fp.open(APP_PATH + "/Output/msgstringtable_" + exe.getClientDate() + ".txt", "w");

    while (!done)
    {
        if (pe.fetchDWord(offset) === id)
        {
            consoleLog("Step 3a - Get the string for id: " + id);
            var start_offset = pe.vaToRaw(pe.fetchDWord(offset + 4));
            if (start_offset === -1)
            {
                msgStr = "empty";
            }
            else
            {
                var end_offset = pe.find("00 ", start_offset);
                msgStr = exe.fetch(start_offset, end_offset - start_offset);
            }

            consoleLog("Step 3b - Map the Korean string to English");
            if (engMap[msgStr])
            {
                fp.appendLine(engMap[msgStr] + '#');
            }
            else
            {
                msgStr = msgStr.replace(/\r/g, "\\r");
                msgStr = msgStr.replace(/\n/g, "\\n");
                msgStr = msgStr.replace("#", "_");
                fp.appendLine(msgStr + "#");
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
