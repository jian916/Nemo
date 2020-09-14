//##############################################
//# Purpose: Change the Default BGM            #
//#          to custom file specified by user  #
//##############################################

function ChangeDefaultBGM()
{
    var org_name = "bgm\\01.mp3";
    var offset = exe.findString(org_name, RVA);
    if (offset === -1)
        return "Failed in Step 1a - Default BGM file name not found";

    offset = exe.findCode("68" + offset.packToHex(4),  PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in Step 1b - Default BGM reference not found";

    var myfile = exe.getUserInput("$newBGMPath", XTYPE_STRING, _("String input - maximum 100 characters"), _("Please enter new BGM file path"), org_name, 1, 100);
    if (myfile === org_name)
        return "Patch Cancelled - New value is same as old";

    var free = exe.findZeros(myfile.length);
    if (free === -1)
        return "Failed in Step 2 - Not enough free space";

    exe.insert(free, myfile.length, "$newBGMPath", PTYPE_STRING);
    exe.replace(offset+1, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);

    return true;
}

//=================================//
// Disable for Unsupported clients //
//=================================//
function ChangeDefaultBGM_()
{
    return (exe.findString("bgm\\01.mp3", RAW) !== -1);
}
