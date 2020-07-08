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
        "8B 0D AB AB AB AB" +  // mov ecx, screen_width
        "A3 AB AB AB AB" +     // mov screen_old_height, eax
        "81 F9 00 04 00 00" +  // cmp ecx, 400h
        "72 0C" +              // jb short A
        "A1 AB AB AB AB" +     // mov eax, screen_height
        "3D 00 03 00 00" +     // cmp eax, 300h
        "73 15" +              // jnb short B
        "B9 00 04 00 00" +     // mov ecx, 400h
        "B8 00 03 00 00" +     // mov eax, 300h
        "89 0D AB AB AB AB" +  // mov screen_width, ecx
        "A3"                   // mov screen_height, eax
    var widthOffset1 = 13;
    var widthOffset2 = 32;
    var heightOffset1 = 25;
    var heightOffset2 = 37;
    var widthLimit = 1024;
    var heightLimit = 768;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
	
	if (offset === -1)  //Newer clients only compare screen_height
	{
		code =
		" A3 AB AB AB AB" +     // mov screen_old_height, eax
		" A1 AB AB AB AB" +     // mov eax, screen_height
		" 3D 98 02 00 00" +     // cmp eax, 298h
		" 73 17" +              // jnb short B
        " B9 00 04 00 00" +     // mov ecx, 400h
        " B8 00 03 00 00" +     // mov eax, 300h
        " 89 0D AB AB AB AB" +  // mov screen_width, ecx
        " A3" ;                 // mov screen_height, eax
		
		var newClient = true;
		var widthOffset1 = -1;
		var widthOffset2 = 18;
		var heightOffset1 = 11;
		var heightOffset2 = 23;
		var widthLimit = 1024;
		var heightLimit = 768;
		var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
	}

    if (offset === -1)
        return "Failed in step 1 - resolution limit not found";
	
	if (!newClient) {
		if (exe.fetchDWord(offset + widthOffset1) !== widthLimit || exe.fetchDWord(offset + widthOffset1) !== exe.fetchDWord(offset + widthOffset2))
			return "Failed in step 1 - wrong width limit found";
	
		if (exe.fetchDWord(offset + heightOffset1) !== heightLimit || exe.fetchDWord(offset + heightOffset1) !== exe.fetchDWord(offset + heightOffset2))
			return "Failed in step 1 - wrong height limit found";
	}

    var width = exe.getUserInput("$newScreenWidth", XTYPE_DWORD, _("Number Input"), _("Enter new minimal width:"), widthLimit, 0, 100000);
    var height = exe.getUserInput("$newScreenHeight", XTYPE_DWORD, _("Number Input"), _("Enter new minimal height:"), heightLimit, 0, 100000);
    if (width === widthLimit && height === heightLimit)
    {
        return "Patch Cancelled - New width and height is same as old";
    }

    width = width.packToHex(4);
    height = height.packToHex(4);

	if (!newClient) {
		exe.replace(offset + widthOffset1, width, PTYPE_HEX);
	}
    exe.replace(offset + widthOffset2, width, PTYPE_HEX);
    exe.replace(offset + heightOffset1, height, PTYPE_HEX);
    exe.replace(offset + heightOffset2, height, PTYPE_HEX);

    return true;
}

function ChangeMinimalResolutionLimit_()
{
    return (exe.findString("WIDTH", RAW) !== -1);  
}
