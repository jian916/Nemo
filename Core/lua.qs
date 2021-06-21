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

function registerLua()
{
    function lua_loadBefore(existingName, newNamesList, free)
    {
        checkArgs("lua.loadBefore", arguments, [["String", "Object"], ["String", "Object", "Number"]]);
        return lua.injectLuaFiles(existingName, newNamesList, free, true);
    }

    function lua_loadAfter(existingName, newNamesList, free)
    {
        checkArgs("lua.loadAfter", arguments, [["String", "Object"], ["String", "Object", "Number"]]);
        return lua.injectLuaFiles(existingName, newNamesList, free, false);
    }

    function lua_getCLuaLoadInfo(stackOffset)
    {
        checkArgs("lua.getCLuaLoadInfo", arguments, [["Number"]]);
        var type = table.get(table.CLua_Load_type);
        if (type == 0)
        {
            throw "CLua_Load type not set";
        }
        var obj = new Object();
        obj.type = type;
        obj.pushLine = "push dword ptr [esp + argsOffset + " + stackOffset + "]";
        if (type == 4)
        {
            obj.asmCopyArgs = asm.combine(
                obj.pushLine,
                obj.pushLine,
                obj.pushLine
            );
            obj.argsOffset = 0xc;
        }
        else if (type == 3)
        {
            obj.asmCopyArgs = asm.combine(
                obj.pushLine,
                obj.pushLine
            );
            obj.argsOffset = 0x8;
        }
        else if (type == 2)
        {
            obj.asmCopyArgs = asm.combine(
                obj.pushLine
            );
            obj.argsOffset = 0x4;
        }
        else
        {
            throw "Unsupported CLua_Load type";
        }

        return obj;
    }

    lua = new Object();
    lua.injectLuaFiles = InjectLuaFiles;
    lua.loadBefore = lua_loadBefore;
    lua.loadAfter = lua_loadAfter;
    lua.getCLuaLoadInfo = lua_getCLuaLoadInfo;
}
