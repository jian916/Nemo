//##################################################################
//# Purpose: Change the JNZ after LangType check in InitMsgStrings #
//#          function to JMP.                                      #
//##################################################################

function ReadMsgstringtabledottxt()
{
    //Step 1 - Find the comparison which is at the start of the function
    var LANGTYPE = GetLangType();//Langtype value overrides Service settings hence they use the same variable - g_serviceTypes
    if (LANGTYPE.length === 1)
        return "Failed in Step 1 - " + LANGTYPE[0];

    var offset2 = 1;
    var code =
        " 83 3D" + LANGTYPE + " 00" //CMP DWORD PTR DS:[g_serviceType], 0
      + " 56"                       //PUSH ESI
      + " 75"                       //JNZ SHORT addr -> continue with msgStringTable.txt loading
      ;
    var offset = pe.findCode(code);  //VC9+ Clients

    if (offset === -1)
    {
        code =
            " A1" + LANGTYPE //MOV EAX, DWORD PTR DS:[g_serviceType]
          + " 56"            //PUSH ESI
          + " 85 C0"         //TEST EAX, EAX
          + " 75"            //JNZ SHORT addr -> continue with msgStringTable.txt loading
        ;
        offset = pe.findCode(code); //Older Clients
    }

    if (offset === -1)
    {
        code =
            " 83 3D" + LANGTYPE + " 00" // CMP DWORD PTR DS:[g_serviceType], 0
          + " 75 25"                    // JNZ SHORT addr
          + " 56"                       // PUSH ESI
        ;
        offset = pe.findCode(code); // 2016 clients [Secret]
        offset2 = 3;
    }

    if (offset === -1)
    {   // 2019-02-13+
        code =
            " 83 3D" + LANGTYPE + " 00" // CMP DWORD PTR DS:[g_serviceType], 0
          + " 75 26"                    // JNZ SHORT addr
          + " 56"                       // PUSH ESI
        ;
        offset = pe.findCode(code); // 2016 clients [Secret]
        offset2 = 3;
    }

    if (offset === -1)
        return "Failed in Step 1";

    //Step 2 - Change JNZ to JMP
    pe.replaceByte(offset + code.hexlength() - offset2, 0xEB);

    return true;
}
