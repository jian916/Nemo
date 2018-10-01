//================================================================//
// Patch Functions wrapping over ChangeAutoFollowDelay function   //
//================================================================//



function SetAutoFollowDelay() {
  return ChangeAutoFollowDelay(exe.getUserInput("$followDelay", XTYPE_WORD, "Number Input", "Enter the new autofollow delay(0-1000) - snaps to closest valid value", 200, 0, 1000));
}

//##############################################################################
//# Purpose: Find the autofollow delay and replace it with the value specified #
//##############################################################################

function ChangeAutoFollowDelay(value) {

  //Step 1a - Find the delay comparison
  var code =
    " FF D7"                //CALL EDI                     ;  timeGetTime
  + " 2B 05 AB AB AB AB"    //SUB EAX, DWORD PRT DS:[addr] ;  lastFollowTime
  + " 3D E8 03 00 00"       //CMP EAX, 3E8h                ;  1000ms
  ;
  
  var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
    return "Failed in Step 1 - AutoFollow Delay Code not found.";
  
  //Step 2 - Replace the value
  exe.replace(offset + 9, value.packToHex(4) , PTYPE_HEX);

  return true;
}