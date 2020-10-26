//###################################################################
//# Purpose: Change the JNE after Langtype comparison to JMP in the #
//#         On Login callback which skips loading HelpMsgStr        #
//###################################################################

function DisableHelpMsg()
{ //Some Pre-2010 client doesnt have this PUSHes or HelpMsgStr reference.

  //Step 1a - Find the Unique PUSHes after the comparison . This is same for all clients
  var code =
    " 6A 0D" //PUSH 0D
  + " 6A 2A" //PUSH 2A
  ;
  var offset = exe.findCode(code, PTYPE_HEX, false);

    if (offset === -1)
    {
        code =
            "6A 0E " +  // 00 push 0Eh
            "6A 2A ";   // 02 push 2Ah

        offset = exe.findCode(code, PTYPE_HEX, false);
    }

  if (offset === -1)
  {
    code = code.replace("6A 2A", "8B 01 6A 2A"); //Insert a MOV EAX, DWORD PTR DS:[ECX] after PUSH 0E
    offset = exe.findCode(code, PTYPE_HEX, false);
  }

    if (offset === -1)
    {
        code =
            "6A 0E " +  // 00 push 0Eh
            "8B 01 " +  // 02 mov eax, [ecx]
            "6A 2F ";   // 04 push 2Fh

        offset = exe.findCode(code, PTYPE_HEX, false);
    }

    if (offset === -1)
    {
        code =
            "6A 0E " +  // 00 push 0Eh
            "8B 11 " +  // 02 mov edx, [ecx]
            "6A 2F ";   // 04 push 2Fh

        offset = exe.findCode(code, PTYPE_HEX, false);
    }

  if (offset === -1)
    return "Failed in Step 1 - Signature PUSHes missing";

  //Step 1b - Now find the comparison before it
  var LANGTYPE = GetLangType();
  if (LANGTYPE.length === 1)
    return "Failed in Step 1 - " + LANGTYPE[0];

  var code =
    LANGTYPE //CMP DWORD PTR DS:[g_serviceType], reg32_A
  + " 75"    //JNE addr
  ;
  var offset2 = exe.find(code, PTYPE_HEX, false, "\xAB", offset - 0x20, offset);

  if (offset2 === -1)
  {
    code = code.replace(" 75", " 00 75");//directly compared to 0
    offset2 = exe.find(code, PTYPE_HEX, false, "\xAB", offset - 0x20, offset);
  }

    if (offset2 === -1)
    {
        code =
            LANGTYPE +  // 00 mov eax, g_serviceType
            "AB AB " +  // 04 cmp eax, edi
            "75 ";      // 06 jnz short addr

        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x20, offset);
    }

  if (offset2 === -1)
    return "Failed in Step 1 - Comparison not found";

  //Step 2 - Replace JNE with JMP
  exe.replace(offset2 + code.hexlength() - 1, "EB", PTYPE_HEX);

  return true;
}
