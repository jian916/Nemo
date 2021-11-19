//############################################################
//# Purpose: Get Addresses of strings, functions & lua_state #
//#          used in Lua Function Calls                      #
//############################################################

delete D2S;
delete D2D;
delete EspAlloc;
delete StrAlloc;
delete AllocType;
delete LuaState;
delete LuaFnCaller;

function _GetLuaAddrs()
{
  //Step 1a - d>s
  var offset = pe.stringVa("d>s");
  if (offset === -1)
    return "LUA: d>s not found";

  D2S = offset.packToHex(4);

  //Step 1b - d>d
  offset = pe.stringVa("d>d");
  if (offset === -1)
    return "LUA: d>d not found";

  D2D = offset.packToHex(4);

  //Step 2a - Find offset of ReqJobName
  offset = pe.stringVa("ReqJobName");
  if (offset === -1)
    return "LUA: ReqJobName not found";

  //Step 2b - Find its reference
  offset = pe.findCode("68" + offset.packToHex(4));
  if (offset === -1)
    return "LUA: ReqJobName reference missing";

  //Step 2c - Find the ESP allocation before the reference and Extract the subtracted value
  var code =
    " 83 EC ??" //SUB ESP, const
  + " 8B CC"    //MOV ECX, ESP
  ;
  var offset2 = pe.find(code, offset - 0x28, offset);
  if (offset2 === -1)
    return "LUA: ESP allocation missing";

  EspAlloc = pe.fetchByte(offset2 + 2);

  //Step 2d - Extract String Allocator Function Address based on which opcode follows the PUSH
  switch (pe.fetchUByte(offset + 5))
  {
    case 0xFF: {//CALL DWORD PTR DS:[func] -> VC9 Clients
      offset += 11;
      StrAlloc = exe.fetchHex(offset - 4, 4);
      AllocType = 0;//0 means function is an MSVC import
      break;
    }
    case 0xE8: {//CALL func -> Older Clients
      offset += 10;
      StrAlloc = pe.rawToVa(offset) + pe.fetchDWord(offset - 4);
      AllocType = 1;//1 means there is an argument PUSH which is a pointer.
      break;
    }
    case 0xC6: {//MOV BYTE PTR DS:[ECX], 0 -> VC10+ Clients
      offset += 13;
      StrAlloc = pe.rawToVa(offset) + pe.fetchDWord(offset - 4);
      AllocType = 2;//2 means there needs to be an assignment of 0F and 0 to ECX+14 and ESP+10
      break;
    }
    default: {
      return "LUA: Unexpected Opcode after ReqJobName";
    }
  }

  //Step 2e - Find Lua_state assignment after offset and extract it
  code = "8B ?? ?? ?? ?? 00"; //MOV reg32_A, DWORD PTR DS:[lua_state]
  offset2 = pe.find(code, offset, offset + 0x10); //VC9 - VC10

  if (offset2 === -1)
  {
    code = "FF 35 ?? ?? ?? 00"; //PUSH DWORD PTR DS:[lua_state]
    offset2 = pe.find(code, offset, offset + 0x10);//VC11
  }

  if (offset2 === -1)
  {
    code = "A1 ?? ?? ?? 00"; //MOV EAX, DWORD PTR DS:[lua_state]
    offset2 = pe.find(code, offset, offset + 0x10);//Older Clients
  }

  if (offset2 === -1)
    return "LUA: Lua_state assignment missing";

  offset2 += code.hexlength();

  LuaState = exe.fetchHex(offset2 - 4, 4);

  //Step 2f - Find the Lua Function caller after offset2
  offset = pe.find(" E8 ?? ?? ?? FF", offset2, offset2 + 0x10);
  if (offset === -1)
    return "LUA: Lua Function caller missing";

  LuaFnCaller = pe.rawToVa(offset + 5) + pe.fetchDWord(offset + 1);

  return true;
}

//###############################################
//# Purpose: Generate code to call Lua Function #
//###############################################

function GenLuaCaller(addr, name, nameAddr, format, inReg)
{
  //Step 1a - Get the Global Addresses if not already obtained
  if (typeof(LuaFnCaller) === "undefined")
  {
    var result = _GetLuaAddrs();
    if (typeof(result) === "string")
      return result;
  }

  //Step 1b - Get Offset of the format specified - can be either d>s or d>d
  if (format === "d>s")
    var fmtAddr = D2S;
  else
    var fmtAddr = D2D;

  //Step 1c - Change nameAddr to PTYPE_HEX format
  if (typeof(nameAddr) === "number")
    nameAddr = nameAddr.packToHex(4);

  //===========================//
  // Now to construct the code //
  //===========================//
  //Step 2a - First we construct a template
  var code =
    " PrePush"
  + " 6A 00"                         //PUSH 0
  + " 54"                            //PUSH ESP
  + inReg                            //PUSH reg32_A
  + " 68" + fmtAddr                  //PUSH fmtAddr; ASCII format
  + " 83 EC" + EspAlloc.packToHex(1) //SUB ESP, const
  + " 8B CC"                         //MOV ECX, ESP
  + " StrAllocPrep"
  + " 68" + nameAddr                 //PUSH nameAddr; ASCII name
  + " FF 15" + StrAlloc              //CALL DWORD PTR DS:[StrAlloc]
  + " FF 35" + LuaState              //PUSH DWORD PTR DS:[LuaState]
  + " E8" + GenVarHex(1)             //CALL LuaFnCaller
  ;

  //Step 2b - Fill PrePush ( Older clients )
  if (AllocType === 1)
  {
    code = code.replace(" PrePush", " 6A" + name.length.packToHex(1)); //PUSH length
  }
  else
  {
    code = code.replace(" PrePush", "");
  }

  //Step 2c - Fill StrAllocPrep (Older & VC10+ Clients )
  if (AllocType === 1)
  {
    code = code.replace(" StrAllocPrep",
      " 8D 44 24" + (EspAlloc + 16).packToHex(1) //LEA EAX, [ESP + const2]; const2 = const + 0x18
    + " 50"                                      //PUSH EAX
    );
  }
  else if (AllocType === 2)
  {
    code = code.replace(" StrAllocPrep",
      " C7 41 14 0F 00 00 00" //MOV DWORD PTR DS:[ECX+14], 0F
    + " C7 41 10 00 00 00 00" //MOV DWORD PTR DS:[ECX+10], 0
    + " C6 01 00"             //MOV BYTE PTR DS:[ECX], 0
    + " 6A" + name.length.packToHex(1) //PUSH length
    );
  }
  else
  {
    code = code.replace(" StrAllocPrep", "");
  }

  //Step 2d - Change the Indirect StrAlloc CALL to direct ( Non VC9 Clients )
  if (AllocType !== 0)
    code = code.replace(" FF 15" + StrAlloc, " E8" + (StrAlloc - pe.rawToVa(addr + code.hexlength() - 12)).packToHex(4));  // CALL StrAlloc

  //Step 2e - Fill the Lua Function Caller
  code = ReplaceVarHex(code, 1, LuaFnCaller - pe.rawToVa(addr + code.hexlength()));

  //Step 2f - Now add the Stack restore and Function output retrieval
  code +=
    " 83 C4" + (EspAlloc + 16).packToHex(1) //ADD ESP, const3; const3 = const + 16
  + " 58"                                   //POP EAX
  ;

  if (AllocType === 1)
  { //For Older clients
    code += " 83 C4 04"; //ADD ESP, 4
  }

  return code;
}

//##########################################
//# Purpose: Inject code to load Lua Files #
//##########################################

function InjectLuaFiles(origFile, nameList, free, loadBefore)
{
    consoleLog("Find original file name string");
    var origOffset = pe.stringVa(origFile);
    if (origOffset === -1)
        return "LUAFL: Filename missing";

    var strHex = origOffset.packToHex(4);

    consoleLog("Find original file name usage");
    var type = table.get(table.CLua_Load_type);
    if (type === 0)
    {
        throw "CLua_Load type not set";
    }

    if (typeof(loadBefore) === "undefined")
        loadBefore = true;

    var mLuaAbsHex = table.getSessionAbsHex4(table.CSession_m_lua_offset);
    var mLuaHex = table.getHex4(table.CSession_m_lua_offset);
    var CLua_Load = table.get(table.CLua_Load);

    if (type == 4)
    {
        var code =
            "8B 8E " + mLuaHex +          // 0 mov ecx, g_session.m_lua
            "6A ?? " +                    // 6 push 0
            "6A ?? " +                    // 8 push 1
            "68 " + strHex +              // 10 push offset aLuaFilesQues_3
            "E8 ";                        // 15 call CLua_Load
        var moveOffset = [0, 6];
        var pushFlagsOffset = [6, 4];
        var strPushOffset = 10;
        var postOffset = 20;
        var otherOffset = 0;
        var callOffset = [16, 4];
        var hookLoader = pe.find(code);
        if (hookLoader === -1)
        {
            code =
                "8B 0D " + mLuaAbsHex +       // 0 mov ecx, g_session.m_lua
                "6A ?? " +                    // 6 push 0
                "6A ?? " +                    // 8 push 1
                "68 " + strHex +              // 10 push offset aLuaFilesQues_3
                "E8 ";                        // 15 call CLua_Load
            moveOffset = [0, 6];
            pushFlagsOffset = [6, 4];
            strPushOffset = 10;
            postOffset = 20;
            otherOffset = 0;
            callOffset = [16, 4];
            hookLoader = pe.find(code);
        }
        if (hookLoader === -1)
        {
            var code =
                "8B 8E " + mLuaHex +          // 0 mov ecx, [esi+5434h]
                "53 " +                       // 6 push ebx
                "6A ?? " +                    // 7 push 1
                "68 " + strHex +              // 9 push offset aLuaFilesData_0
                "E8 ";                        // 14 call CLua_Load
            moveOffset = [0, 6];
            pushFlagsOffset = [6, 3];
            strPushOffset = 9;
            postOffset = 19;
            otherOffset = 0;
            callOffset = [15, 4];
            hookLoader = pe.find(code);
        }
    }
    else if (type == 3)
    {
        var code =
            "8B 8E " + mLuaHex +          // 0 mov ecx, g_session.m_lua
            "6A ?? " +                    // 6 push 1
            "68 " + strHex +              // 8 push offset aLuaFilesQues_3
            "E8 ";                        // 13 call CLua_Load
        var moveOffset = [0, 6];
        var pushFlagsOffset = [6, 2];
        var strPushOffset = 8;
        var postOffset = 18;
        var otherOffset = 0;
        var callOffset = [14, 4];
        var hookLoader = pe.find(code);
        if (hookLoader === -1)
        {
            code =
                "8B 0D " + mLuaAbsHex +       // 0 mov ecx, g_session.m_lua
                "6A ?? " +                    // 6 push 1
                "68 " + strHex +              // 8 push offset aLuaFilesQues_3
                "E8 ";                        // 13 call CLua_Load
            moveOffset = [0, 6];
            pushFlagsOffset = [6, 2];
            strPushOffset = 8;
            postOffset = 18;
            otherOffset = 0;
            callOffset = [14, 4];
            hookLoader = pe.find(code);
        }
    }
    else if (type == 2)
    {
        var code =
            "8B 8E " + mLuaHex +          // 0 mov ecx, g_session.m_lua
            "68 " + strHex +              // 6 push offset aLuaFilesQues_3
            "E8 ";                        // 11 call CLua_Load
        var moveOffset = [0, 6];
        var pushFlagsOffset = 0;
        var strPushOffset = 6;
        var postOffset = 16;
        var otherOffset = 0;
        var callOffset = [12, 4];
        var hookLoader = pe.find(code);
        if (hookLoader === -1)
        {
            code =
                "8B 0D " + mLuaAbsHex +       // 0 mov ecx, g_session.m_lua
                "68 " + strHex +              // 6 push offset aLuaFilesQues_3
                "E8 ";                        // 11 call CLua_Load
            moveOffset = [0, 6];
            pushFlagsOffset = 0;
            strPushOffset = 6;
            postOffset = 16;
            otherOffset = 0;
            callOffset = [12, 4];
            hookLoader = pe.find(code);
        }
        if (hookLoader === -1)
        {
            code =
                "8B 8E " + mLuaHex +          // 0 mov ecx, [esi+44D8h]
                "83 C4 ?? " +                 // 6 add esp, 4
                "68 " + strHex +              // 9 push offset aLuaFilesDatain
                "E8 ";                        // 14 call CLua_Load
            moveOffset = [0, 6];
            pushFlagsOffset = 0;
            strPushOffset = 9;
            postOffset = 19;
            otherOffset = [6, 3];
            callOffset = [15, 4];
            hookLoader = pe.find(code);
        }
    }
    else
    {
        throw "Unsupported CLua_Load type";
    }

    if (hookLoader === -1)
        return "LUAFL: CLua_Load call missing";

    var retLoader = hookLoader + postOffset;

    var callValue = exe.fetchRelativeValue(hookLoader, callOffset);
    if (callValue !== CLua_Load)
        throw "LUAFL: found wrong call function";

    consoleLog("Read stolen code");
    var allStolenCode = exe.fetchHex(hookLoader, strPushOffset);
    var movStolenCode = exe.fetchHexBytes(hookLoader, moveOffset)
    if (pushFlagsOffset !== 0)
    {
        var pushFlagsStolenCode = exe.fetchHexBytes(hookLoader, pushFlagsOffset);
    }
    else
    {
        var pushFlagsStolenCode = "";
    }
    var shortStolenCode = movStolenCode + pushFlagsStolenCode;
    if (otherOffset !== 0)
    {
        var otherStoleCode = exe.fetchHexBytes(hookLoader, otherOffset);
    }
    else
    {
        var otherStoleCode = "";
    }

    consoleLog("Construct asm code with strings");
    var stringsCode = "";
    for (var i = 0; i < nameList.length; i++)
    {
        stringsCode = asm.combine(
            stringsCode,
            "var" + i + ":",
            asm.stringToAsm(nameList[i] + "\x00")
        )
    }

    consoleLog("Create own code");

    if (loadBefore === false)
    {
        var asmCode = asm.combine(
            asm.hexToAsm(allStolenCode),
            "push offset",
            "call CLua_Load"
        )
        var vars = {
            "offset": origOffset,
            "CLua_Load": CLua_Load
        };
    }
    else
    {
        var asmCode = "";
    }
    for (var i = 0; i < nameList.length; i++)
    {
        var asmCode = asm.combine(
            asmCode,
            asm.hexToAsm(shortStolenCode),
            "push var" + i,
            "call CLua_Load"
        )
        var vars = {
            "CLua_Load": CLua_Load
        };
    }

    if (loadBefore === true)
    {
        var text = asm.combine(
            asmCode,
            asm.hexToAsm(allStolenCode),
            "push offset",
            "call CLua_Load",
            "jmp continueAddr",
            asm.hexToAsm("00"),
            stringsCode
        )
    }
    else
    {
        var text = asm.combine(
            asmCode,
            "jmp continueAddr",
            asm.hexToAsm("00"),
            stringsCode
        )
    }
    var vars = {
        "offset": origOffset,
        "CLua_Load": CLua_Load,
        "continueAddr": pe.rawToVa(retLoader)
    };

    consoleLog("Set own code into exe");
    if (typeof(free) === "undefined" || free === -1)
    {
        var obj = exe.insertAsmTextObj(text, vars);
        var free = obj.free;
    }
    else
    {
        exe.replaceAsmText(free, text, vars);
    }

    consoleLog("Set jmp to own code");
    exe.setJmpRaw(hookLoader, free, "jmp", 6);

    return true;
}
