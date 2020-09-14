function Enable44khzAudio ()
{
    //Step 1 - Find the code assign sampling frequency
    var code =
        "C7 86 AB AB 00 00 40 1F 00 00 " + // 0 mov [esi+CSoundMgr.digitalrate], 1F40h
        "EB 16 " +                         // 10 jmp short loc_4656C2
        "C7 86 AB AB 00 00 11 2B 00 00 " + // 12 mov [esi+CSoundMgr.digitalrate], 2B11h
        "EB 0A " +                         // 22 jmp short loc_4656C2
        "C7 86 AB AB 00 00 22 56 00 00 ";  // 24 mov [esi+CSoundMgr.digitalrate], 5622h

    var patchOffset = 30;
    var digitalRateOffsets = [[2, 4], [14, 4], [26, 4]];
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in Step 1";

    for (var i = 0; i < digitalRateOffsets.length; i++)
    {
        logField("CSoundMgr::digitalrate", offset, digitalRateOffsets[i]);
    }

    //Step 2 - Replace 22050 with 44100.
    exe.replace(offset + patchOffset, " 44 AC 00 00", PTYPE_HEX); //44100

    return true;
}
