//#############################################################
//# Purpose: Modify the CGameMode::HaveSiegfriedItem function #
//#          to ignore map type comparisons                   #
//#############################################################

function ShowResurrectionButton()
{ //To do - When on PVP/GVG map the second time u die, the char gets warped to save point anyways.

    //Step 1 - Find the "Token of Siegfried" id PUSH in CGameMode::HaveSiegfriedItem function.
    var offset = pe.findCode(" 68 C5 1D 00 00"); //PUSH 1D5C
    if (offset === -1)
        return "Failed in Step 1";

    offset += 15;//Skipping over the PUSH, MOV ECX and CALL . Any other statements in between can vary

    //Step 2a - Find the triple comparisons after the PUSH (unknown param, PVP, GVG)

    var code =
        " 8B 48 ??" //MOV ECX, DWORD PTR DS:[EAX+const]
      + " 85 C9"    //TEST ECX, ECX
      + " 75 ??"    //JNE SHORT addr
      ;

    var type = 1;//VC6 style
    var offset2 = pe.find(code + code + code, offset, offset + 0x40);

    if (offset2 === -1)
    {
        code =
            " 83 78 ?? 00" //CMP DWORD PTR DS:[EAX+const], 0
          + " 75 ??"       //JNE SHORT addr
        ;

        type = 2;//VC9 & VC11 style
        offset2 = pe.find(code + code + code, offset, offset + 0x40);
    }

    if (offset2 === -1)
    {
        code =
            " 39 58 ??"          //CMP DWORD PTR DS:[EAX+const], reg32
          + " 0F 85 ?? 00 00 00" //JNE addr
        ;

        type = 3;//VC10 style
        offset2 = pe.find(code + code + code, offset, offset + 0x40);
    }

    if (offset2 === -1)
    {
        code =
            " 83 78 ?? 00" //CMP DWORD PTR DS:[EAX+const], 0
          + " 0F 85 ?? 00 00 00" //JNE addr
        ;

        type = 4;//VC17 style
        offset2 = pe.find(code + code + code, offset, offset + 0x40);
    }
    if (offset2 === -1)
    {
        code =
            " 83 78 ?? 00" //CMP DWORD PTR DS:[EAX+const], 0
          + " 0F 85 ?? 01 00 00" //JNE addr
        ;

        type = 4;//VC17 style
        offset2 = pe.find(code + code + code, offset, offset + 0x40);
    }

    if (offset2 === -1)
        return "Failed in Step 2 - No comparisons matched";

    //Step 2b - Skip over the 3 comparisons using a short JMP
    pe.replaceHex(offset2, "EB" + (3 * code.hexlength() - 2).packToHex(1));

    return true;
}
