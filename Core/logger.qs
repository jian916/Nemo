//
// Copyright (C) 2018  Andrei Karas (4144)
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

String.prototype.toHex1 = function()
{
  var result = '';
  for (var i = 0; i < this.length; i++)
  {
    var h = this.charCodeAt(i).toString(16);
    if (h.length === 1)
      h = '0' + h;
    result += h;
  }
  return result;
}

function getClientName()
{
    var name = CLIENT_FILE.split('/').pop();
    var idx = name.lastIndexOf('.');
    if (idx >= 0)
    {
        return name.substring(0, idx);
    }
    return name;
}

function Logger()
{
    this.open = function(fileName)
    {
        this.file = new TextFile();
        this.file.open(APP_PATH + "/Output/selftest/" + getClientName() + "_" + fileName + ".log", "w");
    };
    this.openGlobal = function(fileName)
    {
        this.file = new TextFile();
        this.file.open(APP_PATH + "/Output/" + getClientName() + "_" + fileName + ".log", "w");
    };
    this.close = function()
    {
        this.file.close();
    };
    this.reopen = function(fileName)
    {
        this.close();
        this.open(fileName);
    };
    this.reopenGlobal = function(fileName)
    {
        this.close();
        this.openGlobal(fileName);
    };
    this.bool = function(data, text)
    {
        if (data)
            this.file.writeline(text + ": true");
        else
            this.file.writeline(text + ": false");
    };
    this.data = function(data, text)
    {
        this.file.writeline(text + ": " + typeof(data) + " '" + data + "'");
    };
    this.hex = function(data, text)
    {
        if (data === false)
        {
            this.file.writeline(text + ": false");
        }
        else
        {
            if (Array.isArray(data))
            {
                this.file.writeline(text + ": array = " + data.length);
                for (var i = 0; i < data.length; i ++)
                {
                    this.file.writeline(" 0x" + data[i].toString(16));
                }
            }
            else if (typeof(data) === 'string' || data instanceof String)
            {
                this.file.writeline(text + ": 0x" + data.toHex1());
            }
            else
            {
                this.file.writeline(text + ": 0x" + data.toString(16));
            }
        }
    };
    this.arr = function(data, text)
    {
        this.file.writeline(text + ": array = " + data.length);
        for (var i = 0; i < data.length; i ++)
        {
            this.file.writeline(" " + typeof(data[i]) + " '" + data[i] + "'");
        }
    };
    this.plain = function(data, text)
    {
        this.file.write(text + ": ");
        for (var i = 0; i < data.length; i ++)
        {
            this.file.write(data[i] + ", ");
        }
        this.file.writeline("");
    };

    this.test = function(text)
    {
        this.file.writeline("\nTest: " + text);
    };
}


var GlobalInit_proxified = false;

function GlobalInit()
{
    if (GlobalInit_proxified === false && typeof(GLOBAL_EnableProxy) !== "undefined")
    {
        Global_enableProxy();
    }
}

function proxy_exe_find(pattern, type, useWildCard, wildCard, start, finish)
{
    var args = Array.prototype.slice.call(arguments);
    if (args.length >= 2)
    {
        if (args[1] == 0)
            args[0] += " (" + args[0].toHex1() + ")";
    }
    if (args.length >= 4)
    {
        args[3] = args[3].toHex1();
    }
    if (args.length >= 5)
    {
        args[4] = args[4].toString(16);
    }
    if (args.length >= 6)
    {
        args[5] = args[5].toString(16);
    }
    function_logger.plain(args, "find");
    var res = GlobalProxy.Client_find.apply(exe, arguments);
    function_logger.hex(res, "find res");
    return res;
};

function proxy_exe_findAll(pattern, type, useWildCard, wildCard, start, finish)
{
    var args = Array.prototype.slice.call(arguments);
    if (args.length >= 2)
    {
        if (args[1] == 0)
            args[0] += " (" + args[0].toHex1() + ")";
    }
    if (args.length >= 4)
    {
        args[3] = args[3].toHex1();
    }
    if (args.length >= 5)
    {
        args[4] = args[4].toString(16);
    }
    if (args.length >= 6)
    {
        args[5] = args[5].toString(16);
    }
    function_logger.plain(args, "findAll");
    var res = GlobalProxy.Client_findAll.apply(exe, arguments);
    function_logger.plain(res, "findAll res");
    return res;
};

function proxy_exe_findCode(pattern, type, useWildCard, wildCard)
{
    var args = Array.prototype.slice.call(arguments);
    if (args.length >= 2)
    {
        if (args[1] == 0)
            args[0] += " (" + args[0].toHex1() + ")";
    }
    if (args.length >= 4)
    {
        args[3] = args[3].toHex1();
    }
    function_logger.plain(args, "findCode");
    var res = GlobalProxy.Client_findCode.apply(exe, arguments);
    function_logger.hex(res, "findCode res");
    return res;
};

function proxy_exe_findCodes(pattern, type, useWildCard, wildCard)
{
    var args = Array.prototype.slice.call(arguments);
    if (args.length >= 2)
    {
        if (args[1] == 0)
            args[0] += " (" + args[0].toHex1() + ")";
    }
    if (args.length >= 4)
    {
        args[3] = args[3].toHex1();
    }
    function_logger.plain(args, "findCodes");
    var res = GlobalProxy.Client_findCodes.apply(exe, arguments);
    function_logger.hex(res, "findCodes res");
    return res;
};

function proxy_exe_findZeros(zsize)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "findZeros");
    var res = GlobalProxy.Client_findZeros.apply(exe, arguments);
    function_logger.hex(res, "findZeros res");
    return res;
};

function proxy_exe_fetchDWord(offset)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.hex(offset, "fetchDWord");
    var res = GlobalProxy.Client_fetchDWord.apply(exe, arguments);
    function_logger.hex(res, "fetchDWord res");
    return res;
};

function proxy_exe_fetchQWord(offset)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.hex(offset, "fetchQWord");
    var res = GlobalProxy.Client_fetchQWord.apply(exe, arguments);
    function_logger.hex(res, "fetchQWord res");
    return res;
};

function proxy_exe_fetchWord(offset)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.hex(offset, "fetchWord");
    var res = GlobalProxy.Client_fetchWord.apply(exe, arguments);
    function_logger.hex(res, "fetchWord res");
    return res;
};

function proxy_exe_fetchUByte(offset)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.hex(offset, "fetchUByte");
    var res = GlobalProxy.Client_fetchUByte.apply(exe, arguments);
    function_logger.hex(res, "fetchUByte res");
    return res;
};

function proxy_exe_fetchByte(offset)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.hex(offset, "fetchByte");
    var res = GlobalProxy.Client_fetchByte.apply(exe, arguments);
    function_logger.hex(res, "fetchByte res");
    return res;
};

function proxy_exe_fetchHex(offset, num)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "fetchHex");
    var res = GlobalProxy.Client_fetchHex.apply(exe, arguments);
    function_logger.data(res, "fetchHex res");
    return res;
};

function proxy_exe_fetch(offset, num)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "fetch");
    var res = GlobalProxy.Client_fetch.apply(exe, arguments);
    function_logger.data(res, "fetch res");
    return res;
};

function proxy_exe_Raw2Rva(rawaddr)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.hex(rawaddr, "Raw2Rva");
    var res = GlobalProxy.Client_Raw2Rva.apply(exe, arguments);
    function_logger.hex(res, "Raw2Rva res");
    return res;
};

function proxy_exe_Rva2Raw(rvaaddr)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.hex(rvaaddr, "Rva2Raw");
    var res = GlobalProxy.Client_Rva2Raw.apply(exe, arguments);
    function_logger.hex(res, "Rva2Raw res");
    return res;
};

function proxy_exe_findString(pattern, type, prefixZero)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "findString");
    var res = GlobalProxy.Client_findString.apply(exe, arguments);
    function_logger.hex(res, "findString res");
    return res;
};

function proxy_exe_insert(offset, allocSize, code, type)
{
    var args = Array.prototype.slice.call(arguments);

    if (args.length >= 4)
    {
        if (args[3] == 0)
            args[2] += " (" + args[2].toHex1() + ")";
    }
    else
    {
        args[2] += " (" + args[2].toHex1() + ")";
    }

    function_logger.plain(args, "insert");
    var res = GlobalProxy.Client_insert.apply(exe, arguments);
    function_logger.hex(res, "insert res");
    return res;
};

function proxy_exe_replace(offset, code, type)
{
    var args = Array.prototype.slice.call(arguments);

    if (args.length >= 3)
    {
        if (args[2] == 0)
            args[1] += " (" + args[1].toHex1() + ")";
    }
    else
    {
        args[1] += " (" + args[1].toHex1() + ")";
    }

    function_logger.plain(args, "replace");
    var res = GlobalProxy.Client_replace.apply(exe, arguments);
    function_logger.hex(res, "replace res");
    return res;
};

function proxy_exe_replaceByte(offset, code)
{
    var args = Array.prototype.slice.call(arguments);

    args[1] += " (" + args[1].toString(16) + ")";

    function_logger.plain(args, "replaceByte");
    var res = GlobalProxy.Client_replaceByte.apply(exe, arguments);
    function_logger.data(res, "replaceByte res");
    return res;
};

function proxy_exe_replaceWord(offset, code)
{
    var args = Array.prototype.slice.call(arguments);

    args[1] += " (" + args[1].toString(16) + ")";

    function_logger.plain(args, "replaceWord");
    var res = GlobalProxy.Client_replaceWord.apply(exe, arguments);
    function_logger.data(res, "replaceWord res");
    return res;
};

function proxy_exe_replaceDWord(offset, code)
{
    var args = Array.prototype.slice.call(arguments);

    args[1] += " (" + args[1].toString(16) + ")";

    function_logger.plain(args, "replaceDWord");
    var res = GlobalProxy.Client_replaceDWord.apply(exe, arguments);
    function_logger.data(res, "replaceDWord res");
    return res;
};

function proxy_exe_getUserInput(varname, valtype, title, prompt, value, min, max)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "getUserInput");
    var res = GlobalProxy.Client_getUserInput.apply(exe, arguments);
    function_logger.data(res, "getUserInput res");
    return res;
};

function proxy_exe_getROffset(key)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "getROffset");
    var res = GlobalProxy.Client_getROffset.apply(exe, arguments);
    function_logger.hex(res, "getROffset res");
    return res;
};

function proxy_exe_getVOffset(key)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "getVOffset");
    var res = GlobalProxy.Client_getVOffset.apply(exe, arguments);
    function_logger.hex(res, "getVOffset res");
    return res;
};

function proxy_exe_getRSize(key)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "getRSize");
    var res = GlobalProxy.Client_getRSize.apply(exe, arguments);
    function_logger.hex(res, "getRSize res");
    return res;
};

function proxy_exe_getVSize(key)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "getVSize");
    var res = GlobalProxy.Client_getVSize.apply(exe, arguments);
    function_logger.hex(res, "getVSize res");
    return res;
};

function proxy_exe_getVOffset(key)
{
    var args = Array.prototype.slice.call(arguments);
    function_logger.plain(args, "getVOffset");
    var res = GlobalProxy.Client_getVOffset.apply(exe, arguments);
    function_logger.hex(res, "getVOffset res");
    return res;
};

function proxy_exe_getPEOffset()
{
    var res = GlobalProxy.Client_getPEOffset.apply(exe, arguments);
    function_logger.hex(res, "getPEOffset res");
    return res;
};

function proxy_exe_getImageBase()
{
    var res = GlobalProxy.Client_getImageBase.apply(exe, arguments);
    function_logger.hex(res, "getImageBase res");
    return res;
};

function proxy_exe_getClientDate()
{
    var res = GlobalProxy.Client_getClientDate.apply(exe, arguments);
    function_logger.data(res, "getClientDate res");
    return res;
};

function proxy_exe_isThemida()
{
    var res = GlobalProxy.Client_isThemida.apply(exe, arguments);
    function_logger.bool(res, "isThemida res");
    return res;
};


function Global_addExeProxy(functionName)
{
    eval("GlobalProxy.Client_" + functionName + " = exe." + functionName + ";");
    eval("exe." + functionName + " = proxy_exe_" + functionName + ";");
}

function Global_enableProxy()
{
    GlobalInit_proxified = 2;
    GlobalProxy = new Object();
    global_logger = new Logger();
    global_logger.openGlobal("trace");
    function_logger = new Logger();
    global_patches = [];

    Global_addExeProxy("find");
    Global_addExeProxy("findAll");
    Global_addExeProxy("findCode");
    Global_addExeProxy("findCodes");
    Global_addExeProxy("fetchDWord");
    Global_addExeProxy("fetchQWord");
    Global_addExeProxy("fetchWord");
    Global_addExeProxy("fetchUByte");
    Global_addExeProxy("fetchByte");
    Global_addExeProxy("fetchHex");
    Global_addExeProxy("fetch");
    Global_addExeProxy("Raw2Rva");
    Global_addExeProxy("Rva2Raw");
    Global_addExeProxy("findZeros");
    Global_addExeProxy("findString");
    Global_addExeProxy("insert");
    Global_addExeProxy("replace");
    Global_addExeProxy("replaceByte");
    Global_addExeProxy("replaceWord");
    Global_addExeProxy("replaceDWord");
    Global_addExeProxy("getUserInput");
    Global_addExeProxy("getROffset");
    Global_addExeProxy("getVOffset");
    Global_addExeProxy("getRSize");
    Global_addExeProxy("getVSize");
    Global_addExeProxy("getPEOffset");
    Global_addExeProxy("getImageBase");
    Global_addExeProxy("getClientDate");
    Global_addExeProxy("isThemida");

    globalFunc_registerPatch = registerPatch;

    registerPatch = function(patchId, functionName, patchName, category, groupId, author, description, recommended)
    {
        global_patches.push(functionName);
        var origName = functionName;
        var proxyName = "GlobalProxyPatch" + functionName;

        eval(proxyName + " = function()" +
            "{" +
            "    Global_beforeCallTo('" + functionName + "');" +
            "    var res = " + functionName + "();" +
            "    Global_afterCallTo('" + functionName + "');" +
            "    return res;" +
            "};");
        eval(proxyName + "_ = function()" +
            "{" +
            "    return Global_checkPatchFunction('" + functionName + "');" +
            "};");
        arguments[1] = proxyName;
        globalFunc_registerPatch.apply(this, arguments);
    };
}

function Global_checkPatchFunction(functionName)
{
    try
    {
        var res = eval("typeof(" + functionName + "_) !== 'undefined'");
        if (res === true)
        {
            function_logger.openGlobal("trace_" + functionName + "_");
            res = eval(functionName + "_()");
            function_logger.bool(res, "Enable patch " + functionName);
            function_logger.close();
        }
        else
        {
            res = true;
        }
    }
    catch(e)
    {
        function_logger.data(res, "Exception in enable patch " + functionName + ": " + e);
        res = false;
    }
    global_logger.bool(res, "Enable patch " + functionName);
    return res;
}

function GlobalPostInit()
{
}

function Global_beforeCallTo(functionName)
{
    global_logger.data(functionName, "before functionName");
    function_logger.openGlobal("trace_" + functionName);
}

function Global_afterCallTo(functionName)
{
    function_logger.close();
    global_logger.data(functionName, "after functionName");
}

function consoleLog(message)
{
    if (typeof(console2) === "undefined")
        return;
    console2.log(message);
}

function logVaVar(name, offset, offset2)
{
    if (typeof(console2) === "undefined")
        return;
    console2.logVaVar(name, offset, offset2);
}

function logVaFunc(name, offset, offset2)
{
    if (typeof(console2) === "undefined")
        return;
    console2.logVaFunc(name, offset, offset2);
}

function logRawFunc(name, offset, offset2)
{
    if (typeof(console2) === "undefined")
        return;
    console2.logRawFunc(name, offset, offset2);
}

function logField(name, offset, offset2)
{
    if (typeof(console2) === "undefined")
        return;
    console2.logField(name, offset, offset2[0], offset2[1]);
}

function logVal(name, offset, offset2)
{
    if (typeof(console2) === "undefined")
        return;
    console2.logVal(name, offset, offset2);
}
