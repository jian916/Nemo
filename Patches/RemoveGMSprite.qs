//###########################################################################
//# Purpose: Change the JNE after accountID comparison against GM ID to JMP #
//#          inside CPc::SetSprNameList and CPc::SetActNameList functions   #
//###########################################################################

function RemoveGMSprite()
{

  //Step 1a - Find the location where both functions are called
  var code =
    " 68 ?? ?? ?? 00" //PUSH OFFSET addr; actName
  + " 6A 05"          //PUSH 5; layer
  + " 8B ??"          //MOV ECX, reg32_A
  + " E8 ?? ?? FF FF" //CALL CPc::SetActNameList
  ;
  var len = code.hexlength();

  code += code; //PUSH OFFSET addr; sprName
                //PUSH 5; layer
                //MOV ECX, reg32_A
                //CALL CPc::SetSprNameList

  var offset = pe.findCode(code);

  if (offset === -1)
  {
    code = code.replace(" 8B ??"); //Remove the first MOV ECX, reg32_A . It might have been assigned earlier
    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 1";

  offset += code.hexlength() - len;//offset now points to PUSH sprName

  //Step 1b - Extract the Function addresses (RAW)
  var funcs = [];
  funcs[0] = offset + pe.fetchDWord(offset - 4);//CPc::SetActNameList RAW address
  funcs[1] = offset + len + pe.fetchDWord(offset + len - 4);//CPc::SetSprNameList RAW address

  //Step 2a - Prep code to look for IsNameYellow function call
  code =
    " E8 ?? ?? ?? ??" //CALL IsNameYellow; Compares accountID against GM IDs
  + " 83 C4 04"       //ADD ESP, 4
  + " 84 C0"          //TEST AL, AL
  + " 0F 84"          //JNE addr2
  ;

  for (var i = 0; i < funcs.length; i++)
  {
    //Step 2b - Find the Call
    offset = pe.find(code, funcs[i]);
    if (offset === -1)
      return "Failed in Step 2 - Iteration No." + i;

    //Step 2c - Replace JNE with NOP + JMP
    pe.replaceHex(offset + code.hexlength() - 2, " 90 E9");
  }

  return true;
}
