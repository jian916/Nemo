//############################################################
//# Purpose: Modify the Serial Display function to reset EAX #
//#          and thereby skip showing the serial number      #
//############################################################

function RemoveSerialDisplay()
{

  //Step 1a - Prep comparison code
  var code1 =
    " 83 C0 ??"          //ADD EAX, const1
  + " 3B 41 ??"          //CMP EAX, DWORD PTR DS:[EAX+const2]
  + " 0F 8C ?? 00 00 00" //JL addr
  + " 56"                //PUSH ESI
  ;

  var code2 = " 6A 00"; //PUSH 0

  //Step 1b - Find the code
  var offset = pe.findCode(code1 + " 57" + code2); //New Client

  if (offset === -1)
    offset = pe.findCode(code1 + code2); //Older client

  if (offset === -1)
    return "Failed in Step 1";

  //Step 2 - Overwrite ADD and CMP statements with the following. Since EAX is 0, the JL will always Jump
  // NOP
  // XOR EAX, EAX
  // CMP EAX, 1
  pe.replaceHex(offset, " 90 31 C0 83 F8 01");

  return true;
}

//=================================//
// Disable for Unsupported Clients //
//=================================//
function RemoveSerialDisplay_()
{
  return (exe.getClientDate() > 20101116);
}
