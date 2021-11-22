//######################################################################
//# Purpose: Generate Curiosity's Map Effect Plugin for loaded client  #
//#          using the template DLL (rdll2.asi) along with header file #
//######################################################################

function GenMapEffectPlugin()
{
    consoleLog("Open the Template file (making sure it exists before anything else)");
    var fp = new BinFile();
    if (!fp.open(APP_PATH + "/Input/rdll2.asi"))
        throw "Error: Base File - rdll2.asi is missing from Input folder";

    consoleLog("Find offset of xmas_fild01.rsw");
    var offset = pe.stringVa("xmas_fild01.rsw");
    if (offset === -1)
        throw "Error: xmas_fild01 missing";

    consoleLog("Find the CGameMode_Initialize_EntryPtr using the offset");
    offset = pe.findCode(offset.packToHex(4) + " 8A");
    if (offset === -1)
        throw "Error: xmas_fild01 reference missing";

    consoleLog("Save the EntryPtr address.");
    var CI_Entry = offset - 1;

    consoleLog("Look for g_Weather assignment before EntryPtr");
    var code =
        " B9 ?? ?? ?? 00" //MOV ECX, g_Weather
      + " E8"             //CALL CWeather::ScriptProcess
      ;
    var gWeatherOffset = [1, 4];
    var scriptProcessOffset = 6;

    offset = pe.find(code, CI_Entry - 0x10, CI_Entry);
    if (offset === -1)
    {
        var code =
            " B9 ?? ?? ?? 01" //MOV ECX, g_Weather
          + " E8"             //CALL CWeather::ScriptProcess
          ;
        gWeatherOffset = [1, 4];
        scriptProcessOffset = 6;
        offset = pe.find(code, CI_Entry - 0x10, CI_Entry);
    }
    if (offset === -1)
        throw "Error: g_Weather assignment missing";

    logVaVar("g_Weather", offset, gWeatherOffset);
    logRawFunc("CWeather_ScriptProcess", offset, scriptProcessOffset);

    consoleLog("Save the g_Weather address");
    var gWeather = exe.fetchHex(offset+1, 4);

    consoleLog("Look for the ending pattern after CI_Entry to get CGameMode_Initialize_RetPtr");
    code =
        " 74 0A"         //JE SHORT addr -> after the call. this address is RetPtr
      + " B9" + gWeather //MOV ECX, g_Weather
      + " E8"            //CALL CWeather::LaunchPokJuk
      ;
    var launchPokJukOffset = 8;

    offset = pe.find(code, CI_Entry + 1);
    if (offset === -1)
        throw "Error: CI_Return missing";
    logRawFunc("CWeather::LaunchPokJuk", offset, launchPokJukOffset);

    consoleLog("Save RetPtr.");
    var CI_Return = offset + code.hexlength() + 4;

    consoleLog("Save CWeather::LaunchPokJuk address (not RAW)");
    var CW_LPokJuk = (pe.rawToVa(CI_Return) + pe.fetchDWord(CI_Return-4)).packToHex(4);

    consoleLog("Find offset of yuno.rsw");
    var offset2 = pe.stringVa("yuno.rsw");
    if (offset2 === -1)
        throw "Error: yuno.rsw missing";

    consoleLog("Find its reference between CI_Entry & CI_Return");
    offset = pe.find(offset2.packToHex(4) + " 8A", CI_Entry + 1, CI_Return);
    if (offset === -1)
        throw "Error: yuno.rsw reference missing";

    consoleLog("Find the JZ below it which leads to calling LaunchCloud");
    offset = pe.find("0F 84 ?? ?? 00 00", offset + 5);
    if (offset === -1)
        throw "Error: LaunchCloud JZ missing";

    offset += pe.fetchDWord(offset+2) + 6;

    consoleLog("Go Inside and extract g_useEffect");
    var opcode = pe.fetchByte(offset) & 0xFF;//and mask to fix up Sign issues
    if (opcode === 0xA1)
    {
        var gUseEffect = exe.fetchHex(offset+1, 4);
        logFieldAbs("CSession::m_isEffectOn", offset, [1, 4]);
    }
    else
    {
        var gUseEffect = exe.fetchHex(offset+2, 4);
        logFieldAbs("CSession::m_isEffectOn", offset, [2, 4]);
    }

    consoleLog("Now look for LaunchCloud call after it");
    code =
        " B9" + gWeather //MOV ECX, g_Weather
      + " E8"            //CALL CWeather::LaunchCloud
      ;
    var launchCloudOffset = 6;

    offset = pe.find(code, offset);
    if (offset === -1)
        throw "Error: LaunchCloud call missing";

    logRawFunc("CWeather::LaunchCloud", offset, launchCloudOffset);

    offset += code.hexlength();

    consoleLog("Save CWeather::LaunchCloud address (not RAW)");
    var CW_LCloud = (pe.rawToVa(offset+4) + pe.fetchDWord(offset)).packToHex(4);

    consoleLog("Find the 2nd reference to yuno.rsw - which will be at CGameMode_OnInit_EntryPtr");
    offset = pe.find("B8 " + offset2.packToHex(4), 0, CI_Entry - 1);

    if (offset === -1)
        offset = pe.find("B8 " + offset2.packToHex(4), CI_Return + 1);

    if (offset === -1)
        throw "Error: 2nd yuno.rsw reference missing";

    consoleLog("Save the EntryPtr");
    var CO_Entry = offset;

    consoleLog("Find the closest JZ after CO_Entry. It jumps to a g_renderer assignment");
    offset = pe.find("0F 84 ?? ?? 00 00 ", CO_Entry + 1);
    if (offset === -1)
        throw "Error: JZ after CO_Entry missing";

    offset += pe.fetchDWord(offset+2) + 6 + 1;//1 to skip the first opcode byte

    opcode = pe.fetchByte(offset-1) & 0xFF;//and mask to fix up Sign issues
    if (opcode !== 0xA1)
        offset++;//extra 1 to skip the second opcode byte

    consoleLog("Save g_renderer & the g_renderer->ClearColor offset");
    var gRenderer = exe.fetchHex(offset, 4);
    if (gRenderer != table.getHex4(table.g_renderer))
        throw "Found wrong g_renderer";
    var gR_clrColor = exe.fetchHex(offset+6, 1);

    logVaVar("g_renderer", offset, 0);
    logField("CRenderer::m_nClearColor", offset, [6, 1]);

    consoleLog("Find pattern after offset that JMPs to CGameMode_OnInit_RetPtr");
    code =
        gRenderer                               //MOV reg32_A, DWORD PTR DS:[g_renderer]
      + " C7 ??" + gR_clrColor + " 33 00 33 FF" //MOV DWORD PTR DS:[reg32_A+const], FF330033
      + " EB"                                   //JMP SHORT addr -> jumps to RetPtr
      ;

    offset = pe.find(code, offset + 11);
    if (offset === -1)
        throw "Error: CO_Return missing";

    offset += code.hexlength();
    offset += pe.fetchByte(offset) + 1;

    consoleLog("Check if its really after the last map - new clients have more");
    opcode = pe.fetchByte(offset) & 0xFF;
    if (opcode != 0xA1 && (opcode !== 0x8B || (pe.fetchByte(offset+1) & 0xC7) !== 5))
    {  //not MOV EAX, [addr] or MOV reg32_A, [addr]
        code =
            gRenderer               //MOV reg32_A, g_renderer
          + " C7 ??" + gR_clrColor  //MOV DWORD PTR DS:[reg32_A+const], colorvalue
          ;
        offset = pe.find(code, offset + 1, offset + 0x100);
        if (offset === -1)
            throw "Error: CO_Return missing 2";

        offset += code.hexlength() + 4;
    }

    consoleLog("Save the RetPtr");
    var CO_Return = offset;

    consoleLog("Find CWeather::LaunchNight function. It always has the same code");
    offset = pe.findCode("C6 01 01 C3");  // MOV BYTE PTR DS:[ECX],1 and RETN
    if (offset === -1)
        throw "Error: LaunchNight missing";

    consoleLog("Save CWeather::LaunchNight address (not RAW)");
    var CW_LNight = pe.rawToVa(offset).packToHex(4);

    logRawFuncDirect("CWeather::LaunchNight", offset);

    consoleLog("Find CWeather::LaunchSnow function call. should be after xmas.rsw is PUSHed");
    code =
        " 74 07"          //JZ SHORT addr1 -> Skip LaunchSnow and call StopSnow instead
      + " E8 ?? ?? ?? ??" //CALL CWeather::LaunchSnow
      + " EB 05"          //JMP SHORT addr2 -> Skip StopSnow call
      + " E8"             //CALL CWeather::StopSnow
      ;
    var launchSnowOffset = 3;
    var stopShowOffset = 10;

    offset = pe.find(code, CI_Entry);
    if (offset === -1)
        throw "Error: LaunchSnow call missing";

    logRawFunc("CWeather::LaunchSnow", offset, launchSnowOffset);
    logRawFunc("CWeather::StopSnow", offset, stopShowOffset);

    consoleLog("Save CWeather::LaunchSnow address (not RAW)");
    var CW_LSnow = (pe.rawToVa(offset+7) + pe.fetchDWord(offset+3)).packToHex(4);

    consoleLog("Find the PUSH 14D (followed by MOV) inside CWeather::LaunchMaple");
    offset = pe.findCode("68 4D 01 00 00 89");
    if (offset === -1)
        throw "Error: LaunchMaple missing";

    consoleLog("Find the start of the function");
    code =
        " 83 EC 0C" //SUB ESP, 0C
      + " 56"       //PUSH ESI
      + " 8B F1"    //MOV ESI, ECX
      ;
    offset2 = pe.find("55 8B EC" + code, offset - 0x70, offset);

    if (offset2 === -1)
        offset2 = pe.find(code, offset - 0x60, offset);

    if (offset2 === -1)
        throw "Error: LaunchMaple start missing";

    logRawFuncDirect("CWeather::LaunchMaple", offset2);

    consoleLog("Save CWeather::LaunchMaple address (not RAW)");
    var CW_LMaple = pe.rawToVa(offset2).packToHex(4);

    consoleLog("Find the PUSH A3 (followed by MOV) inside CWeather::LaunchSakura");
    offset = pe.findCode("68 A3 00 00 00 89");
    if (offset === -1)
        throw "Error: LaunchSakura missing";

    consoleLog("Find the start of the function");
    offset2 = pe.find("55 8B EC" + code, offset - 0x70, offset);

    if (offset2 === -1)
        offset2 = pe.find(code, offset - 0x60, offset);

    if (offset2 === -1)
        throw "Error: LaunchSakura start missing";

    logRawFuncDirect("CWeather::LaunchSakura", offset2);

    consoleLog("Save CWeather::LaunchSakura address (not RAW)");
    var CW_LSakura = pe.rawToVa(offset2).packToHex(4);

    consoleLog("Read the input dll file");
    var dll = fp.readHex(0,0x2000);
    fp.close();

    consoleLog("Fill in the values");
    dll = dll.replace(/ C1 C1 C1 C1/i, gWeather);
    dll = dll.replace(/ C2 C2 C2 C2/i, gRenderer);
    dll = dll.replace(/ C3 C3 C3 C3/i, gUseEffect);

    code =
        CW_LCloud
      + CW_LSnow
      + CW_LMaple
      + CW_LSakura
      + CW_LPokJuk
      + CW_LNight
    ;
    dll = dll.replace(/ C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4 C4/i, code);

    dll = dll.replace(/ C5 C5 C5 C5/i, pe.rawToVa(CI_Entry).packToHex(4));
    dll = dll.replace(/ C6 C6 C6 C6/i, pe.rawToVa(CO_Entry).packToHex(4));
    dll = dll.replace(/ C7 C7 C7 C7/i, pe.rawToVa(CI_Return).packToHex(4));
    dll = dll.replace(/ C8 C8 C8 C8/i, pe.rawToVa(CO_Return).packToHex(4));

    dll = dll.replace(/ 6C 5D C3/i, gR_clrColor + " 5D C3");

    consoleLog("Write to output dll file.");
    fp.open(APP_PATH + "/Output/rdll2_" + exe.getClientDate() + ".asi", "w");
    fp.writeHex(0,dll);
    fp.close();

    consoleLog("Also write out the values to header file (client.h)");
    var fp2 = new TextFile();
    fp2.open(APP_PATH + "/Output/client_" + exe.getClientDate() + ".h", "w");
    fp2.writeline("#include <WTypes.h>");
    fp2.writeline("\n// Client Date : " + exe.getClientDate());
    fp2.writeline("\n// Client offsets - some are #define because they were appearing in multiple locations unnecessarily");
    fp2.writeline("#define G_WEATHER 0x" + gWeather.toBE() + ";");
    fp2.writeline("#define G_RENDERER 0x" + gRenderer.toBE() + ";");
    fp2.writeline("#define G_USEEFFECT 0x" + gUseEffect.toBE() + ";");
    fp2.writeline("\nDWORD CWeather_EffectId2LaunchFuncAddr[] = {\n\tNULL, //CEFFECT_NONE");
    fp2.writeline("\t0x" + CW_LCloud.toBE() + ", // CEFFECT_SKY -> void CWeather::LaunchCloud(CWeather this<ecx>, char param)");
    fp2.writeline("\t0x" + CW_LSnow.toBE() + ", // CEFFECT_SNOW -> void CWeather::LaunchSnow(CWeather this<ecx>)");
    fp2.writeline("\t0x" + CW_LMaple.toBE() + ", // CEFFECT_MAPLE -> void CWeather::LaunchMaple(CWeather this<ecx>)");
    fp2.writeline("\t0x" + CW_LSakura.toBE() + ", // CEFFECT_SAKURA -> void CWeather::LaunchSakura(CWeather this<ecx>)");
    fp2.writeline("\t0x" + CW_LPokJuk.toBE() + ", // CEFFECT_POKJUK -> void CWeather::LaunchPokJuk(CWeather this<ecx>)");
    fp2.writeline("\t0x" + CW_LNight.toBE() + ", // CEFFECT_NIGHT -> void CWeather::LaunchNight(CWeather this<ecx>)");
    fp2.writeline("};\n");

    fp2.writeline("#define CGameMode_Initialize_EntryPtr (void*)0x" + pe.rawToVa(CI_Entry ).toBE(4) + ";");
    fp2.writeline("#define CGameMode_OnInit_EntryPtr (void*)0x"     + pe.rawToVa(CO_Entry ).toBE(4) + ";");
    fp2.writeline("void* CGameMode_Initialize_RetPtr = (void*)0x"   + pe.rawToVa(CI_Return).toBE(4) + ";");
    fp2.writeline("void* CGameMode_OnInit_RetPtr = (void*)0x"       + pe.rawToVa(CO_Return).toBE(4) + ";");

    fp2.writeline("\r\n#define GR_CLEAR " + (parseInt(gR_clrColor, 16)/4) + ";");
    fp2.close();

    return "MapEffect plugin for the loaded client has been generated in Output folder";
}
