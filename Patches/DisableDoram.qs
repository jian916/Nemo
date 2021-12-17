//#########################################################################################
//# Purpose: Remove Doram race from character creation UI                                 #
//#          special thanks to @Ai4Rei for the original hex sequences.                    #
//#########################################################################################

function DisableDoram()
{

  // Step 1
  var code =
    " FF 77 ??"       // PUSH DWORD PTR ??
  + " 8B CF"          // MOV ECX, EDI
  + " FF 77 ??"       // PUSH DWORD PTR ??
  + " E8"             // CALL ??
  ;

  var offset = pe.findCode(code);

  if (offset === -1)
    return "Failed in step 1";

  pe.replaceHex(offset, "90 6A 00");

  // Step 2a - MOV pattern
  code =
    " C7 ?? ?? FF FF FF 00 00 00 00"  // MOV [EBP + var_DC], 0
  + " C7 ?? ?? FF FF FF 00 00 00 00"  // MOV [EBP + var_D8], 0
  + " C7 ?? ?? FF FF FF 00 00 00 00"  // MOV [EBP + var_D4], 0
  + " 6A 01"                          // PUSH 1

  offset = pe.findCode(code);

  if (offset === -1)
    return "Failed in step 2 - Cannot find 3 MOV [EXP + var_Dx], 0 pattern.";

  offset += 30; // 10*3 from each MOV

  // Step 2b - XOR jump
  code =
    " 33 F6"             // XOR ESI, ESI
  + " 8D 87 ?? ?? 00 00" // LEA EAX, [EDI + const]
  + " 8D 49 00"          // LEA ECX, [ECX + 0]
  ;

  var offset2 = pe.find(code, offset, offset + 0x300);

  if (offset2 === -1)
    return "Failed in step 2b - XOR after MOV pattern not found";

  offset2 = offset2 - offset - 5;

  pe.replaceHex(offset, "E9" + offset2.packToHex(4) + " 90 90");

  // Step 3
  code =
    " 8B 8D 38 FF FF FF" // MOV ECX, [EBP+var_C8]
  + " 41"                // INC ECX
  + " 89 8D 38 FF FF FF" // MOV [EBP+var_C8], ECX
  + " B8 ?? ?? 00 00"    // MOV EAX, const
  + " 83 F9 02"          // CMP EAX, 2
  ;

  offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in step 3";

  pe.replaceHex(offset + code.hexlength(), "90 90 90 90 90 90");
  return true;
}

function DisableDoram_()
{
    return exe.getClientDate() <= 20170614;
}
