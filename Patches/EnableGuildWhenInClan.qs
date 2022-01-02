//#########################################################################
//# Purpose: Skips the check that requires the player to not be in a clan #
//# Author : Functor                                                      #
//#########################################################################
function EnableGuildWhenInClan()
{

    // Step 1 - Find Message ID #2605 reference
    var code =
        " 68 2D 0A 00 00" // PUSH 0x0A2D
        + " E8 ?? ?? ?? FF" // CALL MsgStr
        + " 50"             // PUSH EAX
    ;

    var offset = pe.findCode(code);
    if (offset === -1)
    {
        var code =
            " 68 2D 0A 00 00" // PUSH 0x0A2D
            + " E9 ?? ?? ?? FF" // jmp addr1
            + " B8"             // mov ...
        ;
        var offset = pe.findCode(code);

        if (offset === -1)
            return "Failed in Step 1 - reference to MsgStr with ID 2605 missing.";
    }

    // Replace the jump before message ID push
    pe.replaceByte(offset - 2, 0xEB);

    // Step 2 - Find the jump followed by push 0x168
    var code =
        " 0F 85 ?? ?? FF FF" // JNZ addr
    +   " B8 68 01 00 00"    // MOV EAX, 168
    ;

    offset = pe.find(code, offset, offset + 0x200);

    if (offset === -1)
        return "Failed in Step 2 - magic jump not found";

    // Replace the jump with NOPs
    pe.replaceHex(offset, " 90".repeat(6));

    return true;
}

// Disable for unsupported clients
function EnableGuildWhenInClan_()
{
    return pe.stringRaw("/clanchat") !== -1;
}
