//###############################################
//# Purpose: Modify ErrorMsg function to return #
//#          without showing the MessageBox     #
//###############################################

function IgnoreResourceErrors()
{
  //Step 1a - Prep code for finding the ErrorMsg(msg) function - New Client has different pattern (see Step 1b)
    var code =
        " E8 AB AB AB FF"    //CALL GDIFlip
      + " MovEax"            //FramePointer Specific MOV
      + " 8B 0D AB AB AB 00" //MOV ECX, DWORD PTR DS:[g_hMainWnd]
      + " 6A 00"             //PUSH 0
      ;

    var fpEnb = HasFramePointer();
    if (fpEnb)
        code = code.replace(" MovEax", " 8B 45 08");    //MOV EAX, DWORD PTR SS:[EBP-8]
    else
        code = code.replace(" MovEax", " 8B 44 24 04"); //MOV EAX, DWORD PTR SS:[ESP+4]

    //Step 1b - Find the function
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    { //New Client - direct PUSHes ugh
        code =
            " E8 AB AB AB FF" //CALL GDIFlip
          + " 6A 00"          //PUSH 0
          + " 68 AB AB AB 00" //PUSH OFFSET addr; ASCII "Error"
          + " FF 75 08"       //PUSH DWORD PTR SS:[EBP+8]
        ;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {  // generic search way from bpe.
        offset = exe.findString("Failed to load Winsock library!", RVA);
        if (offset === -1)
            return "Failed search 'Failed to load Winsock library!";

        code = " 68" + offset.packToHex(4) +  // push "Failed to load Winsock library!"
               " E8";  // call ErrorMsg
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
        if (offset === -1)
            return "Failed search ErrMsg call";
        offset = offset + 10 + exe.fetchDWord(offset + 6)

        // we found ErrorMsg function. now searching for some bytes patterns
        code =
            " E8 AB AB AB FF" //CALL GDIFlip
          + " FF 75 0C"       //PUSH [ebp + uType]
          + " 68 AB AB AB 00" //PUSH OFFSET addr; ASCII "Error"
          + " FF 75 08"       //PUSH DWORD PTR SS:[EBP+8]
        ;
        offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x20);
        if (offset === -1)
            return "Failed search MsgBox call";
    }

    //Step 2 - Replace with XOR EAX, EAX followed by RETN . If Frame Pointer is present then a POP EBP comes before RETN
    if (fpEnb)
        exe.replace(offset + 5, " 33 C0 5D C3", PTYPE_HEX);
    else
        exe.replace(offset + 5, " 33 C0 C3 90", PTYPE_HEX);
    return true;
}
