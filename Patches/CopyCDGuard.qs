//
// Copyright (C) 2018-2019  Andrei Karas (4144)
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
//##############################################################################
//# Purpose: Copy disabled and patched cdclient.dll into destination directory #
//##############################################################################

function CopyCDGuard()
{
    return true;
}

//====================================//
// Do real copy on apply patches time //
//====================================//
function CopyCDGuard_apply()
{
    copyFileToDst(APP_PATH + "/Input/CDClient.dll", "CDClient.dll");
    return true;
}

//============================//
// Disable Unsupported client //
//============================//
function CopyCDGuard_()
{
    return (exe.findString("CDClient.dll", RAW) !== -1);
}
