//
// Copyright (C) 2018  CH.C
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
//================================================================//
// Patch Functions wrapping over ChangeAutoFollowDelay function   //
//================================================================//



function SetAutoFollowDelay()
{
  return ChangeAutoFollowDelay(exe.getUserInput("$followDelay", XTYPE_WORD, _("Number Input"), _("Enter the new autofollow delay(0-1000) - snaps to closest valid value"), 200, 0, 1000));
}

//##############################################################################
//# Purpose: Find the autofollow delay and replace it with the value specified #
//##############################################################################

function ChangeAutoFollowDelay(value)
{

  //Step 1a - Find the delay comparison
  var code =
    " FF D7"                //CALL EDI                     ;  timeGetTime
  + " 2B 05 AB AB AB AB"    //SUB EAX, DWORD PRT DS:[addr] ;  lastFollowTime
  + " 3D E8 03 00 00"       //CMP EAX, 3E8h                ;  1000ms
  ;

  var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
  if (offset === -1)
    return "Failed in Step 1 - AutoFollow Delay Code not found.";

  //Step 2 - Replace the value
  exe.replace(offset + 9, value.packToHex(4) , PTYPE_HEX);

  return true;
}