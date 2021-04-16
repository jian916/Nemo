//============================================================//
// Patch Functions wrapping over ChangeWalkToDelay function   //
//============================================================//

function DisableWalkToDelay()
{
    return ChangeWalkToDelay(0);
}

function SetWalkToDelay()
{
    return ChangeWalkToDelay(exe.getUserInput("$walkDelay", XTYPE_WORD, _("Number Input"), _("Enter the new walk delay (0-1000) - snaps to closest valid value"), 150, 0, 1000));
}

//########################################################################
//# Purpose: Find the walk delay and replace it with the value specified #
//########################################################################

function ChangeWalkToDelay(value)
{
    consoleLog("Step 1a - Search the first delay addition");
    var code =
        "81 ?? 58 02 00 00 " +  // 00 add ecx, 258h ; 600ms
        "3B ?? ";               // 06 cmp eax, ecx

    var offset = pe.findCode(code);

    if (offset === -1)
        return "Failed in Step 1a - Pattern not found";

    consoleLog("Step 2a - Replace the first offset value");
    exe.replace(offset + 2, value.packToHex(4), PTYPE_HEX);

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
        exe.replace(offset + 2, value.packToHex(4), PTYPE_HEX);
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
