//
// Copyright (C) 2018-2019  Andrei Karas (4144)
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
//################################################################################
//# Purpose: Hide date based on zero values (1969-01-01) in guilds member window #
//################################################################################

function HideZeroDateInGuildMembers()
{
    // step 1
    // search in function called from UIGuildMemberManageWnd_virt68
    var code =
        "8D 47 AB " +                 // 0 lea eax, [edi+74h]
        "50 " +                       // 3 push eax
        "C7 85 AB AB AB AB 0F 00 00 00 " + // 4 mov [ebp+arg0.m_allocated_len], 0Fh
        "C7 85 AB AB AB AB 00 00 00 00 " + // 14 mov [ebp+arg0.m_len], 0
        "C6 85 AB AB AB AB 00 " +     // 24 mov byte ptr [ebp+arg0.m_cstr], 0
        "FF 15 AB AB AB AB " +        // 31 call _localtime32
        "83 C4 04 " +                 // 37 add esp, 4
        "50 " +                       // 40 push eax
        "68 C3 0B 00 00 " +           // 41 push 0BC3h
        "E8 AB AB AB AB " +           // 46 call MsgStr
        "83 C4 04 " +                 // 51 add esp, 4
        "50 " +                       // 54 push eax
        "8D 85 AB AB AB AB " +        // 55 lea eax, [ebp+timeStr]
        "68 AB 00 00 00 " +           // 61 push 80h
        "50 " +                       // 66 push eax
        "FF 15 AB AB AB AB " +        // 67 call strftime
        "83 C4 10 " +                 // 73 add esp, 10h
        "8D 85 AB AB AB AB " +        // 76 lea eax, [ebp+timeStr]
        "50 " +                       // 82 push eax
        "68 C4 0B 00 00 " +           // 83 push 0BC4h
        "E8 ";                        // 88 call MsgStr
    var msgStrOffset1 = 47;
    var msgStrOffset2 = 89;
    var timeStrOffset1 = 57;
    var timeStrOffset2 = 78;
    var patchOffset = 31;
    var localTimeOffset = 33;
    var jmp1Offset = 37;
    var jmp2Offset = 82;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        var code =
            "8D 47 AB " +                 // 0 lea eax, [edi+74h]
            "50 " +                       // 3 push eax
            "C6 85 AB AB AB AB 00 " +     // 4 mov byte ptr [ebp+arg0.m_cstr], 0
            "C7 85 AB AB AB AB 00 00 00 00 " + // 11 mov [ebp+arg0.m_len], 0
            "C7 85 AB AB AB AB 0F 00 00 00 " + // 21 mov [ebp+arg0.m_allocated_len], 0Fh
            "FF 15 AB AB AB AB " +        // 31 call _localtime32
            "83 C4 04 " +                 // 37 add esp, 4
            "50 " +                       // 40 push eax
            "68 C3 0B 00 00 " +           // 41 push 0BC3h
            "E8 AB AB AB AB " +           // 46 call MsgStr
            "83 C4 04 " +                 // 51 add esp, 4
            "50 " +                       // 54 push eax
            "8D 85 AB AB AB AB " +        // 55 lea eax, [ebp+timeStr]
            "68 AB 00 00 00 " +           // 61 push 80h
            "50 " +                       // 66 push eax
            "FF 15 AB AB AB AB " +        // 67 call strftime
            "83 C4 10 " +                 // 73 add esp, 10h
            "8D 85 AB AB AB AB " +        // 76 lea eax, [ebp+timeStr]
            "50 " +                       // 82 push eax
            "68 C4 0B 00 00 " +           // 83 push 0BC4h
            "E8 ";                        // 88 call MsgStr
        var msgStrOffset1 = 47;
        var msgStrOffset2 = 89;
        var timeStrOffset1 = 57;
        var timeStrOffset2 = 78;
        var patchOffset = 31;
        var localTimeOffset = 33;
        var jmp1Offset = 37;
        var jmp2Offset = 82;
        var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    var msgStr1 = exe.Raw2Rva(exe.fetchDWord(offset + msgStrOffset1) + offset + msgStrOffset1 + 4);
    var msgStr2 = exe.Raw2Rva(exe.fetchDWord(offset + msgStrOffset2) + offset + msgStrOffset2 + 4);
    var localTime = exe.fetchDWord(offset + localTimeOffset).packToHex(4);
    var timeStr1 = exe.fetchDWord(offset + timeStrOffset1);
    var timeStr2 = exe.fetchDWord(offset + timeStrOffset2);
    if (msgStr1 !== msgStr2)
    {
        return "Failed in step 1 - found different MsgStr";
    }
    if (timeStr1 != timeStr2)
    {
        return "Failed in step 1 - found different timeStr";
    }

    // step 2

    var timeStr = timeStr1.packToHex(4);
    var jmp1Addr = exe.Raw2Rva(offset + jmp1Offset).packToHex(4);
    var jmp2Addr = exe.Raw2Rva(offset + jmp2Offset).packToHex(4);

    var newCode =
        "83 38 00 " +          // cmp [eax], 0
        "74 0C " +             // jz +C
        "FF 15 " + localTime + // call localtime
        "68 " + jmp1Addr +     // push jmpAddr
        "C3" +                 // retn
        "58 " +                // pop eax
        "8D 85 " + timeStr +   // lea eax, [ebp+timeStr]
        "C7 00 00 00 00 00 " + // mov [eax], 0
        "68 " + jmp2Addr +     // push jmpAddr
        "C3";                  // retn

    var codeLen = newCode.hexlength();
    var free = exe.findZeros(codeLen);
    var freeRva = exe.Raw2Rva(free).packToHex(4);
    exe.insert(free, codeLen, newCode, PTYPE_HEX);

    // step 3
    var patchAddr = offset + patchOffset;

    code =
        "68 " + freeRva +  // push jmpAddr
        "C3";              // retn
    exe.replace(patchAddr, code, PTYPE_HEX);
    return true;
}
