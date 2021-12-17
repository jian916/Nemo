//========================================================//
// Patch Functions wrapping over IncreaseZoomOut function //
//========================================================//

function IncreaseZoomOut25Per()
{
    return IncreaseZoomOut("00 00 80 43");  // 256.0
}

function IncreaseZoomOut50Per()
{
    return IncreaseZoomOut("00 00 FF 43");  // 510.0
}

function IncreaseZoomOut75Per()
{
    return IncreaseZoomOut("00 00 4C 44");  // 816.0
}

function IncreaseZoomOutMax()
{
    return IncreaseZoomOut("00 00 99 44");  // 1224.0
}

function IncreaseZoomOutCustom()
{
    var zoomOut = exe.getUserInput("$zoomOut", XTYPE_DWORD, _("Number Input"), _("Enter zoom out level value (256 - 25%, 510 - 50%, 816 - 75%):"), 1224);
    return IncreaseZoomOut(floatToHex(zoomOut));
}

//#########################################################
//# Purpose: Modify the Max Height from Ground (FAR_DIST) #
//#          to accomodate for larger zoom                #
//#########################################################

function IncreaseZoomOut(newvalue)
{
    consoleLog("Step 1 - Find the FAR_DIST location");
    var code =
        " 00 00 66 43" //DD FLOAT 230.000              zoom1 (min zoom level indoor/outdoor)
      + " 00 00 C8 43" //DD FLOAT 400.000 <- FAR_DIST  zoom2 (max outdoor zoom level)
      + " 00 00 96 43" //DD FLOAT 300.000              zoom3 (max indoor zoom level)
    ;

    var offset = pe.find(code); // Its not there in code section - so we use the generic find
    if (offset === -1)
        return "Failed in Step 1";

    consoleLog("Step 2 - Modify with the value supplied - Current value is 400.0");
    pe.replaceHex(offset + 4, newvalue);  // newvalue is actually just the higher 2 bytes of what is required, since lower 2 bytes are 0

    if (pe.stringRaw("/zoom") !== -1)
    {   // found zoom command. need do additional patching
        consoleLog("Step 3 - Patch /zoom enabled/disabled command");
        // get zoom2 addr bytes
        var zoom2 = pe.rawToVa(offset + 4).packToHex(4);

        consoleLog("search and patch also enabled zoom in two places (UIGraphicSettingWnd_virt136 and CGameMode_func)");
        var code1 = " C7 05 " + zoom2 + " 00 00 F0 43"; // mov zoom2, 480.0
        var offsets = pe.findCodes(code1);
        if (offsets.length === 0)
            return "Failed in Step 3. Enabled /zoom usage not found";
        if (offsets.length !== 2 && offsets.length !== 3)
            return "Failed in Step 3. Found wrong number of enabled /zoom usage count.";
        for (var i = 0; i < offsets.length; i++)
        {
            pe.replaceHex(offsets[i] + 6, newvalue);
        }


        consoleLog("search and patch also disabled zoom in two places (UIGraphicSettingWnd_virt136 and CGameMode_func)");
        var code2 = " C7 05 " + zoom2 + " 00 00 C8 43"; // mov zoom2, 480.0
        var offsets = pe.findCodes(code2);
        if (offsets.length === 0)
            return "Failed in Step 3. Disabled /zoom usage not found";
        if (offsets.length !== 2 && offsets.length !== 3)
            return "Failed in Step 3. Found wrong number of disabled /zoom usage count.";
        for (i = 0; i < offsets.length; i++)
        {
            pe.replaceHex(offsets[i] + 6, newvalue);
        }

        consoleLog("Step 4 - Patch /zoom enabled/disabled load configuration (in CSession_lua_configuration)");
        var code =
            "F3 0F 10 0D ?? ?? ?? ??" +  // movss xmm1, zoom_max_load_enabled
            "EB 08" +                    // jmp +8
            "F3 0F 10 0D ?? ?? ?? ??" +  // movss xmm1, zoom_max_load_disabled
            "F3 0F 10 05 ?? ?? ?? ??" +  // movss xmm0, ADDR1
            "F3 0F 10 15 ?? ?? ?? ??" +  // movss xmm2, g_outdoorViewLatitude
            "0F 2F C2" +                 // comiss xmm0, xmm2
            "F3 0F 11 0D " + zoom2;      // movss zoom2_max_outdoor, xmm1
        var enabledOffset = [4, 4];
        var disabledOffset = [14, 4];
        offset = pe.findCode(code);
        if (offset === -1)
        {
            code =
            "F3 0F 10 0D ?? ?? ?? ??" +  // movss xmm1, zoom_max_load_enabled
            code1 +                      // mov zoom2, 480.0
            "EB 12" +                    // jmp +12
            "F3 0F 10 0D ?? ?? ?? ??" +  // movss xmm1, zoom_max_load_disabled
            code2 +                      // mov zoom2, 480.0
            "F3 0F 10 05 ?? ?? ?? ??" +  // movss xmm0, ADDR1
            "F3 0F 10 15 ?? ?? ?? ??" +  // movss xmm2, g_outdoorViewLatitude
            "0F 2F C2";                  // comiss xmm0, xmm2
            enabledOffset = [4, 4];
            disabledOffset = [24, 4];
            offset = pe.findCode(code);
        }
        if (offset === -1)
            return "Failed in Step 4";

        consoleLog("patch enabled and disabled /zoom configuration limit");
        var valueAddr = pe.rawToVa(exe.insertHex(newvalue));
        pe.setValue(offset, enabledOffset, valueAddr);
        pe.setValue(offset, disabledOffset, valueAddr);
    }

    return true;
}
