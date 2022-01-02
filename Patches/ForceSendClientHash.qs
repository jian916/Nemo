//###################################################################
//# Purpose: Change all JE/JNE to JMP after LangType comparisons in #
//#          CLoginMode::CheckExeHashFromAccServer function         #
//###################################################################

function ForceSendClientHash()
{

  //Step 1a - Find the 1st LangType comparison
  var LANGTYPE = GetLangType();//Langtype value overrides Service settings hence they use the same variable - g_serviceType
  if (LANGTYPE.length === 1)
    return "Failed in Step 1 -" + LANGTYPE[0];

  var code =
    " 8B ??" + LANGTYPE //MOV reg32,DWORD PTR DS:[g_serviceType]
  + " 33 C0"            //XOR EAX, EAX
  + " 83 ?? 06"         //CMP reg32, 6
  + " 74"               //JE SHORT addr -> (to MOV EAX, 1)
  ;

  var offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1";

  offset += code.hexlength();

  //Step 1b - Replace JE with JMP
  pe.replaceByte(offset - 1, 0xEB);

  //Step 1c - Update offset to the JE-ed location.
  offset += 1 + pe.fetchByte(offset);

  //Step 2a - Find the 2nd comparison
  code =
    " 85 C0"  //TEST EAX, EAX
  + " 75 ??"  //JNE SHORT addr1
  + " A1"     //MOV EAX, DWORD PTR DS:[addr2]
  ;

  offset = pe.find(code, offset);
  if (offset === -1)
    return "Failed in Step 2";

  offset += code.hexlength() - 1;

  //Step 2b - Replace JNE with JMP
  pe.replaceByte(offset - 2, 0xEB);

  //Step 2c - Update offset to JNE-ed location
  offset += pe.fetchByte(offset - 1);

  //Step 3a - Find the last comparison
  code =
    " 83 F8 06"  //CMP EAX, 6
  + " 75"        //JNE SHORT addr3
  ;

  offset = pe.find(code, offset);
  if (offset === -1)
    return "Failed in Step 3";

  offset += code.hexlength() - 1;

  //Step 3b - Replace JNE with JMP
  pe.replaceByte(offset, 0xEB);

  return true;
}
