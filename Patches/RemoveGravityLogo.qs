//########################################
//# Purpose: Zero out Gravity Logo Image #
//########################################

function RemoveGravityLogo()
{

  //Step 1a - Find the image
  var offset = pe.halfStringRaw("\\T_R%d.tga");
  if (offset === -1)
    return "Failed in Step 1";

  //Step 1b - Replace with NULL
  exe.replace(offset + 1, "00", PTYPE_HEX);

  return true;
}