//#############################################################################
//# Purpose: Make the code inside CLoginMode::OnChangeState which sends 0x2B0 #
//#          use Original Password (which is the Arg.1 of Encryptor) instead  #
//#          of Encrypted Password                                            #
//#############################################################################

function DisableLoginEncryption()
{

  //Step 1 - Find Encryptor function call.
  var code =
    " E8 ?? ?? ?? FF" //CALL Encryptor (preceded by PUSH reg32_A)
  + " B9 06 00 00 00" //MOV ECX,6
  + " 8D"             //LEA reg32_B, [EBP-x]
  ;

  var offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1 - Encryptor call missing";

  //Step 2a - Extract the register PUSHed - Arg.1 which contains the Original Password
  var regPush = pe.fetchByte(offset - 1) - 0x50;

  //Step 2b - Change the LEA to LEA reg32_B, [reg32_A]
  offset += code.hexlength();
  code =
    ((pe.fetchUByte(offset) & 0x38) | regPush).packToHex(1) //LEA reg32_B, [reg32_A]
  + " 90 90 90 90" //NOPs
  ;

  pe.replaceHex(offset, code);

  return true;
}

//=================================//
// Disable for Unsupported Clients //
//=================================//
function DisableLoginEncryption_()
{
  return (exe.getClientDate() < 20100803);
}
