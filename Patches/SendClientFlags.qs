//
// Copyright (C) 2018-2021  Andrei Karas (4144)
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

function SendClientFlagsSearch(offsets2, code, clientOffset)
{
    consoleLog("search g_client_version usage");
    var offsets = pe.findAll(code);
    for (var i = 0; i < offsets.length; i ++)
    {
        offsets2.push(offsets[i] + clientOffset);
    }
    return offsets2;
}

function SendClientFlags()
{
    var flags = 0;

    consoleLog("read table");
    if (table.get(table.g_client_version) === 0)
    {
        return "g_client_version not in table";
    }
    var g_client_versionHex = table.getHex4(table.g_client_version);

    var offsets = [];

    offsets = SendClientFlagsSearch(offsets,
        "A1 " + g_client_versionHex,  // 0 mov eax, g_client_version
        1);
    offsets = SendClientFlagsSearch(offsets,
        "8B 0D " + g_client_versionHex,  // 0 mov ecx, g_client_version
        2);
    offsets = SendClientFlagsSearch(offsets,
        "8B 15 " + g_client_versionHex,  // 0 mov edx, g_client_version
        2);

    if (offsets.length !== 6)
    {
        return "Found wrong number of g_client_version usage";
    }

    consoleLog("replace g_client_version usage");
    var free = exe.findZeros(4);
    if (free === -1)
        return "Not enough free space";

    exe.insert(free, 4, flags.packToHex(4), PTYPE_HEX);
    var freeVaHex = (pe.rawToVa(free)).packToHex(4);

    for (var i = 0; i < offsets.length; i ++)
    {
        exe.replace(offsets[i], freeVaHex, PTYPE_HEX);
    }

    storage.g_client_version = free;

    return true;
}

function SendClientFlags_apply()
{
    var flags = 0x80000000;

    if (storage.ExtendCashShop === true)
        flags |= 1;

    removePatchData(storage.g_client_version);
    exe.replace(storage.g_client_version, flags.packToHex(4), PTYPE_HEX);

    return true;
}
