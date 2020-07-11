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


function ShortcutAllItem()
{
    //Step 1 - Find the item type table fetchers
    var code =
        " 0F B6 80 AB AB AB 00"    //MOVZX EAX,BYTE PTR [EAX+offsetA]
      + " FF 24 85 AB AB AB 00"    //JMP DWORD PTR [EAX*4+offsetB]
      + " 83 BD AB AB AB AB 00"    //CMP DWORD PTR [EBP-x],00
      ;

    var offsets = exe.findCodes(code, PTYPE_HEX, true, "\xAB");
    if (offsets.length === 0)
        return "Failed in Step 1 - Codes not found";

    //Step 2 - Remove the EAX*4 from JMP instruction
    var offset = 0;
    for (var i = 0; i < offsets.length; i++)
    {
        offset = offsets[i] + 7;
        code = "90 FF 25"        //NOP
                                //JMP DWORD PTR [offsetB]

        exe.replace(offset, code, PTYPE_HEX);
    }

    return true;
}
