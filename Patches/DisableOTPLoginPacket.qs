function DisableOTPLoginPacket()
{
  //Step 1 - Find the code inside UILoginWnd::SendMsg
  var code =
    " 8B 0D AB AB AB AB" //0 mov ecx,[g_modeMgr]
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
  var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
    return "Failed in Step 1";

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
    " 8B 0D AB AB AB AB" //0 mov ecx,[g_modeMgr]
  + " 6A 00"             //6 push 0
  + " 6A 00"             //8 push 0
  + " 6A 00"             //10 push 0
  + " 8B 01"             //12 mov eax,[ecx]
  + " 6A 26"             //14 push 26h
  + " 68 35 27 00 00"    //16 push 2735h
  + " FF 50 18"          //21 call dword ptr [eax+18h]
  ;
  return (exe.findCode(code, PTYPE_HEX, true, "\xAB") !== -1);
}
