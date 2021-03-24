//
// Copyright (C) 2018-2022  Andrei Karas (4144)
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

function RestoreAutoFollow()
{
    consoleLog("get patch addresses");
    var CGameMode_ProcessAutoFollow = table.get(table.CGameMode_ProcessAutoFollow);
    var onUpdateOffset = table.getRaw(table.CGameMode_OnUpdate);
    if (onUpdateOffset === 0)
    {
        return "CGameMode_OnUpdate address not found";
    }
    if (CGameMode_ProcessAutoFollow === 0)
    {
        return "CGameMode_ProcessAutoFollow not found";
    }

    consoleLog("search pattern");

    var code =
        "8B 0D ?? ?? ?? ?? " +        // 0 mov ecx, g_CAsyncWorkMgr
        "68 E8 03 00 00 " +           // 6 push 3E8h
        "8B 01 " +                    // 11 mov eax, [ecx]
        "FF 10 " +                    // 13 call dword ptr [eax]
        "8B CB " +                    // 15 mov ecx, ebx
        "E8 ?? ?? ?? ?? " +           // 17 call CGameMode_ProcessInput
        "8B B3 ?? ?? ?? 00 " +        // 22 mov esi, [ebx+CGameMode.m_playWaveList._First]
        "3B B3 ?? ?? ?? 00 " +        // 28 cmp esi, [ebx+CGameMode.m_playWaveList._Last]
        "0F 84 ?? ?? ?? 00 " +        // 34 jz loc_7284D6
        "FF D7 " +                    // 40 call edi
        "FF D7 ";                     // 42 call edi
    var patchOffset = 17;
    var inputOffset = [18, 4];
    var gameModeReg = "ebx";

    var offset = pe.find(code, onUpdateOffset, onUpdateOffset + 0x150);
    if (offset === -1)
    {
        code =
            "8B 0D ?? ?? ?? ?? " +        // 0 mov ecx, g_CAsyncWorkMgr
            "68 E8 03 00 00 " +           // 6 push 3E8h
            "8B 01 " +                    // 11 mov eax, [ecx]
            "FF 10 " +                    // 13 call dword ptr [eax]
            "8B CE " +                    // 15 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 17 call CGameMode_ProcessInput
            "8B CE " +                    // 22 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 24 call CGameMode_ProcessPlayWave
            "8B 0D ?? ?? ?? ?? " +        // 29 mov ecx, g_soundMgr
            "E8 ?? ?? ?? ?? " +           // 35 call CSoundMgr_sub_4BF150
            "84 C0 " +                    // 40 test al, al
            "0F 84 ?? ?? ?? 00 ";         // 42 jz loc_A7D197
        patchOffset = 17;
        inputOffset = [18, 4];
        gameModeReg = "esi";

        offset = pe.find(code, onUpdateOffset, onUpdateOffset + 0x150);
    }

    if (offset === -1)
    {
        code =
            "8B 0D ?? ?? ?? ?? " +        // 0 mov ecx, g_CAsyncWorkMgr
            "68 E8 03 00 00 " +           // 6 push 3E8h
            "8B 01 " +                    // 11 mov eax, [ecx]
            "FF 10 " +                    // 13 call dword ptr [eax]
            "8B CB " +                    // 15 mov ecx, ebx
            "E8 ?? ?? ?? ?? " +           // 17 call CGameMode_ProcessInput
            "8B B3 ?? ?? ?? 00 " +        // 22 mov esi, [ebx+1F4h]
            "3B B3 ?? ?? ?? 00 " +        // 28 cmp esi, [ebx+1F8h]
            "0F 84 ?? ?? ?? 00 " +        // 34 jz loc_9B152F
            "?? ?? ?? ?? " +              // 40 nop dword ptr [eax+00h]
            "FF D7 " +                    // 44 call edi
            "FF D7 ";                     // 46 call edi
        patchOffset = 17;
        inputOffset = [18, 4];
        gameModeReg = "ebx";

        offset = pe.find(code, onUpdateOffset, onUpdateOffset + 0x150);
    }

    if (offset === -1)
    {
        code =
            "83 7E 14 00 " +              // 0 cmp dword ptr [esi+14h], 0
            "0F 84 ?? ?? ?? 00 " +        // 4 jz loc_9E38CE
            "8B 0D ?? ?? ?? ?? " +        // 10 mov ecx, g_CTimeScheduler
            "E8 ?? ?? ?? ?? " +           // 16 call sub_8B8260
            "8B CE " +                    // 21 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 23 call CGameMode_ProcessInput
            "8B CE " +                    // 28 mov ecx, esi
            "E8 ?? ?? ?? ?? " +           // 30 call CGameMode_ProcessPlayWave
            "8B 0D ?? ?? ?? ?? " +        // 35 mov ecx, g_soundMgr
            "E8 ?? ?? ?? ?? " +           // 41 call CSoundMgr_sub_4622A0
            "84 C0 " +                    // 46 test al, al
            "0F 84 ?? ?? ?? 00 ";         // 48 jz loc_9E3837
        patchOffset = 23;
        inputOffset = [24, 4];
        gameModeReg = "esi";

        offset = pe.find(code, onUpdateOffset, onUpdateOffset + 0x150);
    }

    if (offset === -1)
    {
        return "Pattern not found";
    }

    var CGameMode_ProcessInput = exe.fetchRelativeValue(offset, inputOffset);

    consoleLog("add new code");

    var text = asm.combine(
        "call CGameMode_ProcessInput",
        "mov ecx, " + gameModeReg,
        "call CGameMode_ProcessAutoFollow",
        "ret"
    );

    var vars = {
        "CGameMode_ProcessInput": CGameMode_ProcessInput,
        "CGameMode_ProcessAutoFollow": CGameMode_ProcessAutoFollow
    };

    var data = exe.insertAsmText(text, vars);
    var free = data[0]

    consoleLog("add jump to own code");
    exe.setJmpRaw(offset + patchOffset, free, "call");

    return true;
}

function RestoreAutoFollow_()
{
    return IsZero();
}
