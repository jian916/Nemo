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
//# Purpose: Use api StrStrIA instead of _mbsstr to enable         #
//#          case-insensitive search in storage.                   #
//##################################################################
function InsensitiveStorageSearch()
{
  //Check StrStrIA has imported, and get address
  var strstrIA = GetFunction("StrStrIA");
  if (strstrIA === -1)
    return "Failed in Step 1 - StrStrIA not found, Please import SHLWAPI.StrStrIA first";

  //Find string compair for storage
  var code =
    " 51"                 //0 push ecx
  + " 50"                 //1 push eax
  + " FF 15 AB AB AB AB"  //2 call _mbsstr
  + " 83 C4 08"           //8 add esp,8
  + " 85 C0"              //11 test eax,eax
  + " 74 04"              //13 je short
  + " 8B 36"              //15 mov esi,[esi]
  + " EB"                 //17 jmp short
  ;
  var callstrstr = 4;

  var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
  {//newer clients
    code = code.replace(" 51 50", " 51 0F 43 45 AB 50");//cmovnb eax,[ebp-x]
    offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    callstrstr += 4;
  }
  if (offset === -1)
    return "Failed in Step 2 - String compair not found";

  //Change API call address
  exe.replace(offset + callstrstr, strstrIA.packToHex(4), PTYPE_HEX);
  //Nop 'add esp,8' to balance stack
  exe.replace(offset + callstrstr + 4, " 90 90 90", PTYPE_HEX);

  return true;
}