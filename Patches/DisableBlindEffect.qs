//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020 Andrei Karas (4144)
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
//###########################################################################
//# Purpose: Change the JNZ after comparison to disable Blind skills effect #
//#          from blending darkness screen inside SkillEffect function.     #
//###########################################################################

function DisableBlindEffect()
{
    consoleLog("Step 1 - Search pattern for Blind effect");
    var code =
        "0F 85 AB 01 00 00 " +  // 00 jnz loc_66BB7A
        "83 EC 0C " +           // 06 sub esp, 0Ch
        "8B D3 " +              // 09 mov edx, ebx
        "8B CC " +              // 11 mov ecx, esp
        "8B C3 " +              // 13 mov eax, ebx
        "6A AB " +              // 15 push 47h ; 'G'
        "89 5D F4 " +           // 17 mov [ebp+var_C], ebx
        "89 11 " +              // 20 mov [ecx], edx
        "89 5D F8 " +           // 22 mov [ebp+var_8], ebx
        "89 5D FC " +           // 25 mov [ebp+var_4], ebx
        "89 AB 04 " +           // 28 mov [ecx+4], eax
        "89 AB 08 " +           // 31 mov [ecx+8], edx
        "8B CE " +              // 34 mov ecx, esi
        "E8 AB AB AB FF " +     // 36 call sub_625980
        "A3 AB AB AB 00 " +     // 41 mov dword_834B28, eax
        "AB 88 AB 01 00 00 ";   // 46 mov ecx, [eax+180h]

    var repLoc = 52;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code =
            "0F 85 AB 01 00 00 " +  // 00 jnz loc_67922E
            "83 EC 0C " +           // 06 sub esp, 0Ch
            "8B D3 " +              // 09 mov edx, ebx
            "8B CC " +              // 11 mov ecx, esp
            "8B C3 " +              // 13 mov eax, ebx
            "6A AB " +              // 15 push 47h ; 'G'
            "89 5D F4 " +           // 17 mov [ebp+var_C], ebx
            "89 11 " +              // 20 mov [ecx], edx
            "89 5D F8 " +           // 22 mov [ebp+var_8], ebx
            "89 5D FC " +           // 25 mov [ebp+var_4], ebx
            "89 AB 04 " +           // 28 mov [ecx+4], eax
            "89 AB 08 " +           // 31 mov [ecx+8], edx
            "8B CE " +              // 34 mov ecx, esi
            "E8 AB AB AB FF " +     // 36 call sub_631C20
            "89 AB AB AB AB 00 " +  // 41 mov [esi+11C40h], eax
            "AB 88 AB 01 00 00 ";   // 47 mov ecx, [eax+180h]

        repLoc = 53;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "0F 85 AB 01 00 00 " +             // 00 jnz loc_7164A3
            "D9 EE " +                         // 06 fldz
            "83 EC 0C " +                      // 08 sub esp, 0Ch
            "8B C4 " +                         // 11 mov eax, esp
            "D9 54 24 14 " +                   // 13 fst [esp+20h+var_C]
            "8B 4C 24 14 " +                   // 17 mov ecx, [esp+20h+var_C]
            "D9 54 24 18 " +                   // 21 fst [esp+20h+var_8]
            "8B 54 24 18 " +                   // 25 mov edx, [esp+20h+var_8]
            "D9 5C 24 1C " +                   // 29 fstp [esp+20h+var_4]
            "89 08 " +                         // 33 mov [eax], ecx
            "8B 4C 24 1C " +                   // 35 mov ecx, [esp+20h+var_4]
            "89 AB 04 " +                      // 39 mov [eax+4], edx
            "89 AB 08 " +                      // 42 mov [eax+8], ecx
            "6A AB " +                         // 45 push 47h ; 'G'
            "8B CE " +                         // 47 mov ecx, esi
            "E8 AB AB AB FF " +                // 49 call sub_6D8D90
            "89 AB AB AB AB 00 " +             // 54 mov [esi+11C5Ch], eax
            "AB 88 AB 01 00 00 00 02 00 00 ";  // 60 or dword ptr [eax+198h], 200h

        repLoc = 70;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "0F 85 AB 01 00 00 " +             // 00 jnz loc_78E94A
            "D9 EE " +                         // 06 fldz
            "83 EC 0C " +                      // 08 sub esp, 0Ch
            "8B C4 " +                         // 11 mov eax, esp
            "D9 55 F4 " +                      // 13 fst [ebp+var_C]
            "8B 4D F4 " +                      // 16 mov ecx, [ebp+var_C]
            "D9 55 F8 " +                      // 19 fst [ebp+var_8]
            "8B 55 F8 " +                      // 22 mov edx, [ebp+var_8]
            "D9 5D FC " +                      // 25 fstp [ebp+var_4]
            "89 08 " +                         // 28 mov [eax], ecx
            "8B 4D FC " +                      // 30 mov ecx, [ebp+var_4]
            "89 AB 04 " +                      // 33 mov [eax+4], edx
            "89 AB 08 " +                      // 36 mov [eax+8], ecx
            "6A AB " +                         // 39 push 47h ; 'G'
            "8B CE " +                         // 41 mov ecx, esi
            "E8 AB AB AB FF " +                // 43 call sub_751A70
            "89 AB AB AB AB 00 " +             // 48 mov [esi+11C68h], eax
            "AB 88 AB 01 00 00 00 02 00 00 ";  // 54 or dword ptr [eax+1A4h], 200h

        repLoc = 64;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "0F 85 AB 01 00 00 " +             // 00 jnz loc_8A8AA4
            "83 EC 0C " +                      // 06 sub esp, 0Ch
            "8B CC " +                         // 09 mov ecx, esp
            "C7 45 F4 00 00 00 00 " +          // 11 mov dword ptr [ebp+var_C], 0
            "C7 45 F8 00 00 00 00 " +          // 18 mov dword ptr [ebp+var_C+4], 0
            "F3 0F 7E 45 F4 " +                // 25 movq xmm0, [ebp+var_C]
            "C7 45 FC 00 00 00 00 " +          // 30 mov [ebp+var_4], 0
            "8B 45 FC " +                      // 37 mov eax, [ebp+var_4]
            "66 0F D6 01 " +                   // 40 movq qword ptr [ecx], xmm0
            "89 AB 08 " +                      // 44 mov [ecx+8], eax
            "6A AB " +                         // 47 push 47h ; 'G'
            "8B CE " +                         // 49 mov ecx, esi
            "E8 AB AB AB FF " +                // 51 call sub_88AA90
            "89 AB AB AB AB 00 " +             // 56 mov [esi+11C74h], eax
            "AB 88 AB 01 00 00 00 02 00 00 ";  // 62 or dword ptr [eax+1B4h], 200h

        repLoc = 72;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "0F 85 AB 01 00 00 " +             // 00 jnz loc_6D3A11
            "83 EC 0C " +                      // 06 sub esp, 0Ch
            "C7 45 FC 00 00 00 00 " +          // 09 mov [ebp+var_4], 0
            "8B 45 FC " +                      // 16 mov eax, [ebp+var_4]
            "8B CC " +                         // 19 mov ecx, esp
            "0F 57 C0 " +                      // 21 xorps xmm0, xmm0
            "0F 14 C0 " +                      // 24 unpcklps xmm0, xmm0
            "6A AB " +                         // 27 push 47h ; 'G'
            "66 0F D6 01 " +                   // 29 movq qword ptr [ecx], xmm0
            "89 AB 08 " +                      // 33 mov [ecx+8], eax
            "8B CE " +                         // 36 mov ecx, esi
            "E8 AB AB AB FF " +                // 38 call loc_6B1660
            "89 AB AB AB AB 00 " +             // 43 mov [esi+11C7Ch], eax
            "BA 04 00 00 00 " +                // 49 mov edx, 4
            "AB 88 AB 01 00 00 00 02 00 00 ";  // 54 or dword ptr [eax+1BCh], 200h

        repLoc = 64;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    consoleLog("Step 2 - Replace the JE with NOP + JMP");
    exe.replace(offset + code.hexlength() - repLoc, "90 E9 ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableBlindEffect_()
{
    return (exe.getClientDate() > 20020000);
}
