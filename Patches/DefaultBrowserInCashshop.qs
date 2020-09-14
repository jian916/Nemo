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
//####################################################
//# Purpose: Replace arguments of ShellExecuteA in   #
//#          order to open URL with default browser  #
//####################################################

function DefaultBrowserInCashshop ()
{
    //Step 1 - Find address of "iexplore.exe"
    var offset = exe.findString("iexplore.exe", RAW);

    if (offset === -1)
        return "Failed in Step 1 - String not found.";

    //Step 2 - Find the string reference.
    var offsets = exe.findCodes(" 50 68" + exe.Raw2Rva(offset).packToHex(4), PTYPE_HEX, false);

    if (offsets.length === 0)
        return "Failed in Step 2 - String reference missing.";

    //Step 3 - Replace the arguments of ShellExecuteA
    var code =
        " 6A 00"    //PUSH 00
      + " 50"        //PUSH EAX
      + " 90 90 90"    //NOPS
      ;

    for (var i = 0; i < offsets.length; i++)
    {
        offset = offsets[i];
        exe.replace (offset, code, PTYPE_HEX);
    }

    return true;
}

//=======================================================================//
// Disable for Unsupported Clients - Check for string "iexplore.exe"     //
//=======================================================================//

function DefaultBrowserInCashshop_()
{
    return (exe.findString("iexplore.exe") !== -1);
}
