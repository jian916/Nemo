//########################################################################
//# Purpose: Disable the CGameMode::m_lastLockOnPcGid assignment         #
//#          inside CGameMode::ProcessPcPick to ignore shift right click #
//########################################################################

function DisableAutofollow()
{
    if (table.get(table.m_lastLockOnPcGid) === 0)
    {
        return "Auto follow not found";
    }
    var lastLockOnPcGid = table.getHex4(table.m_lastLockOnPcGid);

    //Step 1 - Find the assignment statement
    var code =
        "8B 87 ?? ?? ?? 00 " +        // 0 mov eax, [edi+CGameActor.m_aid]
        "A3 " + lastLockOnPcGid;      // 6 mov m_lastLockOnPcGid, eax
    var starOffset = 6;
    var endOffset = 11;

    var offsets = pe.findCodes(code);

    if (offsets.length === 0)
    {
        code =
            "8B 8B ?? ?? ?? 00 " +        // 0 mov ecx, [ebx+CGameActor.m_aid]
            "89 0D " + lastLockOnPcGid;   // 6 mov m_lastLockOnPcGid, ecx
        starOffset = 6;
        endOffset = 12;

        offsets = pe.findCodes(code);
    }

    if (offsets.length === 0)
    {
        code =
            "8B 83 ?? ?? 00 00 " +        // 0 mov eax, [ebx+CGameActor.m_aid]
            "A3 " + lastLockOnPcGid;      // 6 mov m_lastLockOnPcGid, eax
        starOffset = 6;
        endOffset = 11;

        offsets = pe.findCodes(code);
    }

    if (offsets.length === 0)
        return "Failed in Step 1";

    //Step 2 - NOP out the assignment for the correct match (pattern might match more than one location)
    var found = false;
    for (var i = 0; i < offsets.length; i++)
    {
        var offset = offsets[i];
        pe.setNopsRange(offset + starOffset, offset + endOffset);
    }

    return true;
}
