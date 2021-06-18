//###########################################################################
//# Purpose: Translate Korean strings to user specified strings both loaded #
//#          from TranslateClient.txt . Also fixes Taekwon branch Job names #
//###########################################################################

function TranslateClient()
{
    // Step 1 - Open the text file for reading
    var f = new TextFile();
    if (!f.open(APP_PATH + "/Patches/TranslateClient.txt") )
        return "Failed in Step 1 - Unable to open file";

    var offset = -1;
    var msg = "";
    var failmsgs = [];  // Array to store all Failure messages
    var fStr = "";
    var fStr0 = "";
    var rStr = "";

    // Step 2 - Loop through the text file, get the respective strings & do findString + replace
    var found = false;
    while (!f.eof())
    {
        var str = f.readline().trim();

        if (str.charAt(0) === "M")
        {   // M: = Failure message string
            msg = str.substring(2).trim();
        }
        else if (str.charAt(0) === "F")
        {   // F: = Find string
            fStr0 = str;
            str = str.substring(2).trim();

            if (str.charAt(0) === "'")  // ASCII
                str = str.substring(1, str.length - 1);
            else  // HEX
                str = str.toAscii();
            fStr = str;
        }
        else if (str.charAt(0) === "R")
        {   // R: = Replace string. At this point we have both location and string to replace with
            offset = exe.findString(fStr, RAW);
            if (offset === -1)
            {
                failmsgs.push(msg);  // No Match = Collect Failure message
                continue;
            }

            str = str.substring(2).trim();

            if (str.charAt(0) === "'")
            { // ASCII
                str = str.substring(1, str.length - 1);
                rStr = str
                exe.replace(offset, str + "\x00", PTYPE_STRING);
            }
            else
            { // HEX
                rStr = str.toAscii();
                exe.replace(offset, str + " 00", PTYPE_HEX);
            }

            if (rStr.length > fStr.length)
            {
                return "Error: translation for '" + fStr0 + "' too long. Lengths: " + rStr.length + " vs " + fStr.length;
            }

            found = true;
            offset = -1;
        }
    }
    f.close();
    // Step 3 - Dump all the Failure messages collected to FailedTranslations.txt
    if (failmsgs.length != 0)
    {
        var outfile = new TextFile();

        if (outfile.open(APP_PATH + "/FailedTranslations.txt", "w"))
        {
            for (var i=0; i< failmsgs.length; i++)
            {
                outfile.writeline(failmsgs[i]);
            }
        }

        outfile.close();
    }
    if (found === false)
    {
        return "Found nothing to translate";
    }
    return true;
}
