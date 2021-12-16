//#############################################################
//# Purpose: Change the pf argument to CTexMgr::CreateTexture #
//#          to increase the color depth used to 32 bit       #
//#############################################################

function IncreaseMapQuality()
{
  //Step 1a - Find the CreateTexture call
  var code =
    " 51"             //PUSH ECX ; imgData
  + " 68 00 01 00 00" //PUSH 100 ; h = 256
  + " 68 00 01 00 00" //PUSH 100 ; w = 256
  + " B9 ?? ?? ?? 00" //MOV ECX, OFFSET g_texMgr
  + " E8 ?? ?? ?? FF" //CALL CTexMgr::CreateTexture
  ;

  var offset = pe.findCode(code);

  if (offset === -1)
  {
    code = code.replace(" 51", " 50");//PUSH EAX ; imgData
    offset = pe.findCode(code);
  }

  if (offset === -1)
  {
    code = code.replace(" 00 B9 ?? ?? ?? 00 E8", " 00 E8"); // Remove MOV ECX
    offset = pe.findCode(code);
    var ecxRemove = true;
  }

  if (offset === -1)
    return "Failed in Step 1 - CreateTexture call missing";

  //Step 1b - Find the pf argument push before it.
  if (pe.fetchByte(offset - 1) === 0x01)
  { //PUSH 1 is right before PUSH E*X
    offset--;
  }
  else
  {
    if (ecxRemove)
    {
      offset = pe.find("6A 01 ", offset - 15, offset); // PUSH 1
    }
    else
    {
      offset = pe.find("6A 01 ", offset - 10, offset); // PUSH 1
    }

    if (offset === -1)
      return "Failed in Step 1 - pf push missing";

    offset++;
  }

  //Step 2 - Change PUSH 1 to PUSH 4
  pe.replaceByte(offset, 4);

  return true;
}
