//######################################################################
//# Purpose: Fix up all HackShield related functions or function calls #
//#          by HackShield and remove aossdk.dll from import.          #
//######################################################################

delete Import_Info;  // Removing any stray values before Patches are selected

function DisableHShield()
{
    consoleLog("Step 1a - Search string 'webclinic.ahnlab.com'");
    var offset = pe.stringVa("webclinic.ahnlab.com");

    if (offset === -1)
        return "Failed in Step 1a - String not found";

    consoleLog("Step 1b - Search its reference");
    offset = pe.findCode("68 " + offset.packToHex(4));  // push offset addr ; "webclinic.ahnlab.com"

    if (offset === -1)
        return "Failed in Step 1b - Pattern not found";

    consoleLog("Step 1c - Search the JZ before the RETN that points to the PUSH");
    var code =
        "74 ?? " +  // 00 jz short addr2
        "33 C0 ";   // 04 xor eax, eax

    offset = pe.find(code, offset - 0x10, offset);

    if (offset === -1)
        return "Failed in Step 1c - Pattern not found";

    consoleLog("Step 1d - Replace the JZ + XOR with XOR + INC of EAX to return 1 without initializing AhnLab");
    pe.replaceHex(offset, "33 C0 40 90 ");

    if ((exe.getClientDate() >= 20090000 && exe.getClientDate() <= 20110228) && !IsSakray())
    {
        consoleLog("Step 2a - Search pattern 'HackShield Error'");
        var code =
            "B8 01 00 00 00 " +  // 00 mov eax, 1
            "5B " +              // 05 pop ebx
            "8B E5 " +           // 06 mov esp, ebp
            "5D " +              // 08 pop ebp
            "C2 10 00 " +        // 09 retn 10h
            "E8 ?? ?? ?? ?? " +  // 12 call sub_57AE40
            "85 C0 " +           // 17 test eax, eax
            "75 0E ";            // 19 jnz short loc_6FDD4C

        var repLoc = 12;
        var offset = pe.findCode(code);

        if (offset === -1)
        {
            code =
                "B8 01 00 00 00 " +  // 00 mov eax, 1
                "E9 ?? 01 00 00 " +  // 05 jmp loc_717703
                "E8 ?? ?? ?? ?? " +  // 10 call sub_576E40
                "85 C0 " +           // 15 test eax, eax
                "74 DD ";            // 17 jz short loc_717532

            repLoc = 10;
            offset = pe.findCode(code);
        }

        if (offset === -1)
            return "Failed in Step 2a - Pattern not found";

        consoleLog("Step 2b - Replace the CALL with MOV EAX");
        pe.replaceHex(offset + repLoc, "B8 01 " + "00 ".repeat(3));
    }

    consoleLog("Step 3a - Search failure message - this is there in newer clients");
    offset = pe.stringVa("CHackShieldMgr::Monitoring() failed");

    if (offset !== -1)
    {
        consoleLog("Step 3b - Search reference to Failure message");
        offset = pe.findCode("68 " + offset.packToHex(4) + "FF 15 ");

        consoleLog("Step 3c - Search pattern before the referenced location within 0x40 bytes");
        if (offset !== -1)
        {
            code =
                "E8 ?? ?? ?? ?? " +  // 00 CALL func1
                "84 C0 " +           // 05 TEST AL, AL
                "74 16 " +           // 07 JZ SHORT addr1
                "8B ?? " +           // 09 MOV ECX, ESI
                "E8 ";               // 11 CALL func2

            offset = pe.find(code, offset - 0x40, offset);
        }

        consoleLog("Step 3d - Replace the first call with code to return 1 and cleanup stack");
        if (offset !== -1)
        {
            code =
                "90 " +     // 00 NOP
                "B0 01 " +  // 01 MOV AL, 1
                "5E " +     // 03 POP ESI
                "C3 ";      // 04 RETN

            pe.replaceHex(offset, code);
        }
    }

    consoleLog("Step 4a - Search address of 'ERROR'");
    offset = pe.stringVa("ERROR");

    if (offset === -1)
        return "Failed in Step 4a - String not found";

    consoleLog("Step 4b - Search address of MessageBoxA function");
    var offset2 = imports.ptrValidated("MessageBoxA", "USER32.dll");

    consoleLog("Step 4c - Search ERROR reference followed by MessageBoxA call");
    var strHex1 = offset.packToHex(4);
    var strHex2 = offset2.packToHex(4);

    code =
        "68 " + strHex1 +    // 00 PUSH OFFSET addr; ASCII "ERROR"
        "?? " +              // 05 PUSH reg32_A
        "?? " +              // 06 PUSH reg32_B
        "FF 15 " + strHex2;  // 07 CALL DWORD PTR DS:[<&USER32.MessageBoxA>]

    offset = pe.findCode(code);

    if (offset === -1)
    {
        code = code.replace("?? ?? FF 15 ", "?? 6A 00 FF 15 ");  // Change PUSH reg32_B with PUSH 0
        offset = pe.findCode(code);
    }

    if (offset !== -1)
    {
        consoleLog("Step 4d - Find the JNE after it that skips the HShield calls");
        code =
            "80 3D ?? ?? ?? 00 00 " +  // 00 CMP BYTE PTR DS:[addr1], 0
            "75 ";                     // 07 JNE SHORT addr2

        offset2 = pe.find(code, offset, offset + 0x80);

        if (offset2 === -1)
        {
            code =
                "39 ?? ?? ?? ?? 00 " +  // 00 CMP DWORD PTR DS:[addr1], reg32_A
                "75 ";                  // 06 JNE SHORT addr2

            offset2 = pe.find(code, offset, offset + 0x80);
        }

        consoleLog("Step 4e - Replace the JNE with JMP to always skip");
        if (offset2 !== -1)
            pe.replaceByte(offset2 + code.hexlength() - 1, 0xEB);
    }

    if (exe.getClientDate() > 20140700)
        return true;

    consoleLog("Step 5a - Search address of the 'aossdk.dll'");
    var aOffset = pe.stringRaw("aossdk.dll");

    if (aOffset === -1)
        return "Failed in Step 5a - String not found";

    consoleLog("Step 5b - Construct the Image Descriptor Pattern (Relative Virtual Address prefixed by 8 zeros)");
    aOffset = "00 ".repeat(8) + (pe.rawToVa(aOffset) - pe.getImageBase()).packToHex(4);

    consoleLog("Step 5c - Check for Use Custom DLL patch needed since it modifies the import table location");
    var hasCustomDLL = (getActivePatches().indexOf(211) !== -1);

    if (hasCustomDLL && typeof(Import_Info) !== "undefined")
    {
        consoleLog("Step 5d - If it is used, it means the table has been shifted and all related data is available in Import_Info");
        var tblData = Import_Info.valueSuf;
        var newTblData = " ";

        for (var i = 0; i < tblData.length; i += 20 * 3)
        {
            var curValue = tblData.substr(i, 20 * 3);

            if (curValue.indexOf(aOffset) === 3 * 4)
                continue;  // Skip aossdk import rest all are copied

            newTblData = newTblData + curValue;
        }

        if (newTblData !== tblData)
        {
            consoleLog("Step 5e - If the removal was not already done then Empty the Custom DLL patch and make the changes here instead");
            exe.emptyPatch(211);

            var PEoffset = pe.getPeHeader();

            exe.insert(Import_Info.offset, (Import_Info.valuePre + newTblData).hexlength(), Import_Info.valuePre + newTblData, PTYPE_HEX);
            pe.replaceDWord(PEoffset + 0x18 + 0x60 + 0x08, Import_Info.tblAddr);
            pe.replaceDWord(PEoffset + 0x18 + 0x60 + 0x0C, Import_Info.tblSize);
        }
    }
    else
    {
        consoleLog("Step 5f - If Custom DLL is not present then we need to traverse the Import table and remove the aossdk entry");
        var dir = GetDataDirectory(1);
        var finalValue = " 00".repeat(20);
        var curValue;
        var lastDLL = " ";

        if (dir.offset === -1)
            throw "Failed in Step 5f - Found wrong offset";

        code = " ";  // Will contain the import table

        for (offset = dir.offset; (curValue = pe.fetchHex(offset, 20)) !== finalValue; offset += 20)
        {
            consoleLog("Step 5e - Get the DLL Name for the import entry");
            offset2 = pe.vaToRaw(pe.fetchDWord(offset + 12) + pe.getImageBase());
            var offset3 = pe.find("00 ", offset2);
            var curDLL = pe.fetch(offset2, offset3 - offset2);

            consoleLog("Step 5f - Make sure its not a duplicate or aossdk.dll");
            if (lastDLL === curDLL || curDLL === "aossdk.dll")
                continue;

            consoleLog("Step 5g - Add the entry to code and save current DLL to compare next iteration");
            code += curValue;
            lastDLL = curDLL;
        }

        code += finalValue;

        consoleLog("Step 5h - Overwrite import table with the one we got");
        pe.replaceHex(dir.offset, code);
    }

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableHShield_()
{
    return (pe.stringRaw("aossdk.dll") !== -1);
}

//###########################################################################
//# Purpose: Re-run the UseCustomDLL function again if the Custom DLL patch #
//#          has selected so that it doesn't accommodate for HShield patch. #
//###########################################################################

function _DisableHShield()
{
    if (getActivePatches().indexOf(211) !== -1)
    {
        exe.setCurrentPatch(211);
        exe.emptyPatch(211);
        UseCustomDLL();
    }
}
