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

function ReplaceErrorMessageToSound()
{
    var value = exe.getUserInput("$ReplaceErrorMessageToSound", XTYPE_DWORD,
        _("Number Input"),
        _("Enter sound type"),
        0, 0, 4);

    var vars = {
        "value": value * 16,
    };

    var hooksList = hooks.initImportHooks("MessageBoxA", "user32.dll");
    if (hooksList.length === 0)
        throw "MessageBoxA usages not found";
    hooksList.addFilePre("", vars, 4000);
    hooksList.validate();
    return true;
}
