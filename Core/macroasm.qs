//
// Copyright (C) 2020-2021  Andrei Karas (4144)
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

function macroAsm_create(addrVa, commands, vars)
{
    var obj = new Object();
    obj.addrVa = addrVa;
    obj.text = commands;
    obj.vars = vars;
    obj.line = "";
    obj.update = false;
    return obj;
}

function macroAsm_convert(obj)
{
    macroAsm_replaceCmds(obj);
}


function macroAsm_replaceCmds(obj)
{
    if (obj.text.length === 0)
        return;

    var parts = obj.text.split("\n");
    var text = "";
    var i = 0;
    var reparse = false;
    while (i < parts.length)
    {
        obj.line = parts[i].trim();
        for (var j = 0; j < macroAsm.macroses.length; j ++)
        {
            macroAsm.macroses[j](obj);
            if (obj.update)
            {
                obj.update = false;
                var parts2 = obj.line.split("\n");
                if (i > 0)
                {
                    parts = parts.slice(0, i).concat(parts2).concat(parts.slice(i + 1));
                }
                else
                {
                    parts = parts2.concat(parts.slice(i + 1));
                }
                obj.line = "";
                reparse = true;
                break;
            }
        }
        if (obj.line !== "")
            text += macroAsm_addNewLine(obj.line);
        if (reparse)
            reparse = false;
        else
            i ++;
    }
    obj.line = "";
    obj.text = text;
}

function macroAsm_addNewLine(text)
{
    var sz = text.length;
    if (sz < 1)
        return text;
    if (text[sz - 1] == "\n")
        return text;
    return text + "\n";
}

function macroAsm_addMacroses()
{
    function getCmdArg(cmd, line)
    {
        if (line.indexOf(cmd) !== 0)
            return false;
        return line.substring(cmd.length).trim();
    }

    function getCmdArgEq(cmd, line)
    {
        if (line.indexOf(cmd) !== 0)
            return false;
        line = line.substring(cmd.length).trim();
        return splitArgEq(line);
    }

    function getCmdArgs(cmd, line)
    {
        if (line.indexOf(cmd) !== 0)
            return false;
        line = line.substring(cmd.length);
        var args = line.match(/(?:[^,"]+|"[^"]*")+/g);
        var args2 = [];
        for (var i = 0; i < args.length; i ++)
        {
            args2.push(args[i].trim());
        }
        return args2;
    }

    function splitArgEq(arg)
    {
        var idx = arg.indexOf("=");
        var data0 = arg;
        var data1 = arg;
        if (idx > 0)
        {
            data0 = arg.substring(0, idx).trim();
            data1 = arg.substring(idx + 1).trim();
        }
        return [data0, data1];
    }

    function macro_instAsm(obj)
    {
        var arg = getCmdArg("%insasm ", obj.line);
        if (arg === false)
            return;
        if (!(arg in obj.vars))
        {
            fatalError("Variable " + arg + " not in vars");
            return;
        }
        obj.line = obj.vars[arg];
        obj.update = true;
    }

    function macro_instHex(obj)
    {
        var arg = getCmdArg("%inshex ", obj.line);
        if (arg === false)
            return;
        if (!(arg in obj.vars))
        {
            fatalError("Variable " + arg + " not in vars");
            return;
        }
        obj.line = asm.hexToAsm(obj.vars[arg]);
        obj.update = true;
    }

    function macro_instStr(obj)
    {
        var arg = getCmdArg("%insstr ", obj.line);
        if (arg === false)
            return;
        if (!(arg in obj.vars))
        {
            fatalError("Variable " + arg + " not in vars");
            return;
        }
        obj.line = asm.stringToAsm(obj.vars[arg]);
        obj.update = true;
    }

    function macro_include(obj)
    {
        var arg = getCmdArg("%include ", obj.line);
        if (arg === false)
            return;

        obj.line = asm.load("include/" + arg);
        obj.update = true;
    }

    function macro_tableVar(obj)
    {
        var arg = getCmdArgEq("%tablevar ", obj.line);
        if (arg === false)
            return;
        var varName = arg[0];
        var arg = arg[1];
        if (!(arg in table))
        {
            fatalError("Variable " + arg + " not in table");
        }
        var value = table.getValidated(table[arg]);
        if (varName in obj.vars)
        {
            if (obj.vars[varName] !== value)
            {
                fatalError("Asm variable " + arg + " already exists: " + obj.vars[varName] + " vs " + table[arg]);
            }
        }
        obj.vars[varName] = value;
        obj.line = "";
    }

    function macro_setVar(obj)
    {
        var arg = getCmdArgEq("%setvar ", obj.line);
        if (arg === false)
            return;
        var varName = arg[0];
        var arg = arg[1];
        var value = parseInt(arg);
        if (isNaN(value))
            obj.vars[varName] = arg;
        else
            obj.vars[varName] = value;
        obj.line = "";
    }

    function macro_db(obj)
    {
        var args = getCmdArgs("db ", obj.line);
        if (args === false)
            return;

        if (args.length == 1)
        {
            // if one arg and not string, then skip parsing
            if (args[0][0] != "\"")
                return;
        }

        var line = "";
        for (var i = 0; i < args.length; i ++)
        {
            var arg = args[i];
            var sz = arg.length;
            if (sz < 1)
                fatalError("Wrong macro asm line1: " + obj.line);
            if (arg[0] === "\"")
            {
                if (sz < 3)
                    fatalError("Wrong macro asm line2: " + obj.line);
                if (arg[sz - 1] !== "\"")
                    fatalError("Wrong macro asm line3: " + obj.line);
                arg = arg.substring(1, sz - 1);
                line += macroAsm_addNewLine(asm.stringToAsm(arg));
                continue;
            }
            var arg = parseInt(arg).packToHex(1);
            line += asm.hexToAsm(arg);
        }
        obj.line = line;
        obj.update = true;
    }

    function macro_removeComments(obj)
    {
        var oldLine = obj.line;
        obj.line = obj.line.replaceAll(/[ ][ ][//][//][ ].+$/g, "\n");
        if (obj.line !== oldLine)
            obj.update = true;
    }

    function macro_replaceVars(obj)
    {
        if (obj.line.indexOf("{") < 0)
            return;

        var vars = obj.vars;
        for (var name in vars)
        {
            var value = vars[name];

            var line = obj.line.replaceAll("{" + name + "}", value);
            if (line != obj.line)
            {
                obj.line = line;
                obj.update = true;
            }
        }
    }

    macroAsm.macroses = [
        macro_removeComments,
        macro_replaceVars,
        macro_include,
        macro_instAsm,
        macro_instHex,
        macro_instStr,
        macro_tableVar,
        macro_setVar,
        macro_db
    ];
}

function registerMacroAsm()
{
    macroAsm = new Object();
    macroAsm.create = macroAsm_create;
    macroAsm.convert = macroAsm_convert;
    macroAsm.addMacroses = macroAsm_addMacroses;
    macroAsm.addNewLine = macroAsm_addNewLine;

    macroAsm_addMacroses();
}
