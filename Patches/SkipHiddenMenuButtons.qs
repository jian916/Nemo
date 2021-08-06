//
// Copyright (C) 2018-2021  Andrei Karas (4144)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//#############################################################
//# Purpose: Allow skip hidden menu buttons in                #
//# UIMenuIconWnd_virt56                                      #
//#############################################################

function SkipHiddenMenuButtons()
{
    consoleLog("search string status_doram");
    var strHex = exe.findString("status_doram", RVA).packToHex(4);

    consoleLog("search start for do/while block in adding buttons");
    var code =
        "8D B5 ?? ?? ?? ??" +  // 0 lea esi, [ebp+names]
        "89 8D ?? ?? ?? ??" +  // 6 mov [ebp+cnt2], ecx
        "8B 18" +              // 12 mov ebx, [eax]
        "81 FB ?? ?? 00 00" +  // 14 cmp ebx, 0A9h    <-- stole code here
        "75 ??" +              // 20 jnz short loc_577BA6
        "FF 35 ?? ?? ?? ??" +  // 22 push g_session.jobId
        getEcxSessionHex() +   // 28 mov ecx, offset g_session
        "E8 ?? ?? ?? ??" +     // 33 call is_doram_job
        "3C 01" +              // 38 cmp al, 1
        "75 0E" +              // 40 jnz short loc_577BA0
        "6A 0C" +              // 42 push 0Ch
        "68 " + strHex +       // 44 push offset "status_doram"
        "8B CE" +              // 45 mov ecx, esi
        "E8"                   // 47 call std_string_from_chars_size
    var nonA9Offset = 21;
    var a9Offset = 22;
    var stoleOffset = 14;
    var stoleSize = 6;
    var regName = "esi";
    var noSwitch = false;
    var jobIdOffset = [24, 4];
    var isDoramJobOffset = 34;
    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "8D BD ?? ?? ?? ?? " +        // 0 lea edi, [ebp+names]
            "C7 85 ?? ?? ?? ?? 00 00 00 00 " + // 6 mov [ebp+var_31C], 0
            "89 B5 ?? ?? ?? ?? " +        // 16 mov [ebp+var_310], esi
            "81 3E ?? ?? 00 00 " +        // 22 cmp dword ptr [esi], 0AEh
            "75 ?? " +                    // 28 jnz short loc_5862FE
            "FF 35 ?? ?? ?? ?? " +        // 30 push g_session.jobId
            getEcxSessionHex() +          // 36 mov ecx, offset g_session
            "E8 ?? ?? ?? ?? " +           // 41 call is_doram_job
            "3C 01 " +                    // 46 cmp al, 1
            "75 ?? " +                    // 48 jnz short loc_5862FE
            "6A 0C " +                    // 50 push 0Ch
            "68 " + strHex +              // 52 push offset aStatus_doram
            "8B CF " +                    // 57 mov ecx, edi
            "E8";                         // 59 call std_string_assign

        nonA9Offset = 29;
        a9Offset = 30;
        stoleOffset = 22;
        stoleSize = 6;
        regName = "edi";
        jobIdOffset = [32, 4];
        isDoramJobOffset = 42;
        noSwitch = false;
        offset = pe.findCode(code);
    }
    if (offset === -1)
    {
        code =
            "8D BD ?? ?? ?? ?? " +        // 0 lea edi, [ebp+names]
            "C7 85 ?? ?? ?? ?? 00 00 00 00 " + // 6 mov [ebp+var_31C], 0
            "89 9D ?? ?? ?? ?? " +        // 16 mov [ebp+var_310], ebx
            "81 3B ?? ?? 00 00 " +        // 22 cmp dword ptr [ebx], 0AEh
            "75 ?? " +                    // 28 jnz short loc_5862FE
            "FF 35 ?? ?? ?? ?? " +        // 30 push g_session.jobId
            getEcxSessionHex() +          // 36 mov ecx, offset g_session
            "E8 ?? ?? ?? ?? " +           // 41 call is_doram_job
            "3C 01 " +                    // 46 cmp al, 1
            "75 ?? " +                    // 48 jnz short loc_5862FE
            "6A 0C " +                    // 50 push 0Ch
            "68 " + strHex +              // 52 push offset aStatus_doram
            "8B CF " +                    // 57 mov ecx, edi
            "E8";                         // 59 call std_string_assign

        nonA9Offset = 29;
        a9Offset = 30;
        stoleOffset = 22;
        stoleSize = 6;
        regName = "edi";
        jobIdOffset = [32, 4];
        isDoramJobOffset = 42;
        noSwitch = false;
        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        var code =
            "8D B5 ?? ?? ?? FF " +        // 0 lea esi, [ebp+var_224]
            "8B 18 " +                    // 6 mov ebx, [eax]
            "81 FB ?? ?? 00 00 " +        // 8 cmp ebx, 0A8h
            "75 ?? " +                    // 14 jnz short loc_514D99
            "FF 35 ?? ?? ?? ?? " +        // 16 push g_session.m_job
            "B9 ?? ?? ?? ?? " +           // 22 mov ecx, offset g_session
            "E8 ?? ?? ?? ?? " +           // 27 call CSession_isDoramJob
            "3C 01 " +                    // 32 cmp al, 1
            "75 0E " +                    // 34 jnz short loc_514D8D
            "6A 0C " +                    // 36 push 0Ch
            "68 " + strHex +              // 38 push offset aStatus_doram
            "8B CE " +                    // 43 mov ecx, esi
            "E8 ";                        // 45 call std_string_assign
        nonA9Offset = 15;
        a9Offset = 16;
        stoleOffset = 8;
        stoleSize = 6;
        regName = "esi";
        jobIdOffset = [18, 4];
        isDoramJobOffset = 28;
        noSwitch = false;
        offset = pe.findCode(code);
    }


    if (offset === -1)
        return "Failed in step 2 - pattern not found";
    offset1 = offset;

    logFieldAbs("CSession::m_job", offset, jobIdOffset);
    logRawFunc("CSession_isDoramJob", offset, isDoramJobOffset);

    var nonA9JmpAddr = pe.rawToVa(exe.fetchByte(offset + nonA9Offset) + offset + nonA9Offset + 1);
    var a9JmpAddr = pe.rawToVa(offset + a9Offset);
    var patchAddr = offset + stoleOffset;

    consoleLog("search switch block and non default jmp in switch (using first one jump)");
    code =
        "8D 83 ?? ?? ?? ??" +     // 0 lea eax, [ebx-164h]
        "3D ?? ?? 00 00" +        // 6 cmp eax, 0A6h
        "77 0E" +                 // 11 ja short loc_577BC1
        "0F B6 80 ?? ?? ?? ??" +  // 13 movzx eax, switch1[eax]
        "FF 24 85 ?? ?? ?? ??";   // 20 jmp switch2[eax*4]
    var switch1Offset = 16;
    var switch2Offset = 23;
    offset = pe.find(code, offset1, offset1 + 0x50);

    if (offset === -1)
    {
        var code =
            "8B 06 " +                    // 0 mov eax, [esi]
            "05 ?? ?? ?? FF " +           // 2 add eax, 0FFFFFE97h
            "3D ?? ?? 00 00 " +           // 7 cmp eax, 0B5h
            "77 0E " +                    // 12 ja short loc_58631A
            "0F B6 80 ?? ?? ?? ?? " +     // 14 movzx eax, ds:switch1[eax]
            "FF 24 85 ?? ?? ?? ?? ";      // 21 jmp ds:switch2[eax*4]
        switch1Offset = 17;
        switch2Offset = 24;
        noSwitch = false;
        offset = pe.find(code, offset1, offset1 + 0x50);
    }

    var jmpOffset1 = 0;
    var jmpOffset2 = 0;

    if (offset === -1)
    {
        code =
          " 2D ?? ?? 00 00"    //0 sub eax, 1E9h
        + " 0F 84 ?? ?? 00 00" //5 jz continueAddr
        + " 83 E8 ??"          //11 sub eax, 7h
        + " 0F 84 ?? ?? 00 00" //14 jz continueAddr
        ;
        noSwitch = true;
        jmpOffset1 = 7;
        jmpOffset2 = 16;
        offset = pe.find(code, offset1, offset1 + 0x50);
    }

    if (offset === -1)
    {
        code =
          " 2D ?? ?? 00 00"    //0 sub eax, 1E9h
        + " 0F 84 ?? ?? 00 00" //5 jz continueAddr
        + " 2D ?? ?? 00 00"    //11 sub eax, 86h
        + " 0F 84 ?? ?? 00 00" //16 jz continueAddr
        ;
        noSwitch = true;
        jmpOffset1 = 7;
        jmpOffset2 = 18;
        offset = pe.find(code, offset1, offset1 + 0x50);
    }

    if (offset === -1)
    {
        code =
          " 81 FB ?? ?? 00 00" //0 cmp ebx,162h
        + " 0F 84 ?? ?? 00 00" //6 jz continueAddr
        + " 81 FB ?? ?? 00 00" //12 cmp ebx,203h
        + " 0F 84 ?? ?? 00 00" //18 jz continueAddr
        ;
        noSwitch = true;
        jmpOffset1 = 8;
        jmpOffset2 = 20;
        offset = pe.find(code, offset1, offset1 + 0x50);
    }

    if (offset === -1)
    {
        code =
          " 81 FB ?? ?? 00 00" //0 cmp ebx,164h
        + " 0F 84 ?? ?? 00 00" //6 jz continueAddr
        + " 81 FB ?? ?? 00 00" //12 cmp ebx,208h
        + " 7E ??"             //18 jle short
        + " 81 FB ?? ?? 00 00" //20 cmp ebx,20Ah
        + " 0F 8E ?? ?? 00 00" //26 jle continueAddr
        ;
        noSwitch = true;
        jmpOffset1 = 8;
        jmpOffset2 = 28;
        offset = pe.find(code, offset1, offset1 + 0x50);
    }

    if (offset === -1)
    {
        code =
            "81 FB ?? ?? 00 00 " +        // 0 cmp ebx, 1F0h
            "0F 84 ?? ?? 00 00 " +        // 6 jz Menu_icons_switch_1F0
            "68 ?? ?? ?? 00 " +           // 12 push 118h
            "E8 ?? ?? ?? ?? " +           // 17 call operator_new
            "8B F8 " +                    // 22 mov edi, eax
            "83 C4 04 ";                  // 24 add esp, 4
        noSwitch = true;
        jmpOffset1 = 8;
        jmpOffset2 = 0;
        offset = pe.find(code, offset1, offset1 + 0x50);
    }

    if (offset === -1)
        return "Failed in Step 3 - switch not found";

    if (noSwitch)
    {
        var jmpAdd1 = exe.fetchDWord(offset + jmpOffset1);
        var continueAddr = pe.rawToVa(offset + jmpOffset1 + 4) + jmpAdd1;
        if (jmpOffset2 !== 0)
        {
            var jmpAdd2 = exe.fetchDWord(offset + jmpOffset2);
            var continueAddr2 = pe.rawToVa(offset + jmpOffset2 + 4) + jmpAdd2;
            if (continueAddr !== continueAddr2)
                return "Failed in Step 3.1 - Found wrong continueAddr";
        }
    }
    else
    {
        // get switch jmp address for value 0
        var addr1 = pe.vaToRaw(exe.fetchDWord(offset + switch1Offset));
        var addr2 = pe.vaToRaw(exe.fetchDWord(offset + switch2Offset));
        var offset1 = exe.fetchUByte(addr1);
        var continueAddr = exe.fetchDWord(addr2 + 4 * offset1);
    }

    consoleLog("patch code");

    var vars = {
        "continueAddr": continueAddr,
        "a9JmpAddr": a9JmpAddr,
        "nonA9JmpAddr": nonA9JmpAddr,
        "regName": regName,
        "stolenCode": asm.hexToAsm(exe.fetchHex(patchAddr, stoleSize))
    };
    var data = exe.insertAsmFile("", vars);

    consoleLog("add jump to own code");
    exe.setJmpRaw(patchAddr, data.free);

    return true;
}

function SkipHiddenMenuButtons_()
{
    return (exe.findString("status_doram", RAW) !== -1);
}
