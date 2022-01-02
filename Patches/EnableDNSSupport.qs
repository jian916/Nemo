//#############################################################################
//# Purpose: Make the client call our DNS resolution function before          #
//#          g_accountAddr is accessed. Function replaces g_accountAddr value #
//#############################################################################

function EnableDNSSupport()
{
  //Step 1a - Find the common IP address across all clients
    var offset = pe.stringVa("211.172.247.115");
    if (offset === -1)
        return "Failed in Step 1 - IP not found";

    //Step 1b - Find the g_accountAddr assignment to the IP
    var code = "C7 05 ?? ?? ?? 00" + offset.packToHex(4); //MOV DWORD PTR DS:[g_accountAddr], OFFSET addr; ASCII '211.172.247.115'

    offset = pe.findCode(code);
    if (offset === -1)
        return "Failed in Step 1 - g_accountAddr assignment missing";

    //Step 1c - Extract g_accountAddr
    var gAccountAddr = pe.fetchHex(offset + 2, 4);

    //Step 2a - Find the code to hook our function to
    code =
        " E8 ?? ?? ?? FF"    //CALL g_resMgr
      + " 8B C8"             //MOV ECX,EAX
      + " E8 ?? ?? ?? FF"    //CALL CResMgr::Get
      + " 50"                //PUSH EAX
      + getEcxWindowMgrHex() //MOV ECX,OFFSET g_windowMgr
      + " E8 ?? ?? ?? FF"    //CALL UIWindowMgr::SetWallpaper
      + " A1" + gAccountAddr //MOV EAX,DWORD PTR DS:[g_accountAddr]
    ;
    offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            " E8 ?? ?? ?? FF"    //CALL g_resMgr
          + " 8B C8"             //MOV ECX,EAX
          + " E8 ?? ?? ?? FF"    //CALL CResMgr::Get
          + " 50"                //PUSH EAX
          + getEcxWindowMgrHex() //MOV ECX,OFFSET g_windowMgr
          + " E8 ?? ?? ?? FF"    //CALL UIWindowMgr::SetWallpaper
          + " 8B ??" + gAccountAddr //MOV reg32_B,DWORD PTR DS:[g_accountAddr]
        ;
        offset = pe.findCode(code);
    }

    if (offset === -1)
    { // 2018-03-xx ragexe +
        code =
            " E8 ?? ?? ?? FF"    //CALL g_resMgr
          + " 8B C8"             //MOV ECX,EAX
          + " E8 ?? ?? ?? FF"    //CALL CResMgr::Get
          + " 50"                //PUSH EAX
          + getEcxWindowMgrHex() //MOV ECX,OFFSET g_windowMgr
          + " E8 ?? ?? ?? FF"    //CALL UIWindowMgr::SetWallpaper
          + " 8B 0D ?? ?? ?? ??" //mov ecx, g_CCheatDefenderMgr
          + " E8 ?? ?? ?? FF"    //CALL CCheatDefenderMgr::init
          + " 8B ??" + gAccountAddr //MOV reg32_B,DWORD PTR DS:[g_accountAddr]
        ;
        offset = pe.findCode(code);
    }

    if (offset === -1)
    { // 2018-05-30 ragexe +
        code =
            " E8 ?? ?? ?? FF"    //CALL g_resMgr
          + " 8B C8"             //MOV ECX,EAX
          + " E8 ?? ?? ?? FF"    //CALL CResMgr::Get
          + " 50"                //PUSH EAX
          + getEcxWindowMgrHex() //MOV ECX,OFFSET g_windowMgr
          + " E8 ?? ?? ?? FF"    //CALL UIWindowMgr::SetWallpaper
          + " 8B 0D ?? ?? ?? ??" //mov ecx, g_CCheatDefenderMgr
          + " E8 ?? ?? ?? 00"    //CALL CCheatDefenderMgr::init
          + " 8B ??" + gAccountAddr //MOV reg32_B,DWORD PTR DS:[g_accountAddr]
        ;
        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 2";

    //Step 2b - Extract g_resMgr
    var gResMgr = pe.rawToVa(offset+5) + pe.fetchDWord(offset + 1);

    //Step 3a - Construct our function
    var dnscode =
        " E8" + GenVarHex(1)    //CALL g_ResMgr ; call the actual function that was supposed to be run
      + " 60"                   //PUSHAD
      + " 8B 35" + GenVarHex(2) //MOV ESI,DWORD PTR DS:[g_accountAddr]
      + " 56"                   //PUSH ESI
      + " FF 15" + GenVarHex(3) //CALL DWORD PTR DS:[<&WS2_32.#52>] ; WS2_32.gethostbyname()
      + " 8B 48 0C"             //MOV ECX,DWORD PTR DS:[EAX+0C]
      + " 8B 11"                //MOV EDX,DWORD PTR DS:[ECX]
      + " 89 D0"                //MOV EAX,EDX
      + " 0F B6 48 03"          //MOVZX ECX,BYTE PTR DS:[EAX+3]
      + " 51"                   //PUSH ECX
      + " 0F B6 48 02"          //MOVZX ECX,BYTE PTR DS:[EAX+2]
      + " 51"                   //PUSH ECX
      + " 0F B6 48 01"          //MOVZX ECX,BYTE PTR DS:[EAX+1]
      + " 51"                   //PUSH ECX
      + " 0F B6 08"             //MOVZX ECX,BYTE PTR DS:[EAX]
      + " 51"                   //PUSH ECX
      + " 68" + GenVarHex(4)    //PUSH OFFSET addr1 ; ASCII "%d.%d.%d.%d"
      + " 68" + GenVarHex(5)    //PUSH OFFSET addr2 ; location is at the end of the code with Initial value "127.0.0.1"
      + " FF 15" + GenVarHex(6) //CALL DWORD PTR DS:[<&USER32.wsprintfA>]
      + " 83 C4 18"             //ADD ESP,18
      + " C7 05" + GenVarHex(7) + GenVarHex(8) //MOV DWORD PTR DS:[g_accountAddr], addr2 ; Replace g_accountAddr current value with its ip address
      + " 61"                   //POPAD
      + " C3"                   //RETN
      + " 00"                   //Just a gap in between
      + "127.0.0.1".toHex() + " 00".repeat(7) //addr2 ; Putting enough space for 4*3 digits
    ;

    //Step 3b - Calculate free space that the code will need.
    var size = dnscode.hexlength();

    //Step 3c - Allocate space for it
    var free = exe.findZeros(size); // Free space of enable multiple grf + space for dns support
    if (free === -1)
        return "Failed in Step 3 - Not enough free space";

    //Step 4a - Create a call to our function at CALL g_ResMgr
    pe.replaceHex(offset+1, (pe.rawToVa(free) - pe.rawToVa(offset+5)).packToHex(4));

    //Step 4b - Find gethostbyname function address (#52 when imported by ordinal)
    var uGethostbyname = imports.ptrValidated("gethostbyname", "ws2_32.dll", 52);  // By Ordinal

    //Step 4c - Find the IP address format string
    var ipFormat = pe.stringVa("%d.%d.%d.%d");
    if (ipFormat === -1)
        return "Failed in Step 4 - IP string missing";

    //Step 4d - Adjust g_resMgr relative to function
    gResMgr = gResMgr - pe.rawToVa(free + 5);

    //Step 4e - addr2 value
    offset = pe.rawToVa(free + size - (3*1 + 4*3 + 1));//3 Dots, 4 3digits, NULL

    //Step 4g - Replace all the variables
    dnscode = ReplaceVarHex(dnscode, 1, gResMgr);
    dnscode = ReplaceVarHex(dnscode, 2, gAccountAddr);
    dnscode = ReplaceVarHex(dnscode, 3, uGethostbyname);
    dnscode = ReplaceVarHex(dnscode, 4, ipFormat);
    dnscode = ReplaceVarHex(dnscode, 5, offset);
    dnscode = ReplaceVarHex(dnscode, 6, imports.ptrValidated("wsprintfA", "USER32.dll"));
    dnscode = ReplaceVarHex(dnscode, 7, gAccountAddr);
    dnscode = ReplaceVarHex(dnscode, 8, offset);

    //Step 5 - Insert the code
    exe.insert(free, size, dnscode, PTYPE_HEX);

    return true;
}
