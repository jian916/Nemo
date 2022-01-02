//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2018-2021 Andrei Karas (4144)
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
//##################################################################
//# Purpose: Disable packets encryption by CDClient.dll            #
//##################################################################

function DisableCDGuard()
{
    consoleLog("Step 1a - Search call 'CCheatDefenderMgr_init' and 'g_CCheatDefenderMgr->enc_enabled = 1'");
    var code =
        "8B 0D ?? ?? ?? ?? " +  // 00 mov ecx, g_CCheatDefenderMgr
        "E8 ?? ?? ?? ?? " +     // 06 call CCheatDefenderMgr_init
        "3C 01 " +              // 11 cmp al, 1
        "A1 ?? ?? ?? ?? " +     // 13 mov eax, g_CCheatDefenderMgr
        "0F 94 C1 " +           // 18 setz cl
        "68 ?? ?? ?? ?? " +     // 21 push offset string_buffer
        "88 48 05 " +           // 26 mov [eax+5], cl
        "E8 ?? ?? ?? ?? " +     // 29 call CRagConnection_instanceR
        "8B C8 " +              // 34 mov ecx, eax
        "E8 ";                  // 36 call CRagConnection_some_func

    var cmpOffset = 12;
    var cheatDefenderMgrOffsets = [2, 14];
    var cheatDefenderMgrInitOffset = 7;
    var zoneServerAddrOffset = 22;
    var instanceROffset = 30;
    var encEnabledOffset = [28, 1];
    var CConnectionConnectOffset = 37;
    var offsets = pe.findCodes(code);

    if (offsets.length === 0)
    {
        code =
            "8B 0D ?? ?? ?? ?? " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 ?? ?? ?? ?? " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 ?? ?? ?? ?? " +     // 13 mov eax, g_CCheatDefenderMgr
            "68 ?? ?? ?? ?? " +     // 18 push offset g_zoneServerAddr
            "0F 94 C1 " +           // 23 setz cl
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 ?? ?? ?? ?? " +     // 29 call CRagConnection_instanceR
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call sub_867160

        cmpOffset = 12;
        cheatDefenderMgrOffsets = [2, 14];
        cheatDefenderMgrInitOffset = 7;
        zoneServerAddrOffset = 19;
        instanceROffset = 30;
        encEnabledOffset = [28, 1];
        CConnectionConnectOffset = 37;
        offsets = pe.findCodes(code);
    }

    if (offsets.length === 0)
        return "Failed in Step 1a - Pattern not found";

    if (offsets.length < 1 || offsets.length > 2)
        return "Failed in Step 1a - Found wrong offset number";

    consoleLog("Step 1b - Replace CMP AL, 1 to CMP AL, 0");
    for (var i = 0; i < offsets.length; i++)
    {
        var offset = offsets[i];
        for (var j = 0; j < cheatDefenderMgrOffsets.length; j++)
        {
            logVaVar("g_CCheatDefenderMgr", offset, cheatDefenderMgrOffsets[j]);
        }
        logRawFunc("CCheatDefenderMgr_init", offset, cheatDefenderMgrInitOffset);
        logVaVar("g_zoneServerAddr", offset, zoneServerAddrOffset);
        logRawFunc("CRagConnection_instanceR", offset, instanceROffset);
        logField("CCheatDefenderMgr::m_enc_enabled", offset, encEnabledOffset);
        logRawFunc("CConnection_Connect", offset, CConnectionConnectOffset);

        pe.replaceByte(offset + cmpOffset, 0);
    }

    var CCheatDefenderMgr = (pe.fetchDWord(offsets[0] + cheatDefenderMgrOffsets[0])).packToHex(4)

    consoleLog("Step 2a - Search separate 'g_CCheatDefenderMgr->enc_enabled = 1'");
    var code =
        "A1 " + CCheatDefenderMgr +  // 00 mov eax, g_CCheatDefenderMgr
        "C6 40 05 01 " +             // 05 mov byte ptr [eax+5], 1
        "B8 ?? ?? ?? 00 ";           // 08 mov eax, CZ_ENTER

    var enableOffset = 8;
    var offset = pe.find(code, offsets[1], offsets[1] + 0x150);

    if (offset === -1)
        return "Failed in Step 2a - Pattern not found";

    consoleLog("Step 2b - Replace MOV BYTE PTR [eax+5], 1 to MOV BYTE PTR [eax+5], 0");
    pe.replaceByte(offset + enableOffset, 0);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableCDGuard_()
{
    return (pe.stringRaw("CDClient.dll") !== -1);
}
