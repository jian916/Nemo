//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2021 Andrei Karas (4144)
// Copyright (C) 2018-2021 X-EcutiOnner (xex.ecutionner@gmail.com)
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
//#####################################################################
//# Purpose: NOPs out the JZ following TEST EAX, EAX after Comparison #
//#          to Show Damage on GvG Maps during the Guild War.         #
//#####################################################################

function EnableGvGDamage()
{
    consoleLog("Step 1 - Prep code for finding the GvG Damage display");
    var code =
        getEcxSessionHex() +          // 0 mov ecx, offset g_session
        "E8 ?? ?? ?? ?? " +           // 5 call CSession_IsSiegeMode
        "85 C0 " +                    // 10 test eax, eax
        "75 0E " +                    // 12 jnz short loc_99A826
        getEcxSessionHex() +          // 14 mov ecx, offset g_session
        "E8 ?? ?? ?? ?? " +           // 19 call CSession_IsBattleFieldMode
        "85 C0 " +                    // 24 test eax, eax
        "74 14 " +                    // 26 jz short loc_99A83A
        "6A 07 " +                    // 28 push 7
        getEcxSessionHex() +          // 30 mov ecx, offset g_session
        "E8 ?? ?? ?? ?? " +           // 35 call CSession_IsMasterAid
        "85 C0 " +                    // 40 test eax, eax
        "0F 84 ?? ?? 00 00 ";         // 42 jz loc_9A1A84
    var nopsStart = 0;
    var nopsEnd = 48;
    var IsSiegeModeOffset = 6;
    var IsBattleFieldModeOffset = 20;
    var isMasterAid = 36;

    var offset = pe.findCode(code);

    if (offset === -1)
        return "Failed in Step 1 - Pattern not found";

    logRawFunc("CSession_IsSiegeMode", offset, IsSiegeModeOffset);
    logRawFunc("CSession_IsBattleFieldMode", offset, IsBattleFieldModeOffset);
    logRawFunc("CSession_IsMasterAid", offset, isMasterAid);

    consoleLog("Step 2 - Replace offset found in step 1 with NOPs");
    exe.setNopsRange(offset + nopsStart, offset + nopsEnd);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function EnableGvGDamage_()
{
    var code =
        getEcxSessionHex() +          // 0 mov ecx, offset g_session
        "E8 ?? ?? ?? ?? " +           // 5 call CSession_IsSiegeMode
        "85 C0 " +                    // 10 test eax, eax
        "75 0E " +                    // 12 jnz short loc_99A826
        getEcxSessionHex() +          // 14 mov ecx, offset g_session
        "E8 ?? ?? ?? ?? " +           // 19 call CSession_IsBattleFieldMode
        "85 C0 " +                    // 24 test eax, eax
        "74 14 " +                    // 26 jz short loc_99A83A
        "6A 07 " +                    // 28 push 7
        getEcxSessionHex() +          // 30 mov ecx, offset g_session
        "E8 ?? ?? ?? ?? " +           // 35 call CSession_IsMasterAid
        "85 C0 " +                    // 40 test eax, eax
        "0F 84 ?? ?? 00 00 ";         // 42 jz loc_9A1A84

    return (pe.findCode(code) !== -1);
}
