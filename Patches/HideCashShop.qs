//###################################################################################
//# Purpose: Make client skip over the Cash Shop Icon UIWindow creation (ID = 0xBE) #
//###################################################################################

function HideCashShop()
{
  //Step 1b - Find the UIWindow creation for Cash Shop - 0xBE
  var code =
    " 68 BE 00 00 00"  //PUSH 0BE
  + getEcxWindowMgrHex() //MOV ECX, OFFSET g_windowMgr
  + " E8"              //CALL UIWindowMgr::MakeWindow
  ;

  var offset = pe.findCode(code);
  if (offset === -1)
    return "Patch Cancelled - Cash Shop already hidden";

  //Step 2 - If found then clean eax and JMP over it
  pe.replaceHex(offset, "31 C0 EB 0B"); //xor eax,eax  jmp 0B
  return true;
}

//======================================================//
// Disable for Unsupported Clients - Check for Icon bmp //
//======================================================//
function HideCashShop_()
{
  return (pe.stringRaw("NC_CashShop") !== -1);
}
