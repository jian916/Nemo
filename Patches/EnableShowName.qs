//#################################################################
//# Purpose: Change the JZ to JMP after LangType check when using #
//#          '/showname' inside CSession::SetTextType function    #
//#################################################################

function EnableShowName()
{

  //Step 1 - Find the Comparison
  var code =
    " 85 C0"    //TEST EAX, EAX
  + " 74 ??"    //JZ SHORT addr -> loading setting for showname
  + " 83 F8 06" //CMP EAX, 06
  + " 74 ??"    //JZ SHORT addr -> loading setting for showname
  + " 83 F8 0A" //CMP EAX, 0A
  ;

  var offset = pe.findCode(code);
  if (offset == -1)
    return "Failed in Step 1";

  //Step 2 - Replace the first JZ with JMP - rest of JZ have no need to change
  pe.replaceByte(offset + 2, 0xEB);

  return true;
}
