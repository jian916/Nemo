//########################################################################
//# Purpose: Find call to the encryption function and substitute it with #
//#          XOR EAX, EAX                                                #
//########################################################################

function DisablePacketEncryption()
{

  //Step 1a - Check if any of the Packet Key patches are ON
  var patches = getActivePatches();
  for (var i = 0; i < 3; i++)
  {
    if (patches.indexOf(92 + i) !== -1)
      return "Patch Cancelled - One or more of the Packet Key Patches are ON";
  }

  //Step 1b - Get the Packet Key Info.
  var info = FetchPacketKeyInfo();
  if (typeof(info) === "string")
    return info;

  //Step 2a - Find the Packet Encryption call Prep code to insert.
  var code = info.refMov; //MOV ECX, DWORD PTR DS:[refAddr]

  if (info.type !== 0)
    code += " 6A 00";    //PUSH 0

  code += " E8";         //CALL CRagConnection::Encryptor

  var offset = exe.findCode(code, PTYPE_HEX, false);
  if (offset === -1)
    return "Failed in Step 2";

  //Step 3 - Replace CALL with XOR EAX, EAX and JMP to skip the rest till end of CALL
  code =
    " 33 C0" //XOR EAX, EAX
  + " EB" + code.hexlength().packToHex(1) //JMP addr
  ;

  exe.replace(offset, code, PTYPE_HEX);

  return true;
}
