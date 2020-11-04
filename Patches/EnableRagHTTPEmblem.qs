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
//##################################################################
//# Purpose: Use normal buffer instead of CDClient buffer for      #
//#          HTTP Packet.                                          #
//##################################################################

function EnableRagHTTPEmblem()
{
  //Step 1 - Find the code
  var code =
      " 55"        //0 push ebp
    + " 8B EC"     //1 mov ebp, esp
    + " 83 C1 6C"  //3 add ecx, 6Ch
    + " 5D"        //6 pop ebp
    + " E9"        //7 jmp
    ;

  var modPos = 5;
  var offset = exe.findCode(code, PTYPE_HEX, false);
  if (offset === -1)
    return "Failed in Step 1";

  //Step 2 - Change buffer offset
  exe.replace(offset + modPos, " 3C", PTYPE_HEX);

  return true;
}