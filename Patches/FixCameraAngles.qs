//========================================================//
// Patch Functions wrapping over FixCameraAngles function //
//========================================================//

function FixCameraAnglesRecomm()
{
    return FixCameraAngles(floatToHex(42.0));
}

function FixCameraAnglesLess()
{
    return FixCameraAngles(floatToHex(29.50));
}

function FixCameraAnglesFull()
{
    return FixCameraAngles(floatToHex(65.0));
}

function FixCameraAnglesCustom()
{
    var angle = exe.getUserInput("$cameraAngle", XTYPE_DWORD, _("Number Input"), _("Enter max camera angle value (43 - recommended, 29.5 - less, 65 - full):"), 43);
    return FixCameraAngles(floatToHex(angle));
}

//====================================================================================//
// Note - VC9+ compilers finally recognized to store float values which are used more //
//        than once at an offset and use FLD/FSTP/MOVSS to place those in registers.  //
//====================================================================================//

//#############################################################
//# Purpose: Find the Camera Angle and replace with new angle #
//#############################################################

function FixCameraAngles(newvalue)
{
    consoleLog("Step 1a - Find the common pattern after the function call we need.");
    var code =
        " 6A 01" //PUSH 1
      + " 6A 5D" //PUSH 5D
      + " EB";   //JMP SHORT addr
    var offset = pe.findCode(code);

    if (offset !== -1)
    { //VC9+ clients
        consoleLog("Step 1b - Now find the function call we need (should be within 0x50 bytes before)");
            code =
                "8B CE " +                    // 0 mov ecx, esi
                "E8 ?? ?? ?? ?? " +           // 2 call CGameMode_ProcessRBtn
                "?? " +                       // 7 push edi
                "8B CE " +                    // 8 mov ecx, esi
                "E8 ";                        // 10 call CGameMode_ProcessWheel
        var ProcessRBtnOffset = 3;
        var ProcessWheelOffset = 11;

        offset = pe.find(code, offset - 0x80, offset);
        if (offset === -1)
            return "Failed in Step 1 - Function Call Missing";

        logRawFunc("CGameMode_ProcessRBtn", offset, ProcessRBtnOffset);
        logRawFunc("CGameMode_ProcessWheel", offset, ProcessWheelOffset);

        consoleLog("Step 1c - Extract the Function Address (RAW)");
        offset = pe.vaToRaw(pe.fetchRelativeValue(offset, [ProcessRBtnOffset, 4]));

        consoleLog("Step 2a - Find the angle value assignment in the function (should be within 0x800 bytes)");
        code =
            " 74 ??"             //JZ SHORT addr
          + " D9 05 ?? ?? ?? 00" //FLD DWORD PTR DS:[angleAddr]
          ;
        var angleOffset = 4;
        var offset2 = pe.find(code, offset, offset+0x800);

        if (offset2 === -1)
        {
            code =
                " 74 ??"                     //JZ SHORT addr
              + " F3 0F 10 ?? ?? ?? ?? 00";  //MOVSS XMM#, DWORD PTR DS:[angleAddr]
            var angleOffset = 6;
            offset2 = pe.find(code, offset, offset+0x800);
        }

        if (offset2 === -1)
            return "Failed in Step 2 - Angle Address missing";

        offset2 += angleOffset;

        consoleLog("Step 2b - Find Space to allocate the new angle");
        var free = exe.insertHex(newvalue);

        consoleLog("Step 3b - Replace angleAddr reference with the allocated address");
        pe.replaceDWord(offset2, pe.rawToVa(free));
    }
    else
    { //Older clients
        consoleLog("Step 4a - Find all locations where the current angle = 20.00 (0x41A0000) is assigned");
        code =
            " C7 45 ?? 00 00 A0 41" //MOV DWORD PTR SS:[EBP+const1], 41A00000 ; FLOAT 20.00000
          + " 8B";                  //MOV reg32_A, DWORD PTR DS:[reg32_B+const2]

        var offsets = pe.findCodes(code);
        if (offsets.length === 0 || offsets.length > 2)
            return "Failed in Step 4 - No or Too Many matches";

        consoleLog("Step 4b - Change the angle value for all in offsets");
        for (var i = 0; i < offsets.length; i++)
        {
            pe.replaceHex(offsets[i] + 3, newvalue);
        }

        consoleLog("Step 5a - Now we need to find two stored angles -25.00000 and -65.00000 (dunno what this is for, but it was there in old patch)");
        code =
            " 00 00 C8 C1"  //DD FLOAT -25.00000
          + " 00 00 82 C2";  //DD FLOAT -65.00000

        offset = pe.find(code, pe.sectionRaw(CODE)[1]);  // Check only after Code section
        if (offset === -1)
            return "Failed in Step 5";

        consoleLog("Step 5b - Replace with -1.00000 and -89.00000 respectively");
        code =
            " 00 00 80 BF"  //DD FLOAT -1.00000
          + " 00 00 B2 C2";  //DD FLOAT -89.00000

        pe.replaceHex(offset, code);
    }

    return true;
}
