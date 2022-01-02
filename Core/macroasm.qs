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
    obj.defines = {};
    obj.line = "";
    obj.update = false;
    obj.reparse = false;
    return obj;
}

function macroAsm_convert(obj)
{
    macroAsm_replaceCmds(obj);
}

function macroAsm_invokeMacros(obj, index, macroses)
{
    var macro = macroses[index];
    var cmd = macro[1];
    var getArgFunc = macro[2];
    if (typeof(getArgFunc) !== "undefined")
    {
        var arg = getArgFunc(cmd, obj.line);
        if (arg === false)
            return;
        obj.macro = macro;
        var checkArgFunc = macro[3];
        if (typeof(checkArgFunc) !== "undefined")
            checkArgFunc(obj, arg);
        var macroFunc = macro[0];
        macroFunc(obj, cmd, arg);
    }
    else
    {
        obj.macro = macro;
        var macroFunc = macro[0];
        macroFunc(obj, cmd);
    }
}

function macroAsm_invokeMacroses(obj, i, macroses)
{
    for (var j = 0; j < macroses.length; j ++)
    {
        macroAsm_invokeMacros(obj, j, macroses);
        if (obj.update)
        {
            obj.update = false;
            var parts2 = obj.line.split("\n");
            if (i > 0)
            {
                obj.parts = obj.parts.slice(0, i).concat(parts2).concat(obj.parts.slice(i + 1));
            }
            else
            {
                obj.parts = parts2.concat(obj.parts.slice(i + 1));
            }
            obj.line = "";
            obj.reparse = true;
            return;
        }
    }
}

function macroAsm_replaceCmds(obj)
{
    if (obj.text.length === 0)
        return;

    obj.parts = obj.text.split("\n");
    var text = "";
    var i = 0;
    obj.reparse = false;
    while (i < obj.parts.length)
    {
        obj.line = obj.parts[i].trim();
        if (obj.line.length === 0 || obj.line[0] === ";")
        {
            obj.reparse = false;
            i ++;
            continue;
        }
        macroAsm_invokeMacroses(obj, i, macroAsm.macroses1);
        if (obj.reparse === false && (obj.line[0] === "%" || obj.line[0] === "#"))
            macroAsm_invokeMacroses(obj, i, macroAsm.macroses2);
        if (obj.reparse === false)
            macroAsm_invokeMacroses(obj, i, macroAsm.macroses3);
        if (obj.line !== "")
            text += macroAsm_addNewLine(obj.line);
        if (obj.reparse)
            obj.reparse = false;
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
    function parse_cmd_arg(cmd, line)
    {
        cmd = cmd + " ";
        var idx = line.indexOf(cmd);
        if (idx !== 0 && idx !== 1)
            return false;
        return line.substring(cmd.length).trim();
    }

    function parse_cmd_argEq(cmd, line)
    {
        cmd = cmd + " ";
        var idx = line.indexOf(cmd);
        if (idx !== 0 && idx !== 1)
            return false;
        line = line.substring(cmd.length).trim();
        return splitArgEq(line);
    }

    function parse_cmd_args(cmd, line)
    {
        cmd = cmd + " ";
        var idx = line.indexOf(cmd);
        if (idx !== 0 && idx !== 1)
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

    function parse_cmd_eqArgs(cmd, line)
    {
        cmd = cmd + " ";
        var idx = line.indexOf(cmd);
        if (idx !== 0 && idx !== 1)
            return false;
        line = line.substring(cmd.length);
        line = splitArgEq(line);
        if (line[0] === line[1])
            line[0] = undefined;
        var args = line[1].match(/(?:[^,"]+|"[^"]*")+/g);
        var args2 = [];
        for (var i = 0; i < args.length; i ++)
        {
            args2.push(args[i].trim());
        }
        return [line[0], args2];
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

    function check_arg_var(obj, arg)
    {
        if (!(arg in obj.vars))
            fatalError("Variable " + arg + " not in vars: " + obj.line);
    }

    function check_arg_table2(obj, arg)
    {
        var arg = arg[1];
        if (!(arg in table))
        {
            fatalError("Variable " + arg + " not in table: " + obj.line);
        }
    }

    function check_exists_args(obj, args)
    {
        if (args.length < 1)
            fatalError("No args in macro asm command: " + obj.line);
    }

    function macro_instAsm(obj, cmd, arg)
    {
        obj.line = obj.vars[arg];
        obj.update = true;
    }

    function macro_instHex(obj, cmd, arg)
    {
        obj.line = asm.hexToAsm(obj.vars[arg]);
        obj.update = true;
    }

    function macro_instStr(obj, cmd, arg)
    {
        obj.line = asm.stringToAsm(obj.vars[arg]);
        obj.update = true;
    }

    function macro_include(obj, cmd, arg)
    {
        obj.line = asm.load("include/" + arg);
        obj.update = true;
    }

    function macro_tableVarInternal(obj, cmd, arg, tableFunc)
    {
        var varName = arg[0];
        var arg = arg[1];
        var value = tableFunc(table[arg]);
        assign_var(obj, varName, value);
        obj.line = "";
    }

    function macro_tableVar(obj, cmd, arg)
    {
        macro_tableVarInternal(obj, cmd, arg, table.getValidated);
    }

    function macro_tableVar0(obj, cmd, arg)
    {
        macro_tableVarInternal(obj, cmd, arg, table.get);
    }

    function macro_setVar(obj, cmd, arg)
    {
        var varName = arg[0];
        var arg = arg[1];
        var value = parseInt(arg);
        if (isNaN(value))
            obj.vars[varName] = arg;
        else
            obj.vars[varName] = value;
        obj.line = "";
    }

    function macro_db(obj, cmd, args)
    {
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

    function macro_asciz(obj, cmd, arg)
    {
        if (arg[0] != "\"")
            fatalError("Not string in asm command: " + cmd);
        var sz = arg.length;
        if (sz < 3)
            fatalError("Wrong macro asm line2: " + obj.line);
        if (arg[sz - 1] !== "\"")
            fatalError("Wrong macro asm line3: " + obj.line);
        arg = arg.substring(1, sz - 1);
        obj.line = macroAsm_addNewLine(asm.stringToAsm(arg) + "db 0");
        obj.update = true;
    }

    function macro_def(obj, cmd, arg)
    {
        obj.defines[arg[0]] = arg[1];
        obj.line = "";
    }

    function macro_removeComments(obj, cmd)
    {
        var oldLine = obj.line;
        obj.line = obj.line.replaceAll(/[ ][ ][//][//][ ].+$/g, "\n");
        if (obj.line !== oldLine)
            obj.update = true;
    }

    function macro_replaceVars(obj, cmd)
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

    function macro_replaceDefs(obj, cmd)
    {
        var defines = obj.defines;
        for (var name in defines)
        {
            var value = defines[name];
            var line = obj.line.replaceAll(name, value);
            if (line != obj.line)
            {
                obj.line = line;
                obj.update = true;
            }
        }
    }

    function macro_import(obj, cmd, args)
    {
        var varName = args[0];
        args = args[1];
        if (typeof(varName) === "undefined")
            varName = args[0];
        var value = imports.ptrValidated(args[0], args[1], args[2]);
        assign_var(obj, varName, value);
        obj.line = "";
    }

    function assign_var(obj, varName, value)
    {
        if (varName in obj.vars)
        {
            if (obj.vars[varName] !== value)
            {
                fatalError("Asm variable " + arg + " already exists: " + obj.vars[varName] + " vs " + value);
            }
        }
        obj.vars[varName] = value;
    }

    macroAsm.macroses1 = [
        [macro_removeComments, undefined,    undefined,        undefined],
        [macro_replaceVars,    undefined,    undefined,        undefined],
        [macro_replaceDefs,    undefined,    undefined,        undefined],
    ];

    macroAsm.macroses2 = [
        [macro_def,            "%def",       parse_cmd_argEq,  undefined],
        [macro_include,        "%include",   parse_cmd_arg,    undefined],
        [macro_instAsm,        "%insasm",    parse_cmd_arg,    check_arg_var],
        [macro_instHex,        "%inshex",    parse_cmd_arg,    check_arg_var],
        [macro_instStr,        "%insstr",    parse_cmd_arg,    check_arg_var],
        [macro_tableVar,       "%tablevar",  parse_cmd_argEq,  check_arg_table2],
        [macro_tableVar0,      "%tablevar0", parse_cmd_argEq,  check_arg_table2],
        [macro_setVar,         "%setvar",    parse_cmd_argEq,  undefined],
        [macro_import,         "%import",    parse_cmd_eqArgs, check_exists_args],
    ];

    macroAsm.macroses3 = [
        [macro_db,             "db",         parse_cmd_args,   undefined],
        [macro_asciz,          "asciz",      parse_cmd_arg,    undefined],
    ];
}

function registerMacroAsm()
{
    macroAsm = new Object();
    macroAsm.create = macroAsm_create;
    macroAsm.convert = macroAsm_convert;
    macroAsm.addMacroses = macroAsm_addMacroses;
    macroAsm.addNewLine = macroAsm_addNewLine;
    macroAsm.invokeMacros = macroAsm_invokeMacros;

    macroAsm_addMacroses();
}
