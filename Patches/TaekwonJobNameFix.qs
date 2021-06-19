
function TaekwonJobNameFix()
{
    function searchUsage(data, name)
    {
        var res = pe.findCodes(data);
        if (res.length === 0)
            throw "Reference not found for " + name;
        return res;
    }

    function searchIndexBlock(code, index, refOffset, fIndex)
    {
        if (typeof(fIndex) === "undefined")
            fIndex = 0x3f38;
        var offsets = pe.findCodes(code);
        for (var i = 0; i < offsets.length; i ++)
        {
            var offset = offsets[i];
            var value = exe.fetchValue(offset, [index, 4]);
            if (value == fIndex)
                found.push([offset, offset + refOffset]);
            else
                exclude.push([offset, offset + refOffset]);
        }
    }

    function excludeBlock(code, refOffset)
    {
        var offsets = pe.findCodes(code);
        for (var i = 0; i < offsets.length; i ++)
        {
            var offset = offsets[i];
            exclude.push([offset, offset + refOffset]);
        }
    }

    function searchBlock2(code, ref0Offset, ref1Offset)
    {
        var offsets = pe.findCodes(code);
        for (var i = 0; i < offsets.length; i ++)
        {
            var offset = offsets[i];
            foundRef[0].push([
                offset,
                offset + ref0Offset]);
            foundRef[1].push([
                offset,
                offset + ref1Offset]);
        }
    }

    function searchIndexBlock2(code, index, ref0Offset, ref1Offset, fIndex)
    {
        if (typeof(fIndex) === "undefined")
            fIndex = 0x3f38;
        var offsets = pe.findCodes(code);
        for (var i = 0; i < offsets.length; i ++)
        {
            var offset = offsets[i];
            var value = exe.fetchValue(offset, [index, 4]);
            if (value == fIndex)
            {
                foundRef[0].push([
                    offset,
                    offset + ref0Offset]);
                foundRef[1].push([
                    offset,
                    offset + ref1Offset]);
            }
            else
            {
                excludeRef[0].push([
                    offset,
                    offset + ref0Offset]);
                excludeRef[1].push([
                    offset,
                    offset + ref1Offset]);
            }
        }
    }

    function printHexAddr(text, val)
    {
        consoleLog(text + ": 0x" + pe.rawToVa(val).toString(16));
    }

    var enStr = [
        pe.stringHex4("TaeKwon Girl"),
        pe.stringHex4("TaeKwon Boy")
    ];
    var krStr = [
        pe.stringHex4("\xC5\xC2\xB1\xC7\xBC\xD2\xB3\xE0"),
        pe.stringHex4("\xC5\xC2\xB1\xC7\xBC\xD2\xB3\xE2")
    ];

    var allKrRef = [
        searchUsage(krStr[0]),
        searchUsage(krStr[1])
    ];

    var foundRef = [[], []];
    var excludeRef = [[], []];

    for (var i = 0; i < 2; i ++)
    {
        var ref = krStr[i];
        var found = foundRef[i];
        var exclude = excludeRef[i];

        consoleLog("Search referenced for index " + i);
        searchIndexBlock(
            "C7 80 ?? ?? ?? 00 " + ref,  // 0 mov dword ptr [eax+180h], offset aT_5
            2,
            6);
        searchIndexBlock(
            "C7 81 ?? ?? ?? 00 " + ref,  // 0 mov dword ptr [ecx+180h], offset aT_5
            2,
            6);
        searchIndexBlock(
            "C7 82 ?? ?? ?? 00 " + ref,  // 0 mov dword ptr [edx+180h], offset aT_5
            2,
            6);
        searchIndexBlock(
            "C7 85 ?? ?? ?? 00 " + ref,  // 0 mov dword ptr [ebp+180h], offset aT_5
            2,
            6);
        searchIndexBlock(
            "C7 87 ?? ?? ?? 00 " + ref,  // 0 mov dword ptr [edi+180h], offset aT_5
            2,
            6);

        searchIndexBlock(
            "C7 45 F0 " + ref +           // 0 mov dword ptr [ebp+Val+4], offset aR_3
            "FF 75 ?? " +                 // 7 push dword ptr [ebp+Val+4]
            "C7 45 EC ?? ?? ?? 00 ",      // 10 mov [ebp+Val.id], 0FCEh
            13,
            3,
            0xfce);
        searchIndexBlock(
            "68 ?? ?? ?? 00 " +           // 0 push 0A5h
            "8B CF " +                    // 5 mov ecx, edi
            "C7 00 " + ref +              // 7 mov dword ptr [eax], offset aT_1
            "E8 ",                        // 13 call sub_4D35B0
            1,
            9);
        searchIndexBlock(
            "B9 " + ref +                 // 0 mov ecx, offset aT_0
            "89 8D ?? ?? ?? 00 ",         // 5 mov [ebp+184h], ecx
            7,
            1);
        searchIndexBlock(
            "BA " + ref +                 // 0 mov edx, offset aT_0
            "89 93 ?? ?? ?? 00 ",         // 5 mov [ebx+184h], edx
            7,
            1);

        excludeBlock(
            "6A ?? " +                    // 0 push 61h
            "8B CE " +                    // 2 mov ecx, esi
            "C7 00 " + ref +              // 4 mov dword ptr [eax], offset asc_78F0F0
            "E8 ",                        // 10 call std_vector_char_ptr_getAt
            6);
        excludeBlock(
            "6A ?? " +                    // 0 push 62h
            "8B CF " +                    // 2 mov ecx, edi
            "C7 00 " + ref +              // 4 mov dword ptr [eax], offset aT_1
            "E8 ",                        // 10 call sub_4D35B0
            6);
        excludeBlock(
            "B9 " + ref +                 // 0 mov ecx, offset aT_0
            "E9 ?? ?? 00 00 ",            // 5 jmp loc_71AA27
            1);
        excludeBlock(
            "BA " + ref +                 // 0 mov edx, offset aT_0
            "E9 ?? ?? 00 00 ",            // 5 jmp loc_6EDAAD
            1);
        excludeBlock(
            "8B 06 " +                    // 0 mov eax, [esi]
            "C7 45 ?? " + ref +           // 2 mov [ebp+var_1C], offset aR_3
            "C7 80 ",                     // 9 mov dword ptr [eax+3F40h], offset aIsb
            5);

        // wrong bytes found
        excludeBlock(
            "C7 80 9C 02 00 00 ?? 00 00 00 ",  // 0 mov dword ptr [eax+29Ch], 0B2h
            4);
        excludeBlock(
            "E8 ?? ?? 00 00 " +           // 0 call sub_A75A20
            "83 C4 ",                     // 5 add esp, 10h
            0);
        excludeBlock(
            "0F 85 ?? 00 00 00 " +        // 0 jnz loc_87CB09
            "3D ?? 00 00 00 ",            // 6 cmp eax, 0CAh
            5);
        excludeBlock(
            "E9 ?? 00 00 00 " +           // 0 jmp loc_88E35E
            "3D ?? 00 00 00 " +           // 5 cmp eax, 0CAh
            "74 ",                     // 10 jz short loc_88E2F9
            4);
        excludeBlock(
            "E9 ?? ?? 00 00 " +           // 0 jmp loc_891D58
            "3D ?? 00 00 00 " +           // 5 cmp eax, 0CAh
            "0F 84 ?? ?? 00 00 ",         // 10 jz loc_891BFA
            4);
    }

    searchIndexBlock2(
        "81 FF ?? ?? ?? 00 " +        // 0 cmp edi, 0FCEh
        "0F 85 ?? ?? ?? 00 " +        // 6 jnz loc_653751
        "85 F6 " +                    // 12 test esi, esi
        "BA " + krStr[0] +            // 14 mov edx, offset aR_1
        "B8 " + krStr[1] +            // 19 mov eax, offset aT_5
        "0F 45 D0 ",                  // 24 cmovnz edx, eax
        2,
        15, 20,
        0xfce);
    searchIndexBlock2(
        "B8 " + krStr[1] +            // 0 mov eax, offset aT_5
        "85 FF " +                    // 5 test edi, edi
        "B9 " + krStr[0] +            // 7 mov ecx, offset aR_1
        "0F 45 C8 " +                 // 12 cmovnz ecx, eax
        "A1 ?? ?? ?? ?? " +           // 15 mov eax, g_session.m_jobNameTable._First
        "5F " +                       // 20 pop edi
        "89 88 ?? ?? ?? 00 ",         // 21 mov [eax+3F38h], ecx
        23,
        8, 1);
    searchIndexBlock2(
        "B8 " + krStr[1] +            // 0 mov eax, offset aT_3
        "B9 " + krStr[0] +            // 5 mov ecx, offset aR_2
        "0F 45 C8 " +                 // 10 cmovnz ecx, eax
        "A1 ?? ?? ?? ?? " +           // 13 mov eax, dword ptr g_session.m_jobNameTable
        "5F " +                       // 18 pop edi
        "89 88 ?? ?? ?? 00 ",         // 19 mov [eax+3F38h], ecx
        21,
        6, 1);
    searchIndexBlock2(
        "B9 " + krStr[0] +            // 0 mov ecx, offset aR_2
        "BA " + krStr[1] +            // 5 mov edx, offset aT_3
        "0F 45 CA " +                 // 10 cmovnz ecx, edx
        "89 88 ?? ?? ?? 00 ",         // 13 mov [eax+3F38h], ecx
        15,
        1, 6);

    var isError = false;
    for (var i = 0; i < 2; i ++)
    {
        var missing = [];
        consoleLog("Index " + i);
        var found = [];
        var foundCnt = 0;
        var excludeCnt = 0;
        for (var j = 0; j < foundRef[i].length; j ++)
        {
            var val = foundRef[i][j][1];
            if (allKrRef[i].indexOf(val) >= 0)
            {
                printHexAddr(" Found ref", val);
                found.push(val);
                foundCnt = foundCnt + 1;
            }
        }
        for (var j = 0; j < excludeRef[i].length; j ++)
        {
            var val = excludeRef[i][j][1];
            if (allKrRef[i].indexOf(val) >= 0)
            {
                printHexAddr(" Exclude ref", val);
                found.push(val);
                excludeCnt = excludeCnt + 1;
            }
        }
        for (var j = 0; j < allKrRef[i].length; j ++)
        {
            var val = allKrRef[i][j];
            if (found.indexOf(val) < 0)
            {
                printHexAddr(" Missing ref", val);
                isError = true;
            }
        }
        var cnt = foundCnt + excludeCnt;
        consoleLog("Found " + cnt + " from " + allKrRef[i].length + " referenced");
        if (cnt !== allKrRef[i].length)
        {
            throw "Found " + cnt + " from " + allKrRef[i].length + " referenced for index " + i;
        }
    }
    if (isError === true)
    {
        throw "Found not all references";
    }
    for (var i = 0; i < 2; i ++)
    {
        for (var j = 0; j < foundRef[i].length; j ++)
        {
            var addr = foundRef[i][j][1];
            exe.replace(addr, enStr[i], PTYPE_HEX);
        }
    }

    return true;
}
