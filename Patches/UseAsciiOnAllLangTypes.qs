//############################################################
//# Purpose: Change the JNZ after Langtype comparison inside #
//#          CSession::IsOnlyEnglish to NOP                  #
//############################################################

function UseAsciiOnAllLangTypes()
{

  //Step 1 - Find the comparison. JNZ is the very next instruction
  //         TEST BYTE PTR DS:[reg32_A + reg32_B], 80
  //         JNZ SHORT addr
  var offset = pe.findCode("F6 04 ?? 80 75");
  if (offset === -1)
    var offset = pe.findCode("80 3C ?? 00 7C");
  if (offset === -1)
    return "Failed in Step 1";

  //Step 2 - NOP out the JNZ
  pe.replaceHex(offset + 4, " 90 90");

  return true;
}
