//
// Copyright (C) 2018  Andrei Karas (4144)
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
    //Step 1 - find call CCheatDefenderMgr_init and g_CCheatDefenderMgr->enc_enabled = 1
    var code = 
        "8B 0D AB AB AB 00" +  // mov ecx, g_CCheatDefenderMgr
        "E8 AB AB AB FF" +     // call CCheatDefenderMgr_init
        "3c 01" +              // cmp al, 1    <-- change here
        "A1 AB AB AB AB" +     // mov eax, g_CCheatDefenderMgr
        "0F 94 C1" +           // setz cl
        "68 AB AB AB 01" +     // push offset string_buffer
        "88 48 05" +           // mov [eax+5], cl
        "E8 AB AB AB FF" +     // call CRagConnection_instanceR
        "8B C8" +              // mov ecx, eax
        "E8";                  // call CRagConnection_some_func
    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    if (offsets.length === 0)
    {
        var code = 
            "8B 0D AB AB AB 00" +  // mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB FF" +     // call CCheatDefenderMgr_init
            "3c 01" +              // cmp al, 1    <-- change here
            "A1 AB AB AB AB" +     // mov eax, g_CCheatDefenderMgr
            "0F 94 C1" +           // setz cl
            "68 AB AB AB 00" +     // push offset string_buffer
            "88 48 05" +           // mov [eax+5], cl
            "E8 AB AB AB FF" +     // call CRagConnection_instanceR
            "8B C8" +              // mov ecx, eax
            "E8";                  // call CRagConnection_some_func
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }
    if (offsets.length === 0)
    {
        var code = 
            "8B 0D AB AB AB 00" +  // mov ecx, g_CCheatDefenderMgr
            "E8 AB AB AB 00" +     // call CCheatDefenderMgr_init
            "3c 01" +              // cmp al, 1    <-- change here
            "A1 AB AB AB AB" +     // mov eax, g_CCheatDefenderMgr
            "0F 94 C1" +           // setz cl
            "68 AB AB AB 00" +     // push offset string_buffer
            "88 48 05" +           // mov [eax+5], cl
            "E8 AB AB AB 00" +     // call CRagConnection_instanceR
            "8B C8" +              // mov ecx, eax
            "E8";                  // call CRagConnection_some_func
        offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    }
    if (offsets.length === 0)
        return "Failed in Step 1 - CCheatDefenderMgr_init call not found";
    if (offsets.length !== 2)
        return "Failed in Step 1 - CCheatDefenderMgr_init calls wrong number found";

    for (var i = 0; i < offsets.length; i++)
    {
        exe.replace(offsets[i] + 12, "00", PTYPE_HEX);  // replace cmp al, 1 to cmp al, 0
    }

    //Step 2 - find separate g_CCheatDefenderMgr->enc_enabled = 1
    var code =
        "A1 AB AB AB 00" + // mov eax, g_CCheatDefenderMgr
        "C6 40 05 01" +    // mov byte ptr [eax+5], 1
        "B8 AB AB 00 00";  // mov eax, CZ_ENTER
    var offset = exe.find(code, PTYPE_HEX, true, "\xAB", offsets[1], offsets[1] + 0x150);
    if (offset === -1)
        return "Failed in Step 2 - 'g_CCheatDefenderMgr->enc_enabled = 1' not found";
    exe.replace(offset + 8, "00", PTYPE_HEX);  // replace mov byte ptr [eax+5], 1 to mov byte ptr [eax+5], 0

    return true;
}

//============================//
// Disable Unsupported client //
//============================//
function DisableCDGuard_()
{
    return (exe.findString("CDClient.dll", RAW) !== -1);  
}
