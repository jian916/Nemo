//#####################################################################
//# Purpose: JMP over the original iteminfo loader Function call      #
//#          and instead add the call after char servername is stored #
//#          Also modify the "main" Lua Func call routine inside the  #
//#          loader function to include 1 argument - server name      #
//#####################################################################

function LoadItemInfoPerServer()
{
  //Step 1a - Find the pattern before Server Name is pushed to StringAllocator Function
  var code =
    " C1 ?? 05"                   //SHL EDI,5
  + " 66 83 ?? ?? ?? ?? 00 00 03" //CMP WORD PTR DS:[ESI+EDI+1F4],3
  ;

  var offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 1 - Pattern not found";

  offset += code.hexlength();

  //Step 1b - Find the StringAllocator call after pattern
  code =
    " B9 ?? ?? ?? 00"    //MOV ECX, addr
  + " E8 ?? ?? ?? ??"    //CALL StringAllocator
  + " 8B ?? ?? ?? 00 00" //MOV reg32_A, DWORD PTR DS:[reg32_B + const]
  ;
  var directCall = true;
  var offset2 = pe.find(code, offset, offset + 0x40);

  if (offset2 === -1)
  {
    code = code.replace(" E8", " FF 15");//CALL DWORD PTR DS:[StringAllocator]
    directCall = false;
    offset2 = pe.find(code, offset, offset + 0x40);
  }

  if (offset2 === -1)
    return "Failed in Step 1 - StringAllocator call missing";

  var allocInject = offset2 + 5;

  //Step 2a - Find address of ItemInfo Error string
  offset = pe.stringVa("ItemInfo file Init");
  if (offset === -1)
    return "Failed in Step 2 - ItemInfo String missing";

  //Step 2b - Find its reference
  offset = pe.findCode("68" + offset.packToHex(4));
  if (offset === -1)
    return "Failed in Step 2 - ItemInfo String reference missing";

  //Step 2c - Find the ItemInfo Loader call before it
  code =
    " E8 ?? ?? ?? ??"    //CALL iteminfoPrep
  + " 8B 0D ?? ?? ?? 00" //MOV ECX, DWORD PTR DS:[refAddr]
  + " E8 ?? ?? ?? ??"    //CALL iteminfoLoader
  ;

  offset = pe.find(code, offset - 0x30, offset);
  if (offset === -1)
    return "Failed in Step 2 - ItemInfo Loader missing";

  //Step 2d - Extract the MOV ECX statement
  var refMov = pe.fetchHex(offset + 5, 6);

  //Step 2e - Change the MOV statement to JMP for skipping the loader
  var code2 =
    " 90 90" //NOPs
  + " B0 01" //MOV AL, 1
  + " EB 05" //JMP to after iteminfoLoader call
  ;

  exe.replace(offset + 5, code2, PTYPE_HEX);

  //Step 2f - Extract iteminfoLoader function address
  offset += code.hexlength();
  offset += pe.fetchDWord(offset - 4);
  var iiLoaderFunc = pe.rawToVa(offset);

  //Step 3a - Find offset of "main"
  offset2 = pe.stringVa("main");
  if (offset2 === -1)
    return "Failed in Step 3 - main string missing";

  //Step 3b - Find the "main" push to Lua stack
  code =
    " 68" + offset2.packToHex(4) //PUSH OFFSET addr; ASCII "main"
  + " 68 EE D8 FF FF"           //PUSH -2712
  + " ??"                       //PUSH reg32_A
  + " E8 ?? ?? ?? 00"           //CALL LuaFnNamePusher
  ;
  offset2 = pe.find(code, offset, offset + 0x200);

  if (offset2 === -1)
  {
    code = code.replace(" FF FF ?? E8", "FF FF FF 75 ?? E8");
    offset2 = pe.find(code, offset, offset + 0x200);
  }

  if (offset2 === -1)
    return "Failed in Step 3 - main push missing";

  var mainInject = offset2 + code.hexlength() - 5;

  //Step 3c - Find the arg count PUSHes after it
  offset = pe.find(" 6A 00 6A 02 6A 00", mainInject + 5, mainInject + 0x20);
  if (offset === -1)
    return "Failed in Step 3 - Arg Count Push missing";

  //Step 3d - Change the last PUSH 0 to PUSH 1 (since we have 1 input argument)
  exe.replace(offset + 5, "01", PTYPE_HEX);

  //Step 4a - Find the location where the iteminfo copier is called
  code =
    refMov            //MOV ECX, DWORD PTR DS:[refAddr]
  + " 68 ?? ?? ?? 00" //PUSH OFFSET iiAddr
  + " E8 ?? ?? ?? FF" //CALL iteminfoCopier
  ;

  offset = pe.findCode(code);
  if (offset === -1)
    return "Failed in Step 4 - ItemInfo copy function missing";

  offset += refMov.hexlength();

  //Step 4b - Extract the PUSH statement and Copier Function address
  var iiPush = pe.fetchHex(offset, 5);
  var iiCopierFunc = pe.rawToVa(offset + 10) + pe.fetchDWord(offset + 6);

  //Step 5a - Find the 's' input Push Function call inside the LuaFn Caller
  code =
    " 8B ??"          //MOV reg32_A, DWORD PTR DS:[reg32_B]
  + " 8B ??"          //MOV reg32_C, DWORD PTR DS:[reg32_D]
  + " 83 ?? 04"       //ADD reg32_B, 4
  + " ??"             //PUSH reg32_A
  + " ??"             //PUSH reg32_C
  + " E8 ?? ?? ?? 00" //CALL StringPusher
  + " 83 C4 08"       //ADD ESP, 8
  ;
  offset = pe.findCode(code);

  if (offset === -1)
  {
    code = code.replace(" 8B ?? 8B ??", " FF ??");//PUSH DWORD PTR DS:[reg32_B]
    code = code.replace(" ?? ?? E8", " FF ?? E8");//PUSH DWORD PTR DS:[reg32_D]

    offset = pe.findCode(code);
  }

  if (offset === -1)
    return "Failed in Step 5 - String Pusher missing";

  offset += code.hexlength() - 3;

  //Step 5b - Extract the Function address
  var stringPushFunc = pe.rawToVa(offset) + pe.fetchDWord(offset - 4);

  //Step 6a - Prep code to Push String after "main" push
  code =
    " E8" + GenVarHex(1)    //CALL LuaFnNamePusher
  + " 83 C4 08"             //ADD ESP, 8
  + " FF 35" + GenVarHex(2) //PUSH DWORD PTR DS:[serverAddr]
  + " 83 EC 04"             //SUB ESP, 4
  + " E8" + GenVarHex(3)    //CALL StringPusher
  + " E9" + GenVarHex(4)    //JMP addr -> after original CALL LuaFnNamePusher
  + " 00 00 00 00"          //<-serverAddr
  ;

  //Step 6b - Allocate space for it
  var free = exe.findZeros(code.hexlength());
  if (free === -1)
    return "Failed in Step 6 - Not enough space available";

  var freeRva = pe.rawToVa(free);
  var serverAddr = freeRva + code.hexlength() - 4;

  //Step 6c - Fill in the blanks
  offset = pe.rawToVa(mainInject + 5) + pe.fetchDWord(mainInject + 1) - (freeRva + 5);
  code = ReplaceVarHex(code, 1, offset);
  code = ReplaceVarHex(code, 2, serverAddr);
  code = ReplaceVarHex(code, 3, stringPushFunc - (serverAddr - 5));
  code = ReplaceVarHex(code, 4, pe.rawToVa(mainInject + 5) - serverAddr);

  //Step 6d - Change the LuaFnNamePusher call to a JMP to our code
  offset = freeRva - pe.rawToVa(mainInject + 5);
  exe.replace(mainInject, "E9" + offset.packToHex(4), PTYPE_HEX);

  //Step 6e - Inject to allocated space
  exe.insert(free, code.hexlength(), code, PTYPE_HEX);

  //Step 7a - Prep code for calling the iteminfo loader upon server select
  code =
    " E8" + GenVarHex(1)    //CALL StringAllocator - This function also does stack restore but the servername argument is not wiped off the stack
  + " 8B 44 24 FC"          //MOV EAX, DWORD PTR SS:[ESP-4]
  + " 3B 05" + GenVarHex(2) //CMP EAX, DWORD PTR DS:[serverAddr]; need to improve this - better would be to do strcmp on the string addresses
  + " 74 20"                //JE Skip
  + " A3" + GenVarHex(3)    //MOV DWORD PTR DS:[serverAddr], EAX
  + refMov                  //MOV ECX, DWORD PTR DS:[refAddr]
  + " E8" + GenVarHex(4)    //CALL iiLoaderFunc
  + refMov                  //MOV ECX, DWORD PTR DS:[refAddr] ;You can also add checking before this
  + iiPush                  //PUSH OFFSET iiAddr
  + " E8" + GenVarHex(5)    //CALL iiCopierFunc
  + " E9" + GenVarHex(6)    //JMP to after original function call
  ;

  if (!directCall)
    code = code.replace("E8", "FF 15");

  //Step 7b - Allocate space for it
  free = exe.findZeros(code.hexlength());
  if (free === -1)
    return "Failed in Step 7 - Not enough space available";

  freeRva = pe.rawToVa(free);

  //Step 7c - Fill in the blanks
  if (directCall)
    offset = pe.rawToVa(allocInject + 5) + pe.fetchDWord(allocInject + 1) - (freeRva + 5);
  else
    offset = pe.fetchDWord(allocInject + 2);

  code = ReplaceVarHex(code, 1, offset);
  code = ReplaceVarHex(code, 2, serverAddr);
  code = ReplaceVarHex(code, 3, serverAddr);

  offset = iiLoaderFunc - (freeRva + code.hexlength() - (refMov.hexlength() + iiPush.hexlength() + 10));
  code = ReplaceVarHex(code, 4, offset);

  offset = iiCopierFunc - (freeRva + code.hexlength() - 5);
  code = ReplaceVarHex(code, 5, offset);

  offset = pe.rawToVa(allocInject + 5) - (freeRva + code.hexlength());
  code = ReplaceVarHex(code, 6, offset);

  //Step 7d - Change the function call to a JMP to our custom code
  offset = freeRva - pe.rawToVa(allocInject + 5);
  exe.replace(allocInject, "E9" + offset.packToHex(4), PTYPE_HEX);

  if (!directCall)
    exe.replace(allocInject + 5, "90", PTYPE_HEX);

  //Step 7e - Inject to allocated space
  exe.insert(free, code.hexlength(), code, PTYPE_HEX);

  return true;
}

//=================================//
// Disable for Unsupported clients //
//=================================//
function LoadItemInfoPerServer_()
{
  return (pe.stringRaw("System/iteminfo.lub") !== -1);
}
