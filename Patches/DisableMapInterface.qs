//##################################################################
//# Purpose: Skip over all instances of World View Window creation #
//##################################################################

function DisableMapInterface()
{
  //Step 1a - Find the creation pattern 1 - There should be exactly 2 matches (map button, shortcut)
  var code =
    " 68 8C 00 00 00"    //PUSH 8C
  + getEcxWindowMgrHex() //MOV ECX, g_winMgr
  + " E8 ?? ?? ?? ??"    //CALL UIWindowMgr::PrepWindow ?
  + " 84 C0"             //TEST AL, AL
  + " 0F 85 ?? ?? 00 00" //JNE addr
  + " 68 8C 00 00 00"    //PUSH 8C
  + getEcxWindowMgrHex() //MOV ECX, g_winMgr
  + " E8"                //CALL UIWindowMgr::MakeWindow
  ;

  var offsets = pe.findCodes(code);
  if (offsets.length === 0)
    return "Failed in Step 1 - No matches found";

  //Step 1b - Change the First PUSH to a JMP to the JNE location and  change the JNE to JMP
  for (var i = 0; i < offsets.length; i++)
  {
    pe.replaceHex(offsets[i], "EB 0F");
    pe.replaceHex(offsets[i] + 17, "90 E9");
  }

  //Step 2a - Swap the JNE with a JNE SHORT and search pattern - Only for latest clients
  code = code.replace(" 0F 85 ?? ?? 00 00", " 75 ??");

  var offsets = pe.findCodes(code);

  //Step 2b - Repeat 1b for this set
  for (var i = 0; i < offsets.length; i++)
  {
    pe.replaceHex(offsets[i], "EB 0F");
    pe.replaceByte(offsets[i] + 17, 0xEB);
  }

  //Step 3a - Find pattern 2 - Only for latest clients (func calls functions from pattern 1)
  code =
    " 68 8C 00 00 00" //PUSH 8C
  + " 8B ??"          //MOV ECX, reg32
  + " E8 ?? ?? ?? FF" //CALL func ?
  + " 5E"             //POP ESI
  ;
  var offset = pe.findCode(code);

  //Step 3b - Replace PUSH with a JMP to the POP ESI
  if (offset !== -1)
  {
    pe.replaceHex(offset, "EB 0A");
  }

  return true;
}
