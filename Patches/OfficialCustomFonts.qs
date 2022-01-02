//#############################################################
//# Purpose: Change the JNE to NOPs after LangType comparison #
//#          in EOT font Checker function                     #
//#############################################################

function OfficialCustomFonts_match()
{
    var LANGTYPE = GetLangType();
    if (LANGTYPE.length === 1)
        return "LANGTYPE error: " + LANGTYPE[0];

    consoleLog("Search url");
    var urlOffset = pe.stringHex4("http://www.ragnarok.co.kr");

    consoleLog("Find the JNE (Comparison pattern changes from client to client, but the JNE and CALL doesn't)");
    var code = [
        [
            "83 3D " + LANGTYPE + "00 " + // 0 cmp g_serviceType, 0
            "?? " +                       // 7 pop esi
            "0F 85 ?? 00 00 00 " +        // 8 jnz locret_A8AA2C
            "E8 ?? ?? ?? ?? " +           // 14 call EotLibInit
            "68 " + urlOffset +           // 19 push offset someStr
            "E8 ?? ?? ?? ?? " +           // 24 call EotLibSetValidUrl
            "6A 00 ",                     // 29 push 0
            {
                "replaceOffset": [8, 6],
                "jmpOffset": [10, 4],
                "EotLibInitOffset": 15,
                "EotLibSetValidUrlOffset": 25
            }
        ],
        [
            "A1 " + LANGTYPE +            // 0 mov eax, g_serviceType
            "?? " +                       // 5 pop esi
            "85 C0 " +                    // 6 test eax, eax
            "0F 85 ?? 00 00 00 " +        // 8 jnz locret_6D1B83
            "E8 ?? ?? ?? ?? " +           // 14 call EotLibInit
            "68 " + urlOffset +           // 19 push offset aHttpWww_ragnar
            "E8 ?? ?? ?? ?? " +           // 24 call EotLibSetValidUrl
            "6A 00 ",                     // 29 push 0
            {
                "replaceOffset": [8, 6],
                "jmpOffset": [10, 4],
                "EotLibInitOffset": 15,
                "EotLibSetValidUrlOffset": 25
            }
        ]
    ];

    var offsetObj = pe.findAnyCode(code);

    if (offsetObj === -1)
        throw "Pattern not found";

    var offset = offsetObj.offset;

    logRawFunc("EotLibInit", offset, offsetObj.EotLibInitOffset);
    logRawFunc("EotLibSetValidUrl", offset, offsetObj.EotLibSetValidUrlOffset);

    var obj = hooks.createHookObj();
//    obj.patchAddr = offsetObj.offset;
    obj.stolenCode = "";
    obj.stolenCode1 = "";
    obj.retCode = "";
    obj.endHook = false;

    obj.offset = offset;
    obj.replaceOffset = offsetObj.replaceOffset;
    obj.jmpOffset = offsetObj.jmpOffset;
    return obj;
}

function EnableOfficialCustomFonts()
{
    var obj = OfficialCustomFonts_match();
    consoleLog("Replace JNE instruction with NOPs");
    pe.setNopsValueRange(obj.offset, obj.replaceOffset);

    return true;
}

function DisableOfficialCustomFonts()
{
    var obj = OfficialCustomFonts_match();
    consoleLog("Replace JNE instruction with JMP");

    var jmpAddr = pe.fetchRelativeValue(obj.offset, obj.jmpOffset);
    pe.setJmpVa(obj.offset + obj.replaceOffset[0], jmpAddr, "jmp", obj.replaceOffset[1]);

    return true;
}
