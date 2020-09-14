//###################################################################
//# Purpose: Change the JNE and JLE to JMP after Hourly Comparisons #
//#          inside CRenderer::DrawAgeRate & PlayTime functions     #
//###################################################################

function RemoveHourlyAnnounce()
{
    //Step 1a - Find the comparison for Game Grade
    var code =
        " 75 AB"    //JNE SHORT addr1
      + " MovR16"    //Frame Pointer Specific MOV
      + " 66 85 AB" //TEST r16, r16
      + " 75 AB"    //JNE SHORT addr2
      ;

    if (offset === -1)
        return "Failed in Step 1a - Pattern not found";

    // Step 1b - Find the Mov R16 reference
    var fpEnb = HasFramePointer();
    if (fpEnb)
        code = code.replace(" MovR16", " 66 8B AB AB"); //MOV r16, WORD PTR SS:[EBP-x]
    else
        code = code.replace(" MovR16", " 66 8B AB 24 AB"); //MOV r16, WORD PTR SS:[ESP+x]

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB"); //VC9+ Clients

    if (offset === -1)
    {
        code = code.replace(" 66", ""); //Change MOV AX to MOV EAX and thereby WORD PTR becomes DWORD PTR
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB"); //Older clients and some new clients
    }

    if (offset === -1 && !fpEnb)
    {
        code = code.replace(" 8B AB 24 AB", " 66 8B AB AB"); // HasFramePointer() broke? [Secret]
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1b - Mov R16 reference not found";

    //Step 1c - Change JNE to JMP
    exe.replace(offset, "EB", PTYPE_HEX);

    var code = "\x25\x64\x20\xBD\xC3\xB0\xA3\xC0\xCC\x20\xB0\xE6\xB0\xFA\xC7\xDF\xBD\xC0\xB4\xCF\xB4\xD9\x2E"; // "%d 시간이 경과했습니다."
    var offset = exe.findString(code, RAW);

    if (offset === -1)
        return "Failed in step 2a - string not found";

    offset = exe.findCode("68" + exe.Raw2Rva(offset).packToHex(4), PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in step 2a - string reference missing";

    //Step 2a - Find Time divider before the PlayTime Reminder comparison - mov eax, 95217CB1h
    offset = exe.find(" B8 B1 7C 21 95", PTYPE_HEX, true, "\xAB", offset - 0xFF, offset);

    if (offset === -1)
        return "Failed in Step 2b - Magic Divisor not found";

    //Step 2b - Find the JLE after each (below the TEST/CMP instruction)
    offset = exe.find(" 0F 8E AB AB 00 00", PTYPE_HEX, true, "\xAB", offset + 7, offset + 30); //JLE addr

    if (offset === -1)
        offset = exe.find(" 0F 86 AB 00 00 00", PTYPE_HEX, true, "\xAB", offset + 7, offset + 55); // JBE addr

    if (offset === -1)
        return "Failed in Step 2c - Comparison not found";

    //Step 2c - Change to NOP + JMP
    exe.replace(offset, " 90 E9", PTYPE_HEX);

    return true;
}
