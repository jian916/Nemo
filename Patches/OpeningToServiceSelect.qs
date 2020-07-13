//
// Copyright (C) 2020  CH.C
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
//#####################################################################################
//# Purpose: Find the indirect table for switch statement inside UILoginWnd::SendMsg, #
//#          Make Opening button work as return Service Selection                     #
//#####################################################################################

function OpeningToServiceSelect()
{

    //Step 1 - Find the MsgString ID references of "Please enter at least %d characters. If you don't have account,"
    var code = " 68 D5 0B 00 00 E8"; //PUSH BD5 CALL

    var offset = exe.findCode(code, PTYPE_HEX, false);
    if (offset === -1)
        return "Failed in Step 1 - MsgString ID Missing";

    //Step 2 - Find the indirect table for switch statement inside UILoginWnd::SendMsg
    code =
      " 0F B6 80 AB AB AB AB"
    + " FF 24 85 AB AB AB AB"
    ;

    offset = exe.find(code, PTYPE_HEX, true, "\xAB", offset - 0x300, offset);
    if (offset === -1)
        return "Failed in Step 2 - Switch Table Missing";

    var switchTable = exe.fetchDWord(offset + 3);

    //Step 2 - Change Opening button to Service Select
    var opOffset = switchTable + 100;

    exe.replace(exe.Rva2Raw(opOffset), "00", PTYPE_HEX);

    return true;
}

//======================================================================//
// Disable for Old Clients - Only Clients with new login window need it //
//======================================================================//
function OpeningToServiceSelect_()
{
  return (exe.findCode(" 68 D5 0B 00 00 E8", PTYPE_HEX, false) !== -1);
}
