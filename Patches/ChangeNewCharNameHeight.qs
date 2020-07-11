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
//####################################################
//# Purpose: Change height for UIEditCtrl2 in        #
//#          UINewMakeCharWnd_virt56                 #
//####################################################

function ChangeNewCharNameHeight()
{
    var code =
        "C7 45 AB FF FF FF FF" +  // mov [ebp+var], 0FFFFFFFFh
        "6A 0D" +                 // push 0Dh    <- change here
        "68 82 00 00 00" +        // push 82h
        "8B C8" +                 // mov ecx, eax
        "89 83 AB AB 00 00" +     // mov  [ebx+28Ch], eax
        "E8 AB AB AB 00" +        // call UIWindow_Create
        "8B 8B AB AB 00 00";      // mov ecx, [ebx+28Ch]
    var heightOffset = 8;
    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
    {
        code =
        "C7 45 AB FF FF FF FF" +  // mov [ebp+var], 0FFFFFFFFh
        "8B C8" +                 // mov ecx, eax
        "6A 0D" +                 // push 0Dh    <- change here
        "68 82 00 00 00" +        // push 82h
        "89 83 AB AB 00 00" +     // mov  [ebx+28Ch], eax
        "E8 AB AB AB 00" +        // call UIWindow_Create
        "8B 8B AB AB 00 00";      // mov ecx, [ebx+28Ch]

        heightOffset = 10;
        offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    }

    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    var height = exe.getUserInput("$newCharNameHeight", XTYPE_BYTE, _("Number Input"), _("Enter new char name height (0-255, default is 13):"), 13, 0, 255);
    if (height === 13)
    {
        return "Patch Cancelled - New value is same as old";
    }

    exe.replace(offset + heightOffset, "$newCharNameHeight", PTYPE_STRING);

    return true;
}

function ChangeNewCharNameHeight_()
{
    return (exe.findString(".?AVUINewMakeCharWnd@@", RAW) !== -1);
}
