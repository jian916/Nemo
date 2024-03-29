//##########################################################
//# Purpose: Change the Format string used for Matk values #
//#          with the one using tilde symbol               #
//##########################################################

function UseTildeForMatk()
{

  //Step 1a - Find the original format string
  var offset = pe.stringVa("%d + %d");
  if (offset === -1)
    return "Failed in Step 1 - Format string missing";

  //Step 1b - Find all its references - There should be exactly 5 matches
  var offsets = pe.findCodes("68" + offset.packToHex(4));
  if (offsets.length !== 5)
    return "Failed in Step 1 - Not enough matches";

  //Step 2a - Find the replacement format string
  offset = pe.halfStringVa("%d ~ %d");
  if (offset === -1)
  {

    //Step 2b - If not present allocate space for a new one
    offset = exe.findZeros(8);//Size of the above
    if (offset === -1)
      return "Failed in Step 2 - Not enough free space";

    //Step 2c - Insert the string in allocated space
    exe.insert(offset, 8, "%d ~ %d", PTYPE_STRING);

    //Step 2d - Get its RVA
    offset = pe.rawToVa(offset);
  }

  //Step 2e - Replace the PUSHed address for the 2nd match out of the 5
  pe.replaceDWord(offsets[1] + 1, offset);

  return true;
}
