//##############################################
//# Purpose: Set g_hideAccountList always to 1 #
//#          assigned above passwordencrypt.   #
//##############################################

function SkipServiceSelect()
{
    // Step 1 - Find address of "passwordencrypt" (g_hideAccountList is assigned just above it)
    var offset = exe.findString("passwordencrypt", RVA);

    if (offset === -1)
        return "Failed in Step 1 - Reference not found";

    // Step 2 - Find its reference
    var code =
        "74 07 " +                    // jz      short loc_4D7E79
        "C6 05 AB AB AB AB 01 " +     // mov     byte_6BA37C, 1
        "68 " + offset.packToHex(4);  // push    offset aPasswordencryp ; "passwordencrypt"

    var repl = "90 90 "; // NOP out JZ
    var offset2 = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset2 === -1)
    {
        code =
            "0F 45 AB " +                 // cmovnz  ecx, esi
            "88 AB AB AB AB AB " +        // mov     byte_FEAAE8, cl
            "68 " + offset.packToHex(4);  // push    offset aPasswordencryp ; "passwordencrypt"

        repl = "90 8B "; // change CMOVNZ to MOV
        offset2 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset2 === -1)
    {
        code =
            "0F 45 AB " +                 // cmovnz  ecx, esi
            "88 AB AB AB AB AB " +        // mov     byte_FC3904, cl
            "8B AB " +                    // mov     ecx, edi
            "68 " + offset.packToHex(4);  // push    offset aPasswordencryp ; "passwordencrypt"

        repl = "90 8B "; // change CMOVNZ to MOV
        offset2 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset2 === -1)
        return "Failed in Step 2 - Pattern not found";

    // Step 3 - Change conditional instruction to permanent setting
    exe.replace(offset2, repl, PTYPE_HEX);

    return true;
}
