//######################################################################
//# Purpose: Extract the Hardcoded msgStringTable in the loaded Client #
//######################################################################

function ExtractMsgTable()
{
    consoleLog("Step 1a - Search string 'msgStringTable.txt'");

    var offset = table.getRaw(table.msgStringTable) - 4;

    consoleLog("Step 3 - Loop through the table inside the client (Each Entry)");
    var done = false;
    var id = 0;
    var msgStr = "";

    var fp = new BinFile();
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

            msgStr = msgStr.replace(/\r/g, "\\r");
            msgStr = msgStr.replace(/\n/g, "\\n");
            msgStr = msgStr.replace("#", "_");
            fp.appendLine(msgStr + "#");

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
