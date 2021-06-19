//
// Copyright (C) 2021  Andrei Karas (4144)
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

function AddCustomLua()
{
    var retVal = lua.loadBefore(
        "Lua Files\\DataInfo\\accName",
        [
            "lua files\\cls\\accessoryid",
            "lua files\\cls\\accname",
            "lua files\\cls\\DrawItemOnAura",
            "lua files\\cls\\enumvar",
            "lua files\\cls\\hateffect_f",
            "lua files\\cls\\hateffectinfo",
            "lua files\\cls\\jobname",
            "lua files\\cls\\lapineddukddakbox",
            "lua files\\cls\\LapineUpgradeBox",
            "lua files\\cls\\npcidentity",
            "lua files\\cls\\OngoingQuests",
            "lua files\\cls\\petinfo",
            "lua files\\cls\\randomoption",
            "lua files\\cls\\RecommendedQuests",
            "lua files\\cls\\shadowtable",
            "lua files\\cls\\spriterobeid",
            "lua files\\cls\\spriterobename",
            "lua files\\cls\\TB_Layer_Priority",
            "lua files\\cls\\titletable",
            "lua files\\cls\\transparentItem"
        ]
    )
    if (retVal !== true)
        return retVal;

    var retVal = lua.loadAfter(
        "Lua Files\\DataInfo\\WeaponTable",
        [
            "lua files\\cls\\weapontable"
        ]
    );
    return retVal;
}
