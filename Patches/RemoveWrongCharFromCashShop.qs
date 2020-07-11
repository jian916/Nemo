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
//# Purpose: Dont draw field with random number in   #
//#          cash shop in UICashShopWnd_virt68       #
//####################################################

function RemoveWrongCharFromCashShop()
{
    var offset = exe.findString("%d C", RVA);
    if (offset === -1)
        return "Failed in Step 1 - format string not found";
    var strHex = offset.packToHex(4)

    // search second string usage in function
    var code =
        "8B CE " +              // mov ecx, esi
        "50 " +                 // push eax
        "68 C2 01 00 00 " +     // push 1C2h
        "68 26 02 00 00 " +     // push 226h
        "E8 AB AB AB AB " +     // call UICashShopWnd_sub
        "FF B6 AB AB 00 00 " +  // push dword ptr [esi+A]
        "8D 45 AB " +           // lea eax, [ebp+string_ptr]
        "68 " + strHex +        // push offset "%d C"
        "50 " +                 // push eax
        "E8 "                   // call std::string::sprintf
    var pushOffset = 18;
    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");

    if (offset === -1)
        return "Failed in step 2 - pattern not found";

    code =
        "6A 00" +  // push 0
        "90" +     // nop
        "90" +     // nop
        "90" +     // nop
        "90"       // nop
    exe.replace(offset + pushOffset, code, PTYPE_HEX);

    return true;
}

function RemoveWrongCharFromCashShop_()
{
    return (exe.findString(".?AVUICashShopWnd@@", RAW) !== -1);
}
