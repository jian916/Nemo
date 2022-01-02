//####################################################################
//# Purpose: Modify the Siege mode and Battleground mode check jumps #
//#          to display Emblem when either mode is ON                #
//####################################################################

function EnableEmblemForBG_Normal(offset)
{
    var code =
        getEcxSessionHex() +  // 00 mov ecx, offset g_session
        "E8 ?? ?? ?? 00 " +   // 05 call CSession_IsSiegeMode
        "85 C0 " +            // 10 test eax, eax
        "74 ?? " +            // 12 jz short loc_550CDE
        getEcxSessionHex() +  // 14 mov ecx, offset g_session
        "E8 ?? ?? ?? 00 " +   // 19 call CSession_IsBattleFieldMode
        "85 C0 " +            // 24 test eax, eax
        "75 ?? ";             // 26 jnz short loc_550CDE
    var jmp1 = 12;
    var jmp1Offset = 28;
    var jmp2 = 26;
    var IsSiegeModeOffset = 6;
    var IsBattleFieldModeOffset = 20;

    var found = pe.match(code, offset);
    if (found !== true)
    {
        throw "Pattern not found";
    }

    logRawFunc("CSession_IsSiegeMode", offset, IsSiegeModeOffset);
    logRawFunc("CSession_IsBattleFieldMode", offset, IsBattleFieldModeOffset);

    consoleLog("Swap the first JZ to JNZ and addr to location after the check code");
    pe.setShortJmpRaw(offset + jmp1, offset + jmp1Offset, "jnz");

    consoleLog("Swap the second JNZ to JZ");
    pe.replaceByte(offset + jmp2, 0x74);
}

function EnableEmblemForBG_Small(offset)
{
    var code =
        getEcxSessionHex() +  // 00 mov ecx, offset g_session
        "E8 ?? ?? ?? 00 " +   // 05 call CSession_IsSiegeMode
        "85 C0 " +            // 10 test eax, eax
        "74 ?? "              // 12 jz short loc_550CDE
    var patchOffset = 5;
    var IsSiegeModeOffset = 6;
    var continueOffset = 13;
    var drawOffset = 14;

    var found = pe.match(code, offset);
    if (found !== true)
    {
        throw "Pattern not found";
    }

    logRawFunc("CSession_IsSiegeMode", offset, IsSiegeModeOffset);

    consoleLog("Add own check code");

    var vars = {
        "continueAddr": pe.fetchRelativeValue(offset, [continueOffset, 1]),
        "drawAddr": pe.rawToVa(offset + drawOffset),
        "CSession_IsSiegeMode": pe.fetchRelativeValue(offset, [IsSiegeModeOffset, 4]),
    };
    var data = exe.insertAsmFile("", vars);

    consoleLog("Change call to CSession_IsSiegeMode to jmp to own code");
    pe.setJmpRaw(offset + patchOffset, data.free);
}

function EnableEmblemForBG()
{
    consoleLog("Read check addresses");
    var check1 = table.getRaw(table.bgCheck1);
    var flag = table.get(table.bgCheck2);
    var check2 = table.getRaw(table.bgCheck2);

    if (flag === 1)
    {
        consoleLog("Single call to CSession_IsSiegeMode");
        EnableEmblemForBG_Small(check1);
    }
    else if (flag === 0)
    {
        consoleLog("First calls to CSession_IsSiegeMode, CSession_IsBattleFieldMode");
        EnableEmblemForBG_Normal(check1);
    }

    if (flag > 1)
    {
        consoleLog("Second calls to CSession_IsSiegeMode, CSession_IsBattleFieldMode");
        EnableEmblemForBG_Normal(check1);
        EnableEmblemForBG_Normal(check2);
    }

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function EnableEmblemForBG_()
{
    return true;
}
