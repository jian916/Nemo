//##########################################################################
//# Purpose: Change the JNE after LangType comparison when loading Palette #
//#          prefixes into Palette Table in CSession::InitJobTable         #
//##########################################################################

function UseOfficialClothPalette()
{

  //Step 1a - Check if Custom Job patch is being used. Does not work with it
  if (getActivePatches().indexOf(202) !== -1)
    return "Patch Cancelled - Turn off Custom Job patch first";

  //Step 1b - Find offset of palette prefix for Knight - 크루
  var offset = pe.stringVa("\xC5\xA9\xB7\xE7");  // Same value is used for job path as well as imf
  if (offset === -1)
    return "Failed in Step 1 - Palette prefix missing";

  //Step 2a - Find its references
  var offsets = pe.findCodes(" C7 ?? 38" + offset.packToHex(4));

  //Step 2b - Find the JNE before one of the references - only 1 will have it for sure
  var offset2 = -1;

  for (var i = 0; i < offsets.length; i++)
  {
    offset2 = pe.find(" 0F 85 ?? ?? 00 00", offsets[i] - 0x20, offsets[i]);
    if (offset2 !== -1)
      break;
  }

  //Step 2c - If no match came up then its probably a 2010 client which used function calls to get the mem location
  if (offset2 === -1)
  {
    offsets = pe.findCodes(" C7 00" + offset.packToHex(4) + " E8");

    //Step 2d - Repeat Step 2b for these offsets
    for (var i = 0; i < offsets.length; i++)
    {
      offset2 = pe.find(" 0F 85 ?? ?? 00 00", offsets[i] - 0x20, offsets[i]);
      if (offset2 !== -1)
        break;
    }
  }

  if (offset2 === -1)
    return "Failed in Step 2 - Prefix reference missing";

  //Step 2e - NOP out the JNE
  pe.replaceHex(offset2, " 90 90 90 90 90 90");

  return true;
}
