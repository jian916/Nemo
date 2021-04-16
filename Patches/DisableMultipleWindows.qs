//#############################################################################
//# Purpose: Check for Existing Multiple Window Checker and enforce Disabling #
//#          If not present, insert custom code to do the check + disable     #
//#############################################################################

function DisableMultipleWindows()
{
    consoleLog("Step 1a - Find Address of ole32.CoInitialize function");
    var funcOffset = GetFunction("CoInitialize", "ole32.dll");
    if (funcOffset === -1)
        return "Failed in Step 1 - CoInitialize not found";

    consoleLog("Step 1b - Find where it is called from.");
    var code =
        " E8 ?? ?? ?? FF" //CALL ResetTimer
      + " ??"             //PUSH reg32
      + " FF 15" + funcOffset.packToHex(4) //CALL DWORD PTR DS:[<&ole32.CoInitialize>]
    ;
    var resetTimerOffset = 1;
    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            " E8 ?? ?? ?? FF" //CALL ResetTimer
          + " 6A 00 "         //PUSH 0
          + " FF 15" + funcOffset.packToHex(4) //CALL DWORD PTR DS:[<&ole32.CoInitialize>]
        ;
        resetTimerOffset = 1;

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            " E8 ?? ?? ?? 00" //CALL ResetTimer
          + " 6A 00 "         //PUSH 0
          + " FF 15" + funcOffset.packToHex(4) //CALL DWORD PTR DS:[<&ole32.CoInitialize>]
        ;
        resetTimerOffset = 1;

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            " 8B 35 ?? ?? ?? ??" //CALL [func]
          + " 6A 00 "            //PUSH 0
          + " FF 15" + funcOffset.packToHex(4) //CALL DWORD PTR DS:[<&ole32.CoInitialize>]
        ;
        resetTimerOffset = 2;

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 1 - CoInitialize call missing";

    logRawFunc("ResetTimer", offset, resetTimerOffset);

    consoleLog("Step 1c - If the MOV EAX statement follows the CoInitialize call then it is the old client where Multiple client check is there,");
    consoleLog("Replace the statement with MOV EAX, 00FFFFFF");
    if (exe.fetchUByte(offset + code.hexlength()) === 0xA1)
    {
        exe.replace(offset + code.hexlength(), " B8 FF FF FF 00");
        return true;
    }

    //=====================================================================================//
    // Now since the MOV was not found we can assume the Multiple Client check is removed. //
    // Hence we will put our own Checker code                                              //
    //=====================================================================================//

    consoleLog("Step 2a - Extract the ResetTimer function address (called before CoInitialize)");
    offset += 5;
    var resetTimer = exe.fetchDWord(offset-4) + exe.Raw2Rva(offset);

    consoleLog("Step 2b - Prepare code for mutex windows");
    code =
        " E8" + GenVarHex(0)          //CALL ResetTimer
      + " 56"                         //PUSH ESI
      + " 33 F6"                      //XOR ESI,ESI
      + " 68" + GenVarHex(1)          //PUSH addr ; "KERNEL32"
      + " FF 15" + GenVarHex(2)       //CALL DWORD PTR DS:[<&KERNEL32.GetModuleHandleA>]
      + " E8 0D 00 00 00"             //PUSH &JMP
      + "CreateMutexA\x00".toHex()    //DB "CreateMutexA", 0
      + " 50"                         //PUSH EAX
      + " FF 15" + GenVarHex(3)       //CALL DWORD PTR DS:[<&KERNEL32.GetProcAddress>]
      + " E8 0F 00 00 00"             //PUSH &JMP
      + "Global\\Surface\x00".toHex() //DB "Global\Surface",0
      + " 56"                         //PUSH ESI
      + " 56"                         //PUSH ESI
      + " FF D0"                      //CALL EAX
      + " 85 C0"                      //TEST EAX,EAX
      + " 74 0F"                      //JE addr1 -> ExitProcess call below
      + " 56"                         //PUSH ESI
      + " 50"                         //PUSH EAX
      + " FF 15" + GenVarHex(4)       //CALL DWORD PTR DS:[<&KERNEL32.WaitForSingleObject>]
      + " 3D 02 01 00 00"             //CMP EAX, 258  ; WAIT_TIMEOUT
      + " 75 26"                      //JNZ addr2 -> POP ESI below
      + " 68" + GenVarHex(5)          //PUSH addr ; "KERNEL32"
      + " FF 15" + GenVarHex(6)       //CALL DWORD PTR DS:[<&KERNEL32.GetModuleHandleA>]
      + " E8 0C 00 00 00"             //PUSH &JMP
      + "ExitProcess\x00".toHex()     //DB "ExitProcess", 0
      + " 50"                         //PUSH EAX
      + " FF 15" + GenVarHex(7)       //CALL DWORD PTR DS:[<&KERNEL32.GetProcAddress>]
      + " 56"                         //PUSH ESI
      + " FF D0"                      //CALL EAX
      + " 5E"                         //POP ESI ; addr2
      + " 68" + GenVarHex(8)          //PUSH AfterStolenCall ; little trick to make calculation easier
      + " C3"                         //RETN
      + "KERNEL32\x00".toHex()        //DB "KERNEL32", 0 ; string to use in GetModuleHandleA
      ;

    var csize = code.hexlength();

    consoleLog("Step 2c - Allocate space to store the code");
    var free = exe.findZeros(csize);
    if (free === -1)
        return "Failed in Step 2 - Not enough free space";

    consoleLog("Step 2d - Replace the resetTimer call with our code");
    exe.replace(offset - 5, "E9" + (exe.Raw2Rva(free) - exe.Raw2Rva(offset)).packToHex(4), PTYPE_HEX);

    consoleLog("Step 2e - Fill in the blanks");
    code = ReplaceVarHex(code, 0, resetTimer - exe.Raw2Rva(free + 5));
    code = ReplaceVarHex(code, 8, exe.Raw2Rva(offset));

    code = ReplaceVarHex(code, 4, GetFunction("WaitForSingleObject", "KERNEL32.dll"));

    offset = exe.Raw2Rva(free + csize - 9);
    code = ReplaceVarHex(code, 1, offset);
    code = ReplaceVarHex(code, 5, offset);

    offset = GetFunction("GetModuleHandleA", "KERNEL32.dll");
    code = ReplaceVarHex(code, 2, offset);
    code = ReplaceVarHex(code, 6, offset);

    offset = GetFunction("GetProcAddress", "KERNEL32.dll");
    code = ReplaceVarHex(code, 3, offset);
    code = ReplaceVarHex(code, 7, offset);

    consoleLog("Step 2f - Insert the code to allocated space");
    exe.insert(free, csize, code, PTYPE_HEX);

    return true;
}
