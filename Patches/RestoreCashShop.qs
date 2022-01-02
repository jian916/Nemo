//#####################################################################
//# Purpose: Restore the Cash Shop Icon UIWindow creation (ID = 0xBE) #
//#####################################################################

function RestoreCashShop()
{
  //Step 1 - Get the Window Manager Info we need
  var movEcx  = getEcxWindowMgrHex();
  var makeWin = table.get(table.UIWindowMgr_MakeWindow);

  //Step 2a - Find the location where the cash shop icon was supposed to be created
  var code =
    " 75 0F"           //JNE addr; skips to location after the call for creating another icon
  + " 68 9F 00 00 00"  //PUSH 09F
  + movEcx             //MOV ECX, OFFSET g_windowMgr
  + " E8"              //CALL UIWindowMgr::MakeWindow
  ;

  var offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 2";

  var offset2 = offset + code.hexlength() + 4;

  if (pe.find("68 BE 00 00 00" + movEcx, offset - 0x30, offset) !== -1)
    return "Patch Cancelled - Icon is already there";

  //Step 3a - Prep insert code (starting portion is same as above hence we dont repeat it)
  code +=
    GenVarHex(1)         //CALL UIWindowMgr::MakeWindow ; E8 opcode is already there
  + " 68 BE 00 00 00"    //PUSH 0BE
  + movEcx               //MOV ECX, OFFSET g_windowMgr
  + " E8" + GenVarHex(2) //CALL UIWindowMgr::MakeWindow
  + " E9" + GenVarHex(3) //JMP offset2; jump back to offset2
  ;

  //Step 3b - Allocate space for it
  var free = exe.findZeros(code.hexlength());
  if (free === -1)
    return "Failed in Step 3 - Not enough free space";

  var refAddr = pe.rawToVa(free + (offset2 - offset));

  //Step 3c - Fill in the blanks.
  code = ReplaceVarHex(code, 1, makeWin - (refAddr));
  code = ReplaceVarHex(code, 2, makeWin - (refAddr + 15)); // (PUSH + MOV + CALL)
  code = ReplaceVarHex(code, 3, pe.rawToVa(offset2) - (refAddr + 20)); // (PUSH + MOV + CALL + JMP)

  //Step 4 - Insert the code and create the JMP to it.
  exe.insert(free, code.hexlength(), code, PTYPE_HEX);
  pe.replaceHex(offset, "E9" + (pe.rawToVa(free) - pe.rawToVa(offset + 5)).packToHex(4));

  return true;
}

//======================================================//
// Disable for Unsupported Clients - Check for Icon bmp //
//======================================================//
function RestoreCashShop_()
{
  return (pe.stringRaw("NC_CashShop") !== -1);
}
