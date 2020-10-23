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
//##################################################################
//# Purpose: Disable packets encryption by CDClient.dll            #
//##################################################################

function DisableCDGuard()
{
    consoleLog("Step 1a - Search call 'CCheatDefenderMgr_init' and 'g_CCheatDefenderMgr->enc_enabled = 1'");
    var code =
        "8B 0D AB AB AB 00 " +  // 00 mov ecx, g_CCheatDefenderMgr
        "E8 AB AB AB FF " +     // 06 call CCheatDefenderMgr_init
        "3C 01 " +              // 11 cmp al, 1
        "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
        "0F 94 C1 " +           // 18 setz cl
        "68 AB AB AB 01 " +     // 21 push offset string_buffer
        "88 48 05 " +           // 26 mov [eax+5], cl
        "E8 AB AB AB FF " +     // 29 call CRagConnection_instanceR
        "8B C8 " +              // 34 mov ecx, eax
        "E8 ";                  // 36 call CRagConnection_some_func

    var cmpOffset = 12;
    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");

    if (offsets.length === 0)
    {
        code =
            "8B 0D AB AB AB 00 " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB FF " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
            "0F 94 C1 " +           // 18 setz cl
            "68 AB AB AB 00 " +     // 21 push offset string_buffer
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 AB AB AB FF " +     // 29 call CRagConnection_instanceR
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call CRagConnection_some_func

        cmpOffset = 12;
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
    {
        code =
            "8B 0D AB AB AB 00 " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB 00 " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
            "0F 94 C1 " +           // 18 setz cl
            "68 AB AB AB 00 " +     // 21 push offset string_buffer
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 AB AB AB 00 " +     // 29 call CRagConnection_instanceR
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call CRagConnection_some_func

        cmpOffset = 12;
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
    {
        code =
            "8B 0D AB AB AB 00 " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB FF " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
            "68 AB AB AB 00 " +     // 18 push offset g_zoneServerAddr
            "0F 94 C1 " +           // 23 setz cl
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 AB AB AB AB " +     // 29 call CRagConnection_instanceR
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call sub_867160

        cmpOffset = 12;
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
    {
        code =
            "8B 0D AB AB AB 00 " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB FF " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
            "68 AB AB AB 01 " +     // 18 push offset g_zoneServerAddr
            "0F 94 C1 " +           // 23 setz cl
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 AB AB AB AB " +     // 29 call CRagConnection_instanceR
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call sub_867160

        cmpOffset = 12;
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
    {
        code =
            "8B 0D AB AB AB 01 " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB FF " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
            "0F 94 C1 " +           // 18 setz cl
            "68 AB AB AB 01 " +     // 21 push offset g_zoneServerAddr
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 AB AB AB AB " +     // 29 call CRagConnection_instanceR
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call sub_9F5F40

        cmpOffset = 12;
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
    {
        code =
            "8B 0D AB AB AB 01 " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB 00 " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
            "68 AB AB AB 00 " +     // 18 push offset g_zoneServerAddr
            "0F 94 C1 " +           // 23 setz cl
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 AB AB AB AB " +     // 29 call CRagConnection_instance
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call sub_867BA0

        cmpOffset = 12;
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
    {
        code =
            "8B 0D AB AB AB 01 " +  // 00 mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB 00 " +     // 06 call CCheatDefenderMgr_init
            "3C 01 " +              // 11 cmp al, 1
            "A1 AB AB AB AB " +     // 13 mov eax, g_CCheatDefenderMgr
            "68 AB AB AB 01 " +     // 18 push offset g_zoneServerAddr
            "0F 94 C1 " +           // 23 setz cl
            "88 48 05 " +           // 26 mov [eax+5], cl
            "E8 AB AB AB 00 " +     // 29 call CRagConnection_instance
            "8B C8 " +              // 34 mov ecx, eax
            "E8 ";                  // 36 call sub_859520

        cmpOffset = 12;
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }

    if (offsets.length === 0)
        return "Failed in Step 1a - Pattern not found";

    if (offsets.length < 1 || offsets.length > 2)
        return "Failed in Step 1a - Found wrong offset number";

    consoleLog("Step 1b - Replace CMP AL, 1 to CMP AL, 0");
    for (var i = 0; i < offsets.length; i++)
    {
        exe.replace(offsets[i] + cmpOffset, "00 ", PTYPE_HEX);
    }

    consoleLog("Step 2a - Search separate 'g_CCheatDefenderMgr->enc_enabled = 1'");
    var code =
        "A1 AB AB AB 00 " +  // 00 mov eax, g_CCheatDefenderMgr
        "C6 40 05 01 " +     // 05 mov byte ptr [eax+5], 1
        "B8 AB AB 00 00 ";   // 08 mov eax, CZ_ENTER

    var enableOffset = 8;
    var offset = exe.find(code, PTYPE_HEX, true, "\xAB", offsets[1], offsets[1] + 0x150);

    if (offset === -1)
    {
        code =
            "A1 AB AB AB 01 " +  // 00 mov eax, g_CCheatDefenderMgr
            "C6 40 05 01 " +     // 05 mov byte ptr [eax+5], 1
            "B8 AB AB 00 00 ";   // 09 mov eax, CZ_ENTER

        enableOffset = 8;
        offset = exe.find(code, PTYPE_HEX, true, "\xAB", offsets[1], offsets[1] + 0x150);
    }

    if (offset === -1)
        return "Failed in Step 2a - Pattern not found";

    consoleLog("Step 2b - Replace MOV BYTE PTR [eax+5], 1 to MOV BYTE PTR [eax+5], 0");
    exe.replace(offset + enableOffset, "00 ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableCDGuard_()
{
    return (exe.findString("CDClient.dll", RAW) !== -1);
}
