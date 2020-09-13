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
//# Purpose: Change fade out delay for same map warpsother    #
//#############################################################

function ChangeFadeOutDelay()
{
    // step 1
    // search for fadeout for cycle in CMode::RunFadeOut
    var code =
        "8B 35 AB AB AB AB " +        // 0 mov esi, timeGetTime
        "FF D6 " +                    // 6 call esi ; timeGetTime
        "8B 0D AB AB AB AB " +        // 8 mov ecx, g_renderer
        "A3 AB AB AB AB " +           // 14 mov dwFadeStart, eax
        "E8 AB AB AB AB " +           // 19 call CRenderer_BackupFrame
        "FF D6 " +                    // 24 call esi ; timeGetTime
        "2B 05 AB AB AB AB " +        // 26 sub eax, dwFadeStart
        "3D AB 00 00 00 " +           // 32 cmp eax, 0FFh
        "0F 83 AB AB 00 00 ";         // 37 jnb loc_72005C
    var dwFadeStartOffset1 = 15;
    var dwFadeStartOffset2 = 28;
    var fadeOutDelayOffset1 = 33;
    var g_rendererOffset = 10;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        var code =
            "8B 35 AB AB AB AB " +        // 0 mov esi, ds:timeGetTime
            "83 C4 AB " +                 // 6 add esp, 18h
            "FF D6 " +                    // 9 call esi
            "8B 0D AB AB AB AB " +        // 11 mov ecx, g_renderer
            "A3 AB AB AB AB " +           // 17 mov dwFadeStart, eax
            "E8 AB AB AB AB " +           // 22 call CRenderer_BackupFrame
            "FF D6 " +                    // 27 call esi
            "2B 05 AB AB AB AB " +        // 29 sub eax, dwFadeStart
            "3D AB 00 00 00 " +           // 35 cmp eax, 0FFh
            "0F 83 AB AB 00 00 ";         // 40 jnb loc_5880DE
        var dwFadeStartOffset1 = 18;
        var dwFadeStartOffset2 = 31;
        var fadeOutDelayOffset1 = 36;
        var g_rendererOffset = 13;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    var addr1 = offset;
    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    var dwFadeStart = exe.fetchDWord(offset + dwFadeStartOffset1);
    if (dwFadeStart !== exe.fetchDWord(offset + dwFadeStartOffset2))
    {
        return "Failed in step 1 - found different dwFadeStart";
    }
    var fadeOutDelay = exe.fetchDWord(offset + fadeOutDelayOffset1);
    if (fadeOutDelay !== 0xff)
    {
        return "Failed in step 1 - found wrong fade out delay: " + fadeOutDelay;
    }
    var g_renderer = exe.fetchDWord(offset + g_rendererOffset);

    // step 2
    // search below in same function second delay usage

    var code =
        "8B 0D " + g_renderer.packToHex(4) +  // 0 mov ecx, g_renderer
        "E8 AB AB AB AB " +                   // 6 call CRenderer_RestoreFrame
        "FF D6 " +                            // 11 call esi ; timeGetTime
        "2B 05 " + dwFadeStart.packToHex(4) + // 13 sub eax, dwFadeStart
        "3D AB 00 00 00 " +                   // 19 cmp eax, 0FFh
        "0F 82 AB AB FF FF ";                 // 24 jb loc_71FFD0
    var fadeOutDelayOffset2 = 20;

    var offset = exe.find(code, PTYPE_HEX, true, "\xAB", addr1, addr1 + 0xc0);
    if (offset === -1)
        return "Failed in step 2 - pattern not found";
    var addr2 = offset;

    // step 3
    // seach for separate fadeout code in CMode_ProcessFadeIn
    var code =
        "FF 15 AB AB AB AB " +        // 0 call timeGetTime
        "2B 05 " + dwFadeStart.packToHex(4) + // 6 sub eax, dwFadeStart
        "5E " +                       // 12 pop esi
        "3D AB 00 00 00 " +           // 13 cmp eax, 0FFh
        "73 AB " +                    // 18 jnb short locret_71FDBC
        "B9 AB 00 00 00 " +           // 20 mov ecx, 0FFh
        "2B C8 " +                    // 25 sub ecx, eax
        "A1 " + g_renderer.packToHex(4) + // 27 mov eax, g_renderer
        "C1 E1 18 " +                 // 32 shl ecx, 18h
        "51 ";                        // 35 push ecx
    var fadeOutDelayOffset3 = 14;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        var code =
            "FF D7 " +                    // 0 call edi
            "2B 05 " + dwFadeStart.packToHex(4) + // 2 sub eax, dwFadeStart
            "5F " +                       // 8 pop edi
            "5E " +                       // 9 pop esi
            "3D AB 00 00 00 " +           // 10 cmp eax, 0FFh
            "73 AB " +                    // 15 jnb short loc_587FF4
            "BA AB 00 00 00 " +           // 17 mov edx, 0FFh
            "2B D0 " +                    // 22 sub edx, eax
            "A1 " + g_renderer.packToHex(4) + // 24 mov eax, g_renderer
            "8B 48 AB " +                 // 29 mov ecx, [eax+28h]
            "C1 E2 18 " +                 // 32 shl edx, 18h
            "52 ";                        // 35 push edx
        var fadeOutDelayOffset3 = 11;
        var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    var addr3 = offset;
    if (offset === -1)
        return "Failed in step 3 - pattern not found";

    // step 4
    var delay = exe.getUserInput("$warpFadeOutDelay", XTYPE_DWORD, _("Number Input"), _("Enter new fadeout delay in ms (0-255, 0 - disable, default is 255):"), 255, 0, 255);
    if (delay === 255)
    {
        return "Patch Cancelled - New value is same as old";
    }

    // first delay in fade out function
    exe.replace(addr1 + fadeOutDelayOffset1, delay.packToHex(4), PTYPE_HEX);
    // second delay in fade out function
    exe.replace(addr2 + fadeOutDelayOffset2, delay.packToHex(4), PTYPE_HEX);
    // separate fade out code
    exe.replace(addr3 + fadeOutDelayOffset3, delay.packToHex(4), PTYPE_HEX);

    return true;
}
