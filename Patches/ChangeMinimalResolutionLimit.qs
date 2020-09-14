//
// Copyright (C) 2018-2019  Andrei Karas (4144)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//###########################################################
//# Purpose: Change minimal screen resolution limit for     #
//#          width and height in function reading settings  #
//###########################################################

function ChangeMinimalResolutionLimit()
{
    var code =
        "8B 0D AB AB AB AB " +        // 0 mov ecx, screen_width
        "A3 AB AB AB AB " +           // 6 mov screen_old_height, eax
        "81 F9 00 04 00 00 " +        // 11 cmp ecx, 400h
        "72 0C " +                    // 17 jb short loc_ADA278
        "A1 AB AB AB AB " +           // 19 mov eax, screen_height
        "3D 00 03 00 00 " +           // 24 cmp eax, 300h
        "73 15 " +                    // 29 jnb short loc_ADA28D
        "B9 00 04 00 00 " +           // 31 mov ecx, 400h
        "B8 00 03 00 00 " +           // 36 mov eax, 300h
        "89 0D AB AB AB AB " +        // 41 mov screen_width, ecx
        "A3 ";                        // 47 mov screen_height, eax
    var widthOffset1 = 13;
    var widthOffset2 = 32;
    var heightOffset1 = 25;
    var heightOffset2 = 37;
    var screenOldHeightOffset = 7;
    var screenWidth1Offset = 2;
    var screenWidth2Offset = 43;
    var screenHeight1Offset = 20;
    var screenHeight2Offset = 48;
    var widthLimit = 1024;
    var heightLimit1 = 768;
    var heightLimit2 = 768;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)  //Newer clients only compare screen_height
    {
        code =
            "A3 AB AB AB AB " +           // 0 mov screen_old_height, eax
            "A1 AB AB AB AB " +           // 5 mov eax, screen_height
            "3D 98 02 00 00 " +           // 10 cmp eax, 298h
            "73 17 " +                    // 15 jnb short loc_AAF6A6
            "B9 00 04 00 00 " +           // 17 mov ecx, 400h
            "B8 00 03 00 00 " +           // 22 mov eax, 300h
            "89 0D AB AB AB AB " +        // 27 mov screen_width, ecx
            "A3 ";                        // 33 mov screen_height, eax
        widthOffset1 = -1;
        widthOffset2 = 18;
        heightOffset1 = 11;
        heightOffset2 = 23;
        screenOldHeightOffset = 1;
        screenWidth1Offset = 29;
        screenWidth2Offset = -1;
        screenHeight1Offset = 6;
        screenHeight2Offset = 34;
        widthLimit = 1024;
        heightLimit1 = 664;
        heightLimit2 = 768;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in step 1 - resolution limit not found";

    if (widthOffset1 !== -1 && exe.fetchDWord(offset + widthOffset1) !== widthLimit)
    {
        return "Failed in step 1 - wrong width limit found";
    }
    if (exe.fetchDWord(offset + widthOffset2) !== widthLimit)
    {
        return "Failed in step 1 - wrong width limit found";
    }
    if (exe.fetchDWord(offset + heightOffset1) !== heightLimit1 || exe.fetchDWord(offset + heightOffset2) !== heightLimit2)
    {
        return "Failed in step 1 - wrong height limit found";
    }
    if (screenWidth2Offset !== -1 && exe.fetchDWord(offset + screenWidth1Offset) !== exe.fetchDWord(offset + screenWidth2Offset))
    {
        return "Failed in step 1 - wrong width found";
    }
    if (exe.fetchDWord(offset + screenHeight1Offset) !== exe.fetchDWord(offset + screenHeight2Offset))
    {
        return "Failed in step 1 - wrong height found";
    }

    logVaVar("screen_old_height", offset, screenOldHeightOffset);
    logVaVar("screen_width", offset, screenWidth1Offset);
    logVaVar("screen_height", offset, screenHeight1Offset);
    logVal("screen_width_limit", offset, widthOffset1);
    logVal("screen_height_limit", offset, heightOffset2);

    var width = exe.getUserInput("$newScreenWidth", XTYPE_DWORD, _("Number Input"), _("Enter new minimal width:"), widthLimit, 0, 100000);
    var height = exe.getUserInput("$newScreenHeight", XTYPE_DWORD, _("Number Input"), _("Enter new minimal height:"), heightLimit2, 0, 100000);
    if (width === widthLimit && (height === heightLimit1 || height === heightLimit2))
    {
        return "Patch Cancelled - New width and height is same as old";
    }

    width = width.packToHex(4);
    height = height.packToHex(4);

    if (widthOffset1 !== -1)
    {
        exe.replace(offset + widthOffset1, width, PTYPE_HEX);
    }
    exe.replace(offset + widthOffset2, width, PTYPE_HEX);
    exe.replace(offset + heightOffset1, height, PTYPE_HEX);
    exe.replace(offset + heightOffset2, height, PTYPE_HEX);


    //Fix potential crash when access the Advanced Settings
    var screenWidthAdd = exe.fetchHex(offset + screenWidth1Offset, 4);
    var screenHeightAdd = exe.fetchHex(offset + screenHeight1Offset, 4);

    code =
        "3B 3D " + screenWidthAdd +    //cmp edi, screenWidth
        "8B BD AB AB AB AB " +         //mov edi, [ebp-x]
        "75 AB " +                     //jne short
        "3B 35 " + screenHeightAdd +   //cmp esi, screenHeight
        "75 AB ";                      //jne short

    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1) //Newer clients
    {
        code =
            "3B AB " + screenWidthAdd +    //cmp reg, screenWidth
            "75 AB " +                     //jne short
            "3B 35 " + screenHeightAdd +   //cmp esi, screenHeight
            "75 AB " +                     //jne short
            "3B ";                         //cmp reg, screenColor

        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    }
    if (offset === -1)
        return "Failed in step 2a";

    code =
        "A3 AB AB AB AB " +              //mov resolutionListIndex, eax
        "89 AB AB 00 00 00 ";            //mov [reg+y], eax

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x80);
    if (offset === -1)
        return "Failed in step 2b";

    code = exe.fetchHex(offset, 5);
    var retAdd = offset + 5;

    var ins =
        "83 F8 00 " +                               //cmp eax,0
        "7D 02 " +                                  //jnl 02
        "31 C0 " +                                  //xor eax,eax
        code +                                      //mov resolutionListIndex, eax
        + " 68" + exe.Raw2Rva(retAdd).packToHex(4)  //push retAdd
        + " C3";                                    //ret

    var size = ins.hexlength();
    var free = exe.findZeros(size + 4);
    if (free === -1)
        return "Failed in Step 3 - No enough free space";


    var jump = exe.Raw2Rva(free) - exe.Raw2Rva(offset + 5);

    code = " E9" + jump.packToHex(4);


    exe.insert(free, size + 4, ins, PTYPE_HEX);
    exe.replace(offset, code, PTYPE_HEX);



    return true;
}

function ChangeMinimalResolutionLimit_()
{
    return (exe.findString("WIDTH", RAW) !== -1);
}
