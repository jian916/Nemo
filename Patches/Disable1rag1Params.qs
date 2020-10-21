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
        "AB " +           // 05 push edi
        "FF AB " +        // 06 call ebx
        "83 C4 08 " +     // 08 add esp, 8
        "85 AB " +        // 11 test eax, eax
        "75 ";            // 13 jnz short loc_B13280

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code =
            "68 " + strHex +     // 00 push offset a1rag1
            "AB " +              // 05 push edi
            "E8 AB AB AB AB " +  // 06 call strstr
            "83 C4 08 " +        // 11 add esp, 8
            "85 AB " +           // 14 test eax, eax
            "75 ";               // 16 jnz short loc_8660B2

        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "68 " + strHex +                    // 00 push offset a1rag1
            "AB " +                             // 05 push ebx
            "C7 05 AB AB AB AB AB AB AB AB " +  // 06 mov dword_8353B4, 1
            "E8 AB AB AB AB " +                 // 16 call _strstr
            "83 C4 08 " +                       // 21 add esp, 8
            "85 AB " +                          // 24 test eax, eax
            "75 ";                              // 26 jnz short loc_6FAAB2

        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 2 - Pattern not found";

    consoleLog("Step 3 - Replace JNZ/JNE with JMP");
    exe.replace(offset + code.hexlength() - 1, "EB ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function Disable1rag1Params_()
{
    return (exe.findString("1rag1", RAW) !== -1);
}
