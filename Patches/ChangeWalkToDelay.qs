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
    var code =
        "81 ?? 58 02 00 00 " +  // 00 add ecx, 258h ; 600ms
        "3B ?? ";               // 06 cmp eax, ecx

    var offset = pe.findCode(code);

    if (offset === -1)
        return "Failed in Step 1a - Pattern not found";

    consoleLog("Step 2a - Replace the first offset value");
    exe.replace(offset + 2, value1.packToHex(4), PTYPE_HEX);

    if (exe.getClientDate() > 20170329)
    {
        consoleLog("Step 1b - Search the second delay addition");
        var code =
            "81 C1 5E 01 00 00 " +  // 00 add ecx, 15Eh ; 350ms
            "3B C1 " ;              // 06 cmp eax, ecx

        var offset = pe.findCode(code);

        if (offset === -1)
            return "Failed in Step 1b - Pattern not found";

        consoleLog("Step 2b - Replace the second offset value");
        exe.replace(offset + 2, value2.packToHex(4), PTYPE_HEX);
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
