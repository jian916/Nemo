//
// Copyright (C) 2020  Andrei Karas (4144)
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

function registerTables()
{
    table.var1 = 0;
    table.g_session = 1;
    table.g_serviceType = 2;
    table.g_windowMgr = 3;
    table.UIWindowMgr_MakeWindow = 4;
    table.UIWindowMgr_DeleteWindow = 5;

    registerTableFunctions();
}

function table_getRaw(varId)
{
    return exe.Rva2Raw(table.get(varId));
}

function table_getHex4(varId)
{
    return table.get(varId).packToHex(4);
}

function getEcxSessionHex()
{
    return "B9 " + table.getHex4(table.g_session);  // mov ecx, g_session
}

function getEcxWindowMgrHex()
{
    return "B9 " + table.getHex4(table.g_windowMgr);  // mov ecx, g_windowMgr
}

function registerTableFunctions()
{
    table.getHex4 = table_getHex4;
    table.getRaw = table_getRaw;
}
