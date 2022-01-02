//##########################################################################
//# Purpose: Change all HKEY_LOCAL_MACHINE parameters to HKEY_CURRENT_USER #
//##########################################################################

function HKLMtoHKCU()
{

  //Step 1 - Find all occurrences of HKEY_LOCAL_MACHINE (0x80000002)
  var offsets = pe.findCodes(" 68 02 00 00 80");

  if (!offsets[0])
    return "Failed in Step 1";

  //Step 2 - Change all to HKEY_CURRENT_USER (0x80000001). If the opcode following the PUSH is a 3B it is a false match so ignore it.
  for (var i = 0; i < offsets.length; i++)
  {
    if (pe.fetchByte(offsets[i] + 5) !== 0x3B)
      pe.replaceByte(offsets[i] + 1, 1);
  }

  return true;
}