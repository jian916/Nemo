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

function ChangeSleepN(n, weight)
{
    var newValue = exe.getUserInput("$ChangeSleep" + n, XTYPE_DWORD,
        _("Number Input"),
        _("New sleep value (ms)"),
        n, 0, 1000);

    var vars = {
        "oldValue": n,
        "newValue": newValue
    }

    var hooksList = hooks.initImportCallHooks("Sleep", "kernel32.dll");
    if (hooksList.length === 0)
        throw "Sleep call usages not found";
    hooksList.addFilePre("ChangeSleep", vars, weight);
    hooksList.validate();

    var hooksList = hooks.initImportJmpHooks("Sleep", "kernel32.dll");
    hooksList.addFilePre("ChangeSleep", vars, weight);
    hooksList.validate();

    var hooksList = hooks.initImportMovHooks("Sleep", "kernel32.dll");
    hooksList.addFilePre("ChangeSleep", vars, weight);
    hooksList.validate();

    return true;
}

function ChangeSleep0()
{
    return ChangeSleepN(0, 10000);
}

function ChangeSleep1()
{
    return ChangeSleepN(1, 5000);
}
