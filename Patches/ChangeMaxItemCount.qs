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
//=============================================================//
// Patch Functions wrapping over ChangeMaxItemCount function   //
//=============================================================//

function SetMaxItemCount()
{
  return ChangeMaxItemCount(exe.getUserInput("$MaxItemCount", XTYPE_STRING, _("Number Input"), _("Enter the max item count (0-999)"), 100, 0, 3));
}

//####################################################################################
//# Purpose: Find the max item count display and replace it with the value specified #
//####################################################################################

function ChangeMaxItemCount(value)
{
      //Step 1a - Prep String
      var newString = "/" + value  ;

      //Step 1b - Allocate space for New Format String.
      var free = exe.findZeros(newString.length);
      if (free === -1)
        return "Failed in Step 1 - Not enough free space";

      //Step 1c - Insert the new format string
      exe.insert(free, newString.length, newString, PTYPE_STRING);


      //Step 2 - Find the max item count.
      var code =
         " 6A 64"          //PUSH 64h
       + " 8D 45 AB"       //LEA EAX, [EBP+Z]
       + " 68 AB AB AB 00" //PUSH offset "/%d"
       ;

      var offsets = exe.findAll(code, PTYPE_HEX, true, "\xAB");

      if (offsets.length === 0)  //new clients
      {
        code =
         " 83 C1 64"          //ADD ECX,64h
       + " 51"                //PUSH ECX
       + " 68 AB AB AB 00"    //PUSH offset "/%d"
       ;
       offsets = exe.findAll(code, PTYPE_HEX, true, "\xAB");
      }

      if (offsets.length === 0)
        return "Failed in Step 2 - function missing";

      //Step 3 - Replace with new one's address
      for (var i = 0; i < offsets.length; i++)
        {
            var offset2 = offsets[i] + code.hexlength();
            exe.replace(offset2 - 4, exe.Raw2Rva(free).packToHex(4), PTYPE_HEX);
        }



  return true;
}
