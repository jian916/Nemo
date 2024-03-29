//#############################################################
//# Purpose: Make client Ignore the character check result of #
//#          space in Guild names inside CGameMode::SendMsg   #
//#############################################################

function AllowSpaceInGuildName()
{
    //Step 1 - Find the comparison code
    var code =
        " 6A 20"    //PUSH 20
      + " ??"       //PUSH reg32_B
      + " FF ??"    //CALL reg32_A; MSVCR#.strchr
      + " 83 C4 08" //ADD ESP, 8
      + " 85 C0"    //TEST EAX, EAX
      ;

    var offset = pe.findCode(code);
    if (offset === -1) //newer clients
    {
        code =
            " 6A 20"    //PUSH 20
          + " ??"       //PUSH reg32_B
          + " E8 ?? ?? ?? ??"  //CALL rel32; MSVCR#.strchr
          + " 83 C4 08" //ADD ESP, 8
          + " 85 C0"    //TEST EAX, EAX
        ;
        offset = pe.findCode(code);
    }
    if (offset === -1)
        return "Failed in Step 1";

    offset += code.hexlength();

    //Step 2 - Overwrite Conditional Jump after TEST. Skip JNEs and change JZ to JMP
    code = "";
    switch (pe.fetchUByte(offset))
    {
        case 0x74:
        {
            code = "EB"; //Change JE SHORT to JMP SHORT
            break;
        }
        case 0x75:
        {
            code = "90 90"; //NOPs
            break;
        }
        case 0x0F:
        {
            switch(pe.fetchUByte(offset+1))
            {
                case 0x84:
                {
                    code = "90 E9"; //JE to JMP
                    break;
                }
                case 0x85:
                {
                    code = " EB 04"; //JNZ to JMP 4 bytes later. alternative to NOP
                    break;
                }
            }
        }
    }

    if (code === "")
        return "Failed in Step 2 - No JMP forms follow code";

    pe.replaceHex(offset, code);

    return true;
}

//==============================//
// Disable for Unsupported date //
//==============================//
function AllowSpaceInGuildName_()
{
    return (exe.getClientDate() >= 20120207);
}
