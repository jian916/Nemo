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

//########################################################################
//# Purpose: Hijack CreateFontA function calls to change the pushed Font #
//#          height before Jumping to actual CreateFontA                 #
//########################################################################

function CreateFontAHook_imp(name, text, def, min, max)
{
    var value = exe.getUserInput(name, XTYPE_DWORD,
        _("Number Input"),
        text,
        def, min, max);

    var vars = {
        "value": value
    }

    var hooksList = hooks.initImportHooks("CreateFontA", "GDI32.dll");
    if (hooksList.length === 0)
        throw "CreateFontA call usages not found";
    hooksList.addFilePre("", vars);
    hooksList.validate();

    return true;
}

function ResizeFont()
{
    return CreateFontAHook_imp("$newFontHgt", _("Enter fixed abs font height"), 10, 0, 1000);
}

function ResizeFontL()
{
    return CreateFontAHook_imp("$newFontHgtL", _("Enter fixed logical font height"), 10, 0, 1000);
}

function ResizeFontSizeMinL()
{
    return CreateFontAHook_imp("$newFontSizeMinL", _("Enter minimal logical font height"), 10, 0, 1000);
}

function ResizeFontSizeMaxL()
{
    return CreateFontAHook_imp("$newFontSizeMaxL", _("Enter maximum logical font height"), 10, 0, 1000);
}

function ResizeFontSizeAdjL()
{
    return CreateFontAHook_imp("$newFontSizeAdjL", _("Enter number for adjust font size height (-100, +100)"), 10, -1000, 1000);
}
