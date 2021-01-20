//###############################################################
//# Purpose: Change the JE/JNE after LangType comparison inside #
//#          CGameMode::SendMsg function for /who command       #
//#          and inside CGameMode::Zc_User_Count                #
//###############################################################

function EnableWhoCommand()
{
    //Step 1a - Find LangType comparison
    var LANGTYPE = GetLangType();  // Langtype value overrides Service settings hence they use the same variable - g_serviceType
    if (LANGTYPE.length === 1)
        return "Failed in Step 1 - " + LANGTYPE[0];

    var code =
        " A1" + LANGTYPE     //MOV EAX,DWORD PTR DS:[g_serviceType]
      + " 83 F8 03"          //CMP EAX,3
      + " 0F 84 AB AB 00 00" //JE addr
      + " 83 F8 08"          //CMP EAX,8
      + " 0F 84 AB AB 00 00" //JE addr
      + " 83 F8 09"          //CMP EAX,9
      + " 0F 84 AB AB 00 00" //JE addr
      + " 8D"                //LEA ECX,[ESP+x]
      ;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code =
            " A1" + LANGTYPE     //MOV EAX,DWORD PTR DS:[g_serviceType]
          + " 83 F8 03"          //CMP EAX,3
          + " 0F 84 AB AB 00 00" //JE addr
          + " 83 F8 08"          //CMP EAX,8
          + " 0F 84 AB AB 00 00" //JE addr
          + " 83 F8 09"          //CMP EAX,9
          + " 0F 84 AB AB 00 00" //JE addr
          + " B8"                //MOV EAX, ...
          ;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1 - LangType comparison missing";

    //Step 1b - Replace the First JE with JMP to LEA
    exe.replace(offset + 5, "90 EB 18", PTYPE_HEX);

    //Step 2a - Find PUSH 0B2 followed by CALL MsgStr - Common pattern inside Zc_User_Count
    code =
        " 68 B2 00 00 00" //0 PUSH 0B2
      + " E8 AB AB AB AB" //5 CALL MsgStr
      + " 83 C4 04"       //10 ADD ESP, 4
      ;
    var msgStrOffset = 6;

    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in Step 2 - MsgStr call missing";

    logRawFunc("MsgStr", offset, msgStrOffset);

    //Step 2b - Find the JNE after LangType comparison before it (closer to start of Zc_User_Count)

    var aidHex = (table.get(table.g_session) + table.get(table.CSession_m_accountId)).packToHex(4);

    code =
        " 75 AB"          //JNE SHORT addr
      + " A1 " + aidHex   //MOV EAX, DWORD PTR DS:[g_session.m_account_id]
      + " 50"             //PUSH EAX
      + " E8 AB AB AB FF" //CALL IsGravityAid
      + " 83 C4 04"       //ADD ESP, 4
      + " 84 C0"          //TEST AL, AL
      + " 75"             //JNE SHORT addr
      ;
    var patchOffset = 0;
    var aidOffset = [3, 4];
    var isGravityAidOffset = 9;
    var offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x60, offset);
    if (offset2 === -1)
    {
        code =
            " 75 AB"          //JNE SHORT addr
          + " FF 35 " + aidHex  // PUSH DWORD PTR DS:[g_session.m_account_id]
          + " E8 AB AB AB FF" //CALL IsGravityAid
          + " 83 C4 04"       //ADD ESP, 4
          + " 84 C0"          //TEST AL, AL
          + " 75"             //JNE SHORT addr
          ;
        patchOffset = 0;
        aidOffset = [4, 4];
        isGravityAidOffset = 9;
        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x60, offset);
    }
    if (offset2 === -1)  // 2018-05-30 +
    {
        code =
            " 75 AB"          //JNE SHORT addr
          + " FF 35 " + aidHex  // PUSH DWORD PTR DS:[g_session.m_account_id]
          + " E8 AB AB AB 00" //CALL IsGravityAid
          + " 83 C4 04"       //ADD ESP, 4
          + " 84 C0"          //TEST AL, AL
          + " 75"             //JNE SHORT addr
          ;
        patchOffset = 0;
        aidOffset = [4, 4];
        isGravityAidOffset = 9;
        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x60, offset);
    }

    if (offset2 === -1)
        return "Failed in Step 2 - LangType comparison missing";

    logFieldAbs("CSession::m_account_id", offset2, aidOffset);
    logRawFunc("IsGravityAid", offset2, isGravityAidOffset);

    //Step 2c - Replace First JNE with JMP
    exe.replace(offset2 + patchOffset, "EB", PTYPE_HEX);

    return true;
}
