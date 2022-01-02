//###########################################################################################
//# Purpose: Modify the JPEG_CORE_PROPERTIES structure assignment inside CRenderer::SaveJPG #
//#          function to set jquality member to user specified value.                       #
//###########################################################################################

function IncreaseScreenshotQuality()
{

  //Step 1 - Find the JPEG_CORE_PROPERTIES member assignments (DIBChannels & DIBColor)
  var fpEnb = HasFramePointer();
  if (fpEnb)
  {
    var code =
      " C7 85 ?? ?? FF FF 03 00 00 00" //MOV DWORD PTR SS:[EBP-x], 3 ; DIBChannels = 3
    + " C7 85 ?? ?? FF FF 02 00 00 00" //MOV DWORD PTR SS:[EBP-y], 2 ; DIBColor = 2
    ;
  }
  else
  {
    var code =
      " C7 44 24 ?? 03 00 00 00" //MOV DWORD PTR SS:[ESP+x], 3 ; DIBChannels = 3
    + " C7 44 24 ?? 02 00 00 00" //MOV DWORD PTR SS:[ESP+y], 2 ; DIBColor = 2
    ;
  }
  var offset = pe.findCode(code);

  if (offset === -1)
  {
    if (fpEnb)
    {
        var code =
          " C7 45 ?? 03 00 00 00"
        + " C7 45 ?? 02 00 00 00"
        ;
    }
    else
    {
        var code =
          " C7 84 24 ?? ?? 00 00 03 00 00 00"
        + " C7 84 24 ?? ?? 00 00 02 00 00 00"
        ;
    }

    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 1";

  var csize = code.hexlength() / 2;//Length of 1 assignment

  //Step 2a - Get new quality value from user
  var newvalue = exe.getUserInput("$uQuality", XTYPE_BYTE, _("Number Input"), _("Enter the new quality factor (0-100)"), 50, 0, 100);
  if (newvalue === 50)
    return "Patch Cancelled - New value is same as old";

  //Step 2b - Get the jquality offset = DIBChannels + 60
  if (fpEnb)
    var offset2 = offset + 2;
  else
    var offset2 = offset + 3;

  if ((pe.fetchUByte(offset + 1) & 0x80) !== 0)//Whether the stack offset is 4 byte or 1 byte
    offset2 = pe.fetchDWord(offset2) + 60;
  else
    offset2 = pe.fetchByte(offset2) + 60;

  //Step 2c - Prep code to change DIBChannels member assignment to jquality member assignment.
  //          By default DIBChannels is 3 and DIBColor is 2 already, so overwriting their assignments doesnt matter
  if (offset2 < -128 || offset2 > 127)
  { //offset2 is 4 byte
    if (fpEnb)
      code = " C7 85" + offset2.packToHex(4) + newvalue.packToHex(4); //MOV DWORD PTR SS:[EBP+offset2], newvalue ;offset2 is negative
    else
      code = " C7 84 24" + offset2.packToHex(4) + newvalue.packToHex(4); //MOV DWORD PTR SS:[ESP+offset2], newvalue
  }
  else
  { //offset2 is 1 byte
    if (fpEnb)
      code = " C7 45" + offset2.packToHex(1) + newvalue.packToHex(4); //MOV DWORD PTR SS:[EBP+offset2], newvalue ;offset2 is negative
    else
      code = " C7 44 24" + offset2.packToHex(1) + newvalue.packToHex(4); //MOV DWORD PTR SS:[ESP+offset2], newvalue
  }

  //Step 3a - Add NOPs to fill any excess/less bytes remaining
  if (code.hexlength() < csize)
    code += " 90".repeat(csize - code.hexlength());
  else if (code.hexlength() > csize)
    code += " 90".repeat(csize * 2 - code.hexlength());

  //Step 3b - Now write into client.
  pe.replaceHex(offset, code);

  return true;
}
