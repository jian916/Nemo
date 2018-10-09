//###################################################################
//# Purpose: Change the JE/JNE to JMP after LangType Comparisons in #
//#          Char Deletion function and the one which shows MsgBox  #
//###################################################################

function DeleteCharWithEmail()
{
    //Step 1a - Find the LangType comparison in Char Delete function (name not known right now)
    var LANGTYPE = GetLangType(); //Langtype value overrides Service settings hence they use the same variable - g_serviceType
    if (LANGTYPE.length === 1)
        return "Failed in Step 1 - " + LANGTYPE[0];

    // search in CLoginMode_virt28, case 11

    var code =
        " A1" + LANGTYPE //MOV EAX, DWORD PTR DS:[g_serviceType]
      + " 83 C4 08"      //ADD ESP,8
      + " 83 F8 0A"      //CMP EAX,0A
      + " 74"            //JE SHORT addr -> do the one for Email
      ;
    var patchOffset = code.hexlength() - 1;
    var offset = exe.findCode(code, PTYPE_HEX, false);
    if (offset !== -1)
    {
        //Step 1b - Change the JE to JMP
        exe.replace(offset + patchOffset, "EB", PTYPE_HEX);
    }
    else
    {
        code =
            "83 F9 0A " +  // cmp ecx, 0Ah
            "74 AB " +     // jz addr
            "83 F9 0C " +  // cmp ecx, 0Ch
            "74 AB " +     // jz addr
            "83 F9 01 " +  // cmp ecx, 01h
            "74 ";         // jz addr
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
        patchOffset = 3

        //Step 1b - Change the JE to JMP
        exe.replace(offset + patchOffset, "EB", PTYPE_HEX);

        //Step 1c - Change the JE to JMP in check before
        var code =
            "8B 0D " + LANGTYPE +  // mov ecx, g_serviceType
            "85 C9 " +             // test ecx, ecx
            "75";                  // jnz addr
        patchOffset = code.hexlength() - 1;
        offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x30, offset);
        if (offset === -1)
            return "Failed in Step 1c - g_serviceType not found";

        //Step 1d - Change the JNZ to JMP
        exe.replace(offset + patchOffset, "EB", PTYPE_HEX);
    }

    if (offset === -1)
        return "Failed in Step 1 - Comparison missing";

    // search in UIEmailAddressWnd_virt68+

    //Step 2a - Find the LangType comparison for MsgBox String
    code =
        " 6A 00"          //PUSH 0
      + " 75 07"          //JNE SHORT addr -> PUSH 12B
      + " 68 AB AB 00 00" //PUSH 717 or 718 or 12E - the MsgString ID changes between clients
      + " EB 05"          //JMP SHORT addr2 -> CALL MsgStr
      ;

    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in Step 2 - Comparison missing";

    //Step 2b - Change JNE to JMP
    exe.replace(offset + 2, "EB", PTYPE_HEX);

    return true;
}