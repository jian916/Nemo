
function ChangeHealthBarSize()
{
    var code =
        " 8B 8F AB AB AB AB"    //MOV ECX,[EDI+x]
      + " 6A 09"                //PUSH 09
      + " 6A 3C"                //PUSH 3C
      + " E8"                    //CALL
      ;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1) // new clients
    {
        code = code.replace(" 8B 8F", " 8B 8E");   //replace EDI with ESI
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }
    if (offset === -1)
        return "Failed in Step 1";
    offset = offset + 6;

    code =
        " 8B 86 AB 00 00 00"    //MOV EAX,[ESI+x]
      + " 83 E8 1E"                //SUB EAX,1E
      + " 89 45 D4"                //MOV [EBP-y],EAX
      ;

    var offset2 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset2 === -1) // new clients
    {
        code = code.replace(" 89 45 D4", " 8B BE AB 00 00 00");   //MOV EDI,[ESI+z]
        offset2 = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }
    if (offset2 === -1)
        return "Failed in Step 2";
    offset2 = offset2 + 8;

    var width = exe.getUserInput("$hpWidth", XTYPE_BYTE, _("hp bar width (default 60)"), _("Enter new hp bar width in pixels"), "60", 1, 127);
    var height = exe.getUserInput("$hpHeight", XTYPE_BYTE, _("hp bar height (default 9)"), _("Enter new hp bar height in pixels"), "9", 1, 127);

    exe.replace(offset+1, height.packToHex(1), PTYPE_HEX);
    exe.replace(offset+3, width.packToHex(1), PTYPE_HEX);
    exe.replace(offset2, (width >> 1).packToHex(1), PTYPE_HEX);

    return true;
}
