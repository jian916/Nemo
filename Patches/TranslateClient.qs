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

    //==================================//
    // Now for the TaeKwon Job name fix //
    //==================================//

    // Step 4a - Find the Langtype Check
    var LANGTYPE = GetLangType();  // Langtype value overrides Service settings hence they use the same variable - g_serviceType
    if (LANGTYPE.length === 1)
        return "Failed in Step 4 - " + LANGTYPE[0];

    var code =
        " 83 3D" + LANGTYPE + " 00"   // CMP DWORD PTR DS:[g_serviceType], 0
      + " B9 ?? ?? ?? 00"             // MOV ECX, addr1
      + " 75"                         // JNZ SHORT addr2
    ;
    offset = pe.findCode(code);  //VC9+ Clients

    if (offset === -1)
    {
        code =
            LANGTYPE            // MOV reg32_A, DWORD PTR DS:[g_serviceType] ; Usually reg32_A is EAX
          + " B9 ?? ?? ?? 00"   // MOV ECX, addr1
          + " 85 ??"            // TEST reg32_A, reg32_A
          + " 75"               // JNZ SHORT addr2
        ;
        offset = pe.findCode(code);  // Older Clients
    }

    if (offset === -1) // This change isn't necessary. [Secret]
    {
        if (found === false)
        {
            return "Found nothing to translate";
        }
        //return "Failed in Step 4 - Translate Taekwon Job";
        return true;
    }

    // Step 4b - Change the JNZ to JMP so that Korean names never get assigned.
    exe.replace(offset + code.hexlength() - 1, "EB", PTYPE_HEX);

    return true;
}
