function FixTetraVortex()
{
    /////////////////////////////////////////////
    // GOAL: Remove the Tetra Vortex bmp names //
    /////////////////////////////////////////////

    for (var i = 1; i <= 8; i++)
    {
        //Step 1 -  Find the tetra vortex .bmp string address
        var code = "effect\\tv-" + i + ".bmp";
        var offset = pe.stringRaw(code);
        if (offset === -1)
            return "Failed in Step 1." + i;

        //Step 2 - Zero out the string
        pe.replaceByte(offset, 0);
    }
    return true;
}
