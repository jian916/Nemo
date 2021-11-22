//
// Copyright (C) 2017-2021  Andrei Karas (4144)
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

function DisablePasswordEncryption()
{
    var obj = LoginPacketSend_match();
    var offset = obj.offset;

    //Disable password encrypt for lang type 7
    var code =
        "83 F9 07 " +                 // 0 cmp ecx, 7
        "75 ";                        // 3 jnz short loc_80905C
    var jmpOffset = 3;
    var offset2 = pe.find(code, offset, offset + 0xFF);
    if (offset2 === -1)
        return "Failed in disable encryption for lang type 7";
    exe.replace(offset2 + jmpOffset, "EB", PTYPE_HEX);

    //Disable password encrypt for lang type 4
    var code =
        "83 F9 04 " +                 // 0 cmp ecx, 4
        "75 ";                        // 3 jnz short loc_80905C
    jmpOffset = 3;
    offset2 = pe.find(code, offset, offset + 0xFF);
    if (offset2 === -1)
        return "Failed in disable encryption for lang type 4";
    exe.replace(offset2 + jmpOffset, "EB", PTYPE_HEX);

    return true;
}

function DisablePasswordEncryption_()
{
    return (exe.getClientDate() > 20171019 && IsZero()) || exe.getClientDate() >= 20181114;
}
