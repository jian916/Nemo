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
        return lua.load(existingName, newNamesList, [], true, free);
    }

    function lua_loadAfter(existingName, newNamesList, free)
    {
        checkArgs("lua.loadAfter", arguments, [["String", "Object"], ["String", "Object", "Number"]]);
        return lua.load(existingName, [], newNamesList, true, free);
    }

    function lua_replace(existingName, newNamesList, free)
    {
        checkArgs("lua.replace", arguments, [["String", "Object"], ["String", "Object", "Number"]]);
        return lua.load(existingName, newNamesList, [], false, free);
    }

    function lua_getCLuaLoadInfo(stackOffset)
    {
        checkArgs("lua.getCLuaLoadInfo", arguments, [["Number"]]);
        var type = table.getValidated(table.CLua_Load_type);
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
            fatalError("Unsupported CLua_Load type");
        }

        return obj;
    }

    function lua_getLoadObj(origFile, beforeNameList, afterNameList, loadDefault)
    {
        checkArgs("lua.getLoadObj",
            arguments,
            [
                ["String", "Object", "Object", "Boolean"],
                ["String", "Array", "Array", "Boolean"]
            ]
        );

        consoleLog("Find original file name string");
        var origOffset = pe.stringVa(origFile);
        if (origOffset === -1)
            throw "LUAFL: Filename missing: " + origFile;

        var strHex = origOffset.packToHex(4);

        consoleLog("Find original file name usage");
        var type = table.getValidated(table.CLua_Load_type);
        var mLuaAbsHex = table.getSessionAbsHex4(table.CSession_m_lua_offset);
        var mLuaHex = table.getHex4(table.CSession_m_lua_offset);
        var CLua_Load = table.get(table.CLua_Load);

        if (type == 4)
        {
            var code =
                "8B 8E " + mLuaHex +          // 0 mov ecx, g_session.m_lua
                "6A ?? " +                    // 6 push 0
                "6A ?? " +                    // 8 push 1
                "68 " + strHex +              // 10 push offset aLuaFilesQues_3
                "E8 ";                        // 15 call CLua_Load
            var moveOffset = [0, 6];
            var pushFlagsOffset = [6, 4];
            var strPushOffset = 10;
            var postOffset = 20;
            var otherOffset = 0;
            var callOffset = [16, 4];
            var hookLoader = pe.find(code);
            if (hookLoader === -1)
            {
                code =
                    "8B 0D " + mLuaAbsHex +       // 0 mov ecx, g_session.m_lua
                    "6A ?? " +                    // 6 push 0
                    "6A ?? " +                    // 8 push 1
                    "68 " + strHex +              // 10 push offset aLuaFilesQues_3
                    "E8 ";                        // 15 call CLua_Load
                moveOffset = [0, 6];
                pushFlagsOffset = [6, 4];
                strPushOffset = 10;
                postOffset = 20;
                otherOffset = 0;
                callOffset = [16, 4];
                hookLoader = pe.find(code);
            }
            if (hookLoader === -1)
            {
                var code =
                    "8B 8E " + mLuaHex +          // 0 mov ecx, [esi+5434h]
                    "53 " +                       // 6 push ebx
                    "6A ?? " +                    // 7 push 1
                    "68 " + strHex +              // 9 push offset aLuaFilesData_0
                    "E8 ";                        // 14 call CLua_Load
                moveOffset = [0, 6];
                pushFlagsOffset = [6, 3];
                strPushOffset = 9;
                postOffset = 19;
                otherOffset = 0;
                callOffset = [15, 4];
                hookLoader = pe.find(code);
            }
        }
        else if (type == 3)
        {
            var code =
                "8B 8E " + mLuaHex +          // 0 mov ecx, g_session.m_lua
                "6A ?? " +                    // 6 push 1
                "68 " + strHex +              // 8 push offset aLuaFilesQues_3
                "E8 ";                        // 13 call CLua_Load
            var moveOffset = [0, 6];
            var pushFlagsOffset = [6, 2];
            var strPushOffset = 8;
            var postOffset = 18;
            var otherOffset = 0;
            var callOffset = [14, 4];
            var hookLoader = pe.find(code);
            if (hookLoader === -1)
            {
                code =
                    "8B 0D " + mLuaAbsHex +       // 0 mov ecx, g_session.m_lua
                    "6A ?? " +                    // 6 push 1
                    "68 " + strHex +              // 8 push offset aLuaFilesQues_3
                    "E8 ";                        // 13 call CLua_Load
                moveOffset = [0, 6];
                pushFlagsOffset = [6, 2];
                strPushOffset = 8;
                postOffset = 18;
                otherOffset = 0;
                callOffset = [14, 4];
                hookLoader = pe.find(code);
            }
        }
        else if (type == 2)
        {
            var code =
                "8B 8E " + mLuaHex +          // 0 mov ecx, g_session.m_lua
                "68 " + strHex +              // 6 push offset aLuaFilesQues_3
                "E8 ";                        // 11 call CLua_Load
            var moveOffset = [0, 6];
            var pushFlagsOffset = 0;
            var strPushOffset = 6;
            var postOffset = 16;
            var otherOffset = 0;
            var callOffset = [12, 4];
            var hookLoader = pe.find(code);
            if (hookLoader === -1)
            {
                code =
                    "8B 0D " + mLuaAbsHex +       // 0 mov ecx, g_session.m_lua
                    "68 " + strHex +              // 6 push offset aLuaFilesQues_3
                    "E8 ";                        // 11 call CLua_Load
                moveOffset = [0, 6];
                pushFlagsOffset = 0;
                strPushOffset = 6;
                postOffset = 16;
                otherOffset = 0;
                callOffset = [12, 4];
                hookLoader = pe.find(code);
            }
            if (hookLoader === -1)
            {
                code =
                    "8B 8E " + mLuaHex +          // 0 mov ecx, [esi+44D8h]
                    "83 C4 ?? " +                 // 6 add esp, 4
                    "68 " + strHex +              // 9 push offset aLuaFilesDatain
                    "E8 ";                        // 14 call CLua_Load
                moveOffset = [0, 6];
                pushFlagsOffset = 0;
                strPushOffset = 9;
                postOffset = 19;
                otherOffset = [6, 3];
                callOffset = [15, 4];
                hookLoader = pe.find(code);
            }
        }
        else
        {
            fatalError("Unsupported CLua_Load type");
        }

        if (hookLoader === -1)
            throw "LUAFL: CLua_Load call missing: " + origFile;

        var retLoader = hookLoader + postOffset;

        var callValue = pe.fetchRelativeValue(hookLoader, callOffset);
        if (callValue !== CLua_Load)
            throw "LUAFL: found wrong call function: " + origFile;

        consoleLog("Read stolen code");
        var allStolenCode = pe.fetchHex(hookLoader, strPushOffset);
        var movStolenCode = pe.fetchHexBytes(hookLoader, moveOffset)
        if (pushFlagsOffset !== 0)
        {
            var pushFlagsStolenCode = pe.fetchHexBytes(hookLoader, pushFlagsOffset);
        }
        else
        {
            var pushFlagsStolenCode = "";
        }
        var shortStolenCode = movStolenCode + pushFlagsStolenCode;
        if (otherOffset !== 0)
        {
            var otherStoleCode = pe.fetchHexBytes(hookLoader, otherOffset);
        }
        else
        {
            var otherStoleCode = "";
        }

        consoleLog("Construct asm code with strings");
        var stringsCode = "";
        for (var i = 0; i < beforeNameList.length; i++)
        {
            stringsCode = asm.combine(
                stringsCode,
                "varb" + i + ":",
                asm.stringToAsm(beforeNameList[i] + "\x00")
            )
        }
        for (var i = 0; i < afterNameList.length; i++)
        {
            stringsCode = asm.combine(
                stringsCode,
                "vara" + i + ":",
                asm.stringToAsm(afterNameList[i] + "\x00")
            )
        }

        consoleLog("Create own code");

        var asmCode = "";

        consoleLog("Add before code");
        for (var i = 0; i < beforeNameList.length; i++)
        {
            var asmCode = asm.combine(
                asmCode,
                asm.hexToAsm(shortStolenCode),
                "push varb" + i,
                "call CLua_Load"
            )
        }

        if (loadDefault === true)
        {
            consoleLog("Add default code");
            var asmCode = asm.combine(
                asmCode,
                asm.hexToAsm(allStolenCode),
                "push offset",
                "call CLua_Load"
            )
        }

        consoleLog("Add after code");
        for (var i = 0; i < afterNameList.length; i++)
        {
            var asmCode = asm.combine(
                asmCode,
                asm.hexToAsm(shortStolenCode),
                "push vara" + i,
                "call CLua_Load"
            )
        }

        consoleLog("Add jmp and strings");
        var text = asm.combine(
            asmCode,
            "jmp continueAddr",
            asm.hexToAsm("00"),
            stringsCode
        )

        consoleLog("Set own code into exe");
        var vars = {
            "offset": origOffset,
            "CLua_Load": CLua_Load,
            "continueAddr": pe.rawToVa(retLoader)
        };

        var obj = Object();
        obj.hookAddrRaw = hookLoader;
        obj.asmText = text;
        obj.vars = vars;
        return obj;
    }

    function lua_load(origFile, beforeNameList, afterNameList, loadDefault, free)
    {
        checkArgs("lua.load",
            arguments,
            [
                ["String", "Object", "Object", "Boolean"],
                ["String", "Array", "Array", "Boolean"],
                ["String", "Object", "Object", "Boolean", "Number"],
                ["String", "Array", "Array", "Boolean", "Number"],
                ["String", "Object", "Object", "Boolean", "Undefined"],
                ["String", "Array", "Array", "Boolean", "Undefined"]
            ]
        );

        var loadObj = lua.getLoadObj(origFile, beforeNameList, afterNameList, loadDefault);

        if (typeof(free) === "undefined" || free === -1)
        {
            var obj = exe.insertAsmTextObj(loadObj.asmText, loadObj.vars);
            var free = obj.free;
        }
        else
        {
            pe.replaceAsmText(free, loadObj.asmText, loadObj.vars);
        }

        consoleLog("Set jmp to own code");
        exe.setJmpRaw(loadObj.hookAddrRaw, free, "jmp", 6);

        return true;
    }

    lua = new Object();
    lua.loadBefore = lua_loadBefore;
    lua.loadAfter = lua_loadAfter;
    lua.replace = lua_replace;
    lua.getCLuaLoadInfo = lua_getCLuaLoadInfo;
    lua.getLoadObj = lua_getLoadObj;
    lua.load = lua_load;
}
