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
//#############################################################
//# Purpose: Allow close cutin by esc                         #
//#############################################################

function AllowCloseCutinByEsc()
{
    // step 1
    // search in UIIllustWnd_virt136 / case 6
    var code =
        "B9 AB AB AB AB" +  // mov ecx, offset g_modeMgr
        "E8 AB AB AB AB" +  // call CModeMgr::GetGameMode
        "8B 10" +           // mov edx, [eax]
        "6A 00" +           // push 0
        "6A AB" +           // push 1
        "6A FF" +           // push 0FFFFFFFFh
        "68 AB AB AB AB" +  // push offset EmptyStr
        "6A 64" +           // push 64h
        "8B C8" +           // mov ecx, eax
        "FF 52";            // call dword ptr [edx+18h] (CGameMode_virt24)

    var gModeMgrOffset = 1;
    var getGameModeOffset = 6;
    var EmptyStrOffset = 19;
    var vptrOffset = 29;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 1 - check pattern not found";

    logVaVar("g_modeMgr", offset, gModeMgrOffset);
    logRawFunc("CModeMgr_GetGameMode", offset, getGameModeOffset);
    var gModeMgrHex = exe.fetchDWord(offset + gModeMgrOffset).packToHex(4);
    var getGameModeHex = exe.Raw2Rva(exe.fetchDWord(offset + getGameModeOffset) + offset + getGameModeOffset + 4).packToHex(4);
    var emptyStrHex = exe.fetchDWord(offset + EmptyStrOffset).packToHex(4);
    var vptrHex = exe.fetchUByte(offset + vptrOffset).packToHex(1);

    // step 2
    // search in UIWindowMgr_sub_71C040 (called from UIWindowMgr_ProcessPushButton)
    // for if (UIWindowMgr_sub_70A020(v4, v11) || v11 != -1 && (unsigned __int8)UIWindowMgr_DeleteWindow(v4, v11) == 1)
    code =
        "56 " +                // push esi
        "8B CF " +             // mov ecx, edi
        "E8 AB AB AB AB " +    // call UIWindowMgr::check_close   <-- patch here
        "84 C0 " +             // test al, al
        "0F 85 AB AB AB AB " + // jnz addr2
        "83 FE FF " +          // cmp esi, 0FFFFFFFFh
        "74 10 " +             // jnz addr1
        "56 " +                // push esi
        "8B CF " +             // mov ecx, edi
        "E8 AB AB AB AB " +    // call UIWindowMgr::DeleteWindow
        "3C 01 " +             // cmp al, 1
        "0F 84 ";              // jz addr2
    var checkFuncOffset = 4;
    var deleteFuncOffset = 25;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 2 - check esc pattern not found";

    logRawFunc("UIWindowMgr_check_close", offset, checkFuncOffset);
    logRawFunc("UIWindowMgr_DeleteWindow", offset, deleteFuncOffset);

    checkFuncOffset = offset + checkFuncOffset;
    var deleteFuncAddr = exe.fetchDWord(offset + deleteFuncOffset) + offset + deleteFuncOffset + 4;
    var checkFuncAddr = exe.fetchDWord(checkFuncOffset) + checkFuncOffset + 4;

    var deleteHex = exe.Raw2Rva(deleteFuncAddr).packToHex(4);
    var checkHex = exe.Raw2Rva(checkFuncAddr).packToHex(4);
    var retHex = exe.Raw2Rva(checkFuncOffset + 4).packToHex(4);
    var widHex = (78).packToHex(4);

    // step 3
    // patch at location found at step 2

    var newCode =
        "51" +                  // PUSH ECX
        "68" + widHex +         // PUSH wid
        "B8" + deleteHex +      // MOV EAX, deleteFunc
        "FF D0" +               // CALL EAX
        "3C 00" +               // CMP AL, 0
        "75 0E" +               // JNZ SHORT +14
        "59" +                  // POP ECX
        "B8" + checkHex +       // MOV EAX, checkFunc
        "FF D0" +               // CALL EAX
        "68" + retHex +         // PUSH ret
        "C3" +                  // RETN
        "52" +                  // PUSH EDX
        "B9" + gModeMgrHex +    // mov ecx, offset g_modeMgr
        "B8" + getGameModeHex + // MOV EAX, CModeMgr::GetGameMode
        "FF D0" +               // CALL EAX
        "8B 10" +               // mov edx, [eax]
        "6A 00" +               // push 0
        "6A 01" +               // push 1
        "6A FF" +               // push 0FFFFFFFFh
        "68 " + emptyStrHex +   // push offset EmptyStr
        "6A 64" +               // push 64h
        "8B C8" +               // mov ecx, eax
        "FF 52" + vptrHex +     // call dword ptr [edx+18h]
        "5A" +                  // POP EDX
        "59" +                  // POP ECX
        "58" +                  // POP EAX
        "68" + retHex +         // PUSH ret
        "C3";                   // RETN

    var codeLen = newCode.hexlength();
    var free = exe.findZeros(codeLen);
    var freeRva = exe.Raw2Rva(free);

    exe.insert(free, codeLen, newCode, PTYPE_HEX);

    exe.replace(checkFuncOffset - 1, "E9" + (freeRva - exe.Raw2Rva(checkFuncOffset) - 4).packToHex(4), PTYPE_HEX); // replace call to check function into own function
    return true;
}
