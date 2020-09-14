//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020 Andrei Karas (4144)
// Copyright (C) 2020 X-EcutiOnner (xex.ecutionner@gmail.com)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//
//#######################################################################
//# Purpose: Modify TownInfoErrorMsg function to return without showing #
//#          the MessageBox and ignore to reading Towninfo.lub file.    #
//#######################################################################

function IgnoreTownInfoReading()
{
    consoleLog("Step 1a - Search string 'TownInfo file Init'");
    var offset = exe.findString("TownInfo file Init", RVA);

    if (offset === -1)
        return "Failed in Step 1a - String not found";

    var strHex = offset.packToHex(4);

    consoleLog("Step 1b - Prep code for finding the TownInfoErrorMsg");
    var code =
        "E8 AB AB AB AB " +     // 00 call sub_892FA0
        "8B AB AB AB AB 00 " +  // 05 mov  esi, ds:MessageBoxA
        "84 C0 " +              // 11 test al, al
        "75 AB " +              // 13 jnz  short loc_841775
        "6A 00 " +              // 15 push 0
        "68 AB AB AB 00 " +     // 17 push offset aError
        "68 " + strHex +        // 22 push offset aTowninfoFileIn
        "6A 00 " +              // 27 push 0
        "FF AB " +              // 29 call esi ; MessageBoxA
        "E8 AB AB AB AB ";      // 31 call sub_A4F320

    var hloc = 15;
    var head = "90 90 ";
    var foot = "90 90 ";
    var loadOffset = 1;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code =
            "E8 AB AB AB AB " +     // 00 call sub_7808E0
            "84 C0 " +              // 05 test al, al
            "75 AB " +              // 07 jnz short loc_A76B29
            "6A 00 " +              // 09 push 0
            "68 AB AB AB 00 " +     // 11 push offset Caption
            "68 " + strHex +        // 16 push offset aTowninfoFileIn
            "6A 00 " +              // 21 push 0
            "FF 15 AB AB AB 00 " +  // 23 call ds:MessageBoxA
            "E8 AB AB AB FF ";      // 29 call sub_920200

        hloc = 9;
        head = "90 90 ";
        foot = "90 90 90 90 90 90 ";
        loadOffset = 1;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "E8 AB AB AB AB " +     // 00 call sub_617080
            "8B 35 AB AB AB 00 " +  // 05 mov  esi, ds:MessageBoxA
            "84 C0 " +              // 11 test al, al
            "75 AB " +              // 13 jnz  short loc_8D8C14
            "53 " +                 // 15 push ebx
            "68 AB AB AB 00 " +     // 16 push offset Caption
            "68 " + strHex +        // 21 push offset aTowninfoFileIn
            "53 " +                 // 26 push ebx
            "FF D6 " +              // 27 call esi ; MessageBoxA
            "E8 AB AB AB FF ";      // 29 call sub_7B9D30

        hloc = 15;
        head = "90 ";
        foot = "90 90 ";
        loadOffset = 1;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
    {
        code =
            "E8 AB AB AB AB " +     // 00 call sub_59ACF0
            "84 C0 " +              // 05 test al, al
            "75 AB " +              // 07 jnz  short loc_801881
            "53 " +                 // 09 push ebx
            "68 AB AB AB 00 " +     // 10 push offset Caption
            "68 " + strHex +        // 15 push offset aTowninfoFileIn
            "53 " +                 // 20 push ebx
            "FF 15 AB AB AB 00 " +  // 21 call ds:MessageBoxA
            "E8 AB AB AB FF ";      // 27 call sub_709360

        hloc = 9;
        head = "90 ";
        foot = "90 90 90 90 90 90 ";
        loadOffset = 1;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in Step 1b - Pattern not found";

    logRawFunc("CTownInfoMgr_Load", offset, loadOffset);

    consoleLog("Step 1c - Replace with xor eax, eax followed by nops");
    exe.replace(offset, "33 C0 90 90 90 ", PTYPE_HEX);  // xor eax, eax + nops

    var hcode =
        head +               // nops
        "33 C0 90 90 90 " +  // xor eax, eax + nops
        "33 C0 90 90 90 " +  // xor eax, eax + nops
        head +               // nops
        foot +               // nops
        "E8 ";               // call sub_A4F320

    exe.replace(offset + hloc, hcode, PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function IgnoreTownInfoReading_()
{
    return (exe.findString("System/Towninfo.lub", RVA) !== -1);
}
