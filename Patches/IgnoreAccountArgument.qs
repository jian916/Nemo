//
// Copyright (C) 2017  Secret
//
// This script is free software: you can redistribute it and/or modify
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
//###################################################################
//# Purpose: Make the client ignore /account: command line argument #
//# Author : Secret                                                 #
//###################################################################

function IgnoreAccountArgument()
{

    // Step 1a - Find /account:
    var offset = exe.findString("/account:", RVA);
    if (offset === -1)
        return "Failed in Step 1 - /account: not found.";

    // Step 1b - Find its reference
    var code = " 68" + offset.packToHex(4);
    offset = exe.findCode(code, PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in Step 1 - Reference not found.";

    // Step 2 - Find the comparison after strstr call
    code =
        //" FF D3"   // CALL EBX ; strstr
        " 83 C4 08"  // ADD ESP, 8
    +    " 85 C0"     // TEST EAX, EAX
    +    " 74 AB"     // JZ loadClientInfo
    ;
    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset, offset + 0x20);
    if (offset === -1)
        return "Failed in Step 2 - Comparison not found.";

    // Step 3 - Replace JZ with JMP
    offset += 5; // 3 from ADD and 2 from TEST

    exe.replace(offset, " EB", PTYPE_HEX);

    return true;
}
