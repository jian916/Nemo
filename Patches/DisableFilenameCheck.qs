//#######################################################################
//# Purpose: Change the JNZ inside WinMain (or function called from it) #
//#          to JMP which will skip showing the "Invalid Exe" Message   #
//#######################################################################

function DisableFilenameCheck()
{
    //Step 1 - Find the Comparison pattern
    var code =
        " 84 C0"          //TEST AL, AL
      + " 74 07"          //JZ SHORT addr1
      + " E8 AB AB FF FF" //CALL SearchProcessIn9X
      + " EB 05"          //JMP SHORT addr2
      + " E8 AB AB FF FF" //CALL SearchProcessInNT <= addr1
      + " 84 C0"          //TEST AL, AL <= addr2
      + " 75"             //JNZ addr3
      ;
    var patchOffset = 18;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code =
            " 84 C0"          //TEST AL, AL
          + " 74 0C"          //JZ SHORT addr1
          + " E8 AB AB FF FF" //CALL SearchProcessIn9X
          + " EB 0A BE 01 00 00 00" //JMP SHORT addr2
          + " E8 AB AB FF FF" //CALL SearchProcessInNT <= addr1
          + " 84 C0"          //TEST AL, AL <= addr2
          + " 75"             //JNZ addr3
          ;
        patchOffset = 23;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {   // 2019-02-13
        code =
            "85 C0 " +                    // 0 test eax, eax
            "74 10 " +                    // 2 jz short loc_AB8DEB
            "83 BD AB AB AB FF 01 " +     // 4 cmp [ebp+VersionInformation.dwPlatformId], 1
            "75 07 " +                    // 11 jnz short loc_AB8DEB
            "E8 AB AB AB FF " +           // 13 call SearchProcessIn9X
            "EB 05 " +                    // 18 jmp short loc_AB8DF0
            "E8 AB AB AB FF " +           // 20 call SearchProcessInNT
            "84 C0 " +                    // 25 test al, al
            "75 1C " +                    // 27 jnz short loc_AB8E10
            "6A 00 " +                    // 29 push 0
            "6A 00 " +                    // 31 push 0
            "68 AB AB AB 00 " +           // 33 push offset aDKIMOJRT_
            "FF 35 AB AB AB 00 " +        // 38 push hWnd
            "FF 15 AB AB AB AB " +        // 44 call ds:MessageBoxA
            "33 C0 " +                    // 50 xor eax, eax
            "E9 ";                        // 52 jmp loc_AB9361
        patchOffset = 27;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {   // 2019-03-06
        code =
            "85 C0 " +                    // 0 test eax, eax
            "74 10 " +                    // 2 jz short loc_AB8DEB
            "83 BD AB AB AB FF 01 " +     // 4 cmp [ebp+VersionInformation.dwPlatformId], 1
            "75 07 " +                    // 11 jnz short loc_AB8DEB
            "E8 AB AB AB FF " +           // 13 call SearchProcessIn9X
            "EB 05 " +                    // 18 jmp short loc_AB8DF0
            "E8 AB AB AB FF " +           // 20 call SearchProcessInNT
            "84 C0 " +                    // 25 test al, al
            "75 1C " +                    // 27 jnz short loc_AB8E10
            "6A 00 " +                    // 29 push 0
            "6A 00 " +                    // 31 push 0
            "68 AB AB AB 00 " +           // 33 push offset aDKIMOJRT_
            "FF 35 AB AB AB 01 " +        // 38 push hWnd
            "FF 15 AB AB AB AB " +        // 44 call ds:MessageBoxA
            "33 C0 " +                    // 50 xor eax, eax
            "E9 ";                        // 52 jmp loc_AB9361
        patchOffset = 27;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1";

    //Step 2 - Replace JNZ/JNE to JMP
    exe.replace(offset + patchOffset, "EB", PTYPE_HEX);

    return true;
}
