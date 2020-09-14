//##############################################
//# Purpose: Change the iteminfo.lub reference #
//#          to custom file specified by user  #
//##############################################

function ChangeItemInfo()
{

    //Step 1a - Check if the client is Renewal (iteminfo file name is "System/iteminfo_Sak.lub" for Renewal clients)
    if (IsSakray())
    {
        var iiName = "System/iteminfo_Sak.lub";
    }
    else
    {
        // iteminfo in old clients
        var iiName = "System/iteminfo.lub";
        if (exe.findString(iiName, RVA) === -1)
        {
            // iteminfo in new clients
            iiName = "System/iteminfo_true.lub";
        }
    }

    //Step 1b - Find offset of the original string
    var offset = exe.findString(iiName, RVA);
    if (offset === -1)
        return "Failed in Step 1 - iteminfo file name not found";

    //Step 1b - Find its reference
    offset = exe.findCode("68" + offset.packToHex(4),  PTYPE_HEX, false);
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
    exe.insert(free, myfile.length, "$newItemInfo", PTYPE_STRING);
    exe.replace(offset+1, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);

    return true;
}

//=================================//
// Disable for Unsupported clients //
//=================================//
function ChangeItemInfo_()
{
    if (IsSakray())
    {
        var iiName = "System/iteminfo_Sak.lub";
    }
    else
    {
        // iteminfo in old clients
        var iiName = "System/iteminfo.lub";
        if (exe.findString(iiName, RAW) !== -1)
            return true;
        // iteminfo in new clients
        iiName = "System/iteminfo_true.lub";
    }
    return (exe.findString(iiName, RAW) !== -1);
}
