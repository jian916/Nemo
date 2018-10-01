//#############################################################
//# Purpose: Change the JNE to NOPs after LangType comparison #
//#          in EOT font Checker function                     #
//#############################################################

function EnableOfficialCustomFonts()
{  //Comparison is not there in Pre-2010 Clients
    var LANGTYPE = GetLangType();
    if (LANGTYPE.length === 1)
        return "Failed in Step 1 - " + LANGTYPE[0];
    //Step 1 - Find the JNE (Comparison pattern changes from client to client, but the JNE and CALL doesn't)
    var code =
        LANGTYPE + " 00 "     //CMP g_serviceType, 0
      + " AB"                 //POP EDI
      + " 0F 85 AE 00 00 00"  //JNE addr - Skips .eot loading
      + " E8 AB AB AB FF"     //CALL func
    ;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {  // 2018-05-30 +
        code =
            LANGTYPE + " 00 "     //CMP g_serviceType, 0
          + " AB"                 //POP EDI
          + " 0F 85 AE 00 00 00"  //JNE addr - Skips .eot loading
          + " E8 AB AB AB 00"     //CALL func
        ;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1";

    //Step 2 - Replace JNE instruction with NOPs
    exe.replace(offset + 6, " 90 90 90 90 90 90", PTYPE_HEX);

    return true;
}
