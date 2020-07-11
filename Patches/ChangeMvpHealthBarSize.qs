function ChangeMvpHealthBarSize()
{
    var code =
        " 6A 05"
      + " 6A 3C"
      + " 8B C8"
      + " 89 83 AB AB 00 00"
      + " E8 AB AB AB AB"
      + " FF B3 AB AB 00 00"
      + " B9 AB AB AB AB"
      + " E8 AB AB AB AB"
      + " 8B 8B AB AB 00 00"
      + " 56"
      ;

    var offset1 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset1 === -1) //newer clients
    {
    code = code.replace(" 6A 05 6A 3C 8B C8", " 8B C8 6A 05 6A 3C");
    offset1 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset1 === -1)
{
        code =
          " 6A 05"
        + " 6A 3C"
        + " 8B C8"
        + " 89 83 AB AB 00 00"
        + " E8 AB AB AB AB"
        + " FF B3 AB AB 00 00"
        + " B9 AB AB AB AB"
        + " E8 AB AB AB AB"
        + " 8B BD AB AB AB AB"
        + " 8B 8B AB AB 00 00"
        + " 56"
        ;

        offset1 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset1 === -1)
        return "Failed in Step 1";

    var offset2 = exe.findString("??????", RVA, true);
    if (offset === -1)
        return "Failed in Step 2a";

    offset2 = exe.findCode("68"+ offset2.packToHex(4), PTYPE_HEX, false);
    if (offset2 === -1)
        return "Failed in Step 2b";

    code =
        " 8A 87 AB AB 00 00"
      + " 88 85 AB AB FF FF"
      + " 8B AB"
      ;

    offset2 = exe.find(code, PTYPE_HEX, true, "\xAB", offset2, offset2 + 0xB0);
    if (offset2 === -1)
        return "Failed in Step 2c";

    var isBoss = exe.fetchHex(offset2 + 2, 4);
    var oriCode = exe.fetchHex(offset1, 6);
    var retAdd = offset1 + 6;

    var width = exe.getUserInput("$mvpHpWidth", XTYPE_BYTE, _("Hp bar width (default 60)"), _("Enter new hp bar width in pixels"), "60", 1, 127);
    var height = exe.getUserInput("$mvpHpHeight", XTYPE_BYTE, _("Hp bar height (default 5)"), _("Enter new hp bar height in pixels"), "5", 1, 127);

    var ins =
        " 80 BB" + isBoss + " 01"
      + " 0F 85 08 00 00 00"
      + " 6A" + height.packToHex(1)
      + " 6A" + width.packToHex(1)
      + " 8B C8"
      + " EB 06"
      +  oriCode
      + " 68" + exe.Raw2Rva(retAdd).packToHex(4)
      + " C3"
      ;

    var size = ins.hexlength();
    var free = exe.findZeros(size + 4);
    if (free === -1)
        return "Failed in Step 3";

    var freeRva = exe.Raw2Rva(free);
    var offset = freeRva - exe.Raw2Rva(offset1 + 5);

    code = " E9" + offset.packToHex(4) + " 90";

    exe.insert(free, size + 4, ins, PTYPE_HEX);
    exe.replace(offset1, code, PTYPE_HEX);

    return true;
}
