//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2017 Secret
// Copyright (C) 2017-2021 Andrei Karas (4144)
// Copyright (C) 2020 X-EcutiOnner (xex.ecutionner@gmail.com)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//
//########################################################################
//# Purpose: Change the CMP after comparison to JMP for direct call only #
//#          Korea service setting inside ExternSettings function.       #
//########################################################################

function AlwaysReadKrExtSettings()
{
    var filePath = "Lua Files\\service_korea\\ExternalSettings_kr";

    if (IsZero())
        filePath = "Lua Files\\service_korea\\zero_server\\ExternalSettings_kr";

    consoleLog("Step 1 - Search filePath string");
    var offset = exe.findString(filePath, RVA);

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    consoleLog("Step 2 - Search pattern for its reference");
    var korea_ref_offset = exe.findCode("68 " + offset.packToHex(4), PTYPE_HEX, false);

    if (korea_ref_offset === -1)
        return "Failed in Step 2 - Pattern not found";

    consoleLog("Step 3 - Search service_korea reading code");
    var LANGTYPE = GetLangType();

    var code =
        "8B F9 " +          // 00 mov edi, ecx
        "A1 " + LANGTYPE +  // 02 mov eax, g_serviceType
        "83 F8 12 ";        // 07 cmp eax, 12h

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", korea_ref_offset - 0x50, korea_ref_offset);

    if (offset !== -1)
    {
        offset += code.hexlength();  // offset now points to the JA instruction after CMP EAX, 12

        consoleLog("Step 4a - Force the client to read Lua Files\service_korea\ExternalSettings_kr.lub");
        var diff = korea_ref_offset - offset - 2;  // Value -2 for EB xx

        consoleLog("Step 5a - Replace JA with JMP");
        exe.replace(offset, "EB " + diff.packToHex(1), PTYPE_HEX);

        return true;
    }

    code =
        "8B F9 " +                 // 00 mov edi, ecx
        "A1 " + LANGTYPE +         // 02 mov eax, g_serviceType
        "83 F8 AB " +              // 07 cmp eax, 12h
        "0F 87 AB AB AB AB " +     // 10 ja default
        "0F B6 80 AB AB AB AB " +  // 16 movzx eax, switch1_byte_AA28EC[eax]
        "FF 24 85 ";               // 23 jmp switch2_off_AA28C0[eax*4]

    var patchOffset = 2;
    var switch1Offset = 19;
    var switch2Offset = 26;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", korea_ref_offset - 0x100, korea_ref_offset);

    if (offset === -1)
    {
        code =
            "8B F9 " +              // 00 mov edi, ecx
            "A1 " + LANGTYPE +      // 02 mov eax, g_serviceType
            "83 F8 AB " +           // 07 cmp eax, 12h
            "0F 87 AB AB AB AB " +  // 10 ja default
            "FF 24 85 ";            // 16 jmp ds:switch2_off_82CD44[eax*4]

        patchOffset = 2;
        switch1Offset = 0;
        switch2Offset = 19;

        offset = exe.find(code, PTYPE_HEX, true, "\xAB", korea_ref_offset - 0x60, korea_ref_offset);
    }

    if (offset === -1)
        return "Failed in Step 3 - Pattern not found";

    consoleLog("Step 4b - Get switch jmp address for value 0");
    if (switch1Offset !== 0)
    {
        var addr1 = exe.Rva2Raw(exe.fetchDWord(offset + switch1Offset));
        var addr2 = exe.Rva2Raw(exe.fetchDWord(offset + switch2Offset));
        var offset1 = exe.fetchUByte(addr1);
    }
    else
    {
        var addr2 = exe.Rva2Raw(exe.fetchDWord(offset + switch2Offset));
        var offset1 = 0;
    }
    var jmpAddr = exe.fetchDWord(addr2 + 4 * offset1);

    code =
        "B8 " + jmpAddr.packToHex(4) +  // 00 mov eax, addr
        "FF E0 ";                       // 05 jmp eax

    consoleLog("Step 5b - Add jump to korean settings");
    exe.replace(offset + patchOffset, code, PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function AlwaysReadKrExtSettings_()
{
    var filePath = "Lua Files\\service_korea\\ExternalSettings_kr";

    if (IsZero())
        filePath = "Lua Files\\service_korea\\zero_server\\ExternalSettings_kr";

    return (exe.findString(filePath, RAW) !== -1);
}
