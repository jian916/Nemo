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
    macroAsm_replaceVars(obj);
    macroAsm_replaceCmds(obj);
}

function macroAsm_replaceVars(obj)
{
    var vars = obj.vars;
    obj.update = true;
    var cnt = 0;
    while (obj.update)
    {
        cnt = cnt + 1;
        obj.update = false;
        macroAsm_removeComments(obj);
        for (var name in vars)
        {
            var value = vars[name];
            if (typeof(value) !== "string")
                continue;
            macroAsm_replaceVar(obj, name, value);
            macroAsm_macro_instAsm(obj, name, value);
            macroAsm_macro_instHex(obj, name, value);
        }
    }
    return cnt;
}

function macroAsm_replaceCmds(obj)
{
    if (obj.text.length === 0)
        return 0;

    var parts = obj.text.split("\n");
    var text = "";
    for (var i = 0; i < parts.length; i ++)
    {
        var line = parts[i].trim();
        // macro commands
        text += line + "\n";
    }
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

function macroAsm_macro_instAsm(obj, name, value)
{
    var text = obj.text.replaceAll("%insasm " + name + "\n", value);
    if (text != obj.text)
    {
        obj.text = text;
        obj.update = true;
    }
}

function macroAsm_macro_instHex(obj, name, value)
{
    if (obj.text.indexOf("%inshex " + name + "\n") < 0)
        return;
    var value = asm.hexToAsm(value);
    var text = obj.text.replaceAll("%inshex " + name + "\n", value);
    if (text != obj.text)
    {
        obj.text = text;
        obj.update = true;
    }
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
    macroAsm.macro_instAsm = macroAsm_macro_instAsm;
    macroAsm.macro_instHex = macroAsm_macro_instHex;
}
