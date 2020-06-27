//#######################################################
//# Purpose: Bypass Homunculus's target select checking #
//#######################################################

function FixHomunculusAI()
{
    consoleLog("Step 1 - Find the function of checking Homunculus's target select");
    var code =
        "55 " +                 // PUSH EBP
        "8B EC " +              // MOV EBP,ESP
        "8B 89 E0 00 00 00 " +  // MOV ECX,[ECX+E0]
        "8B 01 " +              // MOV EAX,[ECX]
        "3B C1 " +              // CMP EAX,ECX
        "74 0E " +              // JE SHORT
        "8B 55 08 " +           // MOV EDX,[EBP+08]
        "39 50 08 " +           // CMP [EAX+08],EDX
        "74 0C " +              // JE SHORT
        "8B 00 " +              // MOV EAX,[EAX]
        "3B C1 " +              // CMP EAX,ECX
        "75 F5 " +              // JNE SHORT
        "32 C0 " +              // XOR AL,AL
        "5D " +                 // POP EBP
        "C2 04 00 " +           // RET 04
        "B0 01 " +              // MOV AL,01
        "5D " +                 // POP EBP
        "C2 04 00 ";            // RET 04

    var offset = exe.findCode(code, PTYPE_HEX, false);

    if (offset === -1)
        return "Failed in step 1: function missing.";

    consoleLog("Step 2 - Move to patch point");
    offset = offset + 0x1D;

    consoleLog("Step 3 - Replace (XOR AL,AL) with (MOV AL,01)");
    exe.replace(offset, "B0 01 ", PTYPE_HEX);

    consoleLog("Step 4 - Remove target cursor for all targets");
    var code =
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "6A 00 " +          // PUSH 00
        "68 86 00 00 00 ";  // PUSH 86

    var offsets = exe.findCodes(code, PTYPE_HEX, false);

    if (offsets.length !== 2)
    {
        code =
            "6A 00 " +          // PUSH 00
            "6A 00 " +          // PUSH 00
            "6A 00 " +          // PUSH 00
            "6A 00 " +          // PUSH 00
            "68 86 00 00 00 ";  // PUSH 86

        offsets = exe.findCodes(code, PTYPE_HEX, false);
    }

    if (offsets.length !== 2)
        return "Failed in Step 4";

    for (var i = 0; i < offsets.length; i++)
    {
        offset = exe.find("84 C0 74 AB ", PTYPE_HEX, true, "\xAB", offsets[i]-8, offsets[i]);

        if (offset === -1)
            return "Failed in Step 4.1";

        offset += 2;
        exe.replace(offset , "EB ", PTYPE_HEX);
    }

    return true;
}
