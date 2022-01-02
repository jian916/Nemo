//
// This file is part of NEMO (Neo Exe Modification Organizer).
// http://nemo.herc.ws - http://gitlab.com/4144/Nemo
//
// Copyright (C) 2020-2021 Andrei Karas (4144)
// Copyright (C) 2020-2021 X-EcutiOnner (xex.ecutionner@gmail.com)
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
//############################################################################################
//# Purpose: Zero out the mp3NameTable.txt file strings use for listing all .mp3 audio files #
//#          in BGM folder for playing background music where used in map.                   #
//############################################################################################

function DisableBGMAudio()
{
    consoleLog("Step 1 - Search string 'mp3NameTable.txt'");
    var offset = pe.stringRaw("mp3NameTable.txt");

    if (offset === -1)
        return "Failed in Step 1 - String not found";

    consoleLog("Step 2 - Zero it out string 'mp3NameTable.txt'");
    pe.replaceByte(offset, 0);

    consoleLog("Step 3 - Search string 'bgm\\01.mp3'");
    var offset = pe.stringRaw("bgm\\01.mp3");

    if (offset === -1)
        return "Failed in Step 3 - String not found";

    consoleLog("Step 4 - Zero it out string 'bgm\\01.mp3'");
    pe.replaceByte(offset, 0);

    return true;
}

//=======================================================//
// Disable for Unsupported Clients - Check for Reference //
//=======================================================//
function DisableBGMAudio_()
{
    return (pe.stringRaw("mp3NameTable.txt") !== -1);
}
