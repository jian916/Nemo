//###############################################################
//# Purpose: Modify the Coordinates of Login and Cancel buttons #
//#          to show both of them in Login Screen.              #
//###############################################################

function ShowCancelToServiceSelect()
{
  //Step 1a - Find address of "btn_intro_b"
  var offset = pe.stringVa("btn_intro_b");
  if (offset === -1)
    return "Failed in Step 1 - btn_intro_b missing";

  //Step 1b - Find its reference (inside UILoginWnd::OnCreate)
  var code = offset.packToHex(4) + " C7";

  offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1 - btn_intro_b reference missing";

  offset += code.hexlength();

  //Step 2a - Find the x-coord of login button (btn_connect)
  if (HasFramePointer())
    code = " C7 45 ?? BD 00 00 00"; //MOV DWORD PTR SS:[EBP-x], 0BD
  else
    code = " C7 44 24 ?? BD 00 00 00"; //MOV DWORD PTR SS:[ESP+x], 0BD

  var offset2 = pe.find(code, offset, offset + 0x40);

  if (offset2 === -1)
  { //x > 0x7F
    if (HasFramePointer())
      code = " C7 85 ?? FF FF FF  BD 00 00 00"; //MOV DWORD PTR SS:[EBP-x], 0BD
    else
      code = " C7 84 24 ?? FF FF FF BD 00 00 00"; //MOV DWORD PTR SS:[ESP+x], 0BD

    offset2 = pe.find(code, offset, offset + 0x40);
  }

  if (offset2 === -1)
    return "Failed in Step 2 - login coordinate missing";

  offset = offset2 + code.hexlength();

  //Step 2b - Change 0xBD to 0x90 (its not a NOP xD)
  pe.replaceByte(offset - 4, 0x90);

  //Step 2c - Find the x-coord of cancel button after login coord.
  code = code.replace(" BD 00", " B2 01"); //swap 0BD with 1B2

  offset = pe.find(code, offset, offset + 0x30);
  if (offset === -1)
    return "Failed in Step 2 - cancel coordinate missing";

  offset += code.hexlength();

  //Step 2d - Change 0x1B2 to 0xBD
  pe.replaceHex(offset - 4, " BD 00");

  return true;
}

//==============================================================================//
// Disable for Unneeded Clients - Only Certain Client onwards shows Exit button //
//==============================================================================//
function ShowCancelToServiceSelect_()
{
  return (exe.getClientDate() > 20100803 && !IsZero());
}
