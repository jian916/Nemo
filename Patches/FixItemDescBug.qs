//######################################################################
//#        Purpose: Fix Item Description '[' Bug                       #
//######################################################################

function FixItemDescBug()
{
    var offset = exe.findCode("80 3E 5B 75 31", PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in Step 1 - '[' string missing";
    exe.replace(offset, "80 3E 5B EB 31", PTYPE_HEX);
    return true;
}

function FixItemDescBug_()
{
    return (exe.findCode("80 3E 5B 75 31", PTYPE_HEX, false) !== -1);
}
