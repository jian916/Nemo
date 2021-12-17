//============================================================//
// Patch Functions wrapping over ChangeWalkToDelay function   //
//============================================================//

function DisableWalkToDelay()
{
    return ChangeWalkToDelay(0, 0);
}

function SetWalkToDelay()
{
    var value1 = exe.getUserInput("$walkDelay", XTYPE_WORD, _("Number Input"), _("Enter the new walk delay (0-1000) - snaps to closest valid value"), 150, 0, 1000);
    if (exe.getClientDate() > 20170329)
    {
        var value2 = exe.getUserInput("$walkDelay2", XTYPE_WORD, _("Number Input"), _("Enter the new walk delay 2 (0-1000) - snaps to closest valid value"), 150, 0, 1000);
    }
    else
    {
        var value2 = 0;
    }
    return ChangeWalkToDelay(value1, value2);
}

//########################################################################
//# Purpose: Find the walk delay and replace it with the value specified #
//########################################################################

function ChangeWalkToDelay(value1, value2)
{
    consoleLog("Step 1a - Search the first delay addition");
    var timeGetTimeHex = imports.ptrHexValidated("timeGetTime", "winmm.dll");

    var code = [
        [
            "FF 15 " + timeGetTimeHex +   // 0 call timeGetTime
            "8B 8B ?? ?? ?? 00 " +        // 6 mov ecx, [ebx+CGameMode.m_leftBtnClickTick]
            "81 C1 58 02 00 00 " +        // 12 add ecx, 258h
            "3B C1 " +                    // 18 cmp eax, ecx
            "8B 83 ?? ?? ?? 00 " +        // 20 mov eax, [ebx+CGameMode.m_world]
            "0F 97 C1 " +                 // 26 setnbe cl
            "8B 40 ?? " +                 // 29 mov eax, [eax+CWorld.m_player]
            "83 8B ?? ?? ?? 00 00 ",      // 32 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [14, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [22, 4],
                "playerOffset": [31, 1],
                "proceedTypeOffset": [34, 4],
            }
        ],
        [
            "8B 2D " + timeGetTimeHex +   // 0 mov ebp, ds:timeGetTime
            "FF D5 " +                    // 6 call ebp
            "8B 8E ?? ?? ?? 00 " +        // 8 mov ecx, [esi+CGameMode.m_leftBtnClickTick]
            "8B 96 ?? ?? ?? 00 " +        // 14 mov edx, [esi+CGameMode.m_world]
            "81 C1 58 02 00 00 " +        // 20 add ecx, 258h
            "3B C1 " +                    // 26 cmp eax, ecx
            "8B 42 ?? " +                 // 28 mov eax, [edx+CWorld.m_player]
            "0F 97 C1 " +                 // 31 setnbe cl
            "83 B8 ?? ?? ?? 00 00 ",      // 34 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [22, 4],
                "leftBtnClickTickOffset": [10, 4],
                "worldOffset": [16, 4],
                "playerOffset": [30, 1],
                "proceedTypeOffset": [36, 4],
            }
        ],
        [
            "FF 15 " + timeGetTimeHex +   // 0 call ds:timeGetTime
            "8B 93 ?? ?? ?? 00 " +        // 6 mov edx, [ebx+CGameMode.m_leftBtnClickTick]
            "81 C2 58 02 00 00 " +        // 12 add edx, 258h
            "3B C2 " +                    // 18 cmp eax, edx
            "8B 83 ?? ?? ?? 00 " +        // 20 mov eax, [ebx+CGameMode.m_world]
            "0F 97 C1 " +                 // 26 setnbe cl
            "8B 50 ?? " +                 // 29 mov edx, [eax+CWorld.m_player]
            "8B 82 ?? ?? ?? 00 " +        // 32 mov eax, [edx+CPlayer.m_proceedType]
            "85 C0 ",                     // 38 test eax, eax
            {
                "delayOffset": [14, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [22, 4],
                "playerOffset": [31, 1],
                "proceedTypeOffset": [34, 4],
            }
        ],
        [
            "8B 2D " + timeGetTimeHex +   // 0 mov ebp, ds:timeGetTime
            "FF D5 " +                    // 6 call ebp
            "8B 8E ?? ?? ?? 00 " +        // 8 mov ecx, [esi+CGameMode.m_leftBtnClickTick]
            "8B 96 ?? ?? ?? 00 " +        // 14 mov edx, [esi+CGameMode.m_world]
            "81 C1 58 02 00 00 " +        // 20 add ecx, 258h
            "3B C1 " +                    // 26 cmp eax, ecx
            "8B 42 ?? " +                 // 28 mov eax, [edx+CWorld.m_player]
            "0F 97 C1 " +                 // 31 setnbe cl
            "39 B8 ?? ?? ?? 00 ",         // 34 cmp [eax+CPlayer.m_proceedType], edi
            {
                "delayOffset": [22, 4],
                "leftBtnClickTickOffset": [10, 4],
                "worldOffset": [16, 4],
                "playerOffset": [30, 1],
                "proceedTypeOffset": [36, 4],
            }
        ],
        [
            "FF 15 " + timeGetTimeHex +   // 0 call timeGetTime
            "8B 8E ?? ?? ?? 00 " +        // 6 mov ecx, [esi+CGameMode.m_leftBtnClickTick]
            "8B 96 ?? ?? ?? 00 " +        // 12 mov edx, [esi+CGameMode.m_world]
            "81 C1 58 02 00 00 " +        // 18 add ecx, 258h
            "3B C1 " +                    // 24 cmp eax, ecx
            "8B 42 ?? " +                 // 26 mov eax, [edx+CWorld.m_player]
            "0F 97 C1 " +                 // 29 setnbe cl
            "83 B8 ?? ?? ?? 00 00 ",      // 32 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [20, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [14, 4],
                "playerOffset": [28, 1],
                "proceedTypeOffset": [34, 4],
            }
        ],
        [
            "FF 15 " + timeGetTimeHex +   // 0 call timeGetTime
            "8B 8E ?? ?? ?? 00 " +        // 6 mov ecx, [esi+CGameMode.m_leftBtnClickTick]
            "81 C1 58 02 00 00 " +        // 12 add ecx, 258h
            "3B C1 " +                    // 18 cmp eax, ecx
            "8B 86 ?? ?? ?? 00 " +        // 20 mov eax, [esi+CGameMode.m_world]
            "0F 97 C1 " +                 // 26 setnbe cl
            "8B 40 ?? " +                 // 29 mov eax, [eax+CWorld.m_player]
            "83 B8 ?? ?? ?? 00 00 ",      // 32 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [14, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [22, 4],
                "playerOffset": [31, 1],
                "proceedTypeOffset": [34, 4],
            }
        ],
        [
            "FF 15 " + timeGetTimeHex +   // 0 call timeGetTime
            "8B 8B ?? ?? ?? 00 " +        // 6 mov ecx, [ebx+CGameMode.m_leftBtnClickTick]
            "81 C1 58 02 00 00 " +        // 12 add ecx, 258h
            "3B C1 " +                    // 18 cmp eax, ecx
            "8B 83 ?? ?? ?? 00 " +        // 20 mov eax, [ebx+CGameMode.m_world]
            "0F 97 C1 " +                 // 26 setnbe cl
            "8B 40 ?? " +                 // 29 mov eax, [eax+CWorld.m_player]
            "83 B8 ?? ?? ?? 00 00 ",      // 32 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [14, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [22, 4],
                "playerOffset": [31, 1],
                "proceedTypeOffset": [34, 4],
            }
        ],
        [
            "FF 15 " + timeGetTimeHex +   // 0 call timeGetTime
            "8B 8B ?? ?? ?? 00 " +        // 6 mov ecx, [ebx+CGameMode.m_leftBtnClickTick]
            "8B 15 ?? ?? ?? ?? " +        // 12 mov edx, _dword_D566CC
            "81 C1 58 02 00 00 " +        // 18 add ecx, 258h
            "3B C1 " +                    // 24 cmp eax, ecx
            "8B 83 ?? ?? ?? 00 " +        // 26 mov eax, [ebx+CGameMode.m_world]
            "8B 0D ?? ?? ?? ?? " +        // 32 mov ecx, g_mouse.field_28
            "8B 40 ?? " +                 // 38 mov eax, [eax+CWorld.m_player]
            "0F 97 45 ?? " +              // 41 setnbe [ebp+var_35]
            "83 B8 ?? ?? ?? 00 00 ",      // 45 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [20, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [28, 4],
                "playerOffset": [40, 1],
                "proceedTypeOffset": [47, 4],
                "unknownOffsets": [
                    [14, 4],
                    [34, 4]
                ],
            }
        ],
        [
            "FF 15 " + timeGetTimeHex +   // 0 call timeGetTime
            "8B 8E ?? ?? ?? 00 " +        // 6 mov ecx, [esi+CGameMode.m_leftBtnClickTick]
            "8B 15 ?? ?? ?? ?? " +        // 12 mov edx, dword ptr unk_D7351C
            "81 C1 58 02 00 00 " +        // 18 add ecx, 258h
            "3B C1 " +                    // 24 cmp eax, ecx
            "8B 86 ?? ?? ?? 00 " +        // 26 mov eax, [esi+CGameMode.m_world]
            "8B 0D ?? ?? ?? ?? " +        // 32 mov ecx, dword ptr unk_D73508
            "8B 40 ?? " +                 // 38 mov eax, [eax+CWorld.m_player]
            "0F 97 45 ?? " +              // 41 setnbe [ebp+var_35]
            "83 B8 ?? ?? ?? 00 00 ",      // 45 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [20, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [28, 4],
                "playerOffset": [40, 1],
                "proceedTypeOffset": [47, 4],
                "unknownOffsets": [
                    [14, 4],
                    [34, 4]
                ],
            }
        ],
        [
            "FF 15 " + timeGetTimeHex +   // 0 call ds:timeGetTime
            "8B 8F ?? ?? ?? 00 " +        // 6 mov ecx, [edi+CGameMode.m_leftBtnClickTick]
            "81 C1 58 02 00 00 " +        // 12 add ecx, 258h
            "3B C1 " +                    // 18 cmp eax, ecx
            "8B 87 ?? ?? ?? 00 " +        // 20 mov eax, [edi+CGameMode.m_world]
            "0F 97 C1 " +                 // 26 setnbe cl
            "8B 40 ?? " +                 // 29 mov eax, [eax+CWorld.m_player]
            "83 B8 ?? ?? ?? 00 00 ",      // 32 cmp [eax+CPlayer.m_proceedType], 0
            {
                "delayOffset": [14, 4],
                "leftBtnClickTickOffset": [8, 4],
                "worldOffset": [22, 4],
                "playerOffset": [31, 1],
                "proceedTypeOffset": [34, 4],
            }
        ],
    ];
    var offsetObj = pe.findAnyCode(code);

    if (offsetObj === -1)
        return "Failed in Step 1a - Pattern not found";

    var offset = offsetObj.offset;

    consoleLog("Step 2a - Replace the first offset value");
    pe.setValue(offset, offsetObj.delayOffset, value1);

    logField("CGameMode::m_leftBtnClickTick", offset, offsetObj.leftBtnClickTickOffset);
    logField("CGameMode::m_world", offset, offsetObj.worldOffset);
    logField("CWorld::m_player", offset, offsetObj.playerOffset);
    logField("CPlayer::m_proceedType", offset, offsetObj.proceedTypeOffset);

    if (typeof(offsetObj.unknownOffsets) !== "undefined")
    {
        var offsets = offsetObj.unknownOffsets;
        for (var i = 0; i < offsets.length; i ++)
        {
            logVaVar("Unknown", offset, offsets[i]);
        }
    }

    if (exe.getClientDate() > 20170329)
    {
        consoleLog("Step 1b - Search the second delay addition");
        var code =
            "81 C1 5E 01 00 00 " +  // 00 add ecx, 15Eh ; 350ms
            "3B C1 " ;              // 06 cmp eax, ecx
        var delayOffset = [2, 4];
        var offset = pe.findCode(code);

        if (offset === -1)
            return "Failed in Step 1b - Pattern not found";

        consoleLog("Step 2b - Replace the second offset value");
        pe.setValue(offset, delayOffset, value2);
    }

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function ChangeWalkToDelay_()
{
    return (exe.getClientDate() > 20020729);
}
