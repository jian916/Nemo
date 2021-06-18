function TaekwonJobNameFix()
{
    // Step 4a - Find the Langtype Check
    var LANGTYPE = GetLangType();  // Langtype value overrides Service settings hence they use the same variable - g_serviceType
    if (LANGTYPE.length === 1)
        return "Failed in Step 4 - " + LANGTYPE[0];

    var g_sessionHex = table.getHex4(table.g_session);

    var code =
        " 83 3D" + LANGTYPE + " 00" +  // CMP DWORD PTR DS:[g_serviceType], 0
        " B9" + g_sessionHex +         // MOV ECX, addr1
        " 75"                          // JNZ SHORT addr2
    ;
    var offset = pe.findCode(code);  //VC9+ Clients

    if (offset === -1)
    {
        code =
            LANGTYPE +          // MOV reg32_A, DWORD PTR DS:[g_serviceType] ; Usually reg32_A is EAX
            " B9" + g_sessionHex +  // MOV ECX, addr1
            " 85 ??" +          // TEST reg32_A, reg32_A
            " 75"               // JNZ SHORT addr2
        ;
        offset = pe.findCode(code);  // Older Clients
    }

    if (offset === -1)
    {
        return "Failed in Step 4 - Translate Taekwon Job";
    }

    // Step 4b - Change the JNZ to JMP so that Korean names never get assigned.
    exe.replace(offset + code.hexlength() - 1, "EB", PTYPE_HEX);

    return true;
}
