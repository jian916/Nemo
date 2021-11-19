//###################################################################
//# Purpose: Change the JNE after Langtype comparison to JMP in the #
//#          'On Login' callback which skips loading HelpMsgStr.    #
//###################################################################

function DisableHelpMsg()
{
    consoleLog("Step 1 - Search the Unique PUSHes after the comparison");
    var code =
        "6A 0D " +  // 00 push 0Dh
        "6A 2A ";   // 02 push 2Ah

    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "6A 0E " +  // 00 push 0Eh
            "6A 2A ";   // 02 push 2Ah

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "6A 0E " +  // 00 push 0Eh
            "8B 01 " +  // 02 mov eax, [ecx]
            "6A 2A ";   // 04 push 2Ah

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "6A 0E " +  // 00 push 0Eh
            "8B 01 " +  // 02 mov eax, [ecx]
            "6A 2F ";   // 04 push 2Fh

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "6A 0E " +  // 00 push 0Eh
            "8B 11 " +  // 02 mov edx, [ecx]
            "6A 2F ";   // 04 push 2Fh

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    consoleLog("Step 2 - Search the address of 'LANGTYPE'");
    var LANGTYPE = GetLangType();

    if (LANGTYPE.length === 1)
        return "Failed in Step 2 - " + LANGTYPE[0];

    consoleLog("Step 3 - Find the comparison before patching");
    var code =
        LANGTYPE +  // 00 CMP DWORD PTR DS:[g_serviceType], reg32_A
        "75 ";      // 04 JNE addr

    var offset2 = pe.find(code, offset - 0x20, offset);

    if (offset2 === -1)
    {
        code =
            LANGTYPE + "00 " +  // 00 cmp dword ptr ds:[g_serviceType], 0
            "75 ";              // 05 jnz short addr

        offset2 = pe.find(code, offset - 0x20, offset);
    }

    if (offset2 === -1)
    {
        code =
            LANGTYPE +  // 00 mov eax, g_serviceType
            "?? ?? " +  // 04 cmp eax, edi
            "75 ";      // 06 jnz short addr

        offset2 = pe.find(code, offset - 0x20, offset);
    }

    if (offset2 === -1)
        return "Failed in Step 3 - Pattern not found";

    consoleLog("Step 4 - Replace JNE with JMP");
    exe.replace(offset2 + code.hexlength() - 1, "EB ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableHelpMsg_()
{
    return (pe.stringRaw("/tip") !== -1);
}
