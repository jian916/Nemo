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

function ResizeFont_imp(name, text, def)
{
    var value = exe.getUserInput(name, XTYPE_DWORD,
        _("Number Input"),
        text,
        def, 0, 1000);

    var vars = {
        "value": value
    }

    var hooksList = hooks.initImportCallHooks("CreateFontA", "GDI32.dll");
    if (hooksList.length === 0)
        throw "CreateFontA call usages not found";
    hooksList.addFilePre("", vars);
    hooksList.validate();

    hooksList = hooks.initImportJmpHooks("CreateFontA", "GDI32.dll");
    hooksList.addFilePre("", vars);
    hooksList.validate();

    return true;
}

function ResizeFont()
{
    return ResizeFont_imp("$newFontHgt", _("Enter fixed abs font height"), 10);
}

function ResizeFontL()
{
    return ResizeFont_imp("$newFontHgtL", _("Enter fixed logical font height"), 10);
}

function ResizeFontSizeMinL()
{
    return ResizeFont_imp("$newFontSizeMinL", _("Enter minimal logical font height"), 10);
}

function ResizeFontSizeMaxL()
{
    return ResizeFont_imp("$newFontSizeMaxL", _("Enter maximum logical font height"), 10);
}
