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

function LimitResolution_imp(name, text, error, weight, offset, compare)
{
    var value = exe.getUserInput(name, XTYPE_DWORD,
        _("Number Input"),
        text,
        0, 0, 10000);

    if (value === 0)
        return error;

    var vars = {
        "value": value,
        "offset": offset,
        "compare": compare
    };
    var hooksList = hooks.initImportCallHooks("CreateWindowExA", "user32.dll");
    if (hooksList.length === 0)
        throw "CreateWindowExA call usages not found";
    hooksList.addFilePre("LimitResolution", vars, weight);
    hooksList.validate();
    return true;
}

function LimitMinResolutionWidth()
{
    return LimitResolution_imp("$LimitMinResolutionWidth",
        _("Allow minimal width in pixels"),
        "Minimal width is not set",
        11000,
        "width",
        "jge");
}

function LimitMinResolutionHeight()
{
    return LimitResolution_imp("$LimitMinResolutionHeight",
        _("Allow minimal height in pixels"),
        "Minimal height is not set",
        11000,
        "height",
        "jge");
}

function LimitMaxResolutionWidth()
{
    return LimitResolution_imp("$LimitMaxResolutionWidth",
        _("Allow maximum width in pixels"),
        "Maximum width is not set",
        12000,
        "width",
        "jle");
}

function LimitMaxResolutionHeight()
{
    return LimitResolution_imp("$LimitMaxResolutionHeight",
        _("Allow maximum height in pixels"),
        "Maximum height is not set",
        12000,
        "height",
        "jle");
}
