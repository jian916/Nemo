//==================================================//
// Patch Functions wrapping over ChatLimit function //
//==================================================//

// Changes the JL/JLE to JMP
function RemoveChatLimit()
{
    return ChatLimit(0);
}

// Changes the compared value from 2 to user specified value - 1
function AllowChatFlood()
{
    return ChatLimit(1);
}

//###################################################################
//# Purpose: Change the comparison in the ::IsSameSentence function #
//#          or Fix up the Conditional Jump to JMP after it.        #
//###################################################################

function ChatLimit(option)
{
    // Step 1a - Get the comparison pattern (changes for different client dates because of ebp/esp shift)
    var LANGTYPE = GetLangType(); // Langtype value overrides Service settings hence they use the same variable - g_serviceType

    if (LANGTYPE.length === 1)
        return "Failed in Step 1a - " + LANGTYPE[0];

    // Step 1b - Now Search for the pattern chosen.
    var code =
        "83 3D " + LANGTYPE + "0A " +  // CMP DWORD PTR DS:[g_serviceType], 0A
        "74 AB ";                      // JE SHORT addr

    if (HasFramePointer())
        code += "83 7D 08 02 "; // CMP DWORD PTR SS:[EBP-8], 02
    else
        code += "83 7C 24 04 02 "; // CMP DWORD PTR SS:[ESP+4], 02

    code += "7C "; // JL SHORT addr
    var isLong = false;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code = code.replace("0A 74 AB 83 7C 24 04 02 7C ", "0A 74 AB 83 7D 08 02 7C "); // Replace ESP+4 with EBP-8
        isLong = false;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code = code.replace("0A 74 AB 83 ", "0A 0F 84 AB 00 00 00 83 "); // Relative offset of the JE is > 7F but < FF. Hence changing to long
        code = code.replaceAt(-3, "0F 8C "); // same reason as above for JL
        isLong = true;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1b - Pattern not found";

    offset += code.hexlength() - 2; // Position of 02

    if (isLong)
        offset--; // JL is two byte hence 02 is at one more byte before

    if (option === 1)
    {
        // Step 2a1 - Get new value from user
        var flood = exe.getUserInput("$allowChatFlood", XTYPE_BYTE, _("Number Input"), _("Enter new chat limit (0-127, default is 2):"), 2, 0, 127);

        if (flood === 2)
            return "Patch Cancelled - New value is same as old value";

        // Step 2b1 - Replace 02 with new value
        exe.replace(offset, "$allowChatFlood", PTYPE_STRING);
    }
    else
    {
        // Step 2a2 - Replace JL with JMP
        if (isLong)
            exe.replace(offset + 1, "90 E9 ", PTYPE_HEX);
        else
            exe.replace(offset + 1, "EB ", PTYPE_HEX);
    }

    return true;
}
