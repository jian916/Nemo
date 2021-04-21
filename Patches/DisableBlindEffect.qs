//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020-2021 Andrei Karas (4144)
// Copyright (C) 2020-2021 X-EcutiOnner (xex.ecutionner@gmail.com)
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
        "0F 85 ?? 01 00 00 " +  // 00 jnz loc_66BB7A
        "83 EC 0C " +           // 06 sub esp, 0Ch
        "8B D3 " +              // 09 mov edx, ebx
        "8B CC " +              // 11 mov ecx, esp
        "8B C3 " +              // 13 mov eax, ebx
        "6A 47 " +              // 15 push 47h ; 'G'
        "89 5D ?? " +           // 17 mov [ebp+var_C], ebx
        "89 11 " +              // 20 mov [ecx], edx
        "89 5D ?? " +           // 22 mov [ebp+var_8], ebx
        "89 5D ?? " +           // 25 mov [ebp+var_4], ebx
        "89 ?? 04 " +           // 28 mov [ecx+4], eax
        "89 ?? 08 " +           // 31 mov [ecx+8], edx
        "8B CE " +              // 34 mov ecx, esi
        "E8 ?? ?? ?? ?? " +     // 36 call CRagEffect_LaunchEffectPrim
        "A3 ?? ?? ?? 00 " +     // 41 mov g_prim, eax
        "?? 88 ?? ?? 00 00 ";   // 46 mov ecx, [eax+180h]

    var repLoc = 52;
    var LaunchEffectPrimOffset = 37;
    var gPrimOffset = 42;
    var mPrimOffset = 0;

    var offset = pe.findCode(code);

    if (offset === -1)
    {
        code =
            "0F 85 ?? 01 00 00 " +  // 00 jnz loc_67922E
            "83 EC 0C " +           // 06 sub esp, 0Ch
            "8B D3 " +              // 09 mov edx, ebx
            "8B CC " +              // 11 mov ecx, esp
            "8B C3 " +              // 13 mov eax, ebx
            "6A 47 " +              // 15 push 47h ; 'G'
            "89 5D ?? " +           // 17 mov [ebp+var_C], ebx
            "89 11 " +              // 20 mov [ecx], edx
            "89 5D ?? " +           // 22 mov [ebp+var_8], ebx
            "89 5D ?? " +           // 25 mov [ebp+var_4], ebx
            "89 ?? 04 " +           // 28 mov [ecx+4], eax
            "89 ?? 08 " +           // 31 mov [ecx+8], edx
            "8B CE " +              // 34 mov ecx, esi
            "E8 ?? ?? ?? ?? " +     // 36 call CRagEffect_LaunchEffectPrim
            "89 ?? ?? ?? ?? 00 " +  // 41 mov [esi+CRagEffect.m_prim], eax
            "?? 88 ?? ?? 00 00 ";   // 47 mov ecx, [eax+180h]

        repLoc = 53;
        LaunchEffectPrimOffset = 37;
        gPrimOffset = 0;
        mPrimOffset = [43, 4];

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "0F 85 ?? 01 00 00 " +             // 00 jnz loc_7164A3
            "D9 EE " +                         // 06 fldz
            "83 EC 0C " +                      // 08 sub esp, 0Ch
            "8B C4 " +                         // 11 mov eax, esp
            "D9 54 24 ?? " +                   // 13 fst [esp+20h+var_C]
            "8B 4C 24 ?? " +                   // 17 mov ecx, [esp+20h+var_C]
            "D9 54 24 ?? " +                   // 21 fst [esp+20h+var_8]
            "8B 54 24 ?? " +                   // 25 mov edx, [esp+20h+var_8]
            "D9 5C 24 ?? " +                   // 29 fstp [esp+20h+var_4]
            "89 08 " +                         // 33 mov [eax], ecx
            "8B 4C 24 ?? " +                   // 35 mov ecx, [esp+20h+var_4]
            "89 ?? 04 " +                      // 39 mov [eax+4], edx
            "89 ?? 08 " +                      // 42 mov [eax+8], ecx
            "6A 47 " +                         // 45 push 47h ; 'G'
            "8B CE " +                         // 47 mov ecx, esi
            "E8 ?? ?? ?? ?? " +                // 49 call CRagEffect_LaunchEffectPrim
            "89 ?? ?? ?? ?? 00 " +             // 54 mov [esi+CRagEffect.m_prim], eax
            "?? 88 ?? ?? 00 00 00 02 00 00 ";  // 60 or dword ptr [eax+198h], 200h

        repLoc = 70;
        LaunchEffectPrimOffset = 50;
        gPrimOffset = 0;
        mPrimOffset = [56, 4];

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "0F 85 ?? 01 00 00 " +             // 00 jnz loc_78E94A
            "D9 EE " +                         // 06 fldz
            "83 EC 0C " +                      // 08 sub esp, 0Ch
            "8B C4 " +                         // 11 mov eax, esp
            "D9 55 ?? " +                      // 13 fst [ebp+var_C]
            "8B 4D ?? " +                      // 16 mov ecx, [ebp+var_C]
            "D9 55 ?? " +                      // 19 fst [ebp+var_8]
            "8B 55 ?? " +                      // 22 mov edx, [ebp+var_8]
            "D9 5D ?? " +                      // 25 fstp [ebp+var_4]
            "89 08 " +                         // 28 mov [eax], ecx
            "8B 4D ?? " +                      // 30 mov ecx, [ebp+var_4]
            "89 ?? 04 " +                      // 33 mov [eax+4], edx
            "89 ?? 08 " +                      // 36 mov [eax+8], ecx
            "6A 47 " +                         // 39 push 47h ; 'G'
            "8B CE " +                         // 41 mov ecx, esi
            "E8 ?? ?? ?? ?? " +                // 43 call CRagEffect_LaunchEffectPrim
            "89 ?? ?? ?? ?? 00 " +             // 48 mov [esi+CRagEffect.m_prim], eax
            "?? 88 ?? ?? 00 00 00 02 00 00 ";  // 54 or dword ptr [eax+1A4h], 200h

        repLoc = 64;
        LaunchEffectPrimOffset = 44;
        gPrimOffset = 0;
        mPrimOffset = [50, 4];

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "0F 85 ?? 01 00 00 " +             // 00 jnz loc_8A8AA4
            "83 EC 0C " +                      // 06 sub esp, 0Ch
            "8B CC " +                         // 09 mov ecx, esp
            "C7 45 ?? 00 00 00 00 " +          // 11 mov dword ptr [ebp+var_C], 0
            "C7 45 ?? 00 00 00 00 " +          // 18 mov dword ptr [ebp+var_C+4], 0
            "F3 0F 7E 45 ?? " +                // 25 movq xmm0, [ebp+var_C]
            "C7 45 ?? 00 00 00 00 " +          // 30 mov [ebp+var_4], 0
            "8B 45 ?? " +                      // 37 mov eax, [ebp+var_4]
            "66 0F D6 01 " +                   // 40 movq qword ptr [ecx], xmm0
            "89 ?? 08 " +                      // 44 mov [ecx+8], eax
            "6A 47 " +                         // 47 push 47h ; 'G'
            "8B CE " +                         // 49 mov ecx, esi
            "E8 ?? ?? ?? ?? " +                // 51 call CRagEffect_LaunchEffectPrim
            "89 ?? ?? ?? ?? 00 " +             // 56 mov [esi+CRagEffect.m_prim], eax
            "?? 88 ?? ?? 00 00 00 02 00 00 ";  // 62 or dword ptr [eax+1B4h], 200h

        repLoc = 72;
        LaunchEffectPrimOffset = 52;
        gPrimOffset = 0;
        mPrimOffset = [58, 4];

        offset = pe.findCode(code);
    }

    if (offset === -1)
    {
        code =
            "0F 85 ?? 01 00 00 " +             // 00 jnz loc_6D3A11
            "83 EC 0C " +                      // 06 sub esp, 0Ch
            "C7 45 ?? 00 00 00 00 " +          // 09 mov [ebp+var_4], 0
            "8B 45 ?? " +                      // 16 mov eax, [ebp+var_4]
            "8B CC " +                         // 19 mov ecx, esp
            "0F 57 C0 " +                      // 21 xorps xmm0, xmm0
            "0F 14 C0 " +                      // 24 unpcklps xmm0, xmm0
            "6A 47 " +                         // 27 push 47h ; 'G'
            "66 0F D6 01 " +                   // 29 movq qword ptr [ecx], xmm0
            "89 ?? 08 " +                      // 33 mov [ecx+8], eax
            "8B CE " +                         // 36 mov ecx, esi
            "E8 ?? ?? ?? ?? " +                // 38 call CRagEffect_LaunchEffectPrim
            "89 ?? ?? ?? ?? 00 " +             // 43 mov [esi+CRagEffect.m_prim], eax
            "BA 04 00 00 00 " +                // 49 mov edx, 4
            "?? 88 ?? ?? 00 00 00 02 00 00 ";  // 54 or dword ptr [eax+1BCh], 200h

        repLoc = 64;
        LaunchEffectPrimOffset = 39;
        gPrimOffset = 0;
        mPrimOffset = [45, 4];

        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    logRawFunc("CRagEffect_LaunchEffectPrim", offset, LaunchEffectPrimOffset);
    if (gPrimOffset !== 0)
    {
        logVaVar("g_prim", offset, gPrimOffset);
    }
    if (mPrimOffset !== 0)
    {
        logField("CEffectPrim::m_prim", offset, mPrimOffset);
    }

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
