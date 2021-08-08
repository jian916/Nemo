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

function macroAsm_convert(obj)
{
    obj.update = true;
    while (obj.update)
    {
        obj.update = false;
        macroAsm_replaceVars(obj);
        macroAsm_replaceCmds(obj);
    }
}

function macroAsm_replaceVars(obj)
{
    var vars = obj.vars;
    macroAsm_removeComments(obj);
    for (var name in vars)
    {
        var value = vars[name];
        if (typeof(value) !== "string")
            continue;
        macroAsm_replaceVar(obj, name, value);
    }
}

function macroAsm_replaceCmds(obj)
{
    if (obj.text.length === 0)
        return 0;

    var parts = obj.text.split("\n");
    var text = "";
    for (var i = 0; i < parts.length; i ++)
    {
        obj.line = parts[i].trim();
        macroAsm_macro_instAsm(obj);
        macroAsm_macro_instHex(obj);
        text += obj.line + "\n";
    }
    obj.line = "";
    obj.text = text;
}

function macroAsm_replaceVar(obj, name, value)
{
    var text = obj.text.replaceAll("{" + name + "}", value);
    if (text != obj.text)
    {
        obj.text = text;
        obj.update = true;
    }
}

function macroAsm_getCmdArg(cmd, line)
{
    if (cmd.indexOf(cmd) != 0)
        return false;
    return line.substring(cmd.length);
}

function macroAsm_macro_instAsm(obj)
{
    var arg = macroAsm_getCmdArg("%insasm ", obj.line);
    if (arg === false)
        return;
    if (!(arg in obj.vars))
        return;
    obj.line = obj.vars[arg];
    obj.update = true;
}

function macroAsm_macro_instHex(obj)
{
    var arg = macroAsm_getCmdArg("%inshex ", obj.line);
    if (arg === false)
        return;
    if (!(arg in obj.vars))
        return;
    obj.line = asm.hexToAsm(obj.vars[arg]);
    obj.update = true;
}

function macroAsm_removeComments(obj)
{
    obj.text = obj.text.replaceAll(/[ ][ ][//][//][ ].+\n/g, "\n");
}

function registerMacroAsm()
{
    macroAsm = new Object();
    macroAsm.convert = macroAsm_convert;
    macroAsm.replaceVar = macroAsm_replaceVar;
    macroAsm.replaceVars = macroAsm_replaceVars;
    macroAsm.removeComments = macroAsm_removeComments;
    macroAsm.getCmdArg = macroAsm_getCmdArg;
    macroAsm.macro_instAsm = macroAsm_macro_instAsm;
    macroAsm.macro_instHex = macroAsm_macro_instHex;
}
