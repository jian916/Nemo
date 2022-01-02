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
  pe.replaceByte(offset + 1, 0);

  return true;
}
