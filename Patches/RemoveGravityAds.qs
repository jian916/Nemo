//###########################################
//# Purpose: Zero out all Gravity Ad Images #
//###########################################

function RemoveGravityAds()
{

  //Step 1a - Find address of 1st Pic -> \T_중력성인.tga
  var offset = pe.halfStringRaw("\\T_\xC1\xDF\xB7\xC2\xBC\xBA\xC0\xCE.tga");
  if (offset !== -1)
  {
    //Step 1b - Replace with NULL
    pe.replaceByte(offset + 1, 0);
  }
  else if (!IsZero())
  {
    return "Failed in Step 1";
  }

  //Step 2a - Find address of 2nd Pic
  offset = pe.halfStringRaw("\\T_GameGrade.tga");
  if (offset === -1)
    return "Failed in Step 2";

  //Step 2b - Replace with NULL
  pe.replaceByte(offset + 1, 0);

  //Step 3a - Find address of Last Pic -> \T_테입%d.tga
  offset = pe.halfStringRaw("\\T_\xC5\xD7\xC0\xD4%d.tga");
  if (offset === -1)
    return "Failed in Step 3";

  //Step 3b - Replace with NULL
  pe.replaceByte(offset + 1, 0);

  return true;
}
