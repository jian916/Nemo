//
// Copyright (C) 2017  Andrei Karas (4144)
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
//##################################################
//# Purpose: Modify LuaErrorMsg function to return #
//#          without showing the MessageBox        #
//##################################################

function IgnoreLuaErrors()
{

    //Step 1a - Prep code for finding the LuaErrorMsg
    var code =
        "FF AB AB AB AB 00" +  // call vsprintf
        "83 AB AB" +           // add esp, 0Ch
        "8D AB AB AB FF FF" +  // lea eax, [ebp + text] <-- replace from here
        "6A 00" +              // push 0
        "AB" +                 // push esi
        "AB" +                 // push eax
        "6A 00" +              // push 0
        "FF 15 AB AB AB 00";   // call MessageBoxA

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in Step 1";

    //Step 2 - Replace with xor eax, eax followed by nops.
    var newCode =
        "33 C0 90 90 90 90" +  // xor eax, eax + nops
        "90 90" +
        "90" +
        "90" +
        "90 90" +
        "90 90 90 90 90 90";
    exe.replace(offset + 9, newCode, PTYPE_HEX);

    return true;
}
