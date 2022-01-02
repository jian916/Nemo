//#################################################################
//# Purpose: Change the JE after comparison of g_useEffect with 0 #
//#          to JMP in Hallucination Effect maker function        #
//#################################################################

function DisableHallucinationWavyScreen()
{
    consoleLog("Extract g_useEffect");
    var isEffectOn = table.getSessionAbsHex4(table.CSession_isEffectOn);

    consoleLog("Find the Comparison we need");
    var code =
        " 8B ??"                      //MOV ECX, reg32
      + " E8 ?? ?? ?? ??"             //CALL addr1
      + " 83 3D" + isEffectOn + " 00" //CMP DWORD PTR DS:[g_useEffect], 0
      + " 0F 84";                     //JE LONG addr2

    var offset = pe.findCode(code);

    if (offset === -1)
    {
        var code =
            " 8B ??"                      //MOV ECX, reg32
          + " E8 ?? ?? ?? ??"             //CALL addr1
          + "A1" + isEffectOn + " 85 C0"  // MOV EAX, DS:[g_useEffect]
          + " 0F 84";                     //JE LONG addr2
        offset = pe.findCode(code);
    }

    if (offset === -1)
        return "Failed in Step 2";

    consoleLog("Replace the JE with NOP + JMP");
    pe.replaceHex(offset + code.hexlength() - 2, "90 E9");

    return true;
}
