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

function SetFontName()
{
    var value = exe.getUserInput("$SetFontName", XTYPE_FONT, _('Font input'), _('Select the new font family'), "Arial");

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
