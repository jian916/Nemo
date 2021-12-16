//#####################################################################
//# Purpose: Zero out 'manner.txt' to prevent any reference bad words #
//#          from loading to compare against                          #
//#####################################################################

function DisableSwearFilter()
{
    //Step 1 - Find offset of manner.txt
    var offset = pe.stringRaw("manner.txt");
    if (offset === -1)
        return "Failed in Step 1";

    //Step 2 - Replace with Zero
    pe.replaceByte(offset, 0);

    return true;
}
