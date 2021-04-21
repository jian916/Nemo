function DisableOTPLoginPacket()
{
  //Step 1 - Find the code inside UILoginWnd::SendMsg
  var code =
    " 8B 0D ?? ?? ?? ??" //0 mov ecx,[g_modeMgr]
  + " 6A 00"             //6 push 0
  + " 6A 00"             //8 push 0
  + " 6A 00"             //10 push 0
  + " 8B 01"             //12 mov eax,[ecx]
  + " 6A 26"             //14 push 26h
  + " 68 35 27 00 00"    //16 push 2735h
  + " FF 50 18"          //21 call dword ptr [eax+18h]
  ;
  var push1 = 15;
  var push2 = 17;
  var CMode_SendMsgOffset = [23, 1]

  var offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1";

  logField("CMode_vtable::SendMsg", offset, CMode_SendMsgOffset)

  //Step 2 - Change parameter, make client send original login packet first
  exe.replace(offset + push1, " 00", PTYPE_HEX); //replace 26h with 0h
  exe.replace(offset + push2, " 10", PTYPE_HEX); //replace 2735h with 2710

  return true;
}

//================================================//
// Disable Patch for Unsupported/Unneeded clients //
//================================================//
function DisableOTPLoginPacket_()
{
  var code =
    " 8B 0D ?? ?? ?? ??" //0 mov ecx,[g_modeMgr]
  + " 6A 00"             //6 push 0
  + " 6A 00"             //8 push 0
  + " 6A 00"             //10 push 0
  + " 8B 01"             //12 mov eax,[ecx]
  + " 6A 26"             //14 push 26h
  + " 68 35 27 00 00"    //16 push 2735h
  + " FF 50 18"          //21 call dword ptr [eax+18h]
  ;
  return (pe.findCode(code) !== -1);
}
