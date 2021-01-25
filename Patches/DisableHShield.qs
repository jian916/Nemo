//######################################################################
//# Purpose: Fix up all HackShield related functions or function calls #
//#          by HackShield and remove aossdk.dll from import.          #
//######################################################################

delete Import_Info;  // Removing any stray values before Patches are selected

function DisableHShield()
{
    consoleLog("Step 1a - Search string 'webclinic.ahnlab.com'");
    var offset = exe.findString("webclinic.ahnlab.com", RVA);

    if (offset === -1)
        return "Failed in Step 1a - String not found";

    consoleLog("Step 1b - Search its reference");
    offset = exe.findCode("68 " + offset.packToHex(4), PTYPE_HEX, false);  // push offset addr ; "webclinic.ahnlab.com"

    if (offset === -1)
        return "Failed in Step 1b - Pattern not found";

    consoleLog("Step 1c - Search the JZ before the RETN that points to the PUSH");
    var code =
        "74 AB " +  // 00 jz short addr2
        "33 C0 ";   // 04 xor eax, eax

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x10, offset);

    if (offset === -1)
        return "Failed in Step 1c - Pattern not found";

    consoleLog("Step 1d - Replace the JZ + XOR with XOR + INC of EAX to return 1 without initializing AhnLab");
    exe.replace(offset, "33 C0 40 90 ", PTYPE_HEX);

    if ((exe.getClientDate() >= 20090000 && exe.getClientDate() <= 20110228) && !IsSakray())
    {
        consoleLog("Step 2a - Search pattern 'HackShield Error'");
        var code =
            "B8 01 00 00 00 " +  // 00 mov eax, 1
            "5B " +              // 05 pop ebx
            "8B E5 " +           // 06 mov esp, ebp
            "5D " +              // 08 pop ebp
            "C2 10 00 " +        // 09 retn 10h
            "E8 AB AB AB AB " +  // 12 call sub_57AE40
            "85 C0 " +           // 17 test eax, eax
            "75 0E ";            // 19 jnz short loc_6FDD4C

        var repLoc = 12;
        var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

        if (offset === -1)
        {
            code =
                "B8 01 00 00 00 " +  // 00 mov eax, 1
                "E9 AB 01 00 00 " +  // 05 jmp loc_717703
                "E8 AB AB AB AB " +  // 10 call sub_576E40
                "85 C0 " +           // 15 test eax, eax
                "74 DD ";            // 17 jz short loc_717532

            repLoc = 10;
            offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
        }

        if (offset === -1)
            return "Failed in Step 2a - Pattern not found";

        consoleLog("Step 2b - Replace the CALL with MOV EAX");
        exe.replace(offset + repLoc, "B8 01 " + "00 ".repeat(3), PTYPE_HEX);
    }

    consoleLog("Step 3a - Search failure message - this is there in newer clients");
    offset = exe.findString("CHackShieldMgr::Monitoring() failed", RVA);

    if (offset !== -1)
    {
        consoleLog("Step 3b - Search reference to Failure message");
        offset = exe.findCode("68 " + offset.packToHex(4) + "FF 15 ", PTYPE_HEX, false);

        consoleLog("Step 3c - Search pattern before the referenced location within 0x40 bytes");
        if (offset !== -1)
        {
            code =
                "E8 AB AB AB AB " +  // 00 CALL func1
                "84 C0 " +           // 05 TEST AL, AL
                "74 16 " +           // 07 JZ SHORT addr1
                "8B AB " +           // 09 MOV ECX, ESI
                "E8 ";               // 11 CALL func2

            offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x40, offset);
        }

        consoleLog("Step 3d - Replace the first call with code to return 1 and cleanup stack");
        if (offset !== -1)
        {
            code =
                "90 " +     // 00 NOP
                "B0 01 " +  // 01 MOV AL, 1
                "5E " +     // 03 POP ESI
                "C3 ";      // 04 RETN

            exe.replace(offset, code, PTYPE_HEX);
        }
    }

    consoleLog("Step 4a - Search address of 'ERROR'");
    offset = exe.findString("ERROR", RVA);

    if (offset === -1)
        return "Failed in Step 4a - String not found";

    consoleLog("Step 4b - Search address of MessageBoxA function");
    var offset2 = GetFunction("MessageBoxA", "USER32.dll");

    if (offset2 === -1)
        return "Failed in Step 4b - Function not found";

    consoleLog("Step 4c - Search ERROR reference followed by MessageBoxA call");
    var strHex1 = offset.packToHex(4);
    var strHex2 = offset2.packToHex(4);

    code =
        "68 " + strHex1 +    // 00 PUSH OFFSET addr; ASCII "ERROR"
        "AB " +              // 05 PUSH reg32_A
        "AB " +              // 06 PUSH reg32_B
        "FF 15 " + strHex2;  // 07 CALL DWORD PTR DS:[<&USER32.MessageBoxA>]

    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code = code.replace("AB AB FF 15 ", "AB 6A 00 FF 15 ");  // Change PUSH reg32_B with PUSH 0
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset !== -1)
    {
        consoleLog("Step 4d - Find the JNE after it that skips the HShield calls");
        code =
            "80 3D AB AB AB 00 00 " +  // 00 CMP BYTE PTR DS:[addr1], 0
            "75 ";                     // 07 JNE SHORT addr2

        offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x80);

        if (offset2 === -1)
        {
            code =
                "39 AB AB AB AB 00 " +  // 00 CMP DWORD PTR DS:[addr1], reg32_A
                "75 ";                  // 06 JNE SHORT addr2

            offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x80);
        }

        consoleLog("Step 4e - Replace the JNE with JMP to always skip");
        if (offset2 !== -1)
            exe.replace(offset2 + code.hexlength() - 1, "EB ", PTYPE_HEX);
    }

    if (exe.getClientDate() > 20140700)
        return true;

    consoleLog("Step 5a - Search address of the 'aossdk.dll'");
    var aOffset = exe.findString("aossdk.dll", PTYPE_STRING, false);

    if (aOffset === -1)
        return "Failed in Step 5a - String not found";

    consoleLog("Step 5b - Construct the Image Descriptor Pattern (Relative Virtual Address prefixed by 8 zeros)");
    aOffset = "00 ".repeat(8) + (exe.Raw2Rva(aOffset) - exe.getImageBase()).packToHex(4);

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

            var PEoffset = exe.getPEOffset();

            exe.insert(Import_Info.offset, (Import_Info.valuePre + newTblData).hexlength(), Import_Info.valuePre + newTblData, PTYPE_HEX);
            exe.replaceDWord(PEoffset + 0x18 + 0x60 + 0x08, Import_Info.tblAddr);
            exe.replaceDWord(PEoffset + 0x18 + 0x60 + 0x0C, Import_Info.tblSize);
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

        for (offset = dir.offset; (curValue = exe.fetchHex(offset, 20)) !== finalValue; offset += 20)
        {
            consoleLog("Step 5e - Get the DLL Name for the import entry");
            offset2 = exe.Rva2Raw(exe.fetchDWord(offset + 12) + exe.getImageBase());
            var offset3 = exe.find("00 ", PTYPE_HEX, false, "\xAB", offset2);
            var curDLL = exe.fetch(offset2, offset3 - offset2);

            consoleLog("Step 5f - Make sure its not a duplicate or aossdk.dll");
            if (lastDLL === curDLL || curDLL === "aossdk.dll")
                continue;

            consoleLog("Step 5g - Add the entry to code and save current DLL to compare next iteration");
            code += curValue;
            lastDLL = curDLL;
        }

        code += finalValue;

        consoleLog("Step 5h - Overwrite import table with the one we got");
        exe.replace(dir.offset, code, PTYPE_HEX);
    }

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableHShield_()
{
    return (exe.findString("aossdk.dll", RAW) !== -1);
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
