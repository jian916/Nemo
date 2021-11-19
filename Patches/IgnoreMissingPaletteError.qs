//################################################################
//# Purpose: Change the JNZ to JMP after CFile::Open result TEST #
//#         in CPaletteRes::Load function                        #
//################################################################

function IgnoreMissingPaletteError()
{

  //Step 1a - Find the Error message string's offset
  var offsetHex = pe.stringHex4("CPaletteRes :: Cannot find File : ");

  //Step 1b - Find its reference
  var code =
    " 68" + offsetHex           //PUSH OFFSET addr; ASCII "CPaletteRes :: Cannot find File : "
  + " 8D"                       //LEA ECX, [LOCAL.x]
  ;
  var offset2 = pe.findCode(code);

  if (offset2 === -1)
  {
    code = code.replace(" 8D", " C7");//mov     [ebp+var_18], 0
    offset2 = pe.findCode(code);
  }


  if (offset2 === -1)
  {
    code = "BF" + offsetHex; //MOV EDI, OFFSET addr; ASCII "CPaletteRes :: Cannot find File : "
    offset2 = pe.findCode(code);
  }

  if (offset2 === -1)
    return "Failed in Step 1 - Message Reference missing";

  //Step 1c - Now Find the call to CFile::Open and its result comparison
  code =
    " E8 ?? ?? ?? ??"    //CALL CFile::Open
  + " 84 C0"             //TEST AL, AL
  + " 0F 85 ?? ?? 00 00" //JNZ addr
  ;

  var offset = pe.find(code, offset2 - 0x100, offset2);

  if (offset === -1)
    return "Failed in Step 1 - Function call missing";

  //Step 2 - Replace JNZ with NOP + JMP
  exe.replace(offset + code.hexlength() - 6, "90 E9", PTYPE_HEX);

  return true;
}
