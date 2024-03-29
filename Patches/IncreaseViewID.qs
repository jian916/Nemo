//#############################################################
//# Purpose: Change the Limit used for allocating and loading #
//           Headgear Prefix table.
//#############################################################

function IncreaseViewID()
{

  //Step 1a - Find "ReqAccName" offset
  var offset = pe.stringVa("ReqAccName");
  if (offset === -1)
    return "Failed in Step 1 - Can't find ReqAccName";

  //Step 1b - Find where it is PUSHed - only 1 match would occur
  offset = pe.findCode(" 68" + offset.packToHex(4));
  if (offset === -1)
    return "Failed in Step 1 - Can't find Function reference";

  //Step 1c - Get the current limit in the client - may need update in future
  if (exe.getClientDate() > 20200325)//increased for newer clients.
    var oldValue = 3000;
  else if (exe.getClientDate() > 20130000)//increased for newer clients.
    var oldValue = 2000;
  else
    var oldValue = 1000;

  //Step 2a - Get the new limit from user
  var newValue = exe.getUserInput("$newValue", XTYPE_DWORD, _("Number input"), _("Enter the new Max Headgear View ID"), oldValue, oldValue, 32000);//32000 could prove fatal.
  if (newValue === oldValue)
    return "Patch Cancelled - New value is same as old";

  //Step 2b - Find all occurrences of the old limit with the user specified value
  var offsets = pe.findAll(oldValue.packToHex(4), offset - 0xA0, offset + 0x50);

  if (offsets.length === 0)
    return "Failed in Step 2 - No match found";

  if (offsets.length > 3)
    return "Failed in Step 2 - Extra matches found";

  //Step 2c - Replace old with new for all
  for (var i = 0; i < offsets.length; i++)
  {
    pe.replaceDWord(offsets[i], newValue);
  }

  return true;
}

//=============================//
// Disable Unsupported Clients //
//=============================//
function IncreaseViewID_()
{
  return(pe.stringRaw("ReqAccName") !== -1);
}
