//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2021 Andrei Karas (4144)
// Copyright (C) 2021 X-EcutiOnner (xex.ecutionner@gmail.com)
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
//##############################################################################################
//# Purpose: Replace are Arrows Keys offset to fix wrong display Font Charset after comparison #
//#          in Hotkey Setting UI for ASCII Langtype inside UIHotkeyGuideWnd_virt6B function.  #
//##############################################################################################

function FixArrowsCharset()
{
    if (
            exe.getClientDate() >= 20200121 && !IsZero() && !IsSakray() ||  // !TODO: Replace with IsMain()
            exe.getClientDate() >= 20200724 && IsSakray() ||
            exe.getClientDate() >= 20200130 && IsZero()
        )
    {
        consoleLog("Step 1-1a - Prep code for finding the Arrows string");
        var code =
            "A1 E7 00 " +  // 00 asc_D14AEC db '←',0
            "00 " +        // 03 db 0
            "A1 E8 00 " +  // 04 asc_D14AF0 db '↑',0
            "00 " +        // 07 db 0
            "A1 E6 00 " +  // 08 asc_D14AF4 db '→',0
            "00 " +        // 11 db 0
            "A1 E9 00 " +  // 12 asc_D14AF8 db '↓',0
            "00 " +        // 15 db 0
            "A2 C7 00 " +  // 16 asc_D14AFC db '▤',0
            "00 " ;        // 19 db 0

        var Short = true;
        var offset = pe.find(code);

        if (offset === -1)
            return "Failed in Step 1-1a - Pattern not found";

        consoleLog("Step 2-1a - Replace Arrows string for the correct match");
            exe.replace(offset, "20 1B 00 00 20 18 00 00 20 1A 00 00 20 95 00 00 20 0F ", PTYPE_HEX);
    }
    else
    {
        consoleLog("Step 1-1b - Prep code for finding the Arrows string");
        var code1 =
            "A1 E7 00 " +           // 000 asc_C888D8 db '←',0
            "00 " +                 // 003 db 0
            "45 6E 74 65 72 00 " +  // 004 aEnter db 'Enter',0
            "00 00 " +              // 010 align 4
            "53 68 69 66 74 00 " +  // 012 aShift db 'Shift',0
            "00 00 " +              // 018 align 4
            "43 74 72 6C 00    " +  // 020 aCtrl_0 db 'Ctrl',0
            "00 00 00 ";            // 025 align 4

        var LeftLoc = 1;
        var offset1 = pe.find(code1);

        if (offset1 === -1)
            return "Failed in Step 1-1b - Pattern not found";

        consoleLog("Step 1-2b - Prep code for finding the Arrows string");
        var code2 =
            "A1 E8 00 " +           // 00 asc_C8892C db '↑',0
            "00 " +                 // 03 db 0
            "A1 E6 00 " +           // 04 asc_C88930 db '→',0
            "00 " +                 // 07 db 0
            "A1 E9 00 " +           // 08 asc_C88934 db '↓',0
            "00 " +                 // 11 db 0
            "50 72 74 53 63 00 " +  // 12 aPrtsc db 'PrtSc',0
            "00 00 ";               // 18 align 10h

        var UpLoc    = 1;
        var RightLoc = 5;
        var DownLoc  = 9;
        var offset2  = pe.find(code2);

        if (offset2 === -1)
            return "Failed in Step 1-2b - Pattern not found";

        consoleLog("Step 1-3b - Prep code for finding the Arrows string");
        var code3 =
            "58 00 " +     // 00 asc_C88968 db 'X',0
            "00 00 " +     // 02 align 4
            "59 00 " +     // 04 aY_0 db 'Y',0
            "00 00 " +     // 06 align 10h
            "5A 00 " +     // 08 aZ_0 db 'Z',0
            "00 00 " +     // 10 align 4
            "A2 C7 00 " +  // 12 asc_C88974 db '▤',0
            "00 ";         // 15 db 0

        var MenuLoc = 13;
        var offset3 = pe.find(code3);

        if (offset3 === -1)
            return "Failed in Step 1-3b - Pattern not found";

        consoleLog("Step 2-1b - Replace Arrows string for the correct match");
            exe.replace(offset1 - 1 + LeftLoc,  "20 1B ", PTYPE_HEX);
            exe.replace(offset2 - 1 + UpLoc,    "20 18 ", PTYPE_HEX);
            exe.replace(offset2 - 1 + RightLoc, "20 1A ", PTYPE_HEX);
            exe.replace(offset2 - 1 + DownLoc,  "20 95 ", PTYPE_HEX);
            exe.replace(offset3 - 1 + MenuLoc,  "20 0F ", PTYPE_HEX);
    }

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function FixArrowsCharset_()
{
    var code =
        "A1 E8 00 " +  // 00 asc_D14AF0 db '↑',0
        "00 " +        // 03 db 0
        "A1 E6 00 " +  // 04 asc_D14AF4 db '→',0
        "00 " +        // 07 db 0
        "A1 E9 00 " +  // 08 asc_D14AF8 db '↓',0
        "00 ";         // 11 db 0

    return (pe.find(code) !== -1);
}
