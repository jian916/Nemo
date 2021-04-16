//#########################################################################
//# Purpose: Find the 1rag1 comparison and change the JNZ after it to JMP #
//#########################################################################

function Disable1rag1Params()
{
    consoleLog("Step 1 - Search string '1rag1'");
    var offset = exe.findString("1rag1", RVA);

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    var strHex = offset.packToHex(4);

    consoleLog("Step 2 - Search pattern for its reference");
    var code =
        "68 " + strHex +  // 00 push offset a1rag1
        "?? " +           // 05 push edi
        "FF ?? " +        // 06 call ebx
        "83 C4 08 " +     // 08 add esp, 8
        "85 ?? " +        // 11 test eax, eax
        "75 ";            // 13 jnz short loc_B13280
    var jmpOffset = 13;
    var strstrOffset = 0;

    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "68 " + strHex +     // 00 push offset a1rag1
            "?? " +              // 05 push edi
            "E8 ?? ?? ?? ?? " +  // 06 call strstr
            "83 C4 08 " +        // 11 add esp, 8
            "85 ?? " +           // 14 test eax, eax
            "75 ";               // 16 jnz short loc_8660B2
        jmpOffset = 16;
        strstrOffset = 7;

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "68 " + strHex +                    // 00 push offset a1rag1
            "?? " +                             // 05 push ebx
            "C7 05 ?? ?? ?? ?? 01 00 00 00 " +  // 06 mov dword_8353B4, 1
            "E8 ?? ?? ?? ?? " +                 // 16 call _strstr
            "83 C4 08 " +                       // 21 add esp, 8
            "85 ?? " +                          // 24 test eax, eax
            "75 ";                              // 26 jnz short loc_6FAAB2
        jmpOffset = 26;
        strstrOffset = 17;

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    if (strstrOffset !== 0)
        logRawFunc("strstr", offset, strstrOffset);

    consoleLog("Step 3 - Replace JNZ/JNE with JMP");
    exe.replace(offset + jmpOffset, "EB ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function Disable1rag1Params_()
{
    return (exe.findString("1rag1", RAW) !== -1);
}
