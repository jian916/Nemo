//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020-2021 Andrei Karas (4144)
// Copyright (C) 2018-2021 X-EcutiOnner (xex.ecutionner@gmail.com)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//
//#########################################################################################
//# Purpose: Change the manifest string "requireAdministrator" to "asInvoker" + 11 Spaces #
//#          to disable OS Privileges execution level for run client by user account.     #
//#########################################################################################

function DisableRequireAdmin()
{
    var level = ["requireAdministrator\x22"];
    var privileges = false;

    for (var i = 0; i < level.length; i++)
    {
        consoleLog("Step 1 - Search string 'requireAdministrator'");
        var offsets = exe.findAll(level[i].toHex(), PTYPE_HEX, false);

        if (offsets.length > 0)
            privileges = true;

        for (var j = 0; j < offsets.length; j++)
        {
            consoleLog("Step 2 - Replace with asInvoker + 11 Spaces");
            exe.replace(offsets[j], "asInvoker\x22\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20", PTYPE_STRING);
        }
    }

    if (privileges === false)
        return "Failed in Step 1 - Pattern not found";

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableRequireAdmin_()
{
    return (exe.findAll("\x72\x65\x71\x75\x69\x72\x65\x41\x64\x6D\x69\x6E\x69\x73\x74\x72\x61\x74\x6F\x72\x22", PTYPE_HEX, false) !== -1);
}
