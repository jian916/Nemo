//###############################################################################
//# Purpose: Change the JZ/JNE to JMP/NOP after LangType Comparison for sending #
//#          Login Packet inside CLoginMode::OnChangeState function.            #
//###############################################################################

function UseSSOLoginPacket()
{

  //Step 1a - Find the LangType comparison
  var LANGTYPE = GetLangType();//Langtype value overrides Service settings hence they use the same variable - g_serviceType
  if (LANGTYPE.length === 1)
    return "Failed in Step 1 - " + LANGTYPE[0];

  var code =
    " 80 3D ?? ?? ?? 00 00" //CMP BYTE PTR DS:[g_passwordencrypt], 0
  + " 0F 85 ?? ?? 00 00"    //JNE addr1
  + " A1" + LANGTYPE        //MOV EAX, DWORD PTR DS:[g_serviceType]
  + " ?? ??"                //TEST EAX, EAX - (some clients use CMP EAX, EBP instead)
  + " 0F 84 ?? ?? 00 00"    //JZ addr2 -> Send SSO Packet (ID = 0x825. was 0x2B0 in Old clients)
  + " 83 ?? 12"             //CMP EAX, 12
  + " 0F 84 ?? ?? 00 00"    //JZ addr2 -> Send SSO Packet (ID = 0x825. was 0x2B0 in Old clients)
  ;
  var offset = pe.findCode(code);

  if (offset === -1)
  {
    var code =
      " 80 3D ?? ?? ?? 00 00" //CMP BYTE PTR DS:[g_passwordencrypt], 0
    + " 0F 85 ?? ?? 00 00"    //JNE addr1
    + " 8B ?? " + LANGTYPE    //MOV EAX, DWORD PTR DS:[g_serviceType]
    + " ?? ??"                //TEST EAX, EAX - (some clients use CMP EAX, EBP instead)
    + " 0F 84 ?? ?? 00 00"    //JZ addr2 -> Send SSO Packet (ID = 0x825. was 0x2B0 in Old clients)
    + " 83 ?? 12"             //CMP EAX, 12
    + " 0F 84 ?? ?? 00 00"    //JZ addr2 -> Send SSO Packet (ID = 0x825. was 0x2B0 in Old clients)
    ;
    offset = pe.findCode(code);
  }

  if (offset === -1)
  {
    var code =
      " 80 3D ?? ?? ?? 01 00" //CMP BYTE PTR DS:[g_passwordencrypt], 0
    + " 0F 85 ?? ?? 00 00"    //JNE addr1
    + " 8B ?? " + LANGTYPE    //MOV EAX, DWORD PTR DS:[g_serviceType]
    + " ?? ??"                //TEST EAX, EAX - (some clients use CMP EAX, EBP instead)
    + " 0F 84 ?? ?? 00 00"    //JZ addr2 -> Send SSO Packet (ID = 0x825. was 0x2B0 in Old clients)
    + " 83 ?? 12"             //CMP EAX, 12
    + " 0F 84 ?? ?? 00 00"    //JZ addr2 -> Send SSO Packet (ID = 0x825. was 0x2B0 in Old clients)
    ;
    offset = pe.findCode(code);
  }

  if (offset !== -1)
  {
    //Step 1b - Change first JZ to JMP
    pe.replaceHex(offset + code.hexlength() - 15, " 90 E9");
    return true;
  }

  // for very old clients
  //Step 2a - Since it failed it is an old client before VC9. Find the alternate comparison pattern
  code =
    " A0 ?? ?? ?? 00"       //MOV AL, DWORD PTR DS:[g_passwordencrypt]
  + " ?? ??"                //TEST AL, AL - (could be checked with CMP also. so using wildcard)
  + " 0F 85 ?? ?? 00 00"    //JNE addr1
  + " A1" + LANGTYPE        //MOV EAX, DWORD PTR DS:[g_serviceType]
  + " ?? ??"                //TEST EAX, EAX - (some clients use CMP EAX, EBP instead)
  + " 0F 85 ?? ?? 00 00"    //JNE addr2 -> Send Login Packet (ID = 0x64)
  ;

  offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1";

  //Step 2b - Convert the JNE addr2 to NOP
  pe.replaceHex(offset + code.hexlength() - 6, " 90 90 90 90 90 90");

  return true;
}
