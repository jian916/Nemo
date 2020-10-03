//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020 Andrei Karas (4144)
// Copyright (C) 2020 X-EcutiOnner (xex.ecutionner@gmail.com)
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
//##########################################################################
//# Purpose: Zero out the ViewPointTable.txt file strings used for locking #
//#          camera viewpoint rotation.                                    #
//##########################################################################

function DisableCameraLock()
{
    consoleLog("Step 1 - Search string 'ViewPointTable.txt'");
    var offset = exe.findString("ViewPointTable.txt", RAW);

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    consoleLog("Step 2 - Zero it out string 'ViewPointTable.txt'");
    exe.replace(offset, "00 ", PTYPE_HEX);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableCameraLock_()
{
    return (exe.findString("ViewPointTable.txt", RAW) !== -1);
}
