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
//# Change shield z offset to draw shield over other sprites  #
//# in CPc_RenderBodyLayer                                    #
//#############################################################

function MoveShieldToTopPatch(floatAddr, offset, offset2, patchAddrOffset, continueOffset, cntOffset)
{
    var oowOffset = 0x10;
    var oowUpOffset = 0x14;
    var stolenCodeSize = 7;
    var patchAddr = offset + patchAddrOffset;
    var continueAddr = exe.Raw2Rva(offset) + continueOffset;
    var stolenCode = exe.fetchHex(offset + patchAddrOffset, stolenCodeSize);
    var cntHex = exe.fetchDWord(offset2 + cntOffset).packToHex(4);

    // step 4 - insert code for adjust oow/oowup
    var code =
        stolenCode +         // lea eax, [ebp+spr]
                             // push eax
        "8B 85 " + cntHex +  // mov eax, [ebp+cnt]
        "83 F8 00 " +        // cmp eax, 0
        "75 26" +            // jnz +26h
        "58" +               // pop eax
        "50 " +              // push eax
        "F3 0F 10 40 " + oowOffset.packToHex(1) +   // movss xmm0, [eax + oow]
        "F3 0F 58 05 " + floatAddr.packToHex(4) +   // addss xmm0, [floatAddr]
        "F3 0F 11 40 " + oowOffset.packToHex(1) +   // movss [eax + oow], xmm0
        "F3 0F 10 40 " + oowUpOffset.packToHex(1) + // movss xmm0, [eax + oowUp]
        "F3 0F 58 05 " + floatAddr.packToHex(4) +   // addss xmm0, [floatAddr]
        "F3 0F 11 40 " + oowUpOffset.packToHex(1) + // movss [eax + oowUp], xmm0
        "B8" + continueAddr.packToHex(4) + // mov eax, continueAddr
        "FF E0" +                // jmp eax
        "";

    var free = exe.findZeros(code.hexlength());
    if (free === -1)
        throw "Not enough free space";
    exe.insert(free, code.hexlength(), code, PTYPE_HEX);

    // step 5 - add jump to own code
    code =
        "B8" + exe.Raw2Rva(free).packToHex(4) + // mov eax, addr1
        "FF E0"                                 // jmp eax
    exe.replace(patchAddr, code, PTYPE_HEX); // add jump to own code
}

function MoveShieldToTop()
{
    // step 1 -  add float number
    var floatAddr = exe.findZeros(4);
    if (floatAddr === -1)
        return "Not enough free space";
    var code =
//        floatToHex(0.0005);
        floatToHex(0.001);
    exe.insert(floatAddr, 4, code, PTYPE_HEX);
    floatAddr = exe.Raw2Rva(floatAddr);

    // step 2 - search block for patching in CPc_RenderBodyLayer
    var code =
        "B9 AB AB AB AB " +           // 0 mov ecx, offset g_session
        "E8 AB AB AB AB " +           // 5 call CSession_sub_AA0510
        "83 EC 08 " +                 // 10 sub esp, 8
        "3C 01 " +                    // 13 cmp al, 1
        "8B 45 AB " +                 // 15 mov eax, [ebp+a2]
        "8B CF " +                    // 18 mov ecx, edi
        "75 25 " +                    // 20 jnz short loc_A67326
        "F3 0F 10 45 AB " +           // 22 movss xmm0, [ebp+y]
        "F3 0F 11 44 24 AB " +        // 27 movss [esp+20Ch+A], xmm0
        "F3 0F 10 45 AB " +           // 33 movss xmm0, [ebp+x]
        "F3 0F 11 04 AB " +           // 38 movss [esp+20Ch+B], xmm0
        "56 " +                       // 43 push esi
        "50 " +                       // 44 push eax
        "8D 85 AB AB AB AB " +        // 45 lea eax, [ebp+spr]
        "50 " +                       // 51 push eax
        "E8 AB AB AB AB " +           // 52 call CRenderObject_RenderSprite2
        "EB 1D " +                    // 57 jmp short loc_A67343
        "C7 44 24 AB 00 00 00 00 " +  // 59 mov [esp+20Ch+A], 0
        "C7 04 AB 00 00 00 00 " +     // 67 mov [esp+20Ch+B], 0
        "56 " +                       // 74 push esi
        "50 " +                       // 75 push eax
        "8D 85 AB AB AB AB " +        // 76 lea eax, [ebp+spr]
        "50 " +                       // 82 push eax
        "E8 ";                        // 83 call CRenderObject_RenderSprite
    var sprOffset1 = 47;
    var sprOffset2 = 78;
    var aOffset1 = 32;
    var aOffset2 = 62;
    var bOffset1 = 42;
    var bOffset2 = 69;
    var patchAddrOffset1 = 45;
    var continueOffset1 = 52;
    var patchAddrOffset2 = 76;
    var continueOffset2 = 83;
    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");

    if (offsets.length === 0)
    {
        var code =
            "B9 AB AB AB AB " +           // 0 mov ecx, offset g_session
            "E8 AB AB AB AB " +           // 5 call CSession_sub_ADB710
            "3C 01 " +                    // 10 cmp al, 1
            "75 2D " +                    // 12 jnz short loc_AA1DED
            "F3 0F 10 45 AB " +           // 14 movss xmm0, [ebp+var_68]
            "8B 45 AB " +                 // 19 mov eax, [ebp+pal]
            "83 EC 08 " +                 // 22 sub esp, 8
            "8B CF " +                    // 25 mov ecx, edi
            "F3 0F 11 44 24 AB " +        // 27 movss [esp+1B0h+A], xmm0
            "F3 0F 10 45 AB " +           // 33 movss xmm0, [ebp+var_64]
            "F3 0F 11 04 AB " +           // 38 movss [esp+1B0h+B], xmm0
            "56 " +                       // 43 push esi
            "50 " +                       // 44 push eax
            "8D 85 AB AB AB AB " +        // 45 lea eax, [ebp+spr]
            "50 " +                       // 51 push eax
            "E8 AB AB AB AB " +           // 52 call CRenderObject_RenderSprite2
            "EB 50 " +                    // 57 jmp short loc_AA1E3D
            "83 7D AB AB " +              // 59 cmp [ebp+a3], 1
            "75 25 " +                    // 63 jnz short loc_AA1E18
            "0F BE 45 AB " +              // 65 movsx eax, [ebp+a4]
            "48 " +                       // 69 dec eax
            "74 13 " +                    // 70 jz short loc_AA1E0D
            "48 " +                       // 72 dec eax
            "75 1B " +                    // 73 jnz short loc_AA1E18
            "85 DB " +                    // 75 test ebx, ebx
            "74 05 " +                    // 77 jz short loc_AA1E06
            "83 FB AB " +                 // 79 cmp ebx, 1
            "75 12 " +                    // 82 jnz short loc_AA1E18
            "BE AB AB AB AB " +           // 84 mov esi, 11h
            "EB 0B " +                    // 89 jmp short loc_AA1E18
            "83 FB AB " +                 // 91 cmp ebx, 5
            "B8 AB AB AB AB " +           // 94 mov eax, 5
            "0F 44 F0 " +                 // 99 cmovz esi, eax
            "8B 45 AB " +                 // 102 mov eax, [ebp+pal]
            "83 EC 08 " +                 // 105 sub esp, 8
            "8B CF " +                    // 108 mov ecx, edi
            "C7 44 24 AB 00 00 00 00 " +  // 110 mov [esp+1B0h+A], 0
            "C7 04 AB 00 00 00 00 " +     // 118 mov [esp+1B0h+B], 0
            "56 " +                       // 125 push esi
            "50 " +                       // 126 push eax
            "8D 85 AB AB AB AB " +        // 127 lea eax, [ebp+spr]
            "50 " +                       // 133 push eax
            "E8 ";                        // 134 call CRenderObject_RenderSprite

        var sprOffset1 = 47;
        var sprOffset2 = 129;
        var aOffset1 = 32;
        var aOffset2 = 113;
        var bOffset1 = 42;
        var bOffset2 = 120;
        var patchAddrOffset1 = 45;
        var continueOffset1 = 52;
        var patchAddrOffset2 = 127;
        var continueOffset2 = 134;
        var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
        return "Failed in Step 2 - pattern not found";
    if (offsets.length !== 1)
        return "Failed in Step 2 - found too many patterns";

    var offset = offsets[0]

    var spr1 = exe.fetchDWord(offset + sprOffset1);
    var spr2 = exe.fetchDWord(offset + sprOffset2);
    if (spr1 != spr2)
        return "Failed in Step 2 - found different spr offsets";
    var a1 = exe.fetchUByte(offset + aOffset1);
    var a2 = exe.fetchUByte(offset + aOffset2);
    if (a1 != a2)
        return "Failed in Step 2 - found different a offsets";
    var b1 = exe.fetchUByte(offset + bOffset1);
    var b2 = exe.fetchUByte(offset + bOffset2);
    if (b1 != b2)
        return "Failed in Step 2 - found different b offsets";

    // step 3 - search cnt init in same function
    code =
        "BB 07 00 00 00 " +           // 0 mov ebx, 7
        "89 9D AB AB AB AB " +        // 5 mov [ebp+cnt], ebx
        "8B 4F AB " +                 // 11 mov ecx, [edi+38h]
        "8B 57 AB " +                 // 14 mov edx, [edi+3Ch]
        "8B C1 " +                    // 17 mov eax, ecx
        "2B 47 AB " +                 // 19 sub eax, [edi+34h]
        "83 C0 FE " +                 // 22 add eax, 0FFFFFFFEh
        "83 F8 03 ";                  // 25 cmp eax, 3
    var cntOffset = 7;

    var offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x1000, offset);
    if (offset2 === -1)
        return "Failed in step 3 - cnt not found";

    MoveShieldToTopPatch(floatAddr, offset, offset2, patchAddrOffset1, continueOffset1, cntOffset);
    MoveShieldToTopPatch(floatAddr, offset, offset2, patchAddrOffset2, continueOffset2, cntOffset);

    return true;
}
