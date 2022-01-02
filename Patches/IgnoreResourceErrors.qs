//###############################################
//# Purpose: Modify ErrorMsg function to return #
//#          without showing the MessageBox     #
//###############################################

function IgnoreResourceErrors()
{
    var hwndHex = table.getHex4(table.g_hMainWnd);

    consoleLog("Step 1a - Prep code for finding the ErrorMsg(msg) function");
    var code =
        "E8 ?? ?? ?? FF " +   // CALL GDIFlip
        "MovEax " +           // FramePointer Specific MOV
        "8B 0D " + hwndHex +  // MOV ECX, DWORD PTR DS:[g_hMainWnd]
        "6A 00 ";             // PUSH 0

    var fpEnb = HasFramePointer();

    if (fpEnb)
        code = code.replace("MovEax", "8B 45 08 ");     // MOV EAX, DWORD PTR SS:[EBP-8]
    else
        code = code.replace("MovEax", "8B 44 24 04 ");  // MOV EAX, DWORD PTR SS:[ESP+4]

    consoleLog("Step 1b - Prep code for finding the ErrorMsg(msg) function different from Step 1a");
    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "E8 ?? ?? ?? FF " +  // 00 CALL GDIFlip
            "6A 00 " +           // 05 PUSH 0
            "68 ?? ?? ?? 00 " +  // 07 PUSH OFFSET addr; ASCII "Error"
            "FF 75 08 ";         // 12 PUSH DWORD PTR SS:[EBP+8]

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        offset = pe.stringVa("Failed to load Winsock library!");

        if (offset === -1)
            return "Failed in Step 1 - String not found";

        consoleLog("Search for ErrMsg call location");
        code =
            "68 " + offset.packToHex(4) +  // 00 push "Failed to load Winsock library!"
            "E8 ";                         // 05 call ErrorMsg

        offset = pe.findCode(code);

        if (offset === -1)
            return "Failed in Step 1 - Pattern not found";

        offset = offset + 10 + pe.fetchDWord(offset + 6);

        consoleLog("Search for MsgBox call location");
        code =
            "E8 ?? ?? ?? FF " +  // 00 CALL GDIFlip
            "FF 75 0C " +        // 05 PUSH [ebp + uType]
            "68 ?? ?? ?? 00 " +  // 08 PUSH OFFSET addr; ASCII "Error"
            "FF 75 08 ";         // 13 PUSH DWORD PTR SS:[EBP+8]

        offset = pe.find(code, offset, offset + 0x20);

        if (offset === -1)
            return "Failed in Step 1 - Pattern not found";
    }

    consoleLog("Step 2 - Replace with XOR EAX, EAX followed by RETN, If Frame Pointer is present then a POP EBP comes before RETN");
    if (fpEnb)
        pe.replaceHex(offset + 5, " 33 C0 5D C3");
    else
        pe.replaceHex(offset + 5, " 33 C0 C3 90");

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function IgnoreResourceErrors_()
{
    return (exe.getClientDate() >= 20100000);
}
