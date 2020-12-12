//###################################################################################\\
//# Modify the Siege mode & BG mode check Jumps to Display Emblem when either is ON #\\
//###################################################################################\\

function EnableEmblemForBG()
{
    consoleLog("Step 1.1 - Look for the Mode checking pattern");
    var code =
        getEcxSessionHex() +          // 0 mov ecx, offset g_session
        "E8 AB AB AB 00 " +           // 5 call CSession_IsSiegeMode
        "85 C0 " +                    // 10 test eax, eax
        "74 AB " +                    // 12 jz short loc_550CDE
        getEcxSessionHex() +          // 14 mov ecx, offset g_session
        "E8 AB AB AB 00 " +           // 19 call CSession_IsBattleFieldMode
        "85 C0 " +                    // 24 test eax, eax
        "75 ";                        // 26 jnz short loc_550CDE

    var jmp1 = 12;
    var jmp2 = 26;
    var IsSiegeModeOffset = 6;
    var IsBattleFieldModeOffset = 20;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 1";

    logRawFunc("CSession_IsSiegeMode", offset, IsSiegeModeOffset);
    logRawFunc("CSession_IsBattleFieldMode", offset, IsBattleFieldModeOffset);

    consoleLog("Step 2.1 - Change the first JZ to JNZ and addr to location after the code");
    exe.replace(offset + jmp1, "75" + (jmp1 + 2).packToHex(1), PTYPE_HEX);

    consoleLog("Step 2.2 - Change the second JNZ to JZ");
    exe.replace(offset + jmp2, "74", PTYPE_HEX);
    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function EnableEmblemForBG_()
{
    return (exe.getClientDate() > 20130710);
}
