//##############################################
//# Purpose: Change the iteminfo.lub reference #
//#          to custom file specified by user  #
//##############################################

function ChangeItemInfo()
{
    //Step 1a - Check if the client is Renewal (iteminfo file name is "System/iteminfo_Sak.lub" for Renewal clients)
    if (IsSakray())
    {
        var offset = pe.stringInfoVa("System/iteminfo_Sak.lub",
            "System\\iteminfo_Sak.lub");
    }
    else
    {
        var offset = pe.stringInfoVa("System/iteminfo.lub",
            "System/iteminfo_true.lub",
            "System\\iteminfo_true.lub");
    }
    if (offset === -1)
        return "Failed in Step 1 - iteminfo file name not found";

    var iiName = offset[0];
    offset = offset[1];

    //Step 1b - Find its reference
    offset = pe.findCode("68" + offset.packToHex(4));
    if (offset === -1)
        return "Failed in Step 1 - iteminfo reference not found";

    //Step 2a - Get the new filename from user
    var myfile = exe.getUserInput("$newItemInfo", XTYPE_STRING,
        _("String input - maximum 28 characters including folder name/"),
        _("Enter the new ItemInfo path (should be relative to RO folder)"), iiName, 1, 28);
    if (myfile === iiName)
        return "Patch Cancelled - New value is same as old";

    //Step 2b - Allocate space for the new name
    var free = exe.findZeros(myfile.length);
    if (free === -1)
        return "Failed in Step 2 - Not enough free space";

    //Step 3 - Insert the new name and replace the iteminfo reference
    exe.insert(free, myfile.length, myfile, PTYPE_STRING);
    pe.replaceDWord(offset + 1, pe.rawToVa(free));

    return true;
}

//=================================//
// Disable for Unsupported clients //
//=================================//
function ChangeItemInfo_()
{
    if (IsSakray())
    {
        return pe.stringAnyRaw("System/iteminfo_Sak.lub",
            "System\\iteminfo_Sak.lub") !== -1;
    }
    else
    {
        return pe.stringAnyRaw("System/iteminfo.lub",
            "System/iteminfo_true.lub",
            "System\\iteminfo_true.lub") !== -1;
    }
}
