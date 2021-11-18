//#############################################################
//# Purpose: Change the JNE to NOPs after LangType comparison #
//#          in EOT font Checker function                     #
//#############################################################

function EnableOfficialCustomFonts()
{
    var LANGTYPE = GetLangType();
    if (LANGTYPE.length === 1)
        return "LANGTYPE error: " + LANGTYPE[0];

    consoleLog("Search url");
    var urlOffset = pe.stringHex4("http://www.ragnarok.co.kr");

    consoleLog("Find the JNE (Comparison pattern changes from client to client, but the JNE and CALL doesn't)");
    var code =
        "83 3D " + LANGTYPE + "00 " + // 0 cmp g_serviceType, 0
        "?? " +                       // 7 pop esi
        "0F 85 ?? 00 00 00 " +        // 8 jnz locret_A8AA2C
        "E8 ?? ?? ?? ?? " +           // 14 call EotLibInit
        "68 " + urlOffset +           // 19 push offset someStr
        "E8 ?? ?? ?? ?? " +           // 24 call EotLibSetValidUrl
        "6A 00 ";                     // 29 push 0
    var replaceOffset = 8;
    var EotLibInitOffset = 15;
    var EotLibSetValidUrlOffset = 25;
    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "A1 " + LANGTYPE +            // 0 mov eax, g_serviceType
            "?? " +                       // 5 pop esi
            "85 C0 " +                    // 6 test eax, eax
            "0F 85 ?? 00 00 00 " +        // 8 jnz locret_6D1B83
            "E8 ?? ?? ?? ?? " +           // 14 call EotLibInit
            "68 " + urlOffset +           // 19 push offset aHttpWww_ragnar
            "E8 ?? ?? ?? ?? " +           // 24 call EotLibSetValidUrl
            "6A 00 ";                     // 29 push 0
        var replaceOffset = 8;
        var EotLibInitOffset = 15;
        var EotLibSetValidUrlOffset = 25;
        var offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Pattern not found";

    logRawFunc("EotLibInit", offset, EotLibInitOffset);
    logRawFunc("EotLibSetValidUrl", offset, EotLibSetValidUrlOffset);

    consoleLog("Replace JNE instruction with NOPs");
    exe.replace(offset + replaceOffset, " 90 90 90 90 90 90", PTYPE_HEX);

    return true;
}
