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
    lua.replace("Lua Files\\DataInfo\\accName_F", ["lua files\\cls\\accname_f"]);
    lua.replace("Lua Files\\DataInfo\\jobName_F", ["lua files\\cls\\jobname_f"]);
    lua.replace("Lua Files\\DataInfo\\QuestInfo_f", ["lua files\\cls\\questinfo_f"]);
    lua.replace("Lua Files\\DataInfo\\AddRandomOption_F", ["lua files\\cls\\addrandomoption_f"]);
    lua.replace("Lua Files\\DataInfo\\ShadowTable_F", ["lua files\\cls\\shadowtable_f"]);
    lua.replace("Lua Files\\DataInfo\\SpriteRobeName_F", ["lua files\\cls\\spriterobename_f"]);
    lua.replace("Lua Files\\transparentItem\\transparentItem_f", ["lua files\\cls\\transparentitem_f"]);
    lua.replace("Lua Files\\DataInfo\\WeaponTable_F", ["lua files\\cls\\weapontable_f"]);

    lua.loadBefore("Lua Files\\DataInfo\\accName", ["lua files\\cls\\accname"]);
    lua.loadBefore("Lua Files\\DataInfo\\AccessoryId", ["lua files\\cls\\accessoryid"]);
    lua.loadBefore("Lua Files\\DataInfo\\EnumVAR", ["lua files\\cls\\enumvar"]);
    lua.loadBefore("Lua Files\\HatEffectInfo\\HatEffectInfo", ["lua files\\cls\\hateffectinfo"]);
    lua.loadBefore("Lua Files\\DataInfo\\jobName", ["lua files\\cls\\jobname"]);
    lua.loadBefore("Lua Files\\DataInfo\\NPCIdentity", ["lua files\\cls\\npcidentity"]);
    lua.loadBefore("Lua Files\\DataInfo\\PetInfo", ["lua files\\cls\\petinfo"]);
    lua.loadBefore("Lua Files\\datainfo\\LapineDdukDDakBox", ["lua files\\cls\\lapineddukddakbox"]);
    lua.loadBefore("Lua Files\\datainfo\\LapineUpgradeBox", ["lua files\\cls\\lapineupgradebox"]);
    lua.loadBefore("Lua Files\\DataInfo\\AddRandomOptionNameTable", ["lua files\\cls\\randomoption"]);
    lua.loadBefore("Lua Files\\DataInfo\\ShadowTable", ["lua files\\cls\\shadowtable"]);
    lua.loadBefore("Lua Files\\DataInfo\\SpriteRobeId", ["lua files\\cls\\spriterobeid"]);
    lua.loadBefore("Lua Files\\DataInfo\\SpriteRobeName", ["lua files\\cls\\spriterobename"]);
    lua.loadBefore("Lua Files\\DataInfo\\TB_Layer_Priority", ["lua files\\cls\\tb_layer_priority"]);
    lua.loadBefore("Lua Files\\DataInfo\\TitleTable", ["lua files\\cls\\titletable"]);
    lua.loadBefore("Lua Files\\transparentItem\\transparentItem", ["lua files\\cls\\transparentitem"]);
    lua.loadBefore("Lua Files\\DataInfo\\WeaponTable", ["lua files\\cls\\weapontable"]);

    return true;
}
